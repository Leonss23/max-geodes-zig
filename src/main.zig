const std = @import("std");
const context = @import("prompt.zig");
const case = context.cases;
const max_geodes = @import("max_geodes.zig");
const Context = max_geodes.Context;
const Cache = max_geodes.Cache;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);
    const allocator = gpa.allocator();

    var input = Context{
        .bp = case[0].bp,
        .max_turns = case[0].turns,
        .memo = Cache.init(allocator),
    };
    defer input.memo.deinit();
    std.log.info("Max geodes calculated: {d}", .{try max_geodes.solution(.{}, &input)});
}
