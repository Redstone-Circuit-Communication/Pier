//! `pier-client-probe` v2: runs every client-side interface that is still unverified and
//! writes a pass or fail line for each, to the game log and to a file that survives a crash.
//!
//! What it covers:
//! * the slot map: which of the 202 host slots a client build really fills;
//! * the client-only calls: two hotkey registrations (in `on_load` and in `on_enable`, to tell
//!   a timing problem from a dead callback), unregistering, the screen name, the cancel
//!   semantics of an input event, `ClientCancelJoinLevelEvent` and the two render events;
//! * the engine-independent slots: kvdb, nbt, bus, service, scheduling, host info, registries;
//! * the engine-facing slots against the local player, once a world has been joined.
//!
//! It is crash-safe: before each call the test name goes into `inflight.txt`. If the client
//! dies inside a call, the next start records that test as CRASHED and skips it, so repeated
//! runs get past every crash. Delete the folder below to start over.
//!
//! Keys (raw `KeyInputEvent`, so they work even if registered hotkeys do not):
//! F4 arms the cancel test, then the next E press is cancelled: if the inventory does NOT
//! open, cancelling an input event works. F6 opens a 3 second render-event window. F8 prints
//! the client state and F9 the results. F7 only exists for the hotkey comparison.
//!
//! Join a world with a throwaway creative save. Files: `%TEMP%\pier_client_probe\`
//! (`probe.log` and `results.tsv`).

use std::collections::BTreeMap;
use std::fs::{self, OpenOptions};
use std::io::Write;
use std::panic::{catch_unwind, AssertUnwindSafe};
use std::path::PathBuf;
use std::sync::atomic::{AtomicBool, AtomicU32, Ordering};
use std::sync::{Arc, Mutex, MutexGuard, OnceLock};
use std::thread::ThreadId;
use std::time::Duration;

use levilamina::client::{self, KeyAction, KeyBinding};
use levilamina::event;
use levilamina::kvdb::KvDb;
use levilamina::nbt::binary::{from_binary, to_binary};
use levilamina::nbt::NbtFormat;
use levilamina::prelude::*;
use levilamina::sys;
use levilamina::types::Bounds;
use levilamina::world::GameRuleValue;
use levilamina::{bus, lane, registry};

/// Writes that put back exactly what was just read, plus harmless messages and particles.
const NOOP_WRITES: bool = true;
/// Calls that change the world or end the session. Leave off outside a disposable save.
const RUN_MUTATING: bool = false;

const KEY_RENDER: i32 = 117; // F6
const KEY_EARLY: i32 = 118; // F7, registered in on_load
const KEY_STATE: i32 = 119; // F8
const KEY_RESULTS: i32 = 120; // F9
const KEY_TEMP: i32 = 121; // F10, registered and dropped at once
const KEY_ARM: i32 = 115; // F4
const KEY_VICTIM: i32 = 69; // E, the key the cancel test swallows

const TIMER_SECONDS: u64 = 30;
const PAYLOAD_MAX_CHARS: usize = 400;

/// The eight client events that are subscribed for the whole session.
const EVENTS: &[&str] = &[
    "ClientStartJoinLevelEvent",
    "ClientJoinLevelEvent",
    "ClientCancelJoinLevelEvent",
    "ClientExitLevelEvent",
    "ClientCommandRegisterEvent",
    "ClientLevelTickEvent",
    "KeyInputEvent",
    "MouseInputEvent",
];
/// Subscribed for three seconds on F6 only: they fire every frame.
const RENDER_EVENTS: &[&str] = &["BeforeUIRenderEvent", "AfterUIRenderEvent"];

/// The slots a client build was predicted to fill, from reading the sources.
const PREDICTED_PRESENT: &str = "log,gaming_status,schedule,schedule_after,subscribe_event,unsubscribe_event,list_events,execute_command,register_command,get_current_tick,get_tick_delta_time,get_player_count,get_sim_paused,spawn_particle,get_player_position,scan_region,get_block,set_block,get_time,set_time,set_weather,list_players,player_resolve,player_send_message,player_disconnect,broadcast_message,player_set_gamemode,player_teleport,player_get_num,player_get_str,player_set_num,player_action,list_actors,actor_snapshot,actor_get_num,actor_get_str,actor_action,spawn_mob,explode,block_get_num,block_get_str,block_action,block_entity_snbt,item_get_num,item_get_str,item_transform,container_size,container_get_item,container_set_item,container_add_item,container_remove_item,container_clear,register_command_ex,register_command_enum,register_command_soft_enum,update_command_soft_enum,nbt_snbt_to_binary,nbt_binary_to_snbt,kvdb_open,kvdb_close,kvdb_get,kvdb_set,kvdb_del,kvdb_has,kvdb_is_empty,kvdb_iter,sys_info_str,sys_get_env,sys_set_env,sys_is_wine,get_difficulty,set_difficulty,get_seed,game_rule_get,game_rule_set,server_info_str,player_send_message_typed,client_get_local_player,client_is_in_level,client_register_key,client_unregister_key,client_get_key_codes,schedule_for,schedule_after_for,schedule_cancel,schedule_pending_count,container_refresh,bus_subscribe,bus_unsubscribe,bus_publish,bus_publish_vetoable,bus_subscriber_count,service_register,service_unregister,service_call,service_list,lane_publish,lane_unpublish,lane_acquire,lane_release,lane_list,level_set_biome,scan_region_indexed,container_get_items,service_caller,registry_list,player_execute_command";

static ENABLED: AtomicBool = AtomicBool::new(false);
static CANCEL_ARMED: AtomicBool = AtomicBool::new(false);
static STATS: OnceLock<Mutex<Stats>> = OnceLock::new();
static RESULTS: OnceLock<Mutex<Results>> = OnceLock::new();
static RENDER_LISTENERS: Mutex<Vec<Listener>> = Mutex::new(Vec::new());

