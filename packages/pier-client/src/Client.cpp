/** pier-client/Client.cpp: the client-only capability group (PIER_BUILD_CLIENT).
 *
 * Every callback runs on the client thread, where KeyRegistry dispatches.
 *
 * Every engine call below goes through IClientInstance, a vtable call that imports no
 * engine symbol, or through a LeviLamina export. The GuiData message calls are the
 * exception and are imported, since GuiData has no virtual for them.
 *
 * Key binding lifetime: KeyRegistry owns the KeyHandle and this package holds a raw
 * pointer to it inside ClientKeyEntry. Unregistering marks the entry dead, which
 * turns the handler into a no-op, and frees the entry.
 */
#ifdef PIER_BUILD_CLIENT

#include <algorithm>
#include <chrono>
#include <memory>
#include <optional>
#include <string>
#include <utility>
#include <vector>

#include "ll/api/input/KeyHandle.h"
#include "ll/api/input/KeyRegistry.h"
#include "ll/api/mod/NativeMod.h"
#include "ll/api/service/TargetedBedrock.h"
#include "ll/api/utils/StringUtils.h"

#include "mc/client/game/ClientInstance.h"
#include "mc/client/game/IClientInstance.h"
#include "mc/client/gui/GuiData.h"
#include "mc/deps/application/AppPlatform.h"
#include "mc/deps/input/enums/FocusImpact.h"
#include "mc/client/player/LocalPlayer.h"
#include "mc/platform/UUID.h"
#include "mc/world/actor/player/Player.h"
#include "mc/client/options/IOptionRegistry.h"
#include "mc/options/option_types/Option.h"
#include "mc/options/option_types/OptionID.h"

#include "sdk/abi.h"

#include "pier/host/hosted_mod.h"
#include "pier/host/spi.h"
#include "pier/support/guard.h"
#include "pier/support/snbt.h"
#include "pier/support/str.h"

namespace pier::api_impl
{
    namespace
    {
        struct ClientKeyEntry
        {
            std::string name;
            ll::input::KeyHandle* handle;
            PierKeyCb down_cb;
            PierKeyCb up_cb;
            void* user;
            std::shared_ptr<bool> alive;
            /** Identity only, never dereferenced. Used to drop this binding when its
             *  mod is unloaded. */
            HostedMod* owner = nullptr;
        };

        /**
         * Every live binding, so that an unload can reach the ones a mod forgot to
         * unregister.
         *
         * A KeyRegistry handler outlives the mod's dylib. It captures the raw down_cb
         * and up_cb function pointers and nothing can detach it after registration.
         * `alive` is the only way to turn such a handler into a no-op, and this table
         * is what sets it to false outside an explicit client_unregister_key. A mod
         * that registers a hotkey and is then unloaded would otherwise leave behind an
         * armed handler pointing into unmapped memory.
         *
         * Client thread only, since KeyRegistry dispatches there and registration
         * comes from the same thread, so no lock is needed.
         */
        std::vector<ClientKeyEntry*>& liveEntries()
        {
            static std::vector<ClientKeyEntry*> entries;
            return entries;
        }

        /** Tears one down. Turns the handler into a no-op and frees the entry. */
        void destroyEntry(ClientKeyEntry* entry)
        {
            *entry->alive = false;
            delete entry;
        }

        PierFocusImpact toAbiFocus(::FocusImpact fi)
        {
            return static_cast<PierFocusImpact>(static_cast<int>(fi));
        }

        bool api_client_get_local_player(void* ctx, PierStrSink sink)
        {
            PIER_API_GUARD_BEGIN
                if (!sink) return false;
                auto ci = ll::service::getClientInstance();
                if (!ci) return false;
                auto* player = ci->getLocalPlayer();
                if (!player) return false;
                sink(ctx, ps(player->getRealName()));
                return true;
            PIER_API_GUARD_END
        }

        bool api_client_is_in_level()
        {
            PIER_API_GUARD_BEGIN
                return ll::service::getMultiPlayerLevel() != nullptr;
            PIER_API_GUARD_END
        }

