load("//toolchain/ts:defs.bzl", "ts_proto_library")

ts_proto_library(
    name = "descriptor_ts_proto",
    protos = [
        "@protobuf//:descriptor_proto",
    ],
    visibility = ["//:__subpackages__"],
)

ts_proto_library(
    name = "compiler_plugin_ts_proto",
    protos = [
        "@protobuf//:compiler_plugin_proto",
    ],
    visibility = ["//:__subpackages__"],
    deps = [
        ":descriptor_ts_proto",
    ],
)
