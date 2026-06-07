# Error Handling

Comprehensive guide to error codes, error response format, and retry strategies.

## 📋 Error Response Format

All errors follow a consistent JSON structure:

```json
{
  "success": false,
  "status": 400,
  "message": "Validation failed",
  "error": "Invalid input data",
  "details": {
    "error_code": "VALIDATION_FAILED",
    "field_errors": [
      {
        "field": "name",
        "message": "Field is required"
      }
    ],
    "request_id": "req_1234567890abcdef",
    "support_reference": "sup_abcdef1234567890",
    "retry_after": null,
    "resource_type": "report",
    "resource_id": "r_1234567890abcdef"
  }
}
```

### Error Schema Fields

| Field | Type | Description |
|-------|------|-------------|
| `success` | boolean | Always `false` for errors |
| `status` | integer | HTTP status code |
| `message` | string | Human-readable error summary |
| `error` | string | Detailed error description |
| `details.error_code` | string | Machine-readable error code (see below) |
| `details.field_errors` | array | Field-level validation errors |
| `details.request_id` | string | Unique request identifier for support |
| `details.support_reference` | string | Reference ID for support tickets |
| `details.retry_after` | integer | Seconds to wait before retrying |
| `details.resource_type` | string | Type of resource involved |
| `details.resource_id` | string | ID of the resource involved |

## HTTP Status Codes

### Client Errors (4xx)

#### 400 Bad Request

The request body or parameters are invalid.

```json
{
  "success": false,
  "status": 400,
  "message": "Invalid query parameters",
  "details": {
    "error_code": "INVALID_PARAMETERS",
    "field_errors": [
      { "field": "page_size", "message": "Must be between 1 and 100" }
    ]
  }
}
```

**Common error codes:** `INVALID_PARAMETERS`, `VALIDATION_FAILED`, `INVALID_FORMAT`, `MISSING_REQUIRED_FIELD`

#### 401 Unauthorized

Authentication is missing or invalid.

```json
{
  "success": false,
  "status": 401,
  "message": "Authentication required",
  "details": {
    "error_code": "AUTH_REQUIRED"
  }
}
```

**Common error codes:** `AUTH_REQUIRED`, `INVALID_API_KEY`, `TOKEN_EXPIRED`, `INVALID_TOKEN`

#### 403 Forbidden

Authenticated but lacks permission for this action.

```json
{
  "success": false,
  "status": 403,
  "message": "Insufficient permissions",
  "details": {
    "error_code": "FORBIDDEN",
    "resource_type": "report",
    "resource_id": "r_1234567890abcdef"
  }
}
```

#### 404 Not Found

The requested resource does not exist.

```json
{
  "success": false,
  "status": 404,
  "message": "Report not found",
  "details": {
    "error_code": "NOT_FOUND",
    "resource_type": "report",
    "resource_id": "r_1234567890abcdef"
  }
}
```

#### 409 Conflict

The request conflicts with existing state.

```json
{
  "success": false,
  "status": 409,
  "message": "Report already exists",
  "details": {
    "error_code": "CONFLICT",
    "resource_type": "report"
  }
}
```

#### 413 Payload Too Large

Request body exceeds the 10 MB limit.

```json
{
  "success": false,
  "status": 413,
  "message": "Payload too large",
  "details": {
    "error_code": "PAYLOAD_TOO_LARGE",
    "max_size": "10MB"
  }
}
```

#### 415 Unsupported Media Type

Invalid file type uploaded.

```json
{
  "success": false,
  "status": 415,
  "message": "Unsupported file type",
  "details": {
    "error_code": "UNSUPPORTED_MEDIA_TYPE",
    "supported_types": ["application/pdf", "image/png", "image/jpeg"]
  }
}
```

#### 422 Unprocessable Entity

Valid format but violates business rules.

```json
{
  "success": false,
  "status": 422,
  "message": "Cannot submit incomplete report",
  "details": {
    "error_code": "BUSINESS_RULE_VIOLATION",
    "missing_sections": ["environmental_metrics", "social_metrics"]
  }
}
```

#### 429 Too Many Requests

Rate limit exceeded. See [Rate Limiting](rate-limiting.md).

```json
{
  "success": false,
  "status": 429,
  "message": "Rate limit exceeded",
  "details": {
    "error_code": "RATE_LIMIT_EXCEEDED",
    "retry_after": 60,
    "limit": 100,
    "remaining": 0
  }
}
```

### Server Errors (5xx)

#### 500 Internal Server Error

