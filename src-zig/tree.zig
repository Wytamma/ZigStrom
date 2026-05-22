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

    pub fn createTestTree(self: *Tree, gpa: std.mem.Allocator) !void {
        try self.clear();
        try self.nodes.resize(gpa, 6);

        var root_node: Node = self.nodes.items[0];
        var first_internal: Node = self.nodes.items[1];
        var second_internal: Node = self.nodes.items[2];
        var first_leaf: Node = self.nodes.items[3];
        var second_leaf: Node = self.nodes.items[4];
        var third_leaf: Node = self.nodes.items[5];

        // Here is the structure of the tree (numbers in
        // parentheses are node numbers, other numbers
        // are edge lengths):
        //
        // first_leaf (0)   second_leaf (1)   third_leaf (2)
        //      \              /                  /
        //       \ 0.1        / 0.1              /
        //        \          /                  /
        //     second_internal (3)             / 0.2
        //             \                      /
        //              \ 0.1                /
        //               \                  /
        //                first_internal (4)
        //                        |
        //                        | 0.1
        //                        |
        //                    root_node (5)
        //

        root_node.parent = null;
        root_node.left_child = &first_internal;
        root_node.right_sib = null;
        root_node.number = 5;
        root_node.name = "root node";
        root_node.edge_length = 0.0;

        first_internal.parent = &root_node;
        first_internal.left_child = &second_internal;
        first_internal.right_sib = null;
        first_internal.number = 4;
        first_internal.name = "first internal node";
        first_internal.edge_length = 0.0;

        second_internal.parent = &first_internal;
        second_internal.left_child = &first_leaf;
        second_internal.right_sib = &third_leaf;
        second_internal.number = 3;
        second_internal.name = "second internal noed";
        second_internal.edge_length = 0.1;

        first_leaf.parent = &second_internal;
        first_leaf.left_child = null;
        first_leaf.right_sib = &second_leaf;
        first_leaf.number = 0;
        first_leaf.name = "first leaf";
        first_leaf.edge_length = 0.1;

        second_leaf.parent = &second_internal;
        second_leaf.left_child = null;
        second_leaf.right_sib = null;
        second_leaf.number = 1;
        second_leaf.name = "second leaf";
        second_leaf.edge_length = 0.1;

        third_leaf.parent = &first_internal;
        third_leaf.left_child = null;
        third_leaf.right_sib = null;
        third_leaf.number = 2;
        third_leaf.name = "thrid leaf";
        third_leaf.edge_length = 0.2;

        self.is_rooted = true;
        self.root = &root_node;
        self.nleaves = 3;

        try self.preorder.append(gpa, &first_internal);
        try self.preorder.append(gpa, &second_internal);
        try self.preorder.append(gpa, &first_leaf);
        try self.preorder.append(gpa, &second_leaf);
        try self.preorder.append(gpa, &third_leaf);

        try self.levelorder.append(gpa, &first_internal);
        try self.levelorder.append(gpa, &second_internal);
        try self.levelorder.append(gpa, &third_leaf);
        try self.levelorder.append(gpa, &first_leaf);
        try self.levelorder.append(gpa, &second_leaf);
    }
};
