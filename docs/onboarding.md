# Onboarding

Human-oriented map of this repository. Coding agents should treat [`AGENTS.md`](../AGENTS.md) as the dense entry point; humans should also read [`CONTRIBUTING.md`](../CONTRIBUTING.md). How docs are split for both audiences: [documentation-structure.md](documentation-structure.md).

## What this repo is

A **Ruby + Rails** specialised line for **GDS-compliant** frontends: Ruby / ViewComponent generate HTML; **GOV.UK Frontend** is the only UI library; **no frontend frameworks** for UI. Exact **HTML parity** against official Frontend fixtures. See [project-purpose.md](project-purpose.md) and [tech-stack.md](tech-stack.md).

**GOV.UK Frontend is Node + Nunjucks by default.** Install `govuk-frontend` from npm, treat Nunjucks `template.njk` / `fixtures.json` as the HTML contract, and keep Node scripts for Sass and optional fixture freshness — request-time HTML is **native Ruby** in `lib/govuk`.

**Official guidance:** search the URLs in [guidance-sources.md](guidance-sources.md).

**Priorities:** frontend web performance → frontend security → reduced maintenance → accessibility → inclusive design ([priorities.md](priorities.md)).

## Repo map

```text
AGENTS.md                 # Slim agent playbook
docs/                     # Dual-audience documentation
baseline/                 # Shared performance + OWASP header contract
styles/                   # Sass entry + govuk-overrides
scripts/                  # Node Sass build helpers
lib/govuk/                # Native Ruby component renderers (fixture parity)
app/
  controllers/            # Journey, catalogue, pages
  services/licence/       # Fishing licence domain
  views/                  # ERB page shell + journey templates
  components/             # Thin ViewComponent wrappers
spec/
  govuk/                  # Fixture parity + helper specs
  requests/               # Smoke + journey request specs
```

## Commands

```sh
npm ci
bundle install
npm start              # Sass + Rails — http://127.0.0.1:3000
npm test               # Node baseline/Sass + RSpec (parity + coverage)
npm run lint:ruby      # RuboCop
npm run verify         # docs + styles + RuboCop + tests
```

Requires **Node 22+** and **Ruby 3.3+**.

## Testing mindset

1. **Parity (primary):** Ruby `Govuk.render` ≡ every fixture `html` (ordinal equality), including hidden fixtures.
2. **Nunjucks suite (secondary):** optional freshness only.
3. Never edit fixture `html`; never normalise to pass tests.
4. Component preview pages compute the parity banner live (`rendered == fixture.html`).

Details: [testing-components.md](testing-components.md).

## Deploy

Public demo on Render.com free tier: [deploying-on-render.md](deploying-on-render.md).
