# Troubleshooting

Solutions to common issues when integrating with the GreenReporter API.

## 🔍 Quick Diagnostics

### Health Check

Verify the API is reachable and your credentials are valid:

```bash
# API health
curl https://api.greenreporter.eu/v1/health

# Your authentication
curl -H "X-API-Key: your-api-key" https://api.greenreporter.eu/v1/auth/me
```

**Expected health response:**

```json
{
  "success": true,
  "data": {
    "status": "healthy",
    "version": "2024-01",
    "timestamp": "2024-01-15T10:30:00Z"
  }
}
```

## Common Issues

### Authentication Errors

#### 401 Unauthorized — "Missing X-API-Key header"

**Cause:** No authentication header was provided.

**Solution:**

```bash
# Make sure the header is included
curl -H "X-API-Key: your-api-key" https://api.greenreporter.eu/v1/reports

# Verify the key is set in your environment
echo $GREENREPORTER_API_KEY
```

#### 401 Unauthorized — "Invalid API key"

**Cause:** The API key is malformed, revoked, or belongs to a different environment.

**Solution:**

1. Verify the key starts with `gr_live_` (production) or `gr_test_` (staging)
2. Check for trailing whitespace or newlines in the key
3. Ensure you're using the correct environment key (test vs. production)
4. Contact your administrator if the key was revoked

```bash
# Check for hidden characters
echo -n "$GREENREPORTER_API_KEY" | xxd | head
```

#### 401 Unauthorized — "JWT token has expired"

**Cause:** Access token has exceeded its 1-hour lifetime.

**Solution:** Use the refresh token to obtain a new access token:

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"refresh_token": "your-refresh-token"}' \
  https://api.greenreporter.eu/v1/auth/refresh
```

#### 403 Forbidden — "Insufficient permissions"

**Cause:** Your role doesn't have the required permission for this endpoint.

**Solution:** Check your current permissions and contact your administrator:

```bash
curl -H "X-API-Key: your-api-key" \
  https://api.greenreporter.eu/v1/auth/me
```

### Rate Limiting

#### 429 Too Many Requests

**Cause:** You've exceeded the rate limit for your authentication method.

**Solution:**

1. Check the `Retry-After` header or `details.retry_after` in the response
2. Implement exponential backoff (see [Rate Limiting](rate-limiting.md))
3. Consider caching or batching requests

```bash
# Check your current rate limit status from response headers
curl -I -H "X-API-Key: your-api-key" \
  https://api.greenreporter.eu/v1/reports
# Look for: X-RateLimit-Remaining, X-RateLimit-Reset
```

### Data Issues

#### 404 Not Found — "Report not found"

**Cause:** The resource ID doesn't exist or belongs to another organization.

**Solution:**

1. Verify the ID format starts with `r_`
2. List your reports to find the correct ID
3. Ensure you're using the right API key for the organization

```bash
# List your reports
curl -H "X-API-Key: your-api-key" \
  "https://api.greenreporter.eu/v1/reports?search=Q4"
```

#### 400 Bad Request — "Validation failed"

**Cause:** Request body contains invalid or missing required fields.

**Solution:** Check the `details.field_errors` array in the error response:

```json
{
  "success": false,
  "status": 400,
  "message": "Validation failed",
  "details": {
    "error_code": "VALIDATION_FAILED",
    "field_errors": [
      { "field": "name", "message": "Field is required" },
      { "field": "reporting_period", "message": "Invalid format. Use YYYY." }
    ]
  }
}
```

#### 409 Conflict — "Report already exists"

**Cause:** A report with the same name and reporting period already exists.

**Solution:** Use a different name, update the existing report, or delete the duplicate first.

#### 422 Unprocessable Entity

**Cause:** The request is valid but violates a business rule (e.g., submitting a report that hasn't been completed).

**Solution:** Check the `error_code` and `message` for the specific business rule violation.

### Network Issues

#### Connection Timeout

**Cause:** Network connectivity or firewall blocking requests to `api.greenreporter.eu`.

**Solution:**

```bash
# Test DNS resolution
nslookup api.greenreporter.eu

# Test connectivity
curl -v https://api.greenreporter.eu/v1/health

# Check firewall allows outbound HTTPS (port 443)
telnet api.greenreporter.eu 443
```

#### SSL/TLS Errors

**Cause:** Outdated TLS library or corporate proxy intercepting traffic.

**Solution:**

1. Ensure your HTTP client supports TLS 1.2+
2. If behind a corporate proxy, add the proxy's CA certificate to your trust store
3. Do not disable SSL verification in production

## JWT Issues

### Token Structure

JWT tokens have three parts: `header.payload.signature`

```bash
# Decode token payload (without verifying)
echo "eyJhbG...VCJ9..." | cut -d. -f2 | base64 -d 2>/dev/null | python3 -m json.tool
```

Check the `exp` (expiration) claim to see if the token is still valid.

### Refresh Token Expired

Refresh tokens expire after 7 days. If your refresh token is expired, you must log in again:

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"email": "user@company.com", "password": "your-password"}' \
  https://api.greenreporter.eu/v1/auth/login
```

### Concurrent Token Usage

If multiple processes use the same user credentials, token refresh can cause race conditions. Use API keys for server-to-server communication instead of shared JWT tokens.

## Debugging Checklist

- [ ] API key is set and correctly formatted (`gr_live_*` or `gr_test_*`)
- [ ] Using correct base URL (`https://api.greenreporter.eu/v1`)
- [ ] Content-Type header is `application/json` for POST/PUT requests
- [ ] Request body is valid JSON
- [ ] Not hitting rate limits (check `X-RateLimit-Remaining`)
- [ ] Resource IDs are correct (check with a list endpoint)
- [ ] JWT token hasn't expired (check `exp` claim)
- [ ] Network allows outbound HTTPS to `api.greenreporter.eu`

## Getting Help

If you can't resolve an issue:

1. Include the `request_id` from the error response in your support ticket
2. Provide the exact request (with secrets redacted)
3. Include the full error response body
4. Note the timestamp of the failed request

**Support:** [api-support@greenreporter.eu](mailto:api-support@greenreporter.eu)

---

**Next**: [Error Handling →](error-handling.md)
