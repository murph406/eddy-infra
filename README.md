# Hoopfest Infra

Infrastructure as code for the Hoopfest platform, managed with AWS SAM and CloudFormation.

## Architecture
```
CloudFront Distribution
├── /api/v1*       → API Gateway (hoopfest-api repo)
├── /lookup*       → Lookup S3 bucket (static JSON files)
└── /*             → Frontend S3 bucket (static admin panel)
```

## Stack

- AWS SAM
- AWS CloudFormation
- AWS CloudFront
- AWS S3
- AWS Lambda@Edge

## Environments

| Branch | Stack | CloudFront |
|--------|-------|------------|
| develop | hoopfest-develop | develop distribution |
| stage | hoopfest-stage | stage distribution |
| main | hoopfest-main | main distribution |

## Deployment

Deployments are triggered automatically on push to `develop`, `stage`, or `main` branches via GitHub Actions.

To deploy manually:
```bash
sam build && sam deploy --config-env develop
```

## S3 Buckets

| Bucket | Purpose |
|--------|---------|
| `hoopfest-{stage}` | Static admin panel |
| `hoopfest-{stage}-lookups` | Static JSON lookup files |
| `hoopfest-{stage}-logs` | CloudFront access logs |

## Lookup Files

Static JSON files served from the `/lookup/*` CloudFront path. Files live in `src/lookups/` and are synced to S3 on every deploy.

### App Config (`/lookup/app-config.json`)

Controls global event state and timing.

| Field | Type | Description |
|-------|------|-------------|
| `eventStart` | string | ISO date string for event start |
| `eventEnd` | string | ISO date string for event end |
| `phase` | number | Current event phase |

**Phase values:**

| Value | Description |
|-------|-------------|
| `-1` | Pre event |
| `0` | Event active |
| `1` | Post event |

## Lambda@Edge Functions

| Function | Trigger | Purpose |
|----------|---------|---------|
| `CloudfrontReactOriginRequest` | Default behavior | Redirects all routes to root for SPA |
| `CloudfrontLookupOriginRequest` | `/lookup*` | Strips `/lookup` prefix before forwarding to S3 |