        PierKeyHandle api_client_register_key(
            PierModHandle modHandle,
            PierStr name,
            int32_t const* keyCodes,
            int32_t keyCount,
            bool allowRemap,
            PierKeyCb downCb,
            PierKeyCb upCb,
            void* user)
        {
            PIER_API_GUARD_BEGIN
                auto* mod = asMod(modHandle);
                if (!mod || name.len == 0 || !keyCodes || keyCount <= 0) return nullptr;

                auto entry = std::make_unique<ClientKeyEntry>();
                entry->name = toString(name);
                entry->down_cb = downCb;
                entry->up_cb = upCb;
                entry->user = user;
                entry->alive = std::make_shared<bool>(true);

                std::vector<int> keys(keyCodes, keyCodes + keyCount);
                // The fourth argument, the owning mod, is left at its default, which
                // KeyRegistry declares as mod::NativeMod::current(). That is the host
                // NativeMod named pier, which is what attribution should say: a hosted
                // mod is not an LL mod, it is a child of the host. To LL the key is
                // registered by pier, while cleanup per hosted mod is this package's
                // job through liveEntries and owner.
                auto& handle = ll::input::KeyRegistry::getInstance().getOrCreateKey(
                    entry->name, keys, allowRemap
                );
                entry->handle = &handle;

                auto alive = entry->alive;
                auto downCbCapture = downCb;
                auto upCbCapture = upCb;
                auto userCapture = user;

                handle.registerButtonDownHandler(
                    [alive, downCbCapture, userCapture](::FocusImpact fi, ::IClientInstance&)
                    {
                        if (!*alive || !downCbCapture) return;
                        downCbCapture(userCapture, /*Down=*/1, toAbiFocus(fi));
                    }
                );
                handle.registerButtonUpHandler(
                    [alive, upCbCapture, userCapture](::FocusImpact fi, ::IClientInstance&)
                    {
                        if (!*alive || !upCbCapture) return;
                        upCbCapture(userCapture, /*Up=*/0, toAbiFocus(fi));
                    }
                );

                entry->owner = mod;
                auto* raw = entry.release();
                liveEntries().push_back(raw);
                return reinterpret_cast<PierKeyHandle>(raw);
            PIER_API_GUARD_END
        }

        bool api_client_unregister_key(PierKeyHandle handle)
        {
            PIER_API_GUARD_BEGIN
                if (!handle) return false;
                auto* entry = reinterpret_cast<ClientKeyEntry*>(handle);
                auto& live = liveEntries();
                auto it = std::find(live.begin(), live.end(), entry);
                // Absence from the table means it was already torn down, either by a
                // repeated unregister or because its mod was unloaded first. Deleting
                // unconditionally here would make a repeated unregister a double free.
                if (it == live.end()) return false;
                live.erase(it);
                destroyEntry(entry);
                return true;
            PIER_API_GUARD_END
        }

        bool api_client_get_key_codes(PierKeyHandle handle, void* ctx, PierStrSink sink)
        {
            PIER_API_GUARD_BEGIN
                if (!handle || !sink) return false;
                auto* entry = reinterpret_cast<ClientKeyEntry*>(handle);
                if (!entry->handle) return false;
                auto const& codes = entry->handle->getKeyCodes();
                std::string out = "[";
                for (size_t i = 0; i < codes.size(); ++i)
                {
                    if (i) out += ',';
                    out += snbtNum(codes[i]);
                }
                out += "]";
                sink(ctx, ps(out));
                return true;
            PIER_API_GUARD_END
        }

        /** The instance seen through its interface, so each call below is a vtable call.
         *  nullptr before the client has built one. */
        ::IClientInstance* client()
        {
            auto ci = ll::service::getClientInstance();
            return ci ? static_cast<::IClientInstance*>(ci.as_ptr()) : nullptr;
        }

        double flag(bool v) { return v ? 1.0 : 0.0; }

