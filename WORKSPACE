git_repository(
    name = "io_bazel_rules_go",
    remote = "https://github.com/bazelbuild/rules_go.git",
    tag = "0.5.5",
)
load("@io_bazel_rules_go//go:def.bzl", "go_repositories", "go_repository")

go_repositories()


go_repository(
    name = "com_github_pelletier_go_buffruneio",
    importpath = "github.com/pelletier/go-buffruneio",
    urls = ["https://codeload.github.com/pelletier/go-buffruneio/zip/c37440a7cf42ac63b919c752ca73a85067e05992"],
    strip_prefix = "go-buffruneio-c37440a7cf42ac63b919c752ca73a85067e05992",
    type = "zip",
)
