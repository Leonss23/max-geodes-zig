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

pub const ResourceCount = u8;
pub const TurnCount = usize;

pub const Case = struct {
    turns: TurnCount,
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

pub const Counter = Resource.List(ResourceCount);
pub const Blueprint = Resource.List(Counter);
