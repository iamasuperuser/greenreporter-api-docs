# API Reference

Complete reference for all GreenReporter API endpoints.

## 🚀 Base URL

```
https://api.greenreporter.eu/v1
```

## 📊 Reports

### List Reports

Get all sustainability reports with optional filtering.

```http
GET /reports
```

**Parameters:**
- `page` (integer): Page number (default: 1)
- `page_size` (integer): Items per page (default: 20, max: 100)
- `search` (string): Search in report names
- `status` (string): Filter by status (`draft`, `submitted`, `approved`)
- `date_from` (date): Filter from date (YYYY-MM-DD)
- `date_to` (date): Filter to date (YYYY-MM-DD)

**Example:**
```bash
curl -H "X-API-Key: your-api-key" \
  "https://api.greenreporter.eu/v1/reports?page=1&page_size=20&status=draft"
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "r_1234567890abcdef",
      "name": "Q4 2024 Sustainability Report",
      "status": "draft",
      "report_type": "comprehensive",
      "reporting_period": "2024",
      "created_at": "2024-01-15T10:30:00Z",
      "updated_at": "2024-01-15T10:30:00Z"
    }
  ],
  "meta": {
    "pagination": {
      "page": 1,
      "page_size": 20,
      "total_items": 50,
      "total_pages": 3,
      "has_next": true,
      "has_previous": false
    }
  }
}
```

### Create Report

Create a new sustainability report.

```http
POST /reports
```

**Request Body:**
```json
{
  "name": "Q4 2024 Sustainability Report",
  "report_type": "comprehensive",
  "reporting_period": "2024",
  "description": "Quarterly sustainability report"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "r_1234567890abcdef",
    "name": "Q4 2024 Sustainability Report",
    "status": "draft",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

### Get Report

Retrieve a specific report by ID.

```http
GET /reports/{reportId}
```

**Example:**
```bash
curl -H "X-API-Key: your-api-key" \
  https://api.greenreporter.eu/v1/reports/r_1234567890abcdef
```

### Update Report

Update an existing report.

```http
PUT /reports/{reportId}
```

**Request Body:**
```json
{
  "name": "Updated Report Name",
  "description": "Updated description",
  "metrics": {
    "energy_consumption": 2500.5,
    "carbon_emissions": 150.0,
    "waste_generated": 75.2
  }
}
```

### Export Report

Export a report in various formats.

```http
GET /reports/{reportId}/export/{format}
```

**Formats:** `pdf`, `xbrl`, `json`, `csv`, `xlsx`

**Example:**
```bash
curl -H "X-API-Key: your-api-key" \
  https://api.greenreporter.eu/v1/reports/r_1234567890abcdef/export/pdf \
  --output report.pdf
```

## 📈 Analytics

### Get Metrics

Retrieve sustainability metrics with filtering.

```http
GET /analytics/metrics
```

**Parameters:**
- `category` (string): Filter by category (`environmental`, `social`, `governance`)
- `report_id` (string): Filter by specific report
- `date_from` (date): Start date
- `date_to` (date): End date

**Example:**
```bash
curl -H "X-API-Key: your-api-key" \
  "https://api.greenreporter.eu/v1/analytics/metrics?category=environmental&date_from=2024-01-01"
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "m_1234567890abcdef",
      "name": "Carbon Emissions",
      "value": 1250.5,
      "unit": "tCO2e",
      "category": "environmental",
      "report_id": "r_1234567890abcdef",
      "created_at": "2024-01-15T10:30:00Z"
    }
  ]
}
```

### Get Trends

Analyze metric trends over time.

```http
GET /analytics/trends
```

**Parameters:**
- `metric_ids` (array): List of metric IDs
- `period` (string): Aggregation period (`daily`, `weekly`, `monthly`)
- `start_date` (date): Analysis start date
- `end_date` (date): Analysis end date

## 🏢 Suppliers

### List Suppliers

Get all suppliers with filtering options.

```http
GET /suppliers
```

**Parameters:**
- `industry` (string): Filter by industry
- `region` (string): Filter by region
- `sustainability_score_min` (number): Minimum score
- `status` (string): Filter by status

**Example:**
```bash
curl -H "X-API-Key: your-api-key" \
  "https://api.greenreporter.eu/v1/suppliers?industry=Manufacturing&sustainability_score_min=80"
