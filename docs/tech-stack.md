# Tech stack

**Status: Ruby** — this is the Ruby specialised line of the GOV.UK Frontend language examples.

## Two layers

| Layer                          | Stack                                                                                               | Notes                                                                                                                          |
| ------------------------------ | --------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| **GOV.UK Frontend (upstream)** | **Node** package (`govuk-frontend`), **Nunjucks** macros (`template.njk`), official `fixtures.json` | Fixed by GDS. Node is for install, fixtures, Sass, and optional freshness checks — **not** for request-time HTML in this line. |
| **This line (wrapper)**        | **Ruby** (3.3+), **Rails** 8, **ERB**, **ViewComponent**, RSpec, RuboCop, Bundler                   | Server-side HTML generated **natively in Ruby**. Tracks Frontend macros/`template.njk` and proves **backend ≡ every fixture**. |

## Prefer established Ruby / Rails practice

| Concern                         | Prefer                                                                                          | Avoid / notes                                                                       |
| ------------------------------- | ----------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| HTTP / routing                  | Rails 8 + Puma                                                                                  | Sinatra-only apps that reimplement chrome                                           |
| Page document shell             | Rails layouts + ERB                                                                             | Hand-pasted full page HTML; React/Vue/etc. for UI                                   |
| GOV.UK component HTML           | `lib/govuk` string builders + ViewComponent wrappers; Nunjucks-parity escape/attributes         | Default Rails/`CGI.escapeHTML` alone; shelling out to Node/Nunjucks at request time |
| Text escaping (Nunjucks parity) | Local escaper (`&quot;`, `&#39;`, `\` → `&#92;`) in `lib/govuk`                                 | Relying only on ERB auto-escape for fixture text                                    |
| Ordered fixture options         | `Govuk::Params` (insertion-ordered keys; number spelling preserved)                             | Unordered Hash round-trips that reshuffle attributes                                |
| Tests                           | RSpec + SimpleCov **100%** on application/library code; ordinal HTML equality for every fixture | Weakening comparison / editing fixture `html`                                       |
| Lint                            | RuboCop (Rails cops)                                                                            |                                                                                     |
| Sessions                        | Cookie store (no ActiveRecord / no Postgres on the free demo)                                   |                                                                                     |
| Forms                           | Explicit field maps → ViewComponent kwargs                                                      | Simple Form (or similar) owning GOV.UK markup                                       |

### HTML rendering (two layers)

| Layer                          | What it is                                                 | Choice here                                    | Notes                                                                                                  |
| ------------------------------ | ---------------------------------------------------------- | ---------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| **Page shell / service pages** | Layout, journey forms, catalogue chrome around components  | Rails layouts + ERB                            | Compose GOV.UK blocks via ViewComponent / `Govuk.render`                                               |
| **GOV.UK components**          | Every `govuk-*` block; must match official `fixtures.json` | `lib/govuk` renderers + ViewComponent wrappers | Source of truth is Frontend `template.njk` + fixtures. Generic ERB alone fights attribute order/escape |

## Consistency tooling

```sh
npm ci                 # preferred install (lockfile + .npmrc ignore-scripts)
npm run build:styles   # Sass → dist/stylesheets/application.css
npm start              # build:styles, then bin/rails server — http://127.0.0.1:3000
npm test               # baseline, Sass, then bundle exec rspec (fixture parity + service); 100% coverage
npm run verify:docs    # Prettier + markdownlint
npm run lint:ruby      # RuboCop
npm run verify         # docs + build:styles + lint:ruby + tests
```

## Shared baseline

[`baseline/`](../baseline/) is part of this template’s contract. This line **implements the same policy in Ruby**, reading [`baseline/policy.json`](../baseline/policy.json). It does not call the Node helpers at request time.

| Piece                                             | How this line uses it                                                                            |
| ------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| [`baseline/policy.json`](../baseline/policy.json) | OWASP header values, CSP (including the Frontend `js-enabled` hash), cache kinds, Brotli budgets |
| [`baseline/*.mjs`](../baseline/)                  | Shared contract + Node test gate; Ruby mirrors behaviour                                         |
| [`styles/`](../styles/)                           | Sass entry compiling Frontend via `@use`, then `govuk-overrides.scss` ([styles.md](styles.md))   |

Local `npm start` is plain HTTP, so responses omit HSTS unless the request is HTTPS-shaped (`X-Forwarded-Proto: https`). Public HTML that sets a cookie uses `private, no-cache`. Pages that show the application use `sensitive-document` (`no-store`). Fingerprinted CSS/JS/fonts use `public, max-age=31536000, immutable`.

The server compresses with Brotli when the client advertises `br`, and Gzip otherwise. `Vary: Accept-Encoding` comes from the baseline.

Details: [frontend-performance.md](frontend-performance.md), [frontend-security.md](frontend-security.md).

## Version pin

| Item                              | Value                                                                                                                                                                                |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Implementation language           | Ruby 3.3+ / Rails 8                                                                                                                                                                  |
| Templating / component approach   | Native Ruby HTML (`lib/govuk`, ViewComponent, ERB page shell); tracks Frontend macros; **no** Node render at request time                                                            |
| `govuk-frontend` (Node)           | **6.5.1** — [v6.5.1](https://github.com/alphagov/govuk-frontend/releases/tag/v6.5.1) (reviewed against [latest release](https://github.com/alphagov/govuk-frontend/releases/latest)) |
| Sass pipeline                     | `styles/application.scss` → `npm run build:styles` → `dist/stylesheets/application.css` ([styles.md](styles.md))                                                                     |
| Backend parity (primary)          | RSpec — Ruby `Govuk.render` ≡ every official `fixtures.json` `html` (including hidden) ([testing-components.md](testing-components.md))                                              |
| Nunjucks freshness (secondary)    | Optional; fixtures and macros come from the same pinned package — never a substitute for backend parity                                                                              |
| Page template reference           | https://design-system.service.gov.uk/styles/page-template/                                                                                                                           |
| Fixture testing guide             | https://frontend.design-system.service.gov.uk/testing-your-html/                                                                                                                     |
| Example service                   | [example-service.md](example-service.md) — `npm start`                                                                                                                               |
| Public demo host                  | [Render.com](https://render.com) via [`render.yaml`](../render.yaml) — [deploying-on-render.md](deploying-on-render.md)                                                              |
| Response baseline                 | [`baseline/policy.json`](../baseline/policy.json) via Ruby baseline — [frontend-performance.md](frontend-performance.md), [frontend-security.md](frontend-security.md)               |
| Upgrade / test / preview commands | `npm run build:styles`, `npm start`, `npm test`, `npm run lint:ruby`, `npm run verify`; Frontend upgrade per [upgrading-govuk-frontend.md](upgrading-govuk-frontend.md)              |

## Hard constraints (always)

See [`AGENTS.md`](../AGENTS.md): Frontend fixture parity (byte-for-byte), no SPA UI frameworks, Sass pipeline (no `!important` in service CSS), baseline headers, Brotli-first compression, 100% coverage, dual-audience docs.
