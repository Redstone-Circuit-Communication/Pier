/** Objects.cpp: native_object and the four native slots that hand out one engine object. */
#include <cstdint>

#include "ll/api/service/Bedrock.h"
#ifdef PIER_BUILD_CLIENT
#include "ll/api/service/TargetedBedrock.h"
#endif

#include "mc/world/actor/Actor.h"
#include "mc/world/actor/player/Player.h"
#include "mc/world/level/BlockSource.h"
#include "mc/world/level/dimension/Dimension.h"

#include "sdk/abi.h"

#include "pier/api/bridge.h"
#include "pier/api/native.h"
#include "pier/host/spi.h"
#include "pier/support/guard.h"

namespace pier::native
{
    namespace
    {
        /** optional_ref is declared at global scope, next to the engine types, and not in ll. */
        template <class T>
        void* addressOf(optional_ref<T> ref)
        {
            return ref ? static_cast<void*>(ref.as_ptr()) : nullptr;
        }

        /** The tail every slot here shares: NOT_FOUND for a null object, else written. */
        std::int32_t hand(void* found, void** out)
        {
            if (!found) return PIER_NATIVE_NOT_FOUND;
            *out = found;
            return PIER_NATIVE_OK;
        }

        std::int32_t api_native_object(PierModHandle mod, std::int32_t kind, void** out)
        {
            PIER_API_GUARD_BEGIN
                if (out) *out = nullptr;
                if (auto const g = gate(mod); g != PIER_NATIVE_OK) return g;
                if (!out) return PIER_NATIVE_REFUSED;
                void* found = nullptr;
                switch (kind)
                {
                case PIER_NATIVE_OBJ_MINECRAFT: found = addressOf(ll::service::getMinecraft()); break;
                case PIER_NATIVE_OBJ_LEVEL: found = addressOf(ll::service::getLevel()); break;
                case PIER_NATIVE_OBJ_SERVER_NETWORK_HANDLER:
                    found = addressOf(ll::service::getServerNetworkHandler());
                    break;
                case PIER_NATIVE_OBJ_SERVER_INSTANCE: found = addressOf(ll::service::getServerInstance()); break;
                case PIER_NATIVE_OBJ_COMMAND_REGISTRY: found = addressOf(ll::service::getCommandRegistry()); break;
                case PIER_NATIVE_OBJ_NETWORK_SYSTEM: found = addressOf(ll::service::getNetworkSystem()); break;
                case PIER_NATIVE_OBJ_DB_STORAGE: found = addressOf(ll::service::getDBStorage()); break;
                // The two client kinds stay null on a server host, which answers NOT_FOUND as
                // abi.h says, rather than REFUSED for a kind this build does not know.
                case PIER_NATIVE_OBJ_CLIENT_INSTANCE:
#ifdef PIER_BUILD_CLIENT
                    found = addressOf(ll::service::getClientInstance());
#endif
                    break;
                case PIER_NATIVE_OBJ_MULTIPLAYER_LEVEL:
#ifdef PIER_BUILD_CLIENT
                    found = addressOf(ll::service::getMultiPlayerLevel());
#endif
                    break;
                default: return PIER_NATIVE_REFUSED;
                }
                return hand(found, out);
            PIER_API_GUARD_END_VAL(PIER_NATIVE_REFUSED)
        }

        std::int32_t api_native_player(PierModHandle mod, PierPlayerSel sel, void** out)
        {
            PIER_API_GUARD_BEGIN
                if (out) *out = nullptr;
                if (auto const g = gate(mod); g != PIER_NATIVE_OK) return g;
                if (!out) return PIER_NATIVE_REFUSED;
                return hand(static_cast<void*>(bridge::resolvePlayer(sel)), out);
            PIER_API_GUARD_END_VAL(PIER_NATIVE_REFUSED)
        }

        std::int32_t api_native_actor(PierModHandle mod, PierActorId id, void** out)
        {
            PIER_API_GUARD_BEGIN
                if (out) *out = nullptr;
                if (auto const g = gate(mod); g != PIER_NATIVE_OK) return g;
                if (!out) return PIER_NATIVE_REFUSED;
                return hand(static_cast<void*>(bridge::resolveActor(id)), out);
            PIER_API_GUARD_END_VAL(PIER_NATIVE_REFUSED)
        }

        std::int32_t api_native_dimension(PierModHandle mod, std::int32_t dim, void** out)
        {
            PIER_API_GUARD_BEGIN
                if (out) *out = nullptr;
                if (auto const g = gate(mod); g != PIER_NATIVE_OK) return g;
                if (!out) return PIER_NATIVE_REFUSED;
                auto* source = bridge::blockSourceOf(dim);
                return hand(source ? static_cast<void*>(&source->getDimension()) : nullptr, out);
            PIER_API_GUARD_END_VAL(PIER_NATIVE_REFUSED)
        }

        std::int32_t api_native_block_source(PierModHandle mod, std::int32_t dim, void** out)
        {
            PIER_API_GUARD_BEGIN
                if (out) *out = nullptr;
                if (auto const g = gate(mod); g != PIER_NATIVE_OK) return g;
                if (!out) return PIER_NATIVE_REFUSED;
                return hand(static_cast<void*>(bridge::blockSourceOf(dim)), out);
            PIER_API_GUARD_END_VAL(PIER_NATIVE_REFUSED)
        }

        void fill(PierApi& api)
        {
            api.native_object = &api_native_object;
            api.native_player = &api_native_player;
            api.native_actor = &api_native_actor;
            api.native_dimension = &api_native_dimension;
            api.native_block_source = &api_native_block_source;
        }

        spi::SlotPackReg regSlots{{"native-objects", &fill}};
    } // namespace
} // namespace pier::native