        /** The keys that read the local player: 0 to 5 and 13 to 27, as abi.h numbers them. */
        bool isLocalKey(int32_t prop)
        {
            return (prop >= PIER_CPROP_POS_X && prop <= PIER_CPROP_DIMENSION)
                || (prop >= PIER_CPROP_HEALTH && prop <= PIER_CPROP_XP_NEEDED_NEXT_LEVEL);
        }

        bool readLocal(::LocalPlayer& player, int32_t prop, double* out)
        {
            switch (prop)
            {
            case PIER_CPROP_POS_X: *out = player.getFeetPos().x; return true;
            case PIER_CPROP_POS_Y: *out = player.getFeetPos().y; return true;
            case PIER_CPROP_POS_Z: *out = player.getFeetPos().z; return true;
            case PIER_CPROP_PITCH: *out = player.getRotation().x; return true;
            case PIER_CPROP_YAW: *out = player.getRotation().y; return true;
            case PIER_CPROP_DIMENSION: *out = static_cast<double>(static_cast<int>(player.getDimensionId())); return true;
            case PIER_CPROP_HEALTH: *out = static_cast<double>(player.getHealth()); return true;
            case PIER_CPROP_MAX_HEALTH: *out = static_cast<double>(player.getMaxHealth()); return true;
            case PIER_CPROP_IS_ON_GROUND: *out = flag(player.isOnGround()); return true;
            case PIER_CPROP_IS_IN_WATER: *out = flag(player.isInWater()); return true;
            case PIER_CPROP_IS_SNEAKING: *out = flag(player.isSneaking()); return true;
            case PIER_CPROP_IS_SPRINTING: *out = flag(player.isSprinting()); return true;
            case PIER_CPROP_IS_SWIMMING: *out = flag(player.isSwimming()); return true;
            case PIER_CPROP_IS_ON_FIRE: *out = flag(player.isOnFire()); return true;
            case PIER_CPROP_IS_FLYING: *out = flag(player.isFlying()); return true;
            case PIER_CPROP_GAME_TYPE: *out = static_cast<double>(static_cast<int>(player.getPlayerGameType())); return true;
            case PIER_CPROP_SELECTED_SLOT: *out = static_cast<double>(player.getSelectedItemSlot()); return true;
            case PIER_CPROP_VEL_X: *out = player.getPosDelta().x; return true;
            case PIER_CPROP_VEL_Y: *out = player.getPosDelta().y; return true;
            case PIER_CPROP_VEL_Z: *out = player.getPosDelta().z; return true;
            case PIER_CPROP_XP_NEEDED_NEXT_LEVEL: *out = static_cast<double>(player.getXpNeededForNextLevel()); return true;
            default: return false;
            }
        }

