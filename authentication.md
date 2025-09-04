# Authentication Guide

Learn how to securely authenticate with the GreenReporter API.

## 🔐 Authentication Methods

The API supports two authentication methods:

### 1. API Key (Recommended for Server-to-Server)

**Best for**: Backend applications, integrations, automated scripts

```bash
curl -H "X-API-Key: gr_live_1234567890abcdef" \
     https://api.greenreporter.eu/v1/reports
```

### 2. JWT Bearer Token (Recommended for User Applications)

**Best for**: Web applications, mobile apps, user-facing integrations

```bash
curl -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
     https://api.greenreporter.eu/v1/reports
```

## 🔑 Getting Your API Key

### Step 1: Contact Your Administrator
Your system administrator will provide you with an API key that looks like:
- **Production**: `gr_live_1234567890abcdef`
- **Testing**: `gr_test_1234567890abcdef`

### Step 2: Store Securely
```bash
# Environment variable (recommended)
export GREENREPORTER_API_KEY="gr_live_1234567890abcdef"

# Use in your application
curl -H "X-API-Key: $GREENREPORTER_API_KEY" \
     https://api.greenreporter.eu/v1/health
```

⚠️ **Never hardcode API keys in your source code!**

## 🎫 Using JWT Tokens

### Step 1: Login to Get Tokens

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@yourcompany.com",
    "password": "your-password"
  }' \
  https://api.greenreporter.eu/v1/auth/login
```

**Response:**
```json
{
  "success": true,
  "data": {
    "tokens": {
      "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "expires_in": 3600
    },
    "user": {
      "id": "u_1234567890abcdef",
      "email": "user@yourcompany.com",
      "role": "manager"
    }
  }
}
```

### Step 2: Use the Access Token

```bash
curl -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
     https://api.greenreporter.eu/v1/reports
```

### Step 3: Refresh When Expired

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }' \
  https://api.greenreporter.eu/v1/auth/refresh
```

## 🛡️ Security Best Practices

### ✅ Do's
- Use HTTPS only (never HTTP)
- Store credentials in environment variables
- Rotate API keys regularly
- Use different keys for different environments
- Implement proper error handling

### ❌ Don'ts
- Never commit credentials to version control
- Don't share API keys in emails or chat
- Don't use production keys in development
- Don't ignore authentication errors

## 👥 User Roles & Permissions

| Role | Permissions | Use Case |
|------|-------------|----------|
| **Admin** | Full access to all endpoints | System administrators |
| **Manager** | Read/write reports, manage suppliers | Department managers |
| **User** | Create and edit own reports | Regular users |
| **Viewer** | Read-only access | Stakeholders, reviewers |

### Check Your Permissions

```bash
curl -H "X-API-Key: your-api-key-here" \
     https://api.greenreporter.eu/v1/auth/me
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user_id": "u_1234567890abcdef",
    "email": "user@yourcompany.com",
    "role": "manager",
    "permissions": [
      "read:reports",
      "write:reports",
      "export:reports",
      "manage:suppliers"
    ]
  }
}
```

## 🚨 Common Authentication Errors

### 401 Unauthorized
```json
{
  "success": false,
  "status": 401,
  "message": "Authentication required",
  "error": "Missing X-API-Key header"
}
```

**Solution**: Add the authentication header

### 403 Forbidden
```json
{
  "success": false,
  "status": 403,
  "message": "Insufficient permissions",
  "error": "User does not have permission to perform this action"
}
```

**Solution**: Contact your administrator for additional permissions

### 401 Token Expired
```json
{
  "success": false,
  "status": 401,
  "message": "Token expired",
  "error": "JWT token has expired"
}
```

**Solution**: Use the refresh token to get a new access token

## 💻 Code Examples

### Python
```python
import requests
import os

# Using API Key
headers = {
    'X-API-Key': os.getenv('GREENREPORTER_API_KEY'),
    'Content-Type': 'application/json'
}

response = requests.get(
    'https://api.greenreporter.eu/v1/reports',
    headers=headers
)
```

### Node.js
```javascript
const axios = require('axios');

// Using API Key
const client = axios.create({
  baseURL: 'https://api.greenreporter.eu/v1',
  headers: {
    'X-API-Key': process.env.GREENREPORTER_API_KEY,
    'Content-Type': 'application/json'
  }
});

const reports = await client.get('/reports');
```

### Java
```java
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

HttpClient client = HttpClient.newHttpClient();
HttpRequest request = HttpRequest.newBuilder()
    .uri(URI.create("https://api.greenreporter.eu/v1/reports"))
    .header("X-API-Key", System.getenv("GREENREPORTER_API_KEY"))
    .header("Content-Type", "application/json")
    .build();

HttpResponse<String> response = client.send(request, 
    HttpResponse.BodyHandlers.ofString());
```

## 🆘 Need Help?

- **Token issues**: [JWT Troubleshooting](troubleshooting.md#jwt-issues)
- **Permission errors**: Contact your administrator
- **API support**: [api-support@greenreporter.eu](mailto:api-support@greenreporter.eu)

---

**Next**: [Make your first API call →](quick-start.md#step-2)
