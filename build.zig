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

    const run_exe = b.addRunArtifact(zig_exe);

    const run_step = b.step("run", "Run the application");
    run_step.dependOn(&run_exe.step);

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

    const exe_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimse,
            .root_source_file = b.path("src-zig/main.zig"),
        }),
    });

    // Tell the build system to actually run the generated test binary
    const run_exe_tests = b.addRunArtifact(exe_tests);

    // Expose the "test" step to the terminal
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_tests.step);

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
