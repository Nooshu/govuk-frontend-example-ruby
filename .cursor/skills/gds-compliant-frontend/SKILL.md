---
name: gds-compliant-frontend
description: >-
  Builds GDS-compliant government frontends with Ruby / Rails / ViewComponent
  and GOV.UK Frontend macros / fixtures as the HTML contract (native Ruby
  HTML in lib/govuk; Node only for install, Sass, fixtures) and 100% fixture
  HTML parity, no SPA/frontend frameworks. Use when scaffolding services,
  implementing GOV.UK components/patterns, upgrading govuk-frontend, or
  verifying assessment-shaped UI.
---

# GDS-compliant frontend (Ruby)

## What this project is

A **Ruby specialised line** for **GDS-compliant** frontends that:

- Use **Ruby / Rails / ViewComponent / ERB** for the server and HTML generation
- Use **[GOV.UK Frontend](https://frontend.design-system.service.gov.uk/)** (pinned version) as the **only** frontend component library
- Generate component HTML **natively in Ruby** (`lib/govuk`) tracking Frontend macros/`template.njk` — do **not** shell out to Node for request-time HTML
- Prove **100% HTML parity** against official `fixtures.json` (`Govuk.render` ≡ every fixture `html`)
- Do **not** use frontend frameworks (React, Vue, Angular, Svelte, etc.) for UI

Priorities: frontend web performance → frontend security → reduced maintenance → accessibility → inclusive design. See [`docs/priorities.md`](../../../docs/priorities.md).

Stack: [`docs/tech-stack.md`](../../../docs/tech-stack.md). Playbooks: [`AGENTS.md`](../../../AGENTS.md).

## Non-negotiable stack shape

| Layer               | Choice                                                                    |
| ------------------- | ------------------------------------------------------------------------- |
| UI                  | GOV.UK Frontend only (`govuk-*`, official JS via `initAll()`)             |
| HTML generation     | Native Ruby renderers in `lib/govuk` + ViewComponent / ERB pages          |
| Frontend frameworks | **Forbidden** for UI                                                      |
| Parity              | Official `fixtures.json` + ordinal HTML equality                          |
| Upstream            | Node package for install, Sass, fixtures freshness — not for request HTML |

## Authoritative guidance

1. [Technology Code of Practice](https://www.gov.uk/guidance/the-technology-code-of-practice)
2. [Assisted digital support](https://www.gov.uk/service-manual/helping-people-to-use-your-service/assisted-digital-support-introduction)
3. [Service Standard](https://www.gov.uk/service-manual/service-standard)
4. [Service Manual](https://www.gov.uk/service-manual)
5. [GOV.UK Design System](https://design-system.service.gov.uk/)
6. [GOV.UK Frontend](https://frontend.design-system.service.gov.uk/)

## Workflow reminders

1. Follow Ruby/Rails practices in [`docs/tech-stack.md`](../../../docs/tech-stack.md).
2. Never hand-paste `govuk-*` markup; use `Govuk.render` / ViewComponents.
3. Upgrade Frontend only after reading the [latest release](https://github.com/alphagov/govuk-frontend/releases/latest).
4. New components: [`docs/creating-components.md`](../../../docs/creating-components.md).
5. HTTP responses use [`baseline/`](../../../baseline/).
6. Sass: `styles/application.scss` → Frontend `@use` → `govuk-overrides.scss` last; no `!important`.
7. Document every change for humans and agents.
8. Preview parity banners must compute `rendered == fixture.html` live.
9. Split finished work into focused commits.
