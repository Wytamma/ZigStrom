const std = @import("std");
const Node = @import("node.zig").Node;
const Tree = @import("tree.zig").Tree;

pub fn main(init: std.process.Init) !void {
    std.debug.print("Starting...\n", .{});

    const allocator = init.gpa;
    var tree: Tree = .{};
    defer tree.deinit(allocator);

    try tree.createTestTree(allocator);

    std.debug.print("\nFinshed!\n", .{});
}
