# Eddy Infra

Infrastructure as code for the Eddy platform, managed with AWS SAM and CloudFormation.

## Architecture
```
CloudFront Distribution
├── /api/v1*       → API Gateway (eddy-api repo)
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
| develop | eddy-develop | develop distribution |
| stage | eddy-stage | stage distribution |
| main | eddy-main | main distribution |

## Deployment

Deployments are triggered automatically on push to `develop`, `stage`, or `main` branches via GitHub Actions.

To deploy manually:
```bash
sam build && sam deploy --config-env develop
```

## S3 Buckets

| Bucket | Purpose |
|--------|---------|
| `eddy-{stage}` | Static admin panel |
| `eddy-{stage}-lookups` | Static JSON lookup files |
| `eddy-{stage}-logs` | CloudFront access logs |


## Lambda@Edge Functions

| Function | Trigger | Purpose |
|----------|---------|---------|
| `CloudfrontReactOriginRequest` | Default behavior | Redirects all routes to root for SPA |

