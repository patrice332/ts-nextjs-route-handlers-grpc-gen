"""Typescript rules for the repo"""

load("@aspect_rules_swc//swc:defs.bzl", "swc")
load("@aspect_rules_ts//ts:defs.bzl", _ts_config = "ts_config", _ts_project = "ts_project")
load("@bazel_skylib//lib:partial.bzl", "partial")
load("@npm//:tsconfig-to-swcconfig/package_json.bzl", tsconfig_to_swcconfig = "bin")

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
        **kwargs
    )