        bool readInstance(::IClientInstance& ci, int32_t prop, double* out)
        {
            switch (prop)
            {
            case PIER_CPROP_GUI_SCALE: *out = static_cast<double>(ci.getGuiScale()); return true;
            case PIER_CPROP_SERVER_PING_MS: *out = static_cast<double>(ci.getServerPingTime().count()); return true;
            case PIER_CPROP_IS_SHOWING_MENU: *out = flag(ci.isShowingMenu()); return true;
            case PIER_CPROP_IS_SHOWING_PAUSE_SCREEN: *out = flag(ci.isShowingPauseScreen()); return true;
            case PIER_CPROP_IS_PLAYING: *out = flag(ci.isPlaying()); return true;
            case PIER_CPROP_IS_IN_REALM: *out = flag(ci.isInRealm()); return true;
            case PIER_CPROP_IS_GAME_INPUT_ENABLED: *out = flag(ci.isInGameInputEnabled()); return true;
            case PIER_CPROP_IS_LEAVING_GAME: *out = flag(ci.isLeavingGame()); return true;
            case PIER_CPROP_IS_EXITING_LEVEL: *out = flag(ci.isExitingLevel()); return true;
            case PIER_CPROP_IS_IN_BED_SCREEN: *out = flag(ci.isInBedScreen()); return true;
            case PIER_CPROP_IS_IN_DEATH_SCREEN: *out = flag(ci.isInDeathScreen()); return true;
            case PIER_CPROP_IS_SHOWING_LOADING_SCREEN: *out = flag(ci.isShowingLoadingScreen()); return true;
            case PIER_CPROP_IS_SHOWING_PROGRESS_SCREEN: *out = flag(ci.isShowingProgressScreen()); return true;
            case PIER_CPROP_IS_SHOWING_WORLD_PROGRESS_SCREEN: *out = flag(ci.isShowingWorldProgressScreen()); return true;
            case PIER_CPROP_IS_SHOWING_DEATH_SCREEN: *out = flag(ci.isShowingDeathScreen()); return true;
            case PIER_CPROP_IS_SHOWING_SERVER_FORM: *out = flag(ci.isShowingServerForm()); return true;
            case PIER_CPROP_IS_IN_WORLD_WITHOUT_MENU: *out = flag(ci.isInWorldAndNotShowingAnyMenuScreens()); return true;
            case PIER_CPROP_IS_WORLD_ACTIVE: *out = flag(ci.isWorldActive()); return true;
            case PIER_CPROP_HAS_LEVEL: *out = flag(ci.hasLevel()); return true;
            case PIER_CPROP_IS_PRE_GAME: *out = flag(ci.isPreGame()); return true;
            case PIER_CPROP_IS_IN_MULTIPLAYER_GAME: *out = flag(ci.isInMultiplayerGame()); return true;
            case PIER_CPROP_IS_MULTIPLAYER_CLIENT: *out = flag(ci.isMultiPlayerClient()); return true;
            case PIER_CPROP_IS_PRIMARY_LEVEL_MULTIPLAYER: *out = flag(ci.isPrimaryLevelMultiplayer()); return true;
            case PIER_CPROP_IS_PRIMARY_LEVEL_CROSS_PLATFORM: *out = flag(ci.isPrimaryLevelCrossPlatformMultiplayer()); return true;
            case PIER_CPROP_IS_KEYBOARD_ENABLED: *out = flag(ci.isKeyboardEnabled()); return true;
            case PIER_CPROP_IS_USING_CONTROLLER: *out = flag(ci.useController()); return true;
            case PIER_CPROP_IS_USING_TOUCHSCREEN: *out = flag(ci.useTouchscreen()); return true;
            case PIER_CPROP_IS_MOUSE_GRABBED: *out = flag(ci.getMouseGrabbed()); return true;
            case PIER_CPROP_IS_MOUSE_AND_KEYBOARD: *out = flag(ci.currentInputModeIsMouseAndKeyboard()); return true;
            case PIER_CPROP_HAS_CONNECTED_CONTROLLER: *out = flag(ci.hasConnectedController()); return true;
            case PIER_CPROP_CONTROLLER_ID: *out = static_cast<double>(ci.getControllerId()); return true;
            case PIER_CPROP_IS_TOUCH_GAMEPLAY_ALLOWED: *out = flag(ci.isTouchGameplayAllowed()); return true;
            case PIER_CPROP_IS_SPLIT_SCREEN_ACTIVE: *out = flag(ci.isSplitScreenActive()); return true;
            case PIER_CPROP_SPLIT_SCREEN_COUNT: *out = static_cast<double>(ci.getSplitScreenCount()); return true;
            case PIER_CPROP_GUI_SCALE_OFFSET: *out = static_cast<double>(ci.getGuiScaleOffset()); return true;
            case PIER_CPROP_IS_EDU_MODE: *out = flag(ci.isEduMode()); return true;
            case PIER_CPROP_IS_IN_EDITOR: *out = flag(ci.isPlayerInEditor()); return true;
            case PIER_CPROP_IS_READY_TO_RENDER: *out = flag(ci.isReadyToRender()); return true;
            case PIER_CPROP_IS_FULL_VANILLA_PACK_ON_STACK: *out = flag(ci.isFullVanillaPackOnStack()); return true;
            case PIER_CPROP_SERVER_CONNECTION_TIME: *out = static_cast<double>(ci.getServerConnectionTime()); return true;
            case PIER_CPROP_REMOTE_SERVER_TIME_MS: *out = static_cast<double>(ci.getRemoteServerTimeMs()); return true;
            case PIER_CPROP_REMOTE_SERVER_NETWORK_TIME_MS: *out = static_cast<double>(ci.getRemoteServerNetworkTimeMs()); return true;
            case PIER_CPROP_FRAME_ALPHA: *out = static_cast<double>(ci.getFrameAlpha()); return true;
            case PIER_CPROP_GAME_UPDATE_SECONDS: *out = static_cast<double>(ci.getGameUpdateDurationInSeconds()); return true;
            case PIER_CPROP_IS_PRIMARY_CLIENT: *out = flag(ci.isPrimaryClient()); return true;
            case PIER_CPROP_USER_ID: *out = static_cast<double>(ci.getUserId()); return true;
            case PIER_CPROP_IS_GAMEPLAY_TIPS_ENABLED: *out = flag(ci.isGamePlayTipsEnabled()); return true;
            case PIER_CPROP_HAS_COMMANDS: *out = flag(ci.hasCommands()); return true;
            default: return false;
            }
        }

