//! The native escape hatch: engine addresses and native detours, for an engine call that no
//! other module wraps.
//!
//! The host checks nothing a mod does with an address. The caller answers for signatures,
//! calling conventions, the object layouts of this exact engine build, threads and
//! lifetimes. Getting an address is therefore safe and every use of it is `unsafe` at the
//! caller. The host's `config.json` has to set `"native_detour": true`; until it does,
//! every call returns an `Err` saying so and [`enabled`] returns false.

use core::ffi::c_void;

use crate::rt::error::{Error, Result};
use crate::rt::ffi::s;
use crate::rt::runtime::rt;
use crate::sys;

/// `ll::memory::HookPriority::Highest`: runs first.
pub const PRIORITY_HIGHEST: i32 = 0;
/// `ll::memory::HookPriority::High`.
pub const PRIORITY_HIGH: i32 = 100;
/// `ll::memory::HookPriority::Normal`.
pub const PRIORITY_NORMAL: i32 = 200;
/// `ll::memory::HookPriority::Low`.
pub const PRIORITY_LOW: i32 = 300;
/// `ll::memory::HookPriority::Lowest`: runs last.
pub const PRIORITY_LOWEST: i32 = 400;

/// Whether the host answers the native calls, which its `config.json` decides.
pub fn enabled() -> bool {
    if !crate::has_slot!(native_enabled) {
        return false;
    }
    match crate::__rt::api().native_enabled {
        Some(f) => unsafe { f() },
        None => false,
    }
}

fn check(code: i32, what: &str) -> Result<()> {
    match code {
        sys::PIER_NATIVE_OK => Ok(()),
        sys::PIER_NATIVE_DISABLED => Err(Error(format!(
            "{what}: the pier host has not enabled this feature; check whether native_detour is true in its config.json"
        ))),
        sys::PIER_NATIVE_NOT_FOUND => Err(Error(format!(
            "{what}: nothing by that name or id exists right now"
        ))),
        sys::PIER_NATIVE_REFUSED => Err(Error(format!("{what}: the host refused the arguments"))),
        sys::PIER_NATIVE_FAILED => Err(Error(format!("{what}: the engine-side call failed"))),
        other => Err(Error(format!(
            "{what}: the host answered {other}, a code this binding does not know"
        ))),
    }
}

fn address(what: &str, call: impl FnOnce(*mut *mut c_void) -> i32) -> Result<*mut c_void> {
    let mut out: *mut c_void = core::ptr::null_mut();
    check(call(&mut out), what)?;
    Ok(out)
}

/// The address of an engine function by its decorated symbol name.
pub fn resolve_symbol(symbol: &str) -> Result<*mut c_void> {
    let f = crate::require_slot!(native_resolve_symbol, "resolving a native symbol");
    address("resolving a native symbol", |out| unsafe {
        f(rt().handle(), s(symbol), out)
    })
}

/// The first match of a byte pattern such as `"48 8B ?? 08"` in the engine executable.
pub fn resolve_signature(pattern: &str) -> Result<*mut c_void> {
    let f = crate::require_slot!(native_resolve_signature, "resolving a byte pattern");
    address("resolving a byte pattern", |out| unsafe {
        f(rt().handle(), s(pattern), out)
    })
}

/// An export of a module already loaded into the process; an empty `module` names the
/// engine executable. LeviLamina's API is an export of `LeviLamina.dll`.
pub fn module_export(module: &str, name: &str) -> Result<*mut c_void> {
    let f = crate::require_slot!(native_module_export, "reading a module export");
    address("reading a module export", |out| unsafe {
        f(rt().handle(), s(module), s(name), out)
    })
}

/// The engine service objects [`object`] hands out.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum NativeObject {
    Minecraft,
    Level,
    ServerNetworkHandler,
    ServerInstance,
    CommandRegistry,
    NetworkSystem,
    DbStorage,
    /// Client hosts only.
    ClientInstance,
    /// Client hosts only: the level the client renders.
    MultiPlayerLevel,
}