#[derive(Default)]
struct Stats {
    seen: BTreeMap<&'static str, u64>,
    logged: BTreeMap<&'static str, u32>,
    subscribed: Vec<(&'static str, std::result::Result<String, String>)>,
    key_presses: BTreeMap<&'static str, u64>,
    first_thread: Option<ThreadId>,
    off_thread: u64,
    timer_fired: u64,
}

fn stats() -> MutexGuard<'static, Stats> {
    STATS
        .get_or_init(|| Mutex::new(Stats::default()))
        .lock()
        .unwrap_or_else(|e| e.into_inner())
}

#[derive(Default)]
struct Results {
    order: Vec<String>,
    map: BTreeMap<String, (String, String)>,
}

fn state_dir() -> PathBuf {
    let d = std::env::temp_dir().join("pier_client_probe");
    let _ = fs::create_dir_all(&d);
    d
}

fn results_path() -> PathBuf {
    state_dir().join("results.tsv")
}

fn load_results() -> Results {
    let mut r = Results::default();
    if let Ok(text) = fs::read_to_string(results_path()) {
        for line in text.lines() {
            let mut it = line.splitn(3, '\t');
            if let (Some(name), Some(verdict)) = (it.next(), it.next()) {
                let detail = it.next().unwrap_or("");
                if !r.map.contains_key(name) {
                    r.order.push(name.to_owned());
                }
                r.map
                    .insert(name.to_owned(), (verdict.to_owned(), detail.to_owned()));
            }
        }
    }
    r
}

fn results() -> MutexGuard<'static, Results> {
    RESULTS
        .get_or_init(|| Mutex::new(load_results()))
        .lock()
        .unwrap_or_else(|e| e.into_inner())
}

/// Every line goes to the game log and to a file that is synced at once, because the game
/// log is buffered and loses its last seconds when the client dies.
fn say(line: &str) {
    Logger::get().info(line);
    if let Ok(mut f) = OpenOptions::new()
        .create(true)
        .append(true)
        .open(state_dir().join("probe.log"))
    {
        let _ = writeln!(f, "{line}");
        let _ = f.sync_data();
    }
}

fn record(name: &str, verdict: &str, detail: &str) {
    let clean: String = detail
        .chars()
        .map(|c| {
            if c == '\t' || c == '\n' || c == '\r' {
                ' '
            } else {
                c
            }
        })
        .collect();
    {
        let mut r = results();
        if !r.map.contains_key(name) {
            r.order.push(name.to_owned());
        }
        r.map
            .insert(name.to_owned(), (verdict.to_owned(), clean.clone()));
    }
    if let Ok(mut f) = OpenOptions::new()
        .create(true)
        .append(true)
        .open(results_path())
    {
        let _ = writeln!(f, "{name}\t{verdict}\t{clean}");
        let _ = f.sync_data();
    }
}

fn recover_inflight() {
    let marker = state_dir().join("inflight.txt");
    if let Ok(text) = fs::read_to_string(&marker) {
        let name = text.trim().to_owned();
        if !name.is_empty() {
            record(
                &name,
                "CRASHED",
                "the client died while this call was running",
            );
            say(&format!(
                "[recover] the last run died inside test {name}: recorded as CRASHED, skipped from now on"
            ));
        }
        let _ = fs::remove_file(&marker);
    }
}

fn ensure(ok: bool, what: &str) -> Result<()> {
    if ok {
        Ok(())
    } else {
        Err(Error(what.to_owned()))
    }
}

/// Runs one named call. A name that already has a result from an earlier session is skipped.
fn run_test(name: &str, f: impl FnOnce() -> Result<String>) {
    if results().map.contains_key(name) {
        return;
    }
    let marker = state_dir().join("inflight.txt");
    let _ = fs::write(&marker, name);
    let outcome = catch_unwind(AssertUnwindSafe(f));
    let _ = fs::remove_file(&marker);
    let (verdict, detail) = match outcome {
        Ok(Ok(d)) => ("PASS", d),
        Ok(Err(e)) => ("FAIL", e.to_string()),
        Err(_) => ("PANIC", "the call panicked".to_owned()),
    };
    record(name, verdict, &detail);
    say(&format!("[test] {name}: {verdict} {detail}"));
}

fn clip(s: &str, max: usize) -> String {
    let total = s.chars().count();
    if total <= max {
        return s.to_owned();
    }
    let head: String = s.chars().take(max).collect();
    format!("{head}...({total} chars)")
}

fn show<T: std::fmt::Display>(r: Result<T>) -> String {
    match r {
        Ok(v) => format!("Ok({v})"),
        Err(e) => format!("Err({e})"),
    }
}

/// Reads `key:123` out of a payload printed as SNBT.
fn field_i64(snbt: &str, key: &str) -> Option<i64> {
    let needle = format!("{key}:");
    let start = snbt.find(&needle)? + needle.len();
    let rest = &snbt[start..];
    let end = rest
        .find(|c: char| !(c.is_ascii_digit() || c == '-'))
        .unwrap_or(rest.len());
    rest[..end].parse().ok()
}

fn payload_budget(name: &str) -> u32 {
    match name {
        "KeyInputEvent" => 20,
        "ClientLevelTickEvent" => 1,
        "BeforeUIRenderEvent" | "AfterUIRenderEvent" => 2,
        _ => 3,
    }
}

fn count(name: &str) -> u64 {
    stats().seen.get(name).copied().unwrap_or(0)
}

// ---------------------------------------------------------------- slot map

macro_rules! slots {
    ($($name:ident),* $(,)?) => {
        vec![$((stringify!($name), levilamina::has_slot!($name))),*]
    };
}

