//! The kinds of `native_object`, mirrored from `abi.h`. Append-only.

pub const PIER_NATIVE_OBJ_MINECRAFT: i32 = 0;
pub const PIER_NATIVE_OBJ_LEVEL: i32 = 1;
pub const PIER_NATIVE_OBJ_SERVER_NETWORK_HANDLER: i32 = 2;
pub const PIER_NATIVE_OBJ_SERVER_INSTANCE: i32 = 3;
pub const PIER_NATIVE_OBJ_COMMAND_REGISTRY: i32 = 4;
pub const PIER_NATIVE_OBJ_NETWORK_SYSTEM: i32 = 5;
pub const PIER_NATIVE_OBJ_DB_STORAGE: i32 = 6;
/// Client hosts only.
pub const PIER_NATIVE_OBJ_CLIENT_INSTANCE: i32 = 7;
/// Client hosts only: the level the client renders.
pub const PIER_NATIVE_OBJ_MULTIPLAYER_LEVEL: i32 = 8;
