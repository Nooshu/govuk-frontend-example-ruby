# Example service (fishing rod licence)

The Rails app in this repo is a **demonstration** fishing rod licence journey — not a live government service.

## Run locally

```sh
npm ci
bundle install
npm start   # Sass → dist/, then rails server on http://127.0.0.1:3000
```

| Path                                | Purpose                                                                                                                           |
| ----------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| `/`                                 | Start page (English); `/cy` Welsh chrome                                                                                          |
| `/licence-length` … `/confirmation` | 7-step session journey (length → name → DOB → country → email → check → confirmation) with PRG, CSRF, `novalidate`, error summary |
| `/components`                       | Catalogue + live fixture parity banner (`Govuk.render` ≡ fixture `html`) when `DEMOS_ENABLED`                                     |
| `/health`                           | Plain `ok`                                                                                                                        |
| `/robots.txt`                       | `Disallow: /`                                                                                                                     |
| `/assets/*`                         | Fingerprinted CSS/JS + GOV.UK Frontend static assets                                                                              |

`DEMOS_ENABLED` defaults on outside production; set `DEMOS_ENABLED=true` to publish the catalogue in production (e.g. Render).

## Architecture (agents)

| Concern                     | Location                                                                            |
| --------------------------- | ----------------------------------------------------------------------------------- |
| GOV.UK component HTML       | `lib/govuk` via `Govuk.render` / thin `Govuk::Component`                            |
| Page shell                  | `app/views/layouts/application.html.erb` + `Licence::Chrome`                        |
| Journey domain              | `app/services/licence/*` (answers, validate, save, options)                         |
| Baseline headers / CSP hash | `lib/baseline/policy.rb` + `BaselineHeaders` middleware from `baseline/policy.json` |
| Parity tests                | `spec/govuk/fixture_parity_spec.rb` — ordinal equality for every fixture            |

Do **not** rewrite component HTML in controllers or ERB — call `Govuk.render` / the `govuk` helper.