fn slot_map() -> Vec<(&'static str, bool)> {
    slots!(
        log,
        gaming_status,
        schedule,
        schedule_after,
        subscribe_event,
        unsubscribe_event,
        list_events,
        execute_command,
        register_command,
        get_current_tick,
        get_tick_delta_time,
        get_player_count,
        get_sim_paused,
        spawn_particle,
        get_player_position,
        scan_region,
        get_block,
        set_block,
        get_time,
        set_time,
        set_weather,
        list_players,
        player_resolve,
        player_send_message,
        player_disconnect,
        broadcast_message,
        player_set_gamemode,
        player_teleport,
        player_get_num,
        player_get_str,
        player_set_num,
        player_action,
        list_actors,
        actor_snapshot,
        actor_get_num,
        actor_get_str,
        actor_action,
        spawn_mob,
        explode,
        block_get_num,
        block_get_str,
        block_action,
        block_entity_snbt,
        item_get_num,
        item_get_str,
        item_transform,
        container_size,
        container_get_item,
        container_set_item,
        container_add_item,
        container_remove_item,
        container_clear,
        scoreboard_op,
        form_send,
        register_command_ex,
        register_command_enum,
        register_command_soft_enum,
        update_command_soft_enum,
        nbt_snbt_to_binary,
        nbt_binary_to_snbt,
        kvdb_open,
        kvdb_close,
        kvdb_get,
        kvdb_set,
        kvdb_del,
        kvdb_has,
        kvdb_is_empty,
        kvdb_iter,
        sys_info_str,
        sys_get_env,
        sys_set_env,
        sys_is_wine,
        get_difficulty,
        set_difficulty,
        get_seed,
        game_rule_get,
        game_rule_set,
        server_info_str,
        spawn_particle_for,
        send_packet,
        tick_freeze,
        tick_step,
        tick_warp,
        profile_begin,
        profile_take,
        sim_spawn,
        sim_do,
        sim_is,
        sim_list,
        villages,
        structures_near,
        player_send_message_typed,
        get_money,
        set_money,
        add_money,
        reduce_money,
        trans_money,
        money_get_hist,
        money_clear_hist,
        money_listen_before_event,
        money_listen_after_event,
        money_ranking,
        player_get_carried_item,
        player_get_item,
        player_set_item,
        player_get_equipment,
        player_get_cooldown,
        player_start_cooldown,
        player_get_network_status,
        actor_get_vehicle,
        actor_get_first_passenger,
        actor_get_owner,
        actor_get_target,
        actor_get_equipped_item,
        actor_set_equipped_item,
        actor_get_effects,
        actor_get_status_flag,
        actor_set_status_flag,
        actor_trace_ray,
        actor_distance_to,
        actor_get_aabb,
        actor_clone,
        block_get_state,
        block_set_state,
        block_get_collision_shape,
        item_get_enchants,
        item_set_enchants,
        item_matches,
        item_get_user_data,
        level_get_biome,
        level_get_default_spawn,
        level_set_default_spawn,
        level_save,
        level_get_sleep_status,
        level_update_weather,
        level_find_path,
        packet_hook_register,
        packet_hook_unregister,
        packet_conn_hook_register,
        packet_conn_hook_unregister,
        client_get_local_player,
        client_is_in_level,
        client_get_screen_name,
        client_register_key,
        client_unregister_key,
        client_get_key_codes,
        md_is_available,
        md_set_dimension_rule,
        md_get_dimension_rule,
        md_clear_dimension_rules,
        md_get_dimension_id,
        schedule_for,
        schedule_after_for,
        schedule_cancel,
        schedule_pending_count,
        container_refresh,
        player_send_title,
        bus_subscribe,
        bus_unsubscribe,
        bus_publish,
        bus_publish_vetoable,
        bus_subscriber_count,
        md_set_plot_merges,
        service_register,
        service_unregister,
        service_call,
        service_list,
        edit_set_block_nbt,
        edit_set_block_states,
        edit_set_block_entity,
        edit_spawn_entity_nbt,
        edit_trace_ray,
        lane_publish,
        lane_unpublish,
        lane_acquire,
        lane_release,
        lane_list,
        md_list_dimensions,
        level_delete_chunk_keys,
        level_chunks_loaded,
        player_conn_id,
        level_chunk_keys,
        level_delete_key,
        level_set_biome,
        get_extra_block,
        set_extra_block,
        get_tps,
        get_mspt,
        packet_hook_register_ids,
        scan_region_indexed,
        edit_fill_region,
        edit_set_blocks,
        container_get_items,
        md_add_dimension,
        md_add_dimension_pack,
        md_pack_inspect,
        md_retire_dimension,
        service_caller,
        md_add_dimension_generated,
        md_set_dimension_cells,
        registry_list,
        player_execute_command,
    )
}

fn report_slots() {
    let map = slot_map();
    let present: Vec<&str> = map.iter().filter(|s| s.1).map(|s| s.0).collect();
    let null: Vec<&str> = map.iter().filter(|s| !s.1).map(|s| s.0).collect();
    say(&format!(
        "[slots] {} of {} host slots are filled on this client",
        present.len(),
        map.len()
    ));
    for chunk in present.chunks(16) {
        say(&format!("[slots] present: {}", chunk.join(", ")));
    }
    for chunk in null.chunks(16) {
        say(&format!("[slots] NULL: {}", chunk.join(", ")));
    }
    let predicted: Vec<&str> = PREDICTED_PRESENT.split(',').collect();
    let wrong_null: Vec<&str> = predicted
        .iter()
        .copied()
        .filter(|p| null.contains(p))
        .collect();
    let wrong_present: Vec<&str> = present
        .iter()
        .copied()
        .filter(|p| !predicted.contains(p))
        .collect();
    say(&format!(
        "[slots] predicted filled but NULL: {}",
        wrong_null.join(", ")
    ));
    say(&format!(
        "[slots] predicted NULL but filled: {}",
        wrong_present.join(", ")
    ));
}

// ---------------------------------------------------------------- client state

fn log_client_state(tag: &str) {
    say(&format!(
        "[state@{tag}] is_available={} is_in_level={} local_player={} screen_name={}",
        client::is_available(),
        show(client::is_in_level()),
        show(client::local_player_name()),
        show(client::screen_name()),
    ));
}

fn report_registry() {
    let all = event::list();
    say(&format!(
        "[registry] the host resolves {} event id(s)",
        all.len()
    ));
    for name in EVENTS.iter().chain(RENDER_EVENTS.iter()) {
        let full = format!("ll::event::{name}");
        say(&format!("[registry] {name}: exact={}", all.contains(&full)));
    }
}

