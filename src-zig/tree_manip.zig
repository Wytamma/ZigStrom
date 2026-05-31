const std = @import("std");
const Tree = @import("tree.zig").Tree;
const Node = @import("node.zig").Node;

const TreeManipError = error{
    TreeManipError,
};

pub const TreeManip = struct {
    tree: ?*Tree = null,

    const Self = @This();

    pub fn calcTreeLength(self: *const Self) TreeManipError!f64 {
        // tree can be null so we return an error
        const tree = self.tree orelse return error.NoTree;
        var tl = 0.0;
        for (tree.preorder.items) |node| {
            tl += node.edge_length;
        }
        return tl;
    }

    pub fn scaleAllEdgeLengths(self: *const Self, scaler: f64) TreeManipError!void {
        const tree = self.tree orelse return error.NoTree;
        for (tree.preorder.items) |node| {
            node.setEdgeLength(scaler * node.edge_length);
        }
    }

    pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
        // dealocate the tree
        if (self.tree) |tree| {
            tree.deinit(allocator);
            allocator.destroy(tree);
            self.tree = null;
        }
    }

    pub fn createTestTree(self: *Self, gpa: std.mem.Allocator) !void {
        self.deinit(gpa);
        const tree = try gpa.create(Tree);
        tree.* = .{}; // he thing pointed to by tree
        self.tree = tree;

        try tree.nodes.resize(gpa, 6);

        var root_node: Node = tree.nodes.items[0];
        var first_internal: Node = tree.nodes.items[1];
        var second_internal: Node = tree.nodes.items[2];
        var first_leaf: Node = tree.nodes.items[3];
        var second_leaf: Node = tree.nodes.items[4];
        var third_leaf: Node = tree.nodes.items[5];

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

        tree.is_rooted = true;
        tree.root = &root_node;
        tree.nleaves = 3;

        try tree.preorder.append(gpa, &first_internal);
        try tree.preorder.append(gpa, &second_internal);
        try tree.preorder.append(gpa, &first_leaf);
        try tree.preorder.append(gpa, &second_leaf);
        try tree.preorder.append(gpa, &third_leaf);

        try tree.levelorder.append(gpa, &first_internal);
        try tree.levelorder.append(gpa, &second_internal);
        try tree.levelorder.append(gpa, &third_leaf);
        try tree.levelorder.append(gpa, &first_leaf);
        try tree.levelorder.append(gpa, &second_leaf);
    }
};
