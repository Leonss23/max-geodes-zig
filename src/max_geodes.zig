const std = @import("std");
const prompt = @import("prompt.zig");
const Resource = prompt.Resource;
const ResourceCount = prompt.ResourceCount;
const Turn = prompt.TurnCount;
const Blueprint = prompt.Blueprint;
const Counter = prompt.Counter;

pub fn solution(state: State, ctx: *Context) !ResourceCount {
    if (ctx.memo.get(state.pack)) |cached|
        if (state.turn >= cached.turn)
            return cached.result;

    if (state.turn >= ctx.max_turns) {
        const result = state.pack.resources[@intFromEnum(Resource.geode)];
        try ctx.memo.put(state.pack, .{
            .turn = state.turn,
            .result = result,
        });
        return result;
    }

    var result: ResourceCount = 0;
    const next_state = state.step();

    result = @max(result, try solution(next_state, ctx));

    for (0..state.pack.robots.len) |i| {
        const kind: Resource = @enumFromInt(i);
        if (state.can_build_robot(kind, ctx.bp))
            result = @max(result, try solution(next_state.build_robot(kind, ctx.bp), ctx));
    }

    try ctx.memo.put(state.pack, .{
        .turn = state.turn,
        .result = result,
    });
    return result;
}

pub const Context = struct {
    bp: Blueprint,
    max_turns: Turn,
    memo: Cache,
};

pub const Cached = struct {
    result: ResourceCount,
    turn: Turn,
};

pub const Cache = std.AutoHashMap(Pack, Cached);

pub const Pack = struct {
    robots: Counter = .{ 1, 0, 0, 0 },
    resources: Counter = .{ 0, 0, 0, 0 },
};

pub const State = struct {
    pack: Pack = .{},
    turn: Turn = 0,

    pub fn step(self: State) State {
        var state = self;
        state.turn += 1;
        state.produce_resources();
        return state;
    }

    fn produce_resources(self: *State) void {
        for (self.pack.robots, &self.pack.resources) |robots, *resources| {
            resources.* += robots;
        }
    }

    pub fn build_robot(self: State, kind_enum: Resource, bp: Blueprint) State {
        const kind = @intFromEnum(kind_enum);

        var state = self;

        const costs = bp[kind];

        // deduct cost
        for (costs, &state.pack.resources) |cost, *resources| {
            resources.* -= cost;
        }

        state.pack.robots[kind] += 1;

        return state;
    }

    pub fn can_build_robot(self: State, kind_enum: Resource, bp: Blueprint) bool {
        const kind = @intFromEnum(kind_enum);
        const costs = bp[kind];
        for (costs, self.pack.resources) |cost, resources| {
            if (cost > resources) return false;
        }
        return true;
    }
};