fn print_event_summary(why: &str) {
    let st = stats();
    say(&format!("[events] ---- {why} ----"));
    for (name, res) in &st.subscribed {
        match res {
            Ok(id) => say(&format!(
                "[events] {name}: subscribed as {id}, fired {} time(s)",
                st.seen.get(name).copied().unwrap_or(0)
            )),
            Err(e) => say(&format!("[events] {name}: NOT subscribed ({e})")),
        }
    }
    for name in RENDER_EVENTS {
        say(&format!(
            "[events] {name}: on demand (F6), fired {} time(s)",
            st.seen.get(name).copied().unwrap_or(0)
        ));
    }
    say(&format!(
        "[events] hotkey presses {:?}; timer fired {} time(s); first thread {:?}, callbacks on another thread: {}",
        st.key_presses, st.timer_fired, st.first_thread, st.off_thread
    ));
}

fn print_results(why: &str) {
    say(&format!("[results] ---- {why} ----"));
    let r = results();
    let (mut pass, mut fail, mut other) = (0, 0, 0);
    for name in &r.order {
        if let Some((verdict, detail)) = r.map.get(name) {
            match verdict.as_str() {
                "PASS" => pass += 1,
                "FAIL" => fail += 1,
                _ => other += 1,
            }
            say(&format!("[results] {name}: {verdict} {detail}"));
        }
    }
    say(&format!(
        "[results] {pass} passed, {fail} failed, {other} crashed or panicked. File: {}",
        results_path().display()
    ));
}

// ---------------------------------------------------------------- events

fn on_event(name: &'static str, ev: &mut Event<'_>) {
    let thread = std::thread::current().id();
    let (n, print) = {
        let mut guard = stats();
        let st: &mut Stats = &mut guard;
        let first = st.first_thread;
        match first {
            None => st.first_thread = Some(thread),
            Some(t) if t != thread => st.off_thread += 1,
            _ => {}
        }
        let n = {
            let c = st.seen.entry(name).or_insert(0);
            *c += 1;
            *c
        };
        let l = st.logged.entry(name).or_insert(0);
        let print = *l < payload_budget(name);
        if print {
            *l += 1;
        }
        (n, print)
    };
    let snbt = ev.snbt().to_owned();
    if print {
        say(&format!(
            "[event:{name}] #{n} can_cancel={:?} thread={thread:?} payload={}",
            ev.can_cancel(),
            clip(&snbt, PAYLOAD_MAX_CHARS),
        ));
    }
    match name {
        "ClientStartJoinLevelEvent" | "ClientCancelJoinLevelEvent" | "ClientExitLevelEvent" => {
            log_client_state(name)
        }
        "ClientJoinLevelEvent" => {
            log_client_state(name);
            let _ = Host::get().schedule_after(Duration::from_secs(3), || {
                if ENABLED.load(Ordering::Relaxed) {
                    run_world_tests();
                }
            });
        }
        "ClientLevelTickEvent" if n % 600 == 0 => print_event_summary("600 client ticks"),
        "KeyInputEvent" => {
            let code = field_i64(&snbt, "keyCode");
            let down = field_i64(&snbt, "action") == Some(1);
            if down {
                match code {
                    Some(c) if c == i64::from(KEY_STATE) => log_client_state("F8"),
                    Some(c) if c == i64::from(KEY_RESULTS) => print_results("F9"),
                    Some(c) if c == i64::from(KEY_RENDER) => render_window(),
                    Some(c) if c == i64::from(KEY_ARM) => {
                        CANCEL_ARMED.store(true, Ordering::Relaxed);
                        say("[cancel] armed: press E. If the inventory does NOT open, cancelling works");
                    }
                    Some(c)
                        if c == i64::from(KEY_VICTIM)
                            && CANCEL_ARMED.swap(false, Ordering::Relaxed) =>
                    {
                        match ev.cancel() {
                            Ok(()) => say("[cancel] cancel() returned Ok for the E key press"),
                            Err(e) => say(&format!("[cancel] cancel() returned Err: {e}")),
                        }
                    }
                    _ => {}
                }
            }
        }
        _ => {}
    }
}

fn subscribe_all(listeners: &mut Vec<Listener>) {
    for &name in EVENTS {
        let candidates = [format!("ll::event::{name}"), name.to_owned()];
        let mut last_error = String::new();
        let mut done = false;
        for id in &candidates {
            match event::subscribe(id, move |ev| on_event(name, ev)) {
                Ok(listener) => {
                    stats().subscribed.push((name, Ok(id.clone())));
                    listeners.push(listener);
                    say(&format!("[subscribe] {name} -> {id}"));
                    done = true;
                    break;
                }
                Err(e) => last_error = format!("{id}: {e}"),
            }
        }
        if !done {
            say(&format!("[subscribe] {name} failed: {last_error}"));
            stats().subscribed.push((name, Err(last_error)));
        }
    }
}

/// The render events fire every frame, so they are subscribed for three seconds only.
fn render_window() {
    let mut subs: Vec<Listener> = Vec::new();
    for &name in RENDER_EVENTS {
        let id = format!("ll::event::{name}");
        match event::subscribe(&id, move |ev| on_event(name, ev)) {
            Ok(listener) => {
                subs.push(listener);
                say(&format!("[render] subscribed {name}"));
            }
            Err(e) => say(&format!("[render] subscribing {name} failed: {e}")),
        }
    }
    if subs.is_empty() {
        return;
    }
    RENDER_LISTENERS
        .lock()
        .unwrap_or_else(|e| e.into_inner())
        .extend(subs);
    let _ = Host::get().schedule_after(Duration::from_secs(3), || {
        RENDER_LISTENERS
            .lock()
            .unwrap_or_else(|e| e.into_inner())
            .clear();
        say(&format!(
            "[render] window closed. BeforeUIRenderEvent fired {} time(s), AfterUIRenderEvent {}",
            count("BeforeUIRenderEvent"),
            count("AfterUIRenderEvent")
        ));
    });
}

// ---------------------------------------------------------------- keys

fn on_key(label: &'static str, action: KeyAction, impact: i32) {
    if action.is_down() {
        *stats().key_presses.entry(label).or_insert(0) += 1;
    }
    say(&format!(
        "[key:{label}] CALLBACK FIRED action={action:?} focus_impact={impact} thread={:?}",
        std::thread::current().id()
    ));
}

