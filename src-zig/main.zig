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
    //
    const nwk = try tm.makeNewick(allocator, 3, false);
    defer allocator.free(nwk);
    std.debug.print("{s}\n", .{nwk});

    const nwk2 = try tm.makeNewick(allocator, 3, true);
    defer allocator.free(nwk2);
    std.debug.print("{s}", .{nwk2});

    std.debug.print("\nFinshed!\n", .{});
}
