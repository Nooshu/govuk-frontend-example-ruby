# GOV.UK Frontend example (Ruby)

> [!IMPORTANT]
> You are free to fork, modify, and maintain this repository for your own use.
>
> This includes using and adapting it within your department, organisation, or project.

> [!WARNING]
> ### 🚨 Example repository only
>
> This repository is a **demonstration only**. It will not be actively maintained or supported.
>
> **It is not an official UK government project.** It is not endorsed, maintained, or supported by any UK government department, the Government Digital Service (GDS), or the GOV.UK Design System team.
>
> **No ongoing support or updates will be provided.** This includes maintenance, dependency updates, security fixes, or technical support.
>
> **Use this code at your own risk.** You are responsible for reviewing, testing, securing, and maintaining the code, and for determining whether it is suitable for use in a service or production environment.
>
> **You are free to fork, modify, and maintain this repository for your own use.**
>
> This repository is released under the [MIT Licence](LICENSE). See the licence for the full terms.

**Ruby + Rails** specialised line: server-rendered HTML with **[GOV.UK Frontend](https://frontend.design-system.service.gov.uk/)** as the only UI component library — **no** React/Vue/Angular/Svelte. Official fixtures enable **100% HTML parity** testing of Ruby/ViewComponent output. Component HTML is generated **natively in Ruby** (never Nunjucks/Node at request time).

**Implementation language: Ruby / Rails 8** — see [`docs/tech-stack.md`](docs/tech-stack.md).

## Priorities

Frontend web performance → frontend security → reduced maintenance → accessibility → inclusive design.

## Who should read what

| You are…            | Start here                                                                                                                                                     |
| ------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Human developer** | [`docs/onboarding.md`](docs/onboarding.md) → [`CONTRIBUTING.md`](CONTRIBUTING.md) → [`docs/`](docs/README.md)                                                  |
| **AI coding agent** | [`AGENTS.md`](AGENTS.md) → [`.cursor/skills/gds-compliant-frontend/`](.cursor/skills/gds-compliant-frontend/SKILL.md) → playbooks in [`docs/`](docs/README.md) |

How docs are split for both audiences: [`docs/documentation-structure.md`](docs/documentation-structure.md).

## Quick local start

```sh
npm ci
bundle install
npm start          # builds Sass, then bin/rails server — http://127.0.0.1:3000
npm test           # Node baseline/Sass + RSpec (fixture parity + 100% coverage)
npm run verify     # docs + styles + RuboCop + tests
```

Requires **Node 22+** (GOV.UK Frontend pin + Sass) and **Ruby 3.3+** / Bundler.

## Licence and security

- Code in this repository: [MIT License](LICENSE)
- How to report vulnerabilities: [SECURITY.md](SECURITY.md)
- GOV.UK Design System and Frontend are maintained by GDS; Crown copyright / OGL apply to GOV.UK content patterns as documented on GOV.UK.