fn bind(name: &'static str, code: i32, label: &'static str) -> Option<KeyBinding> {
    match client::register_key(name, &[code], true, move |a, i| on_key(label, a, i)) {
        Ok(binding) => {
            say(&format!(
                "[key] registered {name} (code {code}); key_codes() reads back {}",
                show(binding.key_codes().map(|c| format!("{c:?}")))
            ));
            Some(binding)
        }
        Err(e) => {
            say(&format!("[key] registering {name} failed: {e}"));
            None
        }
    }
}

fn probe_unregister() {
    match client::register_key("pier_probe_temp", &[KEY_TEMP], false, |_, _| {}) {
        Ok(binding) => {
            say("[key] registered the temporary key, dropping it now");
            drop(binding);
            say("[key] dropped it; if no error line follows, unregistering raised no error");
        }
        Err(e) => say(&format!("[key] the temporary key was not registered: {e}")),
    }
}

// ---------------------------------------------------------------- tests that need no world

fn run_independent_tests() {
    let host = Host::get();

    run_test("kvdb", || {
        let path = state_dir().join("kv").to_string_lossy().into_owned();
        let db = KvDb::open(&path)?;
        db.set("a", "1")?;
        db.set("b", "2")?;
        ensure(
            db.try_get("a")?.as_deref() == Some("1"),
            "get did not return the stored value",
        )?;
        ensure(db.has("a"), "has said no for a key that was just set")?;
        ensure(
            db.iter().len() >= 2,
            "iter returned fewer entries than were set",
        )?;
        db.del("a")?;
        ensure(!db.has("a"), "has said yes for a deleted key")?;
        ensure(!db.is_empty(), "is_empty said yes while a key is left")?;
        Ok(format!("path={path}, {} entries left", db.iter().len()))
    });

    run_test("nbt", || {
        let snbt = "{a:1b,b:\"x\",c:[1,2,3]}";
        let le = to_binary(snbt, NbtFormat::LittleEndian)?;
        let net = to_binary(snbt, NbtFormat::Network)?;
        let back = from_binary(&le, NbtFormat::LittleEndian)?;
        Ok(format!(
            "{} bytes little-endian, {} bytes network, back: {back}",
            le.len(),
            net.len()
        ))
    });

    run_test("bus", || {
        let hits = Arc::new(AtomicU32::new(0));
        let h2 = Arc::clone(&hits);
        let sub = bus::subscribe("pier_probe.topic", move |_topic, payload| {
            if payload == "ping" {
                h2.fetch_add(1, Ordering::Relaxed);
            }
            false
        })?;
        let delivered = bus::publish("pier_probe.topic", "ping")?;
        let counted = bus::subscriber_count("pier_probe.topic");
        let veto = bus::publish_vetoable("pier_probe.topic", "ping")?;
        drop(sub);
        let after = bus::subscriber_count("pier_probe.topic");
        ensure(delivered >= 1, "publish reached nobody")?;
        ensure(
            after == 0,
            "the subscription is still counted after it was dropped",
        )?;
        Ok(format!(
            "delivered={delivered} counted={counted} vetoable(vetoed={}, delivered={}) handler_hits={} after_drop={after}",
            veto.vetoed,
            veto.delivered,
            hits.load(Ordering::Relaxed)
        ))
    });

    run_test("service", || {
        let reg = service::register("pier_probe.echo", |_name, req| Ok(format!("echo:{req}")))?;
        ensure(
            service::exists("pier_probe.echo"),
            "exists said no for a registered service",
        )?;
        let answer = service::call("pier_probe.echo", "hi")?;
        let listed = service::list().iter().any(|s| s.name == "pier_probe.echo");
        drop(reg);
        let gone = !service::exists("pier_probe.echo");
        ensure(answer == "echo:hi", "call returned an unexpected answer")?;
        ensure(listed, "list did not show the service")?;
        Ok(format!("call -> {answer}; listed={listed}; gone after drop={gone}; caller outside a provider={:?}", service::caller()))
    });

    run_test("schedule", || {
        let fired = Arc::new(AtomicBool::new(false));
        let f2 = Arc::clone(&fired);
        let ticket = host.schedule(move || f2.store(true, Ordering::Relaxed))?;
        let far = host.schedule_after(Duration::from_secs(600), || {})?;
        let pending = host.try_pending_tasks()?;
        let cancelled = host.cancel(far);
        let check = Arc::clone(&fired);
        host.schedule_after(Duration::from_secs(2), move || {
            let ran = check.load(Ordering::Relaxed);
            record(
                "schedule-ran",
                if ran { "PASS" } else { "FAIL" },
                "a task queued with schedule() runs by itself within two seconds",
            );
            say(&format!(
                "[test] schedule-ran: {}",
                if ran { "PASS" } else { "FAIL" }
            ));
        })?;
        ensure(
            cancelled,
            "cancel returned false for a task that was still queued",
        )?;
        Ok(format!(
            "ticket {}, {pending} pending, far task cancelled",
            ticket.raw()
        ))
    });

    run_test("host-sys-info", || {
        Ok(format!(
            "os={} {} locale={} local_time={:?}",
            host.os_name()?,
            host.os_version()?,
            host.locale()?,
            host.local_time()?
        ))
    });
    run_test("host-server-info", || {
        Ok(format!(
            "bds={} protocol={} level_protocol={} game={}",
            host.bds_version()?,
            host.protocol_version()?,
            host.level_protocol_version()?,
            host.game_sem_version()?
        ))
    });
    run_test("host-env", || {
        host.set_env("PIER_PROBE_ENV", "1")?;
        let v = host.env("PIER_PROBE_ENV")?;
        ensure(v == "1", "env did not read back what set_env stored")?;
        Ok(format!("round trip ok, wine={}", host.try_is_wine()?))
    });
    run_test("host-gaming-status", || {
        Ok(format!("{:?}", host.gaming_status()))
    });
    run_test("host-current-tick", || {
        host.current_tick()
            .map(|t| format!("tick {t}"))
            .ok_or_else(|| Error("current_tick returned None".to_owned()))
    });
    run_test("host-player-count", || {
        host.player_count()
            .map(|n| format!("{n} player(s)"))
            .ok_or_else(|| Error("player_count returned None".to_owned()))
    });
    run_test("lane-list", || {
        let lanes = lane::list();
        let names: Vec<&str> = lanes.iter().map(|l| l.name.as_str()).collect();
        Ok(format!("{} lane(s): {}", lanes.len(), names.join(", ")))
    });
    run_test("registry-blocks", || {
        Ok(format!("{} block types", registry::blocks()?.len()))
    });
    run_test("registry-items", || {
        Ok(format!("{} item types", registry::items()?.len()))
    });
    run_test("registry-entities", || {
        Ok(format!("{} entity types", registry::entities()?.len()))
    });
    run_test("registry-commands", || {
        Ok(format!("{} commands", registry::commands()?.len()))
    });
}

