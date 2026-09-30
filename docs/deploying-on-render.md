# Deploying on Render.com

Host the Ruby/Rails example service on [Render](https://render.com) as a public demo. This line is a Rails HTTP process — not a static site — so use a **Web Service** with **Docker** (Ruby + Node for Sass / `govuk-frontend`).

Authoritative Render docs: [Docker](https://render.com/docs/docker), [Blueprints](https://render.com/docs/blueprint-spec).

## What this repo already includes

| File                            | Role                                                                 |
| ------------------------------- | -------------------------------------------------------------------- |
| [`render.yaml`](../render.yaml) | Blueprint: free Docker web service, `/health` check, `DEMOS_ENABLED` |
| [`Dockerfile`](../Dockerfile)   | Multi-stage: `npm ci` → Sass → `bundle install` → Puma               |
| `GET /health`                   | Plain `ok` for Render health checks                                  |

Build artefacts kept at runtime: gems, `node_modules/govuk-frontend`, `dist/stylesheets/application.css`, Rails app.

## Prerequisites

1. A GitHub account with this repo (or a fork) pushed to `main`.
2. A [Render](https://render.com) account (free tier is enough for a demo).
3. Local checks green: `npm ci && bundle install && npm run verify` (recommended).

## Option A — Blueprint (recommended)

1. Push this repo to GitHub including `render.yaml` and `Dockerfile`.
2. Open the [Render Dashboard](https://dashboard.render.com/) → **New +** → **Blueprint**.
3. Select this repository and confirm Render detects `render.yaml`.
4. Review the service (free plan, Docker, health `/health`).
5. Apply / Create and wait for the first deploy.
6. Open the `.onrender.com` URL when **Live**.

### After deploy checklist

- [ ] `https://<your-service>.onrender.com/health` returns `ok`
- [ ] Start page loads with GOV.UK styling (`/`)
- [ ] Component catalogue works (`/components`) — Blueprint sets `DEMOS_ENABLED=true`
- [ ] View source / headers show `noindex, nofollow`; `/robots.txt` disallows `/`
- [ ] A form POST in the licence journey retains the session cookie

## Environment

| Key                      | Value              | Notes                                |
| ------------------------ | ------------------ | ------------------------------------ |
| `DEMOS_ENABLED`          | `true`             | Keeps `/components` on in production |
| `SECRET_KEY_BASE`        | generated          | Rails cookies / CSRF                 |
| `RAILS_ENV` / `RACK_ENV` | `production`       |                                      |
| `PORT`                   | injected by Render | Puma binds `0.0.0.0:$PORT`           |

## Free-tier notes

- The service **spins down** when idle; the first request after idle can take ~30–60s (cold start).
- Cookie sessions survive as long as the instance stays up; a restart clears in-memory state but cookie-stored answers persist for the browser session.
- Disk is ephemeral — do not rely on uploaded files lasting across deploys.

## Local Docker smoke test

```sh
docker build -t govuk-frontend-example-ruby .
docker run --rm -e PORT=3000 -e SECRET_KEY_BASE=dev -p 3000:3000 govuk-frontend-example-ruby
curl -s http://127.0.0.1:3000/health
```
