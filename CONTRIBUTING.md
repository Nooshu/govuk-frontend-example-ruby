# Contributing

Thanks for helping improve this **Ruby / Rails** GOV.UK Frontend example.

## Before you start

1. Read [`docs/project-purpose.md`](docs/project-purpose.md) and [`docs/tech-stack.md`](docs/tech-stack.md).
2. Prefer official guidance listed in [`docs/guidance-sources.md`](docs/guidance-sources.md).
3. Keep dual-audience docs updated with every lasting change ([`docs/documentation-structure.md`](docs/documentation-structure.md)).

## Local checks

```sh
npm ci
bundle install
npm start              # Sass + Rails — http://127.0.0.1:3000
npm test               # Node baseline/Sass + RSpec (fixture parity + coverage)
npm run lint:ruby      # RuboCop
npm run verify         # docs + styles + RuboCop + tests
```

Requires **Node 22+** and **Ruby 3.3+**.

## Pull requests

- Keep PRs focused; split unrelated concerns.
- Do not edit official fixture `html` to pass tests.
- Component preview banners must reflect a live `Govuk.render` ≡ fixture check.
- CI runs RuboCop, RSpec (including 100% fixture parity), and Node verify.

## Consistency tooling

EditorConfig, Prettier, and markdownlint cover shared docs/Node files. RuboCop covers Ruby. See [`docs/tech-stack.md`](docs/tech-stack.md).
