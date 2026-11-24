//! lane.zig: fast lanes, a typed call path between two mods that skips the text of the bus and
//! of services. A provider publishes a table of function pointers under a name; a consumer
//! acquires it with a fingerprint it computed itself from the same contract, and the loader
//! refuses the pair when the two differ. Raw pointers cross this boundary, so a mod that does
//! not need the speed should prefer a service.

const std = @import("std");
const core = @import("core.zig");
const types = @import("types.zig");
const internal = @import("internal.zig");

const c = core.c;
const Allocator = std.mem.Allocator;

/// The lane protocol version this binding speaks.
pub const protocol: u32 = c.PIER_LANE_PROTOCOL;

/// One publication. `withdraw` takes the lane back.
pub const Publication = struct {
    id: u64,

    /// Withdraws the lane; calling it twice is harmless. Every outstanding lease is released and
    /// a consumer's next liveness check sees the lane gone.
    pub fn withdraw(self: *Publication) core.Error!void {
        if (self.id == 0) return;
        const f = core.slot("lane_unpublish") orelse return error.NotProvided;
        const id = self.id;
        self.id = 0;
        try core.expect(f(core.handle(), id));
    }
};

/// Publishes a lane, exclusively under `name`. `fingerprint` is the value of the contract and
/// must not be 0, which means anyone may connect and which the host refuses. `table` is the
/// provider's table of function pointers, `data` the pointer each of them receives; `retain`
/// and `release` count leases on `data`. The lane is withdrawn automatically at unload. A
/// name that is taken is Refused, and the host log names the holder.
pub fn publish(name: []const u8, fingerprint: u64, data: ?*anyopaque, table: *const anyopaque, retain: c.PierLaneRefFn, release: c.PierLaneRefFn) core.Error!Publication {
    const f = core.slot("lane_publish") orelse return error.NotProvided;
    if (fingerprint == 0) return error.Refused;
    const desc = c.PierLaneDesc{
        .struct_size = @sizeOf(c.PierLaneDesc),
        .protocol = protocol,
        .fingerprint = fingerprint,
        .data = data,
        .vtable = table,
        .retain = retain,
        .release = release,
    };
    const id = f(core.handle(), core.str(name), &desc);
    if (id == 0) return error.Refused;
    return .{ .id = id };
}

/// A lease on a published lane, kept to return it.
pub const Lease = struct {
    lease: u64,
    fingerprint: u64,
    data: ?*anyopaque,
    table: ?*const anyopaque,
    alive: ?*const u32,
    busy: ?*u32,

    /// Whether the provider is still there.
    pub fn isAlive(self: Lease) bool {
        const cell = self.alive orelse return false;
        return @atomicLoad(u32, cell, .acquire) != 0;
    }

    /// Enters the provider for one call. Null when the provider is gone. The caller makes its
    /// calls through the guard and then `leave`s, so the provider cannot unload underneath a
    /// call that is running:
    ///
    ///     if (lease.enter()) |inside| {
    ///         defer inside.leave();
    ///         inside.table(MyTable).hello(inside.data);
    ///     }
    pub fn enter(self: Lease) ?Guard {
        if (self.table == null) return null;
        if (self.busy) |b| _ = @atomicRmw(u32, b, .Add, 1, .acq_rel);
        if (!self.isAlive()) {
            if (self.busy) |b| _ = @atomicRmw(u32, b, .Sub, 1, .acq_rel);
            return null;
        }
        return .{ .lease = self };
    }

    /// Returns the lease. Only a lease this mod holds. False when the provider is already gone,
    /// since the loader has released it by then and releasing again would be a double free.
    pub fn release(self: *Lease) core.Error!bool {
        if (self.lease == 0) return false;
        const f = core.slot("lane_release") orelse return error.NotProvided;
        const id = self.lease;
        self.lease = 0;
        return f(core.handle(), id);
    }
};

/// One call inside a provider. `leave` ends it.
pub const Guard = struct {
    lease: Lease,

    /// The provider's table, which the contract names the type of.
    pub fn table(self: Guard, comptime Table: type) *const Table {
        return @ptrCast(@alignCast(self.lease.table.?));
    }

    /// The pointer each function of the table receives.
    pub fn data(self: Guard) ?*anyopaque {
        return self.lease.data;
    }

    pub fn leave(self: Guard) void {
        if (self.lease.busy) |b| _ = @atomicRmw(u32, b, .Sub, 1, .acq_rel);
    }
};

/// How acquiring a lane ended.
pub const Outcome = union(enum) {
    lease: Lease,
    /// No lane by that name is published.
    not_found,
    /// The provider's fingerprint, which differs from the one asked for.
    fingerprint: u64,
    refused,
};

/// Acquires a lane. `fingerprint` must be the value the consumer computed itself from the
/// contract; 0 is not valid and always yields `fingerprint`.
pub fn acquire(name: []const u8, fingerprint: u64) core.Error!Outcome {
    const f = core.slot("lane_acquire") orelse return error.NotProvided;
    var out = std.mem.zeroes(c.PierLaneRef);
    out.struct_size = @sizeOf(c.PierLaneRef);
    return switch (f(core.handle(), core.str(name), fingerprint, &out)) {
        c.PIER_LANE_OK => .{ .lease = .{
            .lease = out.lease,
            .fingerprint = out.fingerprint,
            .data = out.data,
            .table = out.vtable,
            .alive = out.alive,
            .busy = out.busy,
        } },
        c.PIER_LANE_NOT_FOUND => .not_found,
        c.PIER_LANE_FINGERPRINT => .{ .fingerprint = out.fingerprint },
        else => .refused,
    };
}

/// The registration record of a published lane.
pub const LaneInfo = struct {
    name: []const u8 = "",
    owner: []const u8 = "",
    fingerprint: []const u8 = "",
    protocol: u32 = 0,
    leases: u32 = 0,
    alive: bool = false,

    pub const json_keys = .{ .owner = "mod" };
};

/// Every lane. It passes no pointer at all, so it suits looking at what exists first.
pub fn list(allocator: Allocator) core.Error!types.Owned(LaneInfo) {
    const text = try listJson(allocator);
    defer allocator.free(text);
    var arena = std.heap.ArenaAllocator.init(allocator);
    errdefer arena.deinit();
    const a = arena.allocator();
    var out: std.ArrayList(LaneInfo) = .empty;
    if (std.mem.trim(u8, text, " \t\r\n").len != 0) {
        const parsed = std.json.parseFromSliceLeaky(std.json.Value, a, text, .{}) catch return error.NoAnswer;
        if (parsed != .array) return error.NoAnswer;
        for (parsed.array.items) |item| {
            if (item != .object) continue;
            try out.append(a, try internal.fromJson(LaneInfo, a, item.object));
        }
    }
    return .{ .arena = arena, .items = try out.toOwnedSlice(a) };
}

/// The raw JSON of the lane listing, unparsed, owned by the caller.
pub fn listJson(allocator: Allocator) core.Error![]u8 {
    const f = core.slot("lane_list") orelse return error.NotProvided;
    var col = core.Collector.init(allocator);
    defer col.deinit();
    f(&col, &core.Collector.sink);
    return col.takeOrEmpty();
}
