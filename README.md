# Eddy Infra

Infrastructure as code for the Eddy platform, managed with AWS SAM and CloudFormation.

## Architecture

```
CloudFront Distribution
├── /api/v1*       → API Gateway (eddy-api repo)
└── /*             → Frontend S3 bucket (api docs panel)

VPC (private, no internet access)
├── RDS Postgres + PostGIS        (optional, toggled by DbEnabled)
└── EC2 Instance Connect Endpoint (laptop access to RDS)
```

## Stack

- AWS SAM
- AWS CloudFormation
- AWS CloudFront
- AWS S3
- AWS Lambda@Edge
- AWS VPC
- AWS RDS (Postgres 18 + PostGIS)
- EC2 Instance Connect Endpoint
- Docker (local database)

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
| `eddy-{stage}-logs` | CloudFront access logs |

## Lambda@Edge Functions

| Function | Trigger | Purpose |
|----------|---------|---------|
| `CloudfrontReactOriginRequest` | Default behavior | Redirects all routes to root for SPA |

## Database (RDS)

Private Postgres 18 + PostGIS instance inside the VPC. No public address.

| Setting | Value |
|---------|-------|
| Instance | `db.t4g.micro` |
| Storage | 20 GB gp3, encrypted |
| Database | `eddy` |
| Admin user | `dbadmin` |
| Backups | 7 days |

**Toggle:** the `DbEnabled` parameter (`true` / `false`) creates or removes the database. Removing it deletes all data in it.

**Prerequisite:** the admin password must exist in Parameter Store before deploying with `DbEnabled=true`:
```bash
aws ssm put-parameter \
  --name /eddy/{stage}/db/password \
  --type SecureString \
  --value "$(openssl rand -hex 24)" \
  --region us-east-1
```

## Local Development

Local Postgres 18 + PostGIS runs in Docker, matching the RDS versions. Run from the repo root:

| Command | Purpose |
|---------|---------|
| `make db-up` | Build (first time) and start the database |
| `make db-ps` | Check it's running |
| `make db-psql` | Open a SQL prompt |
| `make db-down` | Stop the database (data is kept) |

Connection: `postgres://dbadmin:localpassword@localhost:5432/eddy`