// ---------------------------------------------------------------- tests that need a world

fn run_world_tests() {
    run_client_surface_tests();
    let me = match client::local_player_name() {
        Ok(n) => n,
        Err(e) => {
            say(&format!(
                "[suite] no local player yet, in-world tests skipped: {e}"
            ));
            return;
        }
    };
    say(&format!("[suite] in-world tests for {me}"));
    let p = Player::by_name(me.clone());
    let w = World::get();

    run_test("player-list", || {
        let list = Player::list();
        let names: Vec<&str> = list.iter().map(|i| i.name.as_str()).collect();
        Ok(format!("{} player(s): {}", list.len(), names.join(", ")))
    });
    run_test("player-is-online", || {
        ensure(p.is_online(), "is_online said no for the local player")?;
        Ok("online".to_owned())
    });
    run_test("player-position", || {
        let ((x, y, z), dim) = p.position()?;
        Ok(format!("dim {dim} at {x:.1} {y:.1} {z:.1}"))
    });
    run_test("player-game-type", || Ok(format!("{:?}", p.game_type()?)));
    run_test("player-num", || {
        Ok(format!(
            "level={} hunger={} game_type={}",
            p.num(sys::PIER_PPROP_LEVEL)?,
            p.num(sys::PIER_PPROP_HUNGER)?,
            p.num(sys::PIER_PPROP_GAME_TYPE)?
        ))
    });
    run_test("player-text", || {
        Ok(format!("real_name={}", p.text(sys::PIER_PSTR_REAL_NAME)?))
    });
    run_test("player-network", || {
        let n = p.network_status()?;
        Ok(format!(
            "ping={} avg={} loss={}",
            n.ping, n.avg_ping, n.packet_loss
        ))
    });
    run_test("actor-list", || {
        let all = Entity::list(None);
        let types: Vec<&str> = all.iter().take(5).map(|a| a.type_name.as_str()).collect();
        Ok(format!(
            "{} actor(s), first: {}",
            all.len(),
            types.join(", ")
        ))
    });
    run_test("actor-props", || {
        let e = p.as_entity()?;
        Ok(format!(
            "health={} x={} type={}",
            e.num(sys::PIER_APROP_HEALTH)?,
            e.num(sys::PIER_APROP_POS_X)?,
            e.text(sys::PIER_ASTR_TYPE_NAME)?
        ))
    });
    run_test("actor-pos", || {
        let (x, y, z) = p.as_entity()?.pos()?;
        Ok(format!("{x:.1} {y:.1} {z:.1}"))
    });
    run_test("actor-snapshot", || {
        let s = p.as_entity()?.snapshot()?;
        Ok(format!(
            "snapshot ok, {} chars when printed",
            format!("{s:?}").len()
        ))
    });
    run_test("world-time", || Ok(format!("{}", w.time()?)));
    run_test("world-difficulty", || Ok(format!("{:?}", w.difficulty()?)));
    run_test("world-seed", || Ok(format!("{}", w.seed()?)));
    run_test("world-game-rule", || {
        Ok(format!(
            "dodaylightcycle = {:?}",
            w.game_rule("dodaylightcycle")?
        ))
    });
    run_test("world-default-spawn", || {
        let (x, y, z) = w.default_spawn()?;
        Ok(format!("{x} {y} {z}"))
    });
    run_test("world-sleep-status", || {
        Ok(format!("{:?}", w.sleep_status()?))
    });
    run_test("world-biome", || {
        let ((x, y, z), dim) = p.position()?;
        w.biome(dim, x as i32, y as i32, z as i32)
    });
    run_test("world-chunks-loaded", || {
        let ((x, _y, z), dim) = p.position()?;
        let (cx, cz) = ((x as i32) >> 4, (z as i32) >> 4);
        Ok(format!(
            "{}",
            w.chunks_loaded(dim, cx - 1, cz - 1, cx + 1, cz + 1)?
        ))
    });
    run_test("world-scan", || {
        let ((x, y, z), dim) = p.position()?;
        let (x, y, z) = (x as i32, y as i32, z as i32);
        let scan = w.scan(
            dim,
            Bounds {
                min: (x - 2, y - 2, z - 2),
                max: (x + 2, y + 2, z + 2),
            },
        )?;
        Ok(format!(
            "{} block(s), {} entity(ies)",
            scan.blocks.len(),
            scan.entities.len()
        ))
    });
    run_test("world-scan-indexed", || {
        let ((x, y, z), dim) = p.position()?;
        let (x, y, z) = (x as i32, y as i32, z as i32);
        let scan = w.scan_indexed(
            dim,
            Bounds {
                min: (x - 2, y - 2, z - 2),
                max: (x + 2, y + 2, z + 2),
            },
        )?;
        Ok(format!("{} non-air block(s)", scan.non_air_count()))
    });
    run_test("block-read", || {
        let ((x, y, z), dim) = p.position()?;
        let b = Block::at(dim, x as i32, y as i32 - 1, z as i32);
        let info = b.read()?;
        Ok(format!(
            "{} at {:?}, is_air={}, type={}, tags={}",
            info.name,
            info.pos,
            b.num(sys::PIER_BPROP_IS_AIR)?,
            b.text(sys::PIER_BSTR_TYPE_NAME)?,
            b.tags()?.len()
        ))
    });
    run_test("block-nbt", || {
        let ((x, y, z), dim) = p.position()?;
        let nbt = Block::at(dim, x as i32, y as i32 - 1, z as i32).to_nbt()?;
        Ok(format!("{} chars when printed", format!("{nbt:?}").len()))
    });
    run_test("server-tick", || {
        let s = Server::get();
        Ok(format!(
            "delta_time={} sim_paused={}",
            s.tick_delta_time()?,
            s.is_sim_paused()?
        ))
    });
    run_test("container-size", || {
        Ok(format!("{}", p.inventory().size()?))
    });
    run_test("container-items", || {
        Ok(format!("{} slot(s) listed", p.inventory().items()?.len()))
    });
    run_test("container-item", || {
        let it = p.inventory().item(0)?;
        Ok(format!("slot 0 is {} chars of SNBT", it.snbt().len()))
    });
    run_test("item-props", || {
        let it = p.carried_item()?;
        Ok(format!(
            "count={} type={}",
            it.num(sys::PIER_IPROP_COUNT)?,
            it.text(sys::PIER_ISTR_TYPE_NAME)?
        ))
    });
    run_test("player-send-message", || {
        p.send_message("[probe] send_message works")?;
        Ok("sent".to_owned())
    });
    run_test("player-actionbar", || {
        p.set_actionbar("[probe] actionbar works")?;
        Ok("sent".to_owned())
    });
    run_test("player-broadcast", || {
        Player::broadcast("[probe] broadcast works")?;
        Ok("sent".to_owned())
    });
    run_test("player-execute-command", || {
        p.execute_command("say [probe] player execute_command works")
    });
    run_test("host-execute-command", || {
        Host::get().execute_command("say [probe] host execute_command works")
    });

    if NOOP_WRITES {
        run_test("world-set-time-same", || {
            let t = w.time()?;
            w.set_time(t)?;
            Ok(format!("wrote back {t}"))
        });
        run_test("world-set-difficulty-same", || {
            let d = w.difficulty()?;
            w.set_difficulty(d)?;
            Ok(format!("wrote back {d:?}"))
        });
        run_test("world-set-game-rule-same", || {
            let text = match w.game_rule("dodaylightcycle")? {
                GameRuleValue::Bool(b) => b.to_string(),
                GameRuleValue::Int(i) => i.to_string(),
                GameRuleValue::Float(f) => f.to_string(),
            };
            w.set_game_rule("dodaylightcycle", &text)?;
            Ok(format!("wrote back {text}"))
        });
        run_test("world-set-biome-same", || {
            let ((x, y, z), dim) = p.position()?;
            let (x, y, z) = (x as i32, y as i32, z as i32);
            let biome = w.biome(dim, x, y, z)?;
            let n = w.set_biome(dim, (x, z), (x, z), &biome)?;
            Ok(format!("rewrote {n} column(s) with {biome}"))
        });
        run_test("player-teleport-same", || {
            let ((x, y, z), dim) = p.position()?;
            p.teleport(dim, x, y, z)?;
            Ok(format!("teleported to {x:.1} {y:.1} {z:.1}"))
        });
        run_test("player-set-gamemode-same", || {
            let m = p.game_type()?;
            p.set_gamemode(m)?;
            Ok(format!("wrote back {m:?}"))
        });
        run_test("player-set-num-same", || {
            let v = p.num(sys::PIER_PPROP_HUNGER)?;
            p.set_num(sys::PIER_PPROP_HUNGER, v)?;
            Ok(format!("hunger {v} written back"))
        });
        run_test("container-set-item-same", || {
            let c = p.inventory();
            let it = c.item(0)?;
            c.set_item(0, &it)?;
            c.refresh()?;
            Ok("slot 0 rewritten and refreshed".to_owned())
        });
        run_test("world-spawn-particle", || {
            let ((x, y, z), dim) = p.position()?;
            w.spawn_particle(dim, "minecraft:villager_happy", x, y + 1.0, z)?;
            Ok("spawned".to_owned())
        });
        run_test("player-spawn-particle", || {
            let ((x, y, z), dim) = p.position()?;
            p.spawn_particle(dim, "minecraft:villager_happy", x, y + 1.0, z)?;
            Ok("spawned".to_owned())
        });
    }

    if RUN_MUTATING {
        run_test("world-spawn-mob", || {
            let ((x, y, z), dim) = p.position()?;
            let e = w.spawn_mob(dim, "minecraft:chicken", x + 2.0, y, z)?;
            Ok(format!("spawned entity {}", e.id()))
        });
        run_test("player-disconnect", || {
            p.disconnect("probe finished")?;
            Ok("requested".to_owned())
        });
    }

    say("[suite] complete");
    say("[suite] not exercised, on purpose: lane publish/acquire/release (needs a contract), register_command and update_command_soft_enum (server command system), explode, the action slots player/actor/block act and item transform (each action id has side effects), container add/remove/clear, fill_region and set_blocks");
    print_results("suite complete");
}

