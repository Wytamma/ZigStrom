const std = @import("std");
// use .Node to access the Node struct field in the node.zig module struct
const Node = @import("node.zig").Node;

pub const Tree = struct {
    is_rooted: bool = false,
    nleaves: u32 = 0,
    ninternals: u32 = 0,

    root: ?*Node = null,
    preorder: std.ArrayList(*Node) = .empty,
    levelorder: std.ArrayList(*Node) = .empty,
    nodes: std.ArrayList(Node) = .empty,

    // In Zig inline is a guarantee not a request
    pub inline fn isRooted(self: *Tree) bool {
        return self.is_rooted;
    }

    pub fn deinit(self: *Tree, allocator: std.mem.Allocator) void {
        // remove all allocated mem
        self.preorder.deinit(allocator);
        self.levelorder.deinit(allocator);
        self.nodes.deinit(allocator);

        // reset every field to default
        self.* = .{};
    }

    pub fn clear(self: *Tree) !void {
        // don't use self.* = .{} becuase it would leak array mem
        self.is_rooted = false;
        self.root = null;
        self.nleaves = 0;
        self.ninternals = 0;

        // Clear the contents but keep allocated capacity
        self.preorder.clearRetainingCapacity();
        self.levelorder.clearRetainingCapacity();
        self.nodes.clearRetainingCapacity();
    }
};
