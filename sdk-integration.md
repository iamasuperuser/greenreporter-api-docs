# SDK Integration Guides

Official client libraries and SDKs for integrating with the GreenReporter API.

## 📦 Available SDKs

| Language | Package | Install |
|----------|---------|---------|
| **JavaScript / TypeScript** | `@greenreporter/sdk` | `npm install @greenreporter/sdk` |
| **Python** | `greenreporter` | `pip install greenreporter` |

## JavaScript / TypeScript SDK

### Installation

```bash
npm install @greenreporter/sdk
# or
yarn add @greenreporter/sdk
```

### Quick Start

```javascript
import { GreenReporter } from '@greenreporter/sdk';

const client = new GreenReporter({
  apiKey: process.env.GREENREPORTER_API_KEY,
  // or for user-facing apps:
  // baseUrl: 'https://api.greenreporter.eu/v1',
});
```

### Reports

```javascript
// List reports with pagination
const reports = await client.reports.list({
  page: 1,
  page_size: 20,
  status: 'draft',
  sort_by: 'created_at',
  sort_order: 'desc'
});

// Create a new report
const report = await client.reports.create({
  name: 'Q4 2024 Sustainability Report',
  report_type: 'comprehensive',
  reporting_period: '2024',
  description: 'Quarterly sustainability report'
});

// Get a specific report
const report = await client.reports.get('r_1234567890abcdef');

// Update a report
await client.reports.update('r_1234567890abcdef', {
  name: 'Updated Report Name',
  metrics: {
    energy_consumption: 2500.5,
    carbon_emissions: 150.0,
    waste_generated: 75.2
  }
});

// Export report
const pdfBlob = await client.reports.export('r_1234567890abcdef', 'pdf');
```

### Analytics

```javascript
// Get metrics
const metrics = await client.analytics.metrics({
  category: 'environmental',
  date_from: '2024-01-01',
  date_to: '2024-12-31'
});

// Get trends
const trends = await client.analytics.trends({
  metric_ids: ['m_1234567890abcdef'],
  period: 'monthly',
  start_date: '2024-01-01',
  end_date: '2024-12-31'
});
```

### Suppliers

```javascript
// List suppliers
const suppliers = await client.suppliers.list({
  industry: 'Manufacturing',
  sustainability_score_min: 80
});

// Add supplier
const supplier = await client.suppliers.create({
  name: 'Green Energy Solutions',
  industry: 'Energy',
  region: 'Europe',
  contact_email: 'contact@greenenergy.com'
});

// Submit supplier data
await client.suppliers.submitData('sup_1234567890abcdef', {
  reporting_period: '2024',
  metrics: {
    carbon_emissions: 500.0,
    energy_consumption: 1200.0
  }
});
```

### Error Handling

```javascript
import { GreenReporterError, ValidationError, AuthenticationError } from '@greenreporter/sdk';

try {
  const report = await client.reports.create({ name: '' });
} catch (error) {
  if (error instanceof ValidationError) {
    console.error('Validation failed:', error.fieldErrors);
  } else if (error instanceof AuthenticationError) {
    console.error('Auth failed:', error.message);
  } else if (error instanceof GreenReporterError) {
    console.error(`API Error ${error.status}: ${error.message}`);
    if (error.retryAfter) {
      console.log(`Retry after ${error.retryAfter} seconds`);
    }
  }
}
```

### TypeScript Types

The SDK ships with full TypeScript definitions:

```typescript
import type {
  Report,
  ReportStatus,
  ReportType,
  Metric,
  Supplier,
  PaginatedResponse,
  ErrorResponse
} from '@greenreporter/sdk';
```

## Python SDK

### Installation

```bash
pip install greenreporter
```

### Quick Start

```python
import greenreporter
import os

# Initialize with API key
client = greenreporter.Client(api_key=os.getenv('GREENREPORTER_API_KEY'))
```

### Reports

```python
# List reports
reports = client.reports.list(
    page=1,
    page_size=20,
    status='draft',
    sort_by='created_at',
    sort_order='desc'
)

# Create a report
report = client.reports.create(
    name='Q4 2024 Sustainability Report',
    report_type='comprehensive',
    reporting_period='2024'
)

# Get a specific report
report = client.reports.get('r_1234567890abcdef')

# Update a report
client.reports.update('r_1234567890abcdef',
    name='Updated Report Name',
    metrics={
        'energy_consumption': 2500.5,
        'carbon_emissions': 150.0
    }
)

# Export report to file
client.reports.export_to_file('r_1234567890abcdef', 'pdf', './report.pdf')
```

### Analytics

```python
# Get metrics
metrics = client.analytics.metrics(
    category='environmental',
    date_from='2024-01-01',
    date_to='2024-12-31'
)

# Get trends
trends = client.analytics.trends(
    metric_ids=['m_1234567890abcdef'],
    period='monthly',
    start_date='2024-01-01',
    end_date='2024-12-31'
)
```

### Error Handling

```python
import greenreporter

try:
    report = client.reports.create(name='')
except greenreporter.ValidationError as e:
    print(f"Validation failed: {e.field_errors}")
except greenreporter.AuthenticationError as e:
    print(f"Auth failed: {e.message}")
except greenreporter.RateLimitError as e:
    print(f"Rate limited. Retry after {e.retry_after} seconds")
except greenreporter.APIError as e:
    print(f"API Error {e.status}: {e.message}")
```

## Direct HTTP Integration

If an SDK is not available for your language, use any HTTP client:

### cURL

```bash
curl -H "X-API-Key: $GREENREPORTER_API_KEY" \
     -H "Content-Type: application/json" \
     https://api.greenreporter.eu/v1/reports
```

### Go

```go
req, _ := http.NewRequest("GET", "https://api.greenreporter.eu/v1/reports", nil)
req.Header.Set("X-API-Key", os.Getenv("GREENREPORTER_API_KEY"))
resp, _ := http.DefaultClient.Do(req)
```

### Java

```java
HttpClient client = HttpClient.newHttpClient();
HttpRequest request = HttpRequest.newBuilder()
    .uri(URI.create("https://api.greenreporter.eu/v1/reports"))
    .header("X-API-Key", System.getenv("GREENREPORTER_API_KEY"))
    .build();
HttpResponse<String> response = client.send(request,
    HttpResponse.BodyHandlers.ofString());
```

### C# / .NET

```csharp
using var client = new HttpClient();
client.DefaultRequestHeaders.Add("X-API-Key",
    Environment.GetEnvironmentVariable("GREENREPORTER_API_KEY"));
var response = await client.GetAsync("https://api.greenreporter.eu/v1/reports");
```

## Webhook Verification (All Languages)

When receiving webhook events, always verify the HMAC signature:

```javascript
// Node.js
const crypto = require('crypto');

function verifyWebhook(payload, signature, secret) {
  const expected = crypto
    .createHmac('sha256', secret)
    .update(payload)
    .digest('hex');
  return crypto.timingSafeEqual(
    Buffer.from(signature),
    Buffer.from(expected)
  );
}
```

```python
# Python
import hmac, hashlib

def verify_webhook(payload: bytes, signature: str, secret: str) -> bool:
    expected = hmac.new(
        secret.encode(), payload, hashlib.sha256
    ).hexdigest()
    return hmac.compare_digest(signature, expected)
```

---

**Next**: [Webhook Integration →](webhook-integration.md)
