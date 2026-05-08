const std = @import("std");

pub fn main() !void {
    //try std.Io.File.stdout().writeStreamingAll(init.io, "Hello World!\n");
    std.debug.print("Hi\n", .{});
}
