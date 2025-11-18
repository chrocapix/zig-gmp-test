const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "toto",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .root_source_file = b.path("main.zig"),
        }),
    });
    b.installArtifact(exe);

    const gmp = b.dependency("zig_gmp", .{
        .target = target,
        .optimize = .ReleaseFast,
    });
    exe.root_module.linkLibrary(gmp.artifact("gmp"));

    const run = b.addRunArtifact(exe);
    if (b.args) |args| run.addArgs(args);
    const run_step = b.step("run", "run the test");
    run_step.dependOn(&run.step);
}
