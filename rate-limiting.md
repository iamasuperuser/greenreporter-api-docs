# Rate Limiting

Understand the rate limits, quotas, and usage constraints that apply to the GreenReporter API.

## 🚦 Overview

The GreenReporter API uses a multi-tier rate limiting system to ensure fair usage, protect system stability, and prevent abuse. All limits are applied per authentication identity (API key or user token).

## Standard Rate Limits

| Authentication Method | Requests/Minute | Requests/Hour |
|-----------------------|-----------------|---------------|
| **API Key** (`X-API-Key`) | 100 | 1,000 |
| **JWT Bearer Token** | 100 | 1,000 |
| **Public Endpoints** | 200 | 2,000 |

## Burst Limits

Short-duration burst limits prevent traffic spikes from overwhelming the system:

| Window | Limit |
|--------|-------|
| Short burst | 20 requests per 10 seconds |
| Medium burst | 50 requests per 1 minute |
| Long burst | 200 requests per 10 minutes |

## Endpoint-Specific Limits

Certain endpoints have stricter limits due to resource intensity:

| Endpoint Category | Requests/Minute | Requests/Hour | Burst Limit |
|-------------------|-----------------|---------------|-------------|
| **Report Management** (`/reports`) | 50 | 500 | 10 per 10s |
| **Analytics** (`/analytics/*`) | 30 | 300 | 5 per 10s |
| **Authentication** (`/auth/*`) | 20 | 200 | 3 per 10s |
| **File Upload** | 10 | 100 | 2 per 10s |
| **Export Operations** (`/export/*`) | 5 | 50 | 1 per 10s |
| **Webhook Management** (`/webhooks`) | 20 | 200 | 3 per 10s |

## Rate Limit Headers

Every API response includes rate limit headers:

```http
HTTP/1.1 200 OK
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1642224000
X-RateLimit-Policy: 100;w=60
```

| Header | Description |
|--------|-------------|
| `X-RateLimit-Limit` | Maximum requests allowed in the current window |
| `X-RateLimit-Remaining` | Requests remaining in the current window |
| `X-RateLimit-Reset` | Unix timestamp when the rate limit window resets |
| `X-RateLimit-Policy` | Policy in `limit;w=seconds` format |

## Rate Limit Exceeded

When you exceed a rate limit, the API returns a `429 Too Many Requests` response:

```json
{
  "success": false,
  "status": 429,
  "message": "Rate limit exceeded",
  "error": "Too many requests. Please retry after 60 seconds.",
  "details": {
    "error_code": "RATE_LIMIT_EXCEEDED",
    "retry_after": 60,
    "limit": 100,
    "remaining": 0,
    "reset_at": "2024-01-15T10:31:00Z",
    "request_id": "req_1234567890abcdef"
  }
}
```

### Handling 429 Responses

Implement exponential backoff with jitter:

```python
import time, random

def api_call_with_retry(client, endpoint, max_retries=5):
    for attempt in range(max_retries):
        response = client.request(endpoint)
        
        if response.status_code != 429:
            return response
            
        retry_after = response.headers.get('Retry-After', 60)
        jitter = random.uniform(0, 0.5) * retry_after
        wait = min(retry_after * (2 ** attempt) + jitter, 300)
        
        print(f"Rate limited. Waiting {wait:.1f}s (attempt {attempt + 1})")
        time.sleep(wait)
    
    raise Exception(f"Max retries exceeded for {endpoint}")
```

```javascript
async function apiCallWithRetry(client, endpoint, maxRetries = 5) {
  for (let attempt = 0; attempt < maxRetries; attempt++) {
    const response = await client.request(endpoint);
    
    if (response.status !== 429) return response;
    
    const retryAfter = parseInt(response.headers['retry-after'] || '60');
    const jitter = Math.random() * 0.5 * retryAfter;
    const wait = Math.min(retryAfter * Math.pow(2, attempt) + jitter, 300);
    
    console.log(`Rate limited. Waiting ${wait.toFixed(1)}s (attempt ${attempt + 1})`);
    await new Promise(resolve => setTimeout(resolve, wait * 1000));
  }
  throw new Error(`Max retries exceeded for ${endpoint}`);
}
```

## Usage Constraints

### Request Size Limits

| Component | Limit |
|-----------|-------|
| JSON payload | 10 MB per request |
| Query parameters | 8 KB total |
| Header size | 16 KB total |
| URL length | 8 KB maximum |

### File Size Limits

| Operation | Limit |
|-----------|-------|
| Document upload | 50 MB per file |
| Bulk data import | 100 MB per request |
| Report export | 500 MB per export |
| Image attachments | 10 MB per image |

### Concurrent Connections

| Scope | Limit |
|-------|-------|
| Per API key | 10 connections |
| Per user session | 5 connections |
| Per IP address | 20 connections |

### Data Retention

| Data Type | Retention Period |
|-----------|------------------|
| Report versions | 100 versions per report |
| Audit logs | 1 year |
| Session data | 7 days |
| Temporary files | 24 hours |

## Best Practices

1. **Cache responses** — avoid redundant API calls for data that rarely changes
2. **Use webhooks** — for real-time updates instead of polling
3. **Batch operations** — use bulk endpoints where available
4. **Monitor headers** — track `X-RateLimit-Remaining` to avoid hitting limits
5. **Implement backoff** — always handle 429 responses with exponential backoff

---

**Next**: [API Versioning →](api-versioning.md)
