# Millia codespace base image.
#
# A deliberately MINIMAL foundation: the official devcontainers Debian base plus a small,
# tool-agnostic set of CLI utilities. It bakes NO language toolchains — Flutter, Node/pnpm,
# Python/uv, act, … are layered on as composable Dev Container Features from
# millia-labs/devcontainer. That keeps this image valid whether you run it bare (just a
# container builder + act, see .devcontainer/devcontainer.json) or stack features on top.
#
# The base already provides the non-root `vscode` user (UID 1000), git, curl and zsh.
FROM mcr.microsoft.com/devcontainers/base:bookworm

# A tiny baseline shared by most tooling. Anything heavier belongs in a feature, and every
# feature installs its own deps, so keep this list short on purpose.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends \
        ca-certificates curl git jq unzip zip xz-utils \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
