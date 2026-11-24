//! kvdb.zig: a small persistent key-value store the host keeps for the mod.

const std = @import("std");
const core = @import("core.zig");
const types = @import("types.zig");

const c = core.c;
const Allocator = std.mem.Allocator;

/// One key and its value.
pub const Pair = struct {
    key: []const u8,
    value: []const u8,
};

const PairCollector = struct {
    arena: Allocator,
    list: std.ArrayList(Pair) = .empty,
    failed: bool = false,

    fn sink(ctx: ?*anyopaque, key: c.PierStr, value: c.PierStr) callconv(.c) void {
        const self: *PairCollector = @ptrCast(@alignCast(ctx orelse return));
        if (self.failed) return;
        const k = self.arena.dupe(u8, core.view(key)) catch {
            self.failed = true;
            return;
        };
        const v = self.arena.dupe(u8, core.view(value)) catch {
            self.failed = true;
            return;
        };
        self.list.append(self.arena, .{ .key = k, .value = v }) catch {
            self.failed = true;
        };
    }
};

/// One open key-value store. `close` releases it.
pub const KvDb = struct {
    handle: c.PierKvDbHandle,

    /// Opens it, creating it when it does not exist.
    pub fn open(path: []const u8) core.Error!KvDb {
        return openWith(path, true);
    }

    /// Opens an existing one only. A store that does not exist is Refused and no empty one is
    /// created in its place.
    pub fn openExisting(path: []const u8) core.Error!KvDb {
        return openWith(path, false);
    }

    fn openWith(path: []const u8, create: bool) core.Error!KvDb {
        const f = core.slot("kvdb_open") orelse return error.NotProvided;
        const h = f(core.handle(), core.str(path), create);
        if (h == null) return error.Refused;
        return .{ .handle = h };
    }

    /// Closes the store; calling it twice is harmless.
    pub fn close(self: *KvDb) void {
        if (self.handle == null) return;
        const f = core.slot("kvdb_close") orelse return;
        f(self.handle);
        self.handle = null;
    }

    /// Reads one key, owned by the caller: null for a key that does not exist.
    pub fn get(self: KvDb, allocator: Allocator, key: []const u8) core.Error!?[]u8 {
        const f = core.slot("kvdb_get") orelse return error.NotProvided;
        var col = core.Collector.init(allocator);
        defer col.deinit();
        if (!f(self.handle, core.str(key), &col, &core.Collector.sink)) return null;
        return try col.takeOrEmpty();
    }

    pub fn set(self: KvDb, key: []const u8, value: []const u8) core.Error!void {
        const f = core.slot("kvdb_set") orelse return error.NotProvided;
        try core.expect(f(self.handle, core.str(key), core.str(value)));
    }

    /// Deletes one key. A key that never existed also counts as a success.
    pub fn del(self: KvDb, key: []const u8) core.Error!void {
        const f = core.slot("kvdb_del") orelse return error.NotProvided;
        try core.expect(f(self.handle, core.str(key)));
    }

    pub fn has(self: KvDb, key: []const u8) core.Error!bool {
        const f = core.slot("kvdb_has") orelse return error.NotProvided;
        return f(self.handle, core.str(key));
    }

    pub fn isEmpty(self: KvDb) core.Error!bool {
        const f = core.slot("kvdb_is_empty") orelse return error.NotProvided;
        return f(self.handle);
    }

    /// Every key and value. The whole store is read into memory, so a large one needs care.
    pub fn pairs(self: KvDb, allocator: Allocator) core.Error!types.Owned(Pair) {
        const f = core.slot("kvdb_iter") orelse return error.NotProvided;
        var arena = std.heap.ArenaAllocator.init(allocator);
        errdefer arena.deinit();
        const a = arena.allocator();
        var state = PairCollector{ .arena = a };
        f(self.handle, &state, &PairCollector.sink);
        if (state.failed) return error.OutOfMemory;
        return .{ .arena = arena, .items = try state.list.toOwnedSlice(a) };
    }
};
