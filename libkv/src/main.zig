const std = @import("std");
const hash_map = @import("hash_map.zig");

pub fn main() !void {
    std.debug.print("{s}", .{"Hello, world!"});
}
