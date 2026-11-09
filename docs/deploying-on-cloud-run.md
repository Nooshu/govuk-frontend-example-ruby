# Deploying on Google Cloud Run

Host this Ruby on Rails example on [Cloud Run](https://cloud.google.com/run/docs). Puma binds `0.0.0.0:$PORT`. Cloud Run’s default port is 8080. TLS stops at the platform. Production sets `assume_ssl` and `force_ssl`, and allows hosts ending in `.run.app`. `/health` is excluded from the HTTPS redirect and from host authorisation so probes succeed.

You need a Google Cloud project with billing enabled, the [gcloud CLI](https://cloud.google.com/sdk/docs/install), and `openssl`. Cloud Run can scale to zero. Build minutes, Artifact Registry storage, and requests above the free tier are billed.

This service’s name is `govuk-frontend-example-ruby`, region `europe-west2` (London).

## What this repo includes

| File                                                            | Role                                             |
| --------------------------------------------------------------- | ------------------------------------------------ |
| [`Dockerfile`](../Dockerfile)                                   | Node Sass, Bundler, then Puma                    |
| [`scripts/deploy-cloud-run.sh`](../scripts/deploy-cloud-run.sh) | Stores `SECRET_KEY_BASE` and deploys from source |
| `GET /health`                                                   | Plain `ok` for startup, readiness, and liveness  |

## Deploy

From the repo root, with a project selected:

```sh
gcloud config set project PROJECT_ID
./scripts/deploy-cloud-run.sh
```

| Variable        | Default                                       |
| --------------- | --------------------------------------------- |
| `PROJECT`       | gcloud’s active project                       |
| `REGION`        | `europe-west2`                                |
| `SERVICE`       | `govuk-frontend-example-ruby`                 |
| `SECRET`        | `govuk-frontend-example-ruby-secret-key-base` |
| `MEMORY`        | `1Gi`                                         |
| `CPU`           | `1`                                           |
| `MIN_INSTANCES` | `0`                                           |
| `MAX_INSTANCES` | `3`                                           |

The first run creates a Secret Manager secret for `SECRET_KEY_BASE`. Later deploys reuse it. The script sets `DEMOS_ENABLED=true`.

### After deploy checklist

- [ ] `https://<service>-<hash>.<region>.run.app/health` returns `ok`
- [ ] Start page loads with GOV.UK styling
- [ ] `/components` works
- [ ] A form POST in the licence journey keeps the answers on the next page

## Run the image locally

```sh
docker build -t govuk-frontend-example-ruby .
docker run --rm -p 8080:8080 -e PORT=8080 -e SECRET_KEY_BASE=dev -e DEMOS_ENABLED=true govuk-frontend-example-ruby
```

Open <http://127.0.0.1:8080/health>. Local HTTP still has `assume_ssl` on, so the browser may be asked to use HTTPS. Prefer the Cloud Run URL for a full journey.
