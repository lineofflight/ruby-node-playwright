# CI base image for the org's Ruby/Rails projects.
#
# Bakes Ruby + Node + Playwright (chromium) so CI jobs skip the per-run apt
# install, Node setup, and Playwright browser download. Gems and npm packages
# are intentionally NOT baked — they change too often and stay on CI caches in
# the consuming repo.
#
# Published to ghcr.io/lineofflight/ruby-node-playwright by .github/workflows/build.yml.
FROM rubylang/ruby:4.0.5-dev-noble

# System packages for building common native gems (pg, psych, ...).
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libpq-dev libyaml-dev pkg-config curl gnupg \
    && rm -rf /var/lib/apt/lists/*

# Node.js 24 (current Active LTS).
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# Playwright chromium + its OS dependencies. Pinned to the playwright version
# consumers resolve to; keep in sync to avoid a browser re-download at job time.
RUN npx --yes playwright@1.60.0 install --with-deps chromium
