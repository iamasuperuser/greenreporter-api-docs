# API Versioning

Understand how the GreenReporter API manages versions, deprecations, and migrations.

## 🚀 Versioning Strategy

The GreenReporter API uses **path-based versioning** with semantic versioning principles.

### Version Format

| Level | Format | Example | Purpose |
|-------|--------|---------|---------|
| **Path** | `/v1/` | `https://api.greenreporter.eu/v1/reports` | Major API version in URL |
| **API Version** | YYYY-MM | `2024-01` | Feature release identifier |
| **Semantic** | Major.Minor.Patch | `1.0.0` | Internal version tracking |

### Current Versions

| Version | API Release | Status | Support Until |
|---------|-------------|--------|---------------|
| **v1** | 2024-01 | ✅ Current | 2025-01 |
| **v0.9** | 2023-12 | ⚠️ Previous | 2024-12 |
| **v0.8** | 2023-11 | 🔴 Deprecated | 2024-06 |

## Version Headers

The API includes version information in every response:

```http
HTTP/1.1 200 OK
API-Version: 2024-01
Deprecation: true
Sunset: Sat, 01 Jun 2024 00:00:00 GMT
Link: <https://api.greenreporter.eu/v1/reports>; rel="successor-version"
```

| Header | Description |
|--------|-------------|
| `API-Version` | The API version serving the request |
| `Deprecation` | Present and `true` if this version is deprecated |
| `Sunset` | Date when this version will be removed |
| `Link` (rel="successor-version") | URL of the replacement version |

## Lifecycle Management

### Support Tiers

| Phase | Duration | New Features | Bug Fixes | Security Fixes |
|-------|----------|-------------|-----------|----------------|
| **Current** | 12 months | ✅ | ✅ | ✅ |
| **Previous** | 6 months | ❌ | ✅ | ✅ |
| **Deprecated** | 3 months | ❌ | ❌ | ✅ |
| **End of Life** | — | ❌ | ❌ | ❌ |

### Breaking vs Non-Breaking Changes

**Non-breaking** (no version change required):
- Adding new optional fields to responses
- Adding new endpoints
- Adding new enum values
- Increasing rate limits
- Adding new webhook events

**Breaking** (new version required):
- Removing or renaming fields
- Changing field types
- Removing endpoints
- Changing authentication requirements
- Altering error response format

## Migration Guide: v0.9 → v1

### Base URL Change

```
# Old
https://api.greenreporter.eu/v0.9/reports

# New
https://api.greenreporter.eu/v1/reports
```

### Authentication Changes

v1 adds support for API key authentication alongside JWT tokens:

```bash
# v0.9: JWT only
curl -H "Authorization: Bearer <token>" https://api.greenreporter.eu/v0.9/reports

# v1: JWT or API Key
curl -H "X-API-Key: gr_live_..." https://api.greenreporter.eu/v1/reports
```

### Response Format Changes

v1 introduces a standardized envelope with `success`, `data`, and `meta`:

```json
// v1 response
{
  "success": true,
  "data": { ... },
  "meta": {
    "pagination": { ... },
    "api_version": "2024-01"
  }
}
```

### Pagination Changes

v1 adds cursor-based pagination alongside offset-based:

```bash
# v0.9: offset only
GET /v0.9/reports?page=1&page_size=20

# v1: offset or cursor
GET /v1/reports?page=1&page_size=20
GET /v1/reports?cursor=eyJpZC...aIn0=&limit=20
```

### New v1 Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/v1/auth/api-keys` | POST | Create API keys programmatically |
| `/v1/reports/bulk` | POST | Bulk report creation |
| `/v1/analytics/trends` | GET | Trend analysis with aggregation |
| `/v1/suppliers/{id}/data` | POST | Submit supplier sustainability data |

## Requesting a Specific Version

Use the `API-Version` header to pin a specific feature release:

```bash
curl -H "X-API-Key: your-api-key" \
     -H "API-Version: 2024-01" \
     https://api.greenreporter.eu/v1/reports
```

This ensures you receive the response format and behavior for that specific release, even as minor updates are applied.

## Deprecation Notices

When a version enters the **Deprecated** phase:

1. All responses include the `Deprecation: true` and `Sunset` headers
2. A `Warning` header appears in responses: `299 - "This API version is deprecated and will be removed on <date>"`
3. The changelog is updated with migration instructions
4. Email notifications are sent to registered API key holders

## Changelog

Subscribe to API changelog notifications via webhook:

```json
{
  "events": ["api.version.deprecated", "api.version.sunset"],
  "url": "https://your-app.com/webhooks/greenreporter"
}
```

---

**Next**: [Pagination & Filtering →](pagination-filtering.md)
