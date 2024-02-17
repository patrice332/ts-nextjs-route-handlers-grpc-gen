load("@npm//:ts-protoc-gen/package_json.bzl", ts_protoc_gen_bin = "bin")
load("@rules_proto_grpc//:defs.bzl", "proto_plugin")

ts_protoc_gen_bin.protoc_gen_ts_binary(
    name = "protoc_gen_ts",
)

# Proto
proto_plugin(
    name = "js_plugin",
    exclusions = [
        "google/protobuf",
    ],
    options = [
        "import_style=commonjs",
        "binary",
    ],
    outputs = ["{protopath}_pb.js"],
    tool = select({
        "@bazel_tools//src/conditions:darwin_arm64": "@protobuf_javascript_darwin_arm64//:protobuf_javascript",
        "@bazel_tools//src/conditions:darwin_x86_64": "@protobuf_javascript_darwin_x86_64//:protobuf_javascript",
        "@bazel_tools//src/conditions:linux_aarch64": "@protobuf_javascript_linux_arm64//:protobuf_javascript",
        "@bazel_tools//src/conditions:linux_x86_64": "@protobuf_javascript_linux_x86_64//:protobuf_javascript",
    }),
    visibility = ["//visibility:public"],
)

proto_plugin(
    name = "ts_plugin",
    env = {
        "BAZEL_BINDIR": "{bindir}",
    },
    outputs = ["{protopath}_pb.d.ts"],
    tool = ":protoc_gen_ts",
    use_built_in_shell_environment = False,
    visibility = ["//visibility:public"],
)
