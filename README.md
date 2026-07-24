# millia-codespace

A **bare-minimum** GitHub Codespace / Dev Container whose only job is to *exercise
Millia's dev-tooling*:

- **`act`** — run the GitHub Actions workflows locally before pushing.
- **a container builder** (docker-in-docker; podman also works) — build and test
  container images, including the Millia [dev container features](../devcontainer).

That's deliberately all it carries. The actual language toolchains (Flutter, Node/pnpm,
Python/uv, …) are **not** baked in here — they live as composable
[Dev Container Features](https://containers.dev/implementors/features/) in the sibling repo
[`devcontainer`](../devcontainer) (`ghcr.io/millia-labs/devcontainer/*`) and are layered on
wherever a real project needs them.

> Open in a Codespace, or locally with the
> [Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)
> extension / `devcontainer up`.

## What's inside

Built from a **minimal base image** (`Dockerfile` — the devcontainers Debian base plus a
few CLI utilities, no toolchains). Everything else is a layered feature, so the same base
works bare or with extra features stacked on top.

| Tool | How it's provided |
| --- | --- |
| base (git, curl, jq, unzip/zip, xz) | image `Dockerfile` |
| Docker (moby) | feature `docker-in-docker` |
| act | feature `…/act` |

### Adding toolchains

Need Flutter, Node/pnpm or Python for a task? Add the matching feature from
[`../devcontainer`](../devcontainer) to `.devcontainer/devcontainer.json` — the base image
is designed to take them without changes:

```jsonc
"features": {
  "ghcr.io/devcontainers/features/docker-in-docker:2": { "moby": true },
  "ghcr.io/millia-labs/devcontainer/act:1": {},
  "ghcr.io/millia-labs/devcontainer/flutter:1": { "version": "3.41.4" },
  "ghcr.io/millia-labs/devcontainer/node:1": { "nodeMajor": "20", "pnpmVersion": "8" },
  "ghcr.io/millia-labs/devcontainer/uv:1": { "pythonVersion": "3.13" }
}
```

## Verify

`postCreateCommand` runs `.devcontainer/verify.sh`, which prints a version line for `act`
and the container builder. Re-run it any time:

```bash
bash .devcontainer/verify.sh
```

## Running CI locally with `act`

`.github/workflows/toolchain.yml` is a sample workflow to exercise. `act` runs each job in
the `catthehacker/ubuntu:act-22.04` image (pre-seeded in `~/.actrc`) against the
container builder.

```bash
act -l            # list jobs
act -j python     # run one job
act push          # run the whole workflow on a push event
```

## Building container features

The sandbox is a natural place to build and test the features in
[`../devcontainer`](../devcontainer) with the dev container CLI:

```bash
npm install -g @devcontainers/cli
devcontainer features test --features flutter \
  --base-image mcr.microsoft.com/devcontainers/base:bookworm ../devcontainer
```
