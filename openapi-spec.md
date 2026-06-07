# OpenAPI Specification

Download and explore the full GreenReporter API specification in OpenAPI 3.0 format.

## 📥 Download

The OpenAPI specification is available in both JSON and YAML formats:

| Format | URL |
|--------|-----|
| **JSON** | `https://api.greenreporter.eu/docs/openapi.json` |
| **YAML** | `https://api.greenreporter.eu/docs/openapi.yaml` |

```bash
# Download the latest specification
curl -O https://api.greenreporter.eu/docs/openapi.json
```

## 🔧 Using the Specification

### Import into Postman

1. Open Postman → **Import** → **Link**
2. Paste: `https://api.greenreporter.eu/docs/openapi.json`
3. Postman will generate a complete collection with all endpoints

### Import into Insomnia

1. **Application** → **Preferences** → **Data** → **Import/Export**
2. Select the downloaded `openapi.json` file
3. Insomnia creates a workspace with all endpoints organized by tag

### Generate Client SDKs

Use [OpenAPI Generator](https://github.com/OpenAPITools/openapi-generator) to create typed clients:

```bash
# Install generator
npm install @openapitools/openapi-generator-cli -g

# Python client
openapi-generator-cli generate \
  -i https://api.greenreporter.eu/docs/openapi.json \
  -g python \
  -o ./greenreporter-python

# TypeScript/Node.js client
openapi-generator-cli generate \
  -i https://api.greenreporter.eu/docs/openapi.json \
  -g typescript-axios \
  -o ./greenreporter-ts

# Java client
openapi-generator-cli generate \
  -i https://api.greenreporter.eu/docs/openapi.json \
  -g java \
  -o ./greenreporter-java
```

### Explore with Swagger UI

An interactive Swagger UI is available at:

```
https://api.greenreporter.eu/docs/swagger
```

This lets you browse endpoints, view schemas, and execute test calls directly from your browser.

## 📋 Specification Overview

### Servers

| Environment | URL | Description |
|-------------|-----|-------------|
| Production | `https://api.greenreporter.eu/v1` | Live API |
| Staging | `https://staging-api.greenreporter.eu/v1` | Pre-production testing |
| Development | `http://localhost:3001/v1` | Local development |

### Security Schemes

```yaml
securitySchemes:
  ApiKeyAuth:
    type: apiKey
    in: header
    name: X-API-Key
    description: Server-to-server API key (gr_live_* or gr_test_*)

  BearerAuth:
    type: http
    scheme: bearer
    bearerFormat: JWT
    description: JWT token obtained via /auth/login
```

### Tag Groups

| Tag | Endpoints | Description |
|-----|-----------|-------------|
| **Authentication** | 5 | Login, refresh, logout, API key management |
| **Reports** | 6 | CRUD operations for sustainability reports |
| **Analytics** | 3 | Metrics, trends, and aggregation |
| **Suppliers** | 4 | Supplier network management |
| **Webhooks** | 4 | Webhook subscription management |
| **Users** | 3 | User profile and permissions |

### Core Schemas

#### Report

```yaml
Report:
  type: object
  required: [id, name, status, report_type, reporting_period, created_at, updated_at]
  properties:
    id:
      type: string
      example: "r_1234567890abcdef"
    name:
      type: string
      example: "Q4 2024 Sustainability Report"
    status:
      type: string
      enum: [draft, submitted, approved, rejected]
    report_type:
      type: string
      enum: [comprehensive, simplified, vsme]
    reporting_period:
      type: string
      example: "2024"
    description:
      type: string
    metrics:
      type: object
      additionalProperties:
        type: number
    created_at:
      type: string
      format: date-time
    updated_at:
      type: string
      format: date-time
```

#### ErrorResponse

```yaml
ErrorResponse:
  type: object
  required: [success, status, message]
  properties:
    success:
      type: boolean
      example: false
    status:
      type: integer
      description: HTTP status code
    message:
      type: string
      description: Human-readable error message
    error:
      type: string
      description: Detailed error description
    details:
      type: object
      properties:
        error_code:
          type: string
          example: "VALIDATION_FAILED"
        field_errors:
          type: array
          items:
            type: object
            properties:
              field:
                type: string
              message:
                type: string
        request_id:
          type: string
          example: "req_1234567890abcdef"
        retry_after:
          type: integer
          description: Seconds until retry is allowed
```

#### PaginationMeta

```yaml
PaginationMeta:
  type: object
  properties:
    pagination:
      type: object
      properties:
        page:
          type: integer
        page_size:
          type: integer
        total_items:
          type: integer
        total_pages:
          type: integer
        has_next:
          type: boolean
        has_previous:
          type: boolean
```

## 🔄 Specification Version

The OpenAPI specification follows the API version:

| API Version | Spec Version | Status |
|-------------|-------------|--------|
| `v1` | `1.0.0` | Current |
| `v0.9` | `0.9.0` | Previous (supported until 2024-12) |

Check the `info.version` field in the spec file for the exact version.

---

**Next**: [SDK Integration Guides →](sdk-integration.md)