// ---------------------------------------------------------------- the timer

// ---------------------------------------------------------------- client surface

/// Every key of the second client group, the text reads, and the verbs that leave nothing
/// behind; the ones that change the session wait for RUN_MUTATING.
fn run_client_surface_tests() {
    for prop in 0..69 {
        run_test(&format!("client-prop-{prop}"), || {
            Ok(format!("{}", client::property(prop)?))
        });
    }
    let c = client::Client;
    run_test("client-str-screen", || c.screen_name());
    run_test("client-str-top-screen", || c.top_screen_name());
    run_test("client-str-platform-id", || c.platform_id());
    run_test("client-str-platform-online-id", || c.platform_online_id());
    run_test("client-str-local-xuid", || c.local_xuid());
    run_test("client-str-local-uuid", || c.local_uuid());
    run_test("client-str-local-name-tag", || c.local_name_tag());
    run_test("client-str-clipboard", || {
        c.clipboard().map(|s| clip(&s, 40))
    });
    run_test("client-list-keys", || {
        Ok(client::registered_keys()?.join(","))
    });
    run_test("client-local-position", || {
        Ok(format!("{:?}", client::local_position()?))
    });
    run_test("client-options", || {
        Ok(format!("{} option(s)", client::options()?.len()))
    });
    run_test("client-option-read", || {
        let (key, _) = client::options()?
            .into_iter()
            .next()
            .ok_or_else(|| levilamina::Error("the client reported no options".to_owned()))?;
        Ok(format!("{key} = {}", client::option(&key)?))
    });
    run_test("native-gate", || {
        let enabled = levilamina::native::enabled();
        let answer = levilamina::native::object(levilamina::native::NativeObject::ClientInstance);
        match (enabled, answer) {
            (true, Ok(p)) => Ok(format!("enabled, ClientInstance at {p:p}")),
            (false, Err(e)) if e.to_string().contains("native_detour") => {
                Ok("off, and refused with the setting named".to_owned())
            }
            (on, other) => {
                ensure(
                    false,
                    &format!(
                        "enabled={on} but the call answered {:?}",
                        other.map(|p| p as usize)
                    ),
                )?;
                Ok(String::new())
            }
        }
    });

    if NOOP_WRITES {
        run_test("client-show-message", || {
            client::show_message("[probe] show_message works")?;
            Ok("shown".to_owned())
        });
        run_test("client-titles", || {
            client::set_title("[probe] title")?;
            client::set_subtitle("[probe] subtitle")?;
            client::set_action_bar("[probe] action bar")?;
            client::show_tip("[probe] tip")?;
            Ok("shown".to_owned())
        });
        run_test("client-popup", || {
            client::show_popup("[probe] popup", "subtitle")?;
            Ok("shown".to_owned())
        });
        run_test("client-dev-console", || {
            client::show_dev_console_message("[probe] dev console works")?;
            Ok("written".to_owned())
        });
        run_test("client-ui-sound", || {
            client::play_ui_sound("random.click", 1.0, 1.0)?;
            Ok("played".to_owned())
        });
        run_test("client-clipboard-same", || {
            let old = c.clipboard()?;
            client::set_clipboard(&old)?;
            Ok(format!("{} char(s) written back", old.chars().count()))
        });
        run_test("client-gui-scale-offset-same", || {
            let v = c.gui_scale_offset()?;
            client::set_gui_scale_offset(v)?;
            Ok(format!("wrote back {v}"))
        });
        run_test("client-option-same", || {
            let (key, value) = client::options()?
                .into_iter()
                .next()
                .ok_or_else(|| levilamina::Error("the client reported no options".to_owned()))?;
            client::set_option(&key, &value)?;
            Ok(format!("wrote back {key} = {value}"))
        });
    }

    if RUN_MUTATING {
        run_test("client-audio-cycle", || {
            client::mute_audio()?;
            client::unmute_audio()?;
            Ok("muted and unmuted".to_owned())
        });
        run_test("client-input-cycle", || {
            client::set_suspend_input(true)?;
            client::set_suspend_input(false)?;
            client::set_suspend_directional_input(true)?;
            client::set_suspend_directional_input(false)?;
            Ok("suspended and resumed".to_owned())
        });
        run_test("client-mouse-cycle", || {
            client::release_mouse()?;
            client::grab_mouse()?;
            Ok("released and grabbed".to_owned())
        });
    }
}