        bool api_client_get_num(int32_t prop, double* out)
        {
            PIER_API_GUARD_BEGIN
                if (!out) return false;
                auto* ci = client();
                if (!ci) return false;
                if (!isLocalKey(prop)) return readInstance(*ci, prop, out);
                auto* player = ci->getLocalPlayer();
                return player && readLocal(*player, prop, out);
            PIER_API_GUARD_END
        }

        bool api_client_get_str(int32_t prop, void* ctx, PierStrSink sink)
        {
            PIER_API_GUARD_BEGIN
                if (!sink) return false;
                auto* ci = client();
                if (!ci) return false;
                std::string value;
                switch (prop)
                {
                case PIER_CSTR_SCREEN_NAME: value = ci->getScreenName(); break;
                case PIER_CSTR_TOP_SCREEN_NAME: value = ci->getTopScreenName(); break;
                case PIER_CSTR_PLATFORM_ID: value = ci->getPlatformId(); break;
                case PIER_CSTR_PLATFORM_ONLINE_ID: value = ci->getPlatformOnlineId(); break;
                case PIER_CSTR_LOCAL_XUID:
                case PIER_CSTR_LOCAL_UUID:
                case PIER_CSTR_LOCAL_NAME_TAG:
                    {
                        auto* player = ci->getLocalPlayer();
                        if (!player) return false;
                        if (prop == PIER_CSTR_LOCAL_XUID) value = player->getXuid();
                        else if (prop == PIER_CSTR_LOCAL_UUID) value = player->getUuid().asString();
                        else value = player->getNameTag();
                        break;
                    }
                case PIER_CSTR_CLIPBOARD:
                    {
                        auto app = ll::service::getAppPlatform();
                        if (!app) return false;
                        value = ll::string_utils::wstr2str(app->getClipboardText());
                        break;
                    }
                default: return false;
                }
                sink(ctx, ps(value));
                return true;
            PIER_API_GUARD_END
        }

        bool api_client_get_screen_name(void* ctx, PierStrSink sink)
        {
            return api_client_get_str(PIER_CSTR_SCREEN_NAME, ctx, sink);
        }

