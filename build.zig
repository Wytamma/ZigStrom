const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimse = b.standardOptimizeOption(.{});

    // Zig
    const zig_exe = b.addExecutable(.{
        .name = "strom-zig",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimse,
            .root_source_file = b.path("src-zig/main.zig"),
        }),
    });

    b.installArtifact(zig_exe);

    // check step for ZLS zig build check
    const check_exe = b.addExecutable(.{
        .name = "strom-zig",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimse,
            .root_source_file = b.path("src-zig/main.zig"),
        }),
    });

    const check = b.step("check", "Check if strom compiles");
    check.dependOn(&check_exe.step);

    // C++
    const cpp_exe = b.addExecutable(.{
        .name = "strom-cpp",
        .root_module = b.createModule(.{ .target = target, .optimize = optimse, .link_libcpp = true, .strip = true }),
    });

    cpp_exe.root_module.addCSourceFile(.{
        .file = b.path("src-cpp/main.cpp"),
        .flags = &.{
            "-std=c++11", // use c++11 dialect
            "-Wall", // Enables a large collection of useful compiler warnings.defer
            "-Wextra", // Adds additional warnings not included in -Wall.
        },
    });

    // Add the Boost root directory to the include search path
    cpp_exe.root_module.addIncludePath(b.path("src-cpp/libraries/boost_1_71_0"));

    b.installArtifact(cpp_exe);
}
