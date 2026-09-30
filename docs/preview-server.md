# Preview server

Local server for human parity checks, the fishing-licence journey, and component demos.

## Commands

```sh
npm ci
bundle install
npm start    # builds Sass, then `bundle exec rails server` — http://127.0.0.1:3000
```

Stack details: [tech-stack.md](tech-stack.md). Example journey: [example-service.md](example-service.md).

## Surfaces

| Path                                 | Purpose                                                                             |
| ------------------------------------ | ----------------------------------------------------------------------------------- |
| `/`                                  | Start page (links to catalogue under Developer previews)                            |
| `/components`                        | Catalogue index — **links only**, no live demos                                     |
| `/components/:name?fixture=`         | Preview selected fixture + **live** parity banner (`Govuk.render` ≡ fixture `html`) |
| `/components/:name/fixture?fixture=` | Raw official fixture HTML fragment                                                  |
| `/health`                            | Liveness                                                                            |

`DEMOS_ENABLED` gates the catalogue (on in development/test; set `true` on Render).

## Expectations

- Parity banner says “HTML matches the fixture” only when ordinal equality holds.
- Preview uses the same renderer and ordered fixture options as the RSpec suite.
- Responses use [`baseline/`](../baseline/) headers; local HTTP omits HSTS.
- Triple noindex: meta robots, `X-Robots-Tag`, `/robots.txt` Disallow.

## After code changes

```sh
npm run build:styles
bundle exec rspec
```

Hard-refresh the browser. After Frontend upgrades, re-check focus, header/footer, and a failing-form example ([upgrading-govuk-frontend.md](upgrading-govuk-frontend.md)).