        /** The text verbs. The HUD they write to belongs to a loaded world, and the local
         *  player exists exactly while one is loaded. */
        bool hudText(::IClientInstance& ci, int32_t action, std::string const& text)
        {
            if (text.empty() || !ci.getLocalPlayer()) return false;
            auto gui = ci.getGuiData();
            switch (action)
            {
            case PIER_CACT_SHOW_MESSAGE: gui->displayClientMessage(text, std::nullopt, false); return true;
            case PIER_CACT_SET_TITLE: gui->setTitle(text, std::nullopt); return true;
            case PIER_CACT_SET_SUBTITLE: gui->setSubtitle(text, std::nullopt); return true;
            case PIER_CACT_SET_ACTION_BAR: gui->setActionBarMessage(text, std::nullopt); return true;
            case PIER_CACT_SHOW_TIP: gui->showTipMessage(text); return true;
            case PIER_CACT_SHOW_POPUP:
                {
                    auto const cut = text.find('\n');
                    std::string const subtitle = cut == std::string::npos ? std::string{} : text.substr(cut + 1);
                    gui->showPopupNotice(text.substr(0, cut), subtitle);
                    return true;
                }
            case PIER_CACT_SHOW_DEV_CONSOLE_MESSAGE: gui->displayDevConsoleMessage(text); return true;
            default: return false;
            }
        }

        bool api_client_action(int32_t action, PierStr sarg, double a, double b, double c)
        {
            (void)c;
            PIER_API_GUARD_BEGIN
                auto* ci = client();
                if (!ci) return false;
                auto const text = toString(sarg);
                switch (action)
                {
                case PIER_CACT_SHOW_MESSAGE:
                case PIER_CACT_SET_TITLE:
                case PIER_CACT_SET_SUBTITLE:
                case PIER_CACT_SET_ACTION_BAR:
                case PIER_CACT_SHOW_TIP:
                case PIER_CACT_SHOW_POPUP:
                case PIER_CACT_SHOW_DEV_CONSOLE_MESSAGE:
                    return hudText(*ci, action, text);
                case PIER_CACT_PLAY_UI_SOUND:
                    if (text.empty()) return false;
                    ci->playUI(text, static_cast<float>(a), static_cast<float>(b));
                    return true;
                case PIER_CACT_GRAB_MOUSE: ci->grabMouse(); return true;
                case PIER_CACT_RELEASE_MOUSE: ci->releaseMouse(); return true;
                case PIER_CACT_SET_INPUT_DISABLED: ci->setDisableInput(a != 0.0); return true;
                case PIER_CACT_LEAVE_LEVEL: ci->requestLeaveGame(true, false); return true;
                case PIER_CACT_SET_SUSPEND_INPUT: ci->setSuspendInput(a != 0.0); return true;
                case PIER_CACT_SET_SUSPEND_DIRECTIONAL_INPUT: ci->setSuspendDirectionalInput(a != 0.0); return true;
                case PIER_CACT_SET_GAME_INPUT_ENABLED: ci->setInGameInputEnabled(a != 0.0); return true;
                case PIER_CACT_REFOCUS_MOUSE: ci->refocusMouse(a != 0.0); return true;
                case PIER_CACT_MUTE_AUDIO: ci->muteAudio(); return true;
                case PIER_CACT_UNMUTE_AUDIO: ci->unMuteAudio(); return true;
                case PIER_CACT_FADE_OUT_MUSIC: ci->fadeOutMusic(); return true;
                case PIER_CACT_SET_GUI_SCALE_OFFSET: ci->setGuiScaleOffset(static_cast<int>(a)); return true;
                case PIER_CACT_RESET_PLAYER_MOVEMENT: ci->resetPlayerMovement(); return true;
                case PIER_CACT_PUSH_LEAVE_GAME_SCREEN: ci->tryPushLeaveGameScreen(); return true;
                case PIER_CACT_OPEN_CONTENT_LOG_HISTORY: ci->openContentLogHistory(); return true;
                case PIER_CACT_NAVIGATE_HOW_TO_PLAY: ci->navigateToHowToPlayScreen(text); return true;
                case PIER_CACT_SET_CLIPBOARD:
                    {
                        auto app = ll::service::getAppPlatform();
                        if (!app) return false;
                        app->setClipboard(text);
                        return true;
                    }
                default: return false;
                }
            PIER_API_GUARD_END
        }

        /** The ids probed. The header declares OptionID with no enumerators, so the registry
         *  is asked id by id which ones exist, and isValidOption keeps a probe past the end
         *  from indexing anything. */
        constexpr int kOptionIdLimit = 4096;