fn arm_timer(delay: Duration) {
    match Host::get().schedule_after(delay, || {
        if !ENABLED.load(Ordering::Relaxed) {
            return;
        }
        stats().timer_fired += 1;
        print_event_summary("timer");
        arm_timer(Duration::from_secs(TIMER_SECONDS));
    }) {
        Ok(task) => say(&format!("[schedule] ticket {}", task.raw())),
        Err(e) => say(&format!("[schedule] schedule_after failed: {e}")),
    }
}

// ---------------------------------------------------------------- the mod

struct ClientProbe {
    listeners: Vec<Listener>,
    keys: Vec<KeyBinding>,
}

impl LeviMod for ClientProbe {
    fn on_load(ctx: &ModContext) -> Result<Self> {
        recover_inflight();
        say("[probe] pier-client-probe v2");
        let (abi, table_len) = ctx.host_abi();
        say(&format!(
            "[probe] loaded. host ABI v{abi}, table {table_len} bytes, target={}, files in {}",
            if ctx.host_is_client() {
                "client"
            } else {
                "server"
            },
            state_dir().display()
        ));
        // Registered before the game builds its input mapping, to compare with the pair
        // registered in on_enable.
        let mut keys = Vec::new();
        keys.extend(bind("pier_probe_early", KEY_EARLY, "early (on_load)"));
        Ok(ClientProbe {
            listeners: Vec::new(),
            keys,
        })
    }

    fn on_enable(&mut self, _ctx: &ModContext) -> Result<()> {
        ENABLED.store(true, Ordering::Relaxed);
        stats().subscribed.clear();

        report_slots();
        report_registry();
        log_client_state("enable");

        self.keys
            .extend(bind("pier_probe_late_a", KEY_STATE, "late a (on_enable)"));
        self.keys
            .extend(bind("pier_probe_late_b", KEY_RESULTS, "late b (on_enable)"));
        probe_unregister();

        subscribe_all(&mut self.listeners);
        run_independent_tests();
        arm_timer(Duration::from_secs(5));
        say("[probe] ready. Join a world and wait: the in-world tests start three seconds after the join.");
        say("[probe] F4 then E: cancel test. F6: render events for 3 s. F8: state. F9: results. To test ClientCancelJoinLevelEvent, start joining a world and cancel on the loading screen.");
        say("[probe] if the game crashes, start it again and rejoin; repeat until the line [suite] complete appears");
        Ok(())
    }

    fn on_disable(&mut self, _ctx: &ModContext) -> Result<()> {
        say("[life] on_disable was called");
        ENABLED.store(false, Ordering::Relaxed);
        print_event_summary("disable");
        print_results("disable");
        self.listeners.clear();
        self.keys.clear();
        Ok(())
    }

    fn on_unload(&mut self, _ctx: &ModContext) -> Result<()> {
        say("[life] on_unload was called");
        Ok(())
    }
}

levilamina::register_mod!(ClientProbe);
