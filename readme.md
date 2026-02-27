# Terraform AWS Serverless Platform

Production-style serverless platform built with Terraform.

## 🚀 Architecture

    Client (curl)
        ↓
    API Gateway (HTTP API)
        ↓
    Lambda API
        ↓            ↘
    DynamoDB          SQS
                         ↓
                     Lambda Worker

## 🧩 Components

-   API Gateway HTTP API
-   Lambda API (CRUD + event producer)
-   DynamoDB table (items storage)
-   SQS queue + DLQ
-   Lambda Worker (async processor)
-   CloudWatch logs
-   Terraform remote state (S3 + DynamoDB lock)
-   GitHub Actions CI/CD with OIDC

## 📦 Features

-   Serverless CRUD API
-   Event-driven async processing
-   Dead-letter queue handling
-   Infrastructure as Code
-   Secure CI/CD without AWS keys

## 🔧 Usage

### Deploy

``` bash
cd infra
terraform init
terraform apply
```

### Create item

``` bash
API_URL=$(terraform output -raw api_url)

curl -X POST "$API_URL/items"   -H "content-type: application/json"   -d '{"data":{"hello":"world"}}'
```

### Get item

``` bash
curl "$API_URL/items/<id>"
```

### Send event

``` bash
curl -X POST "$API_URL/events"   -H "content-type: application/json"   -d '{"type":"demo"}'
```

## 📁 Repository structure

    infra/      # Terraform infrastructure
    app/        # Lambda source code
    .github/    # CI/CD workflows

## 🛡️ CI/CD

GitHub Actions pipeline:

-   Terraform fmt
-   Terraform validate
-   Terraform plan (PR)
-   Terraform apply (manual)

## 📌 Author

Tony
