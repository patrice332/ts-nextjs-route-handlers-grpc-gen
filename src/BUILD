load("@aspect_rules_js//js:defs.bzl", "js_binary")
load("//toolchain/ts:defs.bzl", "ts_library")

ts_library(
    name = "hello",
    srcs = [
        "hello.ts",
    ],
    deps = [
        "//:node_modules/winston",
        "//third_party:compiler_plugin_ts_proto",
    ],
)

js_binary(
    name = "hello_run",
    data = [":hello"],
    entry_point = "hello.js",
)
