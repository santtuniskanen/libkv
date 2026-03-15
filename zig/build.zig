const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addLibrary(.{
        .name = "kvstore",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/root.zig"),
            .target = target,
            .optimize = optimize,
        }),
        .linkage = .dynamic,
        .version = .{ .major = 0, .minor = 1, .patch = 0 },
    });

    b.installArtifact(lib);

    const install_header = b.addInstallHeaderFile(b.path("../include/kvstore.h"), "kvstore.h");
    b.getInstallStep().dependOn(&install_header.step);
}
