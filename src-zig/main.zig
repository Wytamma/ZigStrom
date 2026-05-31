const std = @import("std");
const Node = @import("node.zig").Node;
const Tree = @import("tree.zig").Tree;
const TreeManip = @import("tree_manip.zig").TreeManip;

pub fn main(init: std.process.Init) !void {
    std.debug.print("Starting...\n", .{});

    const allocator = init.gpa;

    var tm: TreeManip = .{};
    try tm.createTestTree(allocator);
    defer tm.deinit(allocator);

    std.debug.print("\nFinshed!\n", .{});
}
