/** Symbols.cpp: native_resolve_symbol, native_resolve_signature and native_module_export. */
#include <cctype>
#include <optional>
#include <string>
#include <string_view>

#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#include <windows.h>

#include "ll/api/memory/Signature.h"
#include "ll/api/memory/Symbol.h"
#include "ll/api/utils/StringUtils.h"

#include "sdk/abi.h"

#include "pier/api/native.h"
#include "pier/host/spi.h"
#include "pier/support/guard.h"
#include "pier/support/str.h"

namespace pier::native
{
    namespace
    {
        /** The pattern rebuilt with one space between tokens, or nothing when a token is
         *  neither two hexadecimal digits nor a wildcard. Signature::parse reads the first
         *  two characters of a token as digits without checking them, so a typo would turn
         *  into some byte and match an unrelated place. It also reads an empty token, which
         *  a doubled space produces, past its end. */
        std::optional<std::string> normalized(std::string_view pattern)
        {
            std::string out;
            std::size_t i = 0;
            while (i < pattern.size())
            {
                if (pattern[i] == ' ')
                {
                    ++i;
                    continue;
                }
                auto const end = pattern.find(' ', i);
                auto const token = pattern.substr(i, end == std::string_view::npos ? end : end - i);
                bool const wild = token == "?" || token == "??";
                bool const hex = token.size() == 2 && std::isxdigit(static_cast<unsigned char>(token[0]))
                              && std::isxdigit(static_cast<unsigned char>(token[1]));
                if (!wild && !hex) return std::nullopt;
                if (!out.empty()) out += ' ';
                out += token;
                if (end == std::string_view::npos) break;
                i = end + 1;
            }
            if (out.empty()) return std::nullopt;
            return out;
        }

        std::int32_t api_native_resolve_symbol(PierModHandle mod, PierStr symbol, void** out)
        {
            PIER_API_GUARD_BEGIN
                if (out) *out = nullptr;
                if (auto const g = gate(mod); g != PIER_NATIVE_OK) return g;
                if (!out || symbol.len == 0) return PIER_NATIVE_REFUSED;
                std::string const text = toString(symbol);
                void* found = ll::memory::SymbolView{std::string_view{text}}.resolve(true);
                if (!found) return PIER_NATIVE_NOT_FOUND;
                *out = found;
                return PIER_NATIVE_OK;
            PIER_API_GUARD_END_VAL(PIER_NATIVE_REFUSED)
        }

        std::int32_t api_native_resolve_signature(PierModHandle mod, PierStr pattern, void** out)
        {
            PIER_API_GUARD_BEGIN
                if (out) *out = nullptr;
                if (auto const g = gate(mod); g != PIER_NATIVE_OK) return g;
                if (!out) return PIER_NATIVE_REFUSED;
                auto const text = normalized(sv(pattern));
                if (!text) return PIER_NATIVE_REFUSED;
                auto const signature = ll::memory::Signature::parse(*text);
                void* found = ll::memory::SignatureView{signature}.resolve(true);
                if (!found) return PIER_NATIVE_NOT_FOUND;
                *out = found;
                return PIER_NATIVE_OK;
            PIER_API_GUARD_END_VAL(PIER_NATIVE_REFUSED)
        }

        std::int32_t api_native_module_export(PierModHandle mod, PierStr moduleName, PierStr name, void** out)
        {
            PIER_API_GUARD_BEGIN
                if (out) *out = nullptr;
                if (auto const g = gate(mod); g != PIER_NATIVE_OK) return g;
                if (!out || name.len == 0) return PIER_NATIVE_REFUSED;
                // GetModuleHandle and not LoadLibrary: a lookup must not map a dll into the
                // server as a side effect.
                HMODULE image = moduleName.len == 0
                                  ? GetModuleHandleW(nullptr)
                                  : GetModuleHandleW(ll::string_utils::str2wstr(sv(moduleName)).c_str());
                if (!image) return PIER_NATIVE_NOT_FOUND;
                std::string const symbol = toString(name);
                auto* found = reinterpret_cast<void*>(GetProcAddress(image, symbol.c_str()));
                if (!found) return PIER_NATIVE_NOT_FOUND;
                *out = found;
                return PIER_NATIVE_OK;
            PIER_API_GUARD_END_VAL(PIER_NATIVE_REFUSED)
        }

        void fill(PierApi& api)
        {
            api.native_resolve_symbol = &api_native_resolve_symbol;
            api.native_resolve_signature = &api_native_resolve_signature;
            api.native_module_export = &api_native_module_export;
        }

        spi::SlotPackReg regSlots{{"native-symbols", &fill}};
    } // namespace
} // namespace pier::native