```json
{
  "success": false,
  "status": 500,
  "message": "Internal server error",
  "details": {
    "error_code": "INTERNAL_ERROR",
    "request_id": "req_1234567890abcdef"
  }
}
```

#### 503 Service Unavailable

```json
{
  "success": false,
  "status": 503,
  "message": "Service temporarily unavailable",
  "details": {
    "error_code": "SERVICE_UNAVAILABLE",
    "retry_after": 30
  }
}
```

## Error Codes Reference

| Error Code | Status | Description |
|------------|--------|-------------|
| `AUTH_REQUIRED` | 401 | Authentication header missing |
| `INVALID_API_KEY` | 401 | API key is malformed or revoked |
| `TOKEN_EXPIRED` | 401 | JWT access token expired |
| `INVALID_TOKEN` | 401 | JWT token is malformed |
| `FORBIDDEN` | 403 | Insufficient role/permission |
| `NOT_FOUND` | 404 | Resource does not exist |
| `CONFLICT` | 409 | Resource already exists |
| `VALIDATION_FAILED` | 400 | Request body validation failed |
| `INVALID_PARAMETERS` | 400 | Query parameter validation failed |
| `INVALID_FORMAT` | 400 | Data format is incorrect |
| `PAYLOAD_TOO_LARGE` | 413 | Request body exceeds size limit |
| `UNSUPPORTED_MEDIA_TYPE` | 415 | File type not supported |
| `BUSINESS_RULE_VIOLATION` | 422 | Business logic constraint |
| `RATE_LIMIT_EXCEEDED` | 429 | Rate limit hit |
| `INTERNAL_ERROR` | 500 | Unexpected server error |
| `SERVICE_UNAVAILABLE` | 503 | Service temporarily down |

## Retry Strategies

### Which Errors Are Retryable

| Status | Retryable? | Strategy |
|--------|-----------|----------|
| 400 | ❌ No | Fix the request and retry |
| 401 | ❌ No | Fix authentication and retry |
| 403 | ❌ No | Check permissions |
| 404 | ❌ No | Verify resource ID |
| 409 | ⚠️ Conditional | Read-then-write pattern |
| 429 | ✅ Yes | Use `retry_after` value |
| 500 | ✅ Yes | Exponential backoff |
| 503 | ✅ Yes | Use `retry_after` or exponential backoff |

### Exponential Backoff Implementation

```python
import time, random

def call_with_retry(request_func, max_retries=5, base_delay=1.0):
    """Call an API function with exponential backoff and jitter."""
    for attempt in range(max_retries):
        try:
            response = request_func()
            if response.status_code in (200, 201):
                return response
            
            if response.status_code == 429:
                retry_after = response.json().get('details', {}).get('retry_after', 60)
                time.sleep(retry_after)
                continue
            
            if response.status_code >= 500:
                delay = min(base_delay * (2 ** attempt) + random.uniform(0, 1), 60)
                time.sleep(delay)
                continue
            
            # Non-retryable error
            return response
            
        except Exception as e:
            if attempt == max_retries - 1:
                raise
            delay = min(base_delay * (2 ** attempt) + random.uniform(0, 1), 60)
            time.sleep(delay)
    
    raise Exception("Max retries exceeded")
```

### Idempotent Retries

For POST/PUT requests, use an idempotency key to prevent duplicate operations:

```bash
curl -X POST \
  -H "X-API-Key: your-api-key" \
  -H "Idempotency-Key: unique-request-id-12345" \
  -H "Content-Type: application/json" \
  -d '{"name": "Q4 Report"}' \
  https://api.greenreporter.eu/v1/reports
```

The server will return the same response for duplicate `Idempotency-Key` values within 24 hours.

## Error Monitoring

### Logging Best Practices

```javascript
try {
  const report = await client.reports.create(data);
} catch (error) {
  // Log structured error for monitoring
  console.error({
    event: 'api_error',
    status: error.status,
    error_code: error.errorCode,
    message: error.message,
    request_id: error.requestId,
    endpoint: 'POST /v1/reports',
    timestamp: new Date().toISOString()
  });
}
```

### Alert Thresholds

Set up alerts for:

- **Error rate > 5%** over 5 minutes → potential integration issue
- **429 rate > 1%** → rate limit adjustments needed
- **5xx errors > 0.1%** → escalate to GreenReporter support
- **Latency p99 > 5s** → check network or reduce request volume

---

**Need help?** [Troubleshooting Guide](troubleshooting.md) | [api-support@greenreporter.eu](mailto:api-support@greenreporter.eu)