        /** Calls `visit(option, key, value)` for every pair the valid options save, and stops
         *  at the first call that returns true, reporting whether one did. */
        template <class Visit>
        bool forEachOption(::IClientInstance& ci, Visit&& visit)
        {
            auto& registry = ci.getOptions();
            std::vector<std::pair<std::string, std::string>> pairs;
            for (int id = 0; id < kOptionIdLimit; ++id)
            {
                auto const optionId = static_cast<::OptionID>(id);
                if (!registry.isValidOption(optionId)) continue;
                auto found = registry.getIfValid(optionId);
                if (!found || !*found) continue;
                pairs.clear();
                (*found)->save(pairs);
                for (auto const& [key, value] : pairs)
                {
                    if (visit(**found, key, value)) return true;
                }
            }
            return false;
        }

        bool api_client_option_list(void* ctx, PierKvSink sink)
        {
            PIER_API_GUARD_BEGIN
                if (!sink) return false;
                auto* ci = client();
                if (!ci) return false;
                forEachOption(*ci, [&](::Option&, std::string const& key, std::string const& value)
                {
                    sink(ctx, ps(key), ps(value));
                    return false;
                });
                return true;
            PIER_API_GUARD_END
        }

        bool api_client_option_get(PierStr key, void* ctx, PierStrSink sink)
        {
            PIER_API_GUARD_BEGIN
                if (!sink || key.len == 0) return false;
                auto* ci = client();
                if (!ci) return false;
                auto const wanted = sv(key);
                return forEachOption(*ci, [&](::Option&, std::string const& k, std::string const& value)
                {
                    if (k != wanted) return false;
                    sink(ctx, ps(value));
                    return true;
                });
            PIER_API_GUARD_END
        }

        bool api_client_option_set(PierStr key, PierStr value)
        {
            PIER_API_GUARD_BEGIN
                if (key.len == 0) return false;
                auto* ci = client();
                if (!ci) return false;
                auto const wanted = sv(key);
                ::Option* target = nullptr;
                forEachOption(*ci, [&](::Option& option, std::string const& k, std::string const&)
                {
                    if (k != wanted) return false;
                    target = &option;
                    return true;
                });
                if (!target || !target->canModify()) return false;
                target->load(toString(value));
                return true;
            PIER_API_GUARD_END
        }

        bool api_client_list_keys(void* ctx, PierStrSink sink)
        {
            PIER_API_GUARD_BEGIN
                if (!sink) return false;
                for (auto const& name : ll::input::KeyRegistry::getInstance().getRegisteredKeys())
                {
                    sink(ctx, ps(name));
                }
                return true;
            PIER_API_GUARD_END
        }

        /** Teardown at stage 110. Drops every key binding held under this mod. */
        void teardown(HostedMod* mod)
        {
            if (!mod) return;
            auto& live = liveEntries();
            for (auto it = live.begin(); it != live.end();)
            {
                if ((*it)->owner != mod)
                {
                    ++it;
                    continue;
                }
                destroyEntry(*it);
                it = live.erase(it);
            }
        }

        void fill(PierApi& api)
        {
            api.client_get_local_player = &api_client_get_local_player;
            api.client_is_in_level = &api_client_is_in_level;
            api.client_register_key = &api_client_register_key;
            api.client_unregister_key = &api_client_unregister_key;
            api.client_get_key_codes = &api_client_get_key_codes;
            api.client_get_screen_name = &api_client_get_screen_name;
            api.client_get_num = &api_client_get_num;
            api.client_get_str = &api_client_get_str;
            api.client_action = &api_client_action;
            api.client_list_keys = &api_client_list_keys;
            api.client_option_list = &api_client_option_list;
            api.client_option_get = &api_client_option_get;
            api.client_option_set = &api_client_option_set;
        }

        spi::SlotPackReg regSlots{{"client", &fill}};
        spi::TeardownReg regDown{{110, "client", &teardown}};
    } // namespace
} // namespace pier::api_impl

#endif // PIER_BUILD_CLIENT