```

### Add Supplier

Add a new supplier to your network.

```http
POST /suppliers
```

**Request Body:**
```json
{
  "name": "Green Energy Solutions",
  "industry": "Energy",
  "region": "Europe",
  "contact_email": "contact@greenenergy.com"
}
```

### Submit Supplier Data

Submit sustainability data for a supplier.

```http
POST /suppliers/{supplierId}/data
```

**Request Body:**
```json
{
  "reporting_period": "2024",
  "metrics": {
    "carbon_emissions": 500.0,
    "energy_consumption": 1200.0,
    "waste_recycled_percentage": 85.5
  }
}
```

## 🔔 Webhooks

### Create Webhook

Set up notifications for specific events.

```http
POST /webhooks
```

**Request Body:**
```json
{
  "url": "https://your-app.com/webhooks/sustainability",
  "events": [
    "report.created",
    "report.submitted",
    "supplier.data.received"
  ],
  "authentication": {
    "type": "hmac",
    "secret": "your-webhook-secret"
  }
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "webhook_1234567890abcdef",
    "url": "https://your-app.com/webhooks/sustainability",
    "events": ["report.created", "report.submitted"],
    "status": "active",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

### Webhook Events

Common webhook events you can subscribe to:

| Event | Description |
|-------|-------------|
| `report.created` | New report created |
| `report.updated` | Report data updated |
| `report.submitted` | Report submitted for review |
| `report.approved` | Report approved |
| `supplier.data.received` | Supplier submitted data |
| `user.registered` | New user registered |

**Example Event Payload:**
```json
{
  "event_type": "report.created",
  "event_id": "evt_1234567890abcdef",
  "timestamp": "2024-01-15T10:30:00Z",
  "data": {
    "report": {
      "id": "r_1234567890abcdef",
      "name": "Q4 2024 Sustainability Report",
      "status": "draft",
      "created_by": "u_1234567890abcdef"
    }
  }
}
```

## 🚨 Error Handling

### Common Error Codes

| Code | Description | Solution |
|------|-------------|----------|
| `400` | Bad Request | Check request format and required fields |
| `401` | Unauthorized | Verify API key or login credentials |
| `403` | Forbidden | Contact administrator for permissions |
| `404` | Not Found | Check resource ID exists |
| `429` | Rate Limited | Wait and retry with exponential backoff |
| `500` | Server Error | Try again later or contact support |

### Error Response Format

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
    "request_id": "req_1234567890abcdef"
  }
}
```

## 📊 Rate Limits

| Authentication | Requests/Minute | Requests/Hour |
|----------------|-----------------|---------------|
| API Key | 100 | 1,000 |
| JWT Token | 100 | 1,000 |
| Public Endpoints | 200 | 2,000 |

**Rate limit headers in responses:**
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1642224000
```

## 📝 Filtering & Pagination

### Pagination Parameters

All list endpoints support pagination:

- `page`: Page number (starts at 1)
- `page_size`: Items per page (max 100)
- `cursor`: For cursor-based pagination

### Filtering Parameters

Common filters across endpoints:

- `search`: Text search
- `date_from` / `date_to`: Date range
- `status`: Resource status
- `created_by`: Filter by creator
- `tags`: Filter by tags

### Sorting Parameters

- `sort_by`: Field to sort by
- `sort_order`: `asc` or `desc`

**Example:**
```bash
curl -H "X-API-Key: your-api-key" \
  "https://api.greenreporter.eu/v1/reports?page=1&page_size=50&search=Q4&sort_by=created_at&sort_order=desc"
```

## 🔍 Advanced Features

### Bulk Operations

Some endpoints support bulk operations:

```http
POST /reports/bulk
```

```json
{
  "reports": [
    {"name": "Report 1", "report_type": "comprehensive"},
    {"name": "Report 2", "report_type": "simplified"}
  ]
}
```

### Data Export

Export data in multiple formats:

- **PDF**: Human-readable reports
- **XBRL**: Regulatory compliance format
- **JSON**: API-compatible format
- **CSV**: Spreadsheet compatible
- **XLSX**: Excel format

---

**Need Help?**
- [SDK Documentation](sdk-integration.md) for easier integration
- [Troubleshooting Guide](troubleshooting.md) for common issues
- [Support](mailto:api-support@greenreporter.eu) for direct assistance
