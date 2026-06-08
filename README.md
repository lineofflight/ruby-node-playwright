# ruby-node-playwright

CI base image bundling Ruby, Node, and Playwright (chromium) for the org's
Ruby/Rails projects. Lets CI jobs skip the per-run `apt` install, Node setup,
and Playwright browser download.

Published to `ghcr.io/lineofflight/ruby-node-playwright:latest`.

## What's baked

- Ruby 4.0.5 (`rubylang/ruby:4.0.5-dev-noble` base)
- System packages: `libpq-dev`, `libyaml-dev`, `pkg-config`
- Node.js 24 (current Active LTS)
- Playwright 1.60.0 chromium + OS dependencies

Gems and npm packages are intentionally **not** baked — they change too often
and stay on CI caches in the consuming repo.

## Usage

```yaml
jobs:
  checks:
    runs-on: self-hosted
    container:
      image: ghcr.io/lineofflight/ruby-node-playwright:latest
    steps:
      # ... gems from cache + bundle, npm ci, then run checks/tests
```

Keep the consumer's `playwright` npm version in sync with the baked version
(1.60.0) so the browser isn't re-downloaded at job time.

## Rebuilds

`.github/workflows/build.yml` rebuilds and pushes on every push to `main`,
weekly (base-image security patches), and on manual dispatch. Bump the Ruby /
Node / Playwright versions by editing the `Dockerfile`.