impl NativeObject {
    fn raw(self) -> i32 {
        match self {
            NativeObject::Minecraft => sys::PIER_NATIVE_OBJ_MINECRAFT,
            NativeObject::Level => sys::PIER_NATIVE_OBJ_LEVEL,
            NativeObject::ServerNetworkHandler => sys::PIER_NATIVE_OBJ_SERVER_NETWORK_HANDLER,
            NativeObject::ServerInstance => sys::PIER_NATIVE_OBJ_SERVER_INSTANCE,
            NativeObject::CommandRegistry => sys::PIER_NATIVE_OBJ_COMMAND_REGISTRY,
            NativeObject::NetworkSystem => sys::PIER_NATIVE_OBJ_NETWORK_SYSTEM,
            NativeObject::DbStorage => sys::PIER_NATIVE_OBJ_DB_STORAGE,
            NativeObject::ClientInstance => sys::PIER_NATIVE_OBJ_CLIENT_INSTANCE,
            NativeObject::MultiPlayerLevel => sys::PIER_NATIVE_OBJ_MULTIPLAYER_LEVEL,
        }
    }
}

/// The address of one engine service object. An `Err` while it does not exist yet.
pub fn object(kind: NativeObject) -> Result<*mut c_void> {
    let f = crate::require_slot!(native_object, "reading a native object");
    address("reading a native object", |out| unsafe {
        f(rt().handle(), kind.raw(), out)
    })
}

/// The engine's Player object of an online player. Valid while the player stays online.
pub fn player(player: &crate::Player) -> Result<*mut c_void> {
    let f = crate::require_slot!(native_player, "reading a native player");
    let sel = player.sel();
    address("reading a native player", |out| unsafe {
        f(rt().handle(), sel.raw(), out)
    })
}

/// The engine's Actor object of a loaded actor. Valid while the actor stays loaded.
pub fn actor(entity: &crate::Entity) -> Result<*mut c_void> {
    let f = crate::require_slot!(native_actor, "reading a native actor");
    address("reading a native actor", |out| unsafe {
        f(rt().handle(), entity.id(), out)
    })
}

/// The engine's Dimension object of a dimension id, custom dimensions included.
pub fn dimension(dim: i32) -> Result<*mut c_void> {
    let f = crate::require_slot!(native_dimension, "reading a native dimension");
    address("reading a native dimension", |out| unsafe {
        f(rt().handle(), dim, out)
    })
}

/// The engine's BlockSource of a dimension id.
pub fn block_source(dim: i32) -> Result<*mut c_void> {
    let f = crate::require_slot!(native_block_source, "reading a native block source");
    address("reading a native block source", |out| unsafe {
        f(rt().handle(), dim, out)
    })
}

/// One installed detour: the id [`hook_remove`] takes, and the address through which the
/// detour calls the next detour or the engine.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct NativeHook {
    pub id: u64,
    pub original: *mut c_void,
}

/// Installs a detour on `target` through `ll::memory::hook`, at a `PRIORITY_*` value.
///
/// The host removes a detour this mod still holds when the mod unloads, before the dll is
/// unmapped, and does not wait for a call already inside it on another thread.
///
/// # Safety
/// `detour` must be an `extern` function with the exact signature and calling convention of
/// `target`. It must not unwind, and it reaches the engine through `original` only.
pub unsafe fn hook_install(
    target: *mut c_void,
    detour: *mut c_void,
    priority: i32,
) -> Result<NativeHook> {
    let f = crate::require_slot!(native_hook_install, "installing a native detour");
    let mut original: *mut c_void = core::ptr::null_mut();
    let mut id = 0u64;
    check(
        f(
            rt().handle(),
            target,
            detour,
            priority,
            &mut original,
            &mut id,
        ),
        "installing a native detour",
    )?;
    Ok(NativeHook { id, original })
}

/// Removes a detour this mod installed.
pub fn hook_remove(hook: NativeHook) -> Result<()> {
    let f = crate::require_slot!(native_hook_remove, "removing a native detour");
    check(
        unsafe { f(rt().handle(), hook.id) },
        "removing a native detour",
    )
}
