const std = @import("std");

// in Zig everything is a struct...
pub const Node = struct {
    left_child: ?*Node,
    right_sib: ?*Node,
    parent: ?*Node,

    number: i32 = -1,
    name: []const u8 = "",
    edge_length: f64 = smallest_edge_length,

    pub const Vector = std.ArrayList(Node);
    pub const PtrVector = std.ArrayList(*Node);
    pub const smallest_edge_length: f64 = 1.0e-12;

    pub fn setEdgeLength(self: *Node, value: f64) void {
        self.edge_length = @max(value, smallest_edge_length);
    }
};
