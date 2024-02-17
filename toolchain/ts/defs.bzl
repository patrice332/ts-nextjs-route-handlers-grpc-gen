"""Typescript rules for the repo"""

load("@aspect_rules_js//js:defs.bzl", "js_library")
load("@aspect_rules_swc//swc:defs.bzl", "swc")
load("@aspect_rules_ts//ts:defs.bzl", _ts_config = "ts_config", _ts_project = "ts_project")
load("@bazel_skylib//lib:partial.bzl", "partial")
load("@npm//:tsconfig-to-swcconfig/package_json.bzl", tsconfig_to_swcconfig = "bin")
load(
    "@rules_proto_grpc//:defs.bzl",
    "ProtoPluginInfo",
    "proto_compile_attrs",
    "proto_compile_impl",
)

# Create compile rule
_js_proto_compile = rule(
    implementation = proto_compile_impl,
    attrs = dict(
        proto_compile_attrs,
        _plugins = attr.label_list(
            providers = [ProtoPluginInfo],
            default = [
                Label("//toolchain/ts:js_plugin"),
                Label("//toolchain/ts:ts_plugin"),
            ],
            doc = "List of protoc plugins to apply",
        ),
    ),
    toolchains = [str(Label("@rules_proto_grpc//protoc:toolchain_type"))],
)

def ts_proto_library(name, protos, deps = [], **kwargs):
    adapter_name = "{}_adapter".format(name)
    _js_proto_compile(
        name = adapter_name,
        protos = protos,
        output_mode = "NO_PREFIX_FLAT",
    )

    js_library(
        name = name,
        srcs = [":" + adapter_name],
        deps = ["//:node_modules/google-protobuf"] + deps,
        **kwargs
    )

def ts_config(name, **kwargs):
    _ts_config(
        name = name,
        **kwargs
    )

    tsconfig_to_swcconfig.t2s(
        name = "{}_swcrc".format(name),
        srcs = [":{}".format(name)],
        args = ["--filename", "$(location :{})".format(name)],
        stdout = ".{}_swcrc".format(name),
        visibility = ["//visibility:public"],
    )

def ts_library(name, tsconfig = "//:tsconfig", **kwargs):
    _ts_project(
        name = name,
        tsconfig = tsconfig,
        transpiler = partial.make(swc, swcrc = "{}_swcrc".format(tsconfig), source_root = native.package_name(), source_maps = True),
        declaration = True,
        source_map = True,
        declaration_map = True,
        **kwargs
    )
