const std = @import("std");

pub const cases = [_]Case{
    .{
        .turns = 24,
        .bp = .{
            .{ 4, 0, 0, 0 },
            .{ 2, 0, 0, 0 },
            .{ 3, 14, 0, 0 },
            .{ 2, 0, 7, 0 },
        },
    },
};

pub const Case = struct {
    turns: usize,
    bp: Blueprint,
};

pub const Resource = enum {
    ore,
    clay,
    obsidian,
    geode,

    pub const variant_count = std.meta.fields(Resource).len;
    pub fn List(comptime T: type) type {
        return [variant_count]T;
    }
};

pub const Counter = Resource.List(usize);

/// Resource costs of building each robot type
pub const Blueprint = Resource.List(Counter);

pub const State = struct {
    turn: usize,
    resources: Counter = .{0} ** Resource.variant_count,
    robots: Counter = blk: {
        var robots: Counter = .{0} ** Resource.variant_count;
        robots[@intFromEnum(Resource.ore)] = 1; // Start with 1 ore robot;
        break :blk robots;
    },

    pub fn produce_resources(state: *State) void {
        for (state.robots, 0..) |robot, idx| {
            state.resources[idx] += robot;
        }
    }

    pub fn can_buy_robot() !void {}
};
