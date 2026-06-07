# Webhook Integration

Receive real-time notifications when events occur in your GreenReporter account.

## 🔔 Overview

Webhooks let you subscribe to specific events and receive HTTP POST requests at a URL you control whenever those events occur. This enables real-time integrations without polling.

## Setup

### Create a Webhook

```http
POST /webhooks
```

```bash
curl -X POST \
  -H "X-API-Key: your-api-key" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://your-app.com/webhooks/greenreporter",
    "events": [
      "report.created",
      "report.submitted",
      "supplier.data.received"
    ],
    "authentication": {
      "type": "hmac",
      "secret": "your-webhook-secret"
    }
  }' \
  https://api.greenreporter.eu/v1/webhooks
```

**Response:**

```json
{
  "success": true,
  "data": {
    "id": "webhook_1234567890abcdef",
    "url": "https://your-app.com/webhooks/greenreporter",
    "events": ["report.created", "report.submitted", "supplier.data.received"],
    "authentication": { "type": "hmac" },
    "status": "active",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

### List Webhooks

```http
GET /webhooks
```

### Update a Webhook

```http
PUT /webhooks/{webhookId}
```

```json
{
  "events": ["report.created", "report.approved"],
  "status": "active"
}
```

### Delete a Webhook

```http
DELETE /webhooks/{webhookId}
```

## Available Events

| Event | Trigger | Payload |
|-------|---------|---------|
| `report.created` | New report is created | Report object |
| `report.updated` | Report data is modified | Report object + changed fields |
| `report.submitted` | Report submitted for review | Report object |
| `report.approved` | Report passes review | Report object + reviewer |
| `report.rejected` | Report fails review | Report object + rejection reason |
| `supplier.data.received` | Supplier submits sustainability data | Supplier + metrics |
| `supplier.created` | New supplier added to network | Supplier object |
| `user.registered` | New user joins the platform | User object |
| `export.completed` | Report export finishes processing | Export URL + format |

## Event Payload

All webhook events follow a consistent envelope format:

```json
{
  "event_type": "report.created",
  "event_id": "evt_1234567890abcdef",
  "timestamp": "2024-01-15T10:30:00Z",
  "api_version": "v1",
  "data": {
    "report": {
      "id": "r_1234567890abcdef",
      "name": "Q4 2024 Sustainability Report",
      "status": "draft",
      "report_type": "comprehensive",
      "reporting_period": "2024",
      "created_by": "u_1234567890abcdef",
      "created_at": "2024-01-15T10:30:00Z"
    }
  }
}
```

## Security

### HMAC Signature Verification

Every webhook delivery includes an `X-GreenReporter-Signature-256` header containing an HMAC-SHA256 signature. Always verify this before processing events.

**1. Compute the signature:**

```python
import hmac, hashlib

def verify_signature(payload_body: bytes, signature_header: str, secret: str) -> bool:
    """Verify the webhook HMAC signature."""
    expected = hmac.new(
        secret.encode('utf-8'),
        payload_body,
        hashlib.sha256
    ).hexdigest()
    return hmac.compare_digest(f"sha256={expected}", signature_header)
```

```javascript
const crypto = require('crypto');

function verifySignature(payload, signatureHeader, secret) {
  const expected = crypto
    .createHmac('sha256', secret)
    .update(payload)
    .digest('hex');
  return crypto.timingSafeEqual(
    Buffer.from(`sha256=${expected}`),
    Buffer.from(signatureHeader)
  );
}
```

**2. Use the raw request body** — do not parse JSON before verifying, as formatting differences can alter the signature.

### HTTPS Required

Webhook URLs must use HTTPS with a valid TLS certificate. Self-signed certificates are not accepted.

## Delivery Behaviour

### Retry Schedule

If your endpoint returns a non-2xx status or times out, GreenReporter retries:

| Attempt | Delay |
|---------|-------|
| 1st retry | 1 minute |
| 2nd retry | 5 minutes |
| 3rd retry | 15 minutes |
| 4th retry | 1 hour |
| 5th retry | 6 hours |

After 5 failed attempts, the webhook is marked `failing` and delivery stops. Fix your endpoint and update the webhook status to `active` to resume.

### Timeout

Your endpoint must respond with a 2xx status within **30 seconds**. Responses after this window are treated as failures.

### Delivery Headers

```http
POST /your-webhook-url HTTP/1.1
Content-Type: application/json
X-GreenReporter-Event: report.created
X-GreenReporter-Delivery: evt_1234567890abcdef
X-GreenReporter-Signature-256: sha256=abcdef1234567890...
X-GreenReporter-API-Version: v1
```

### Idempotency

Each event has a unique `event_id`. Your endpoint should be idempotent — processing the same `event_id` twice should produce the same result. Use `event_id` to deduplicate.

## Example: Express.js Endpoint

```javascript
const express = require('express');
const crypto = require('crypto');

const app = express();
const WEBHOOK_SECRET = process.env.GREENREPORTER_WEBHOOK_SECRET;

// Raw body parser (needed for signature verification)
app.use('/webhooks', express.raw({ type: 'application/json' }));

app.post('/webhooks/greenreporter', (req, res) => {
  const signature = req.headers['x-greenreporter-signature-256'];
  const payload = req.body;

  // Verify signature
  const expected = crypto
    .createHmac('sha256', WEBHOOK_SECRET)
    .update(payload)
    .digest('hex');

  if (!crypto.timingSafeEqual(
    Buffer.from(`sha256=${expected}`),
    Buffer.from(signature)
  )) {
    return res.status(401).send('Invalid signature');
  }

  const event = JSON.parse(payload);
  console.log(`Received: ${event.event_type} (${event.event_id})`);

  switch (event.event_type) {
    case 'report.created':
      handleReportCreated(event.data.report);
      break;
    case 'report.submitted':
      handleReportSubmitted(event.data.report);
      break;
    default:
      console.log(`Unhandled event: ${event.event_type}`);
  }

  res.status(200).send('OK');
});

app.listen(3000);
```

## Rate Limits

Webhook management endpoints are rate-limited to **20 requests/minute**. See [Rate Limiting](rate-limiting.md) for details.

---

**Next**: [Rate Limiting →](rate-limiting.md)
