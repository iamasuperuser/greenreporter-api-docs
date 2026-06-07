# Pagination & Filtering

Efficiently navigate large datasets using pagination, filtering, and sorting.

## 📄 Pagination Strategies

The GreenReporter API supports two pagination strategies for all list endpoints.

### Offset-Based Pagination (Default)

Best for: page navigation, known page counts, UI pagination controls.

**Parameters:**

| Parameter | Type | Default | Max | Description |
|-----------|------|---------|-----|-------------|
| `page` | integer | 1 | — | Page number (1-based) |
| `page_size` | integer | 20 | 100 | Items per page |

**Request:**

```bash
curl -H "X-API-Key: your-api-key" \
  "https://api.greenreporter.eu/v1/reports?page=2&page_size=20"
```

**Response:**

```json
{
  "success": true,
  "data": [...],
  "meta": {
    "pagination": {
      "page": 2,
      "page_size": 20,
      "total_items": 150,
      "total_pages": 8,
      "has_next": true,
      "has_previous": true,
      "next_page": 3,
      "previous_page": 1,
      "first_page": 1,
      "last_page": 8,
      "items_on_page": 20,
      "items_per_page_options": [10, 20, 50, 100]
    }
  }
}
```

### Cursor-Based Pagination

Best for: real-time data, infinite scroll, large datasets where offset performance degrades.

**Parameters:**

| Parameter | Type | Default | Max | Description |
|-----------|------|---------|-----|-------------|
| `cursor` | string | — | — | Base64-encoded cursor from previous response |
| `limit` | integer | 20 | 100 | Items per page |

**First request** (no cursor needed):

```bash
curl -H "X-API-Key: your-api-key" \
  "https://api.greenreporter.eu/v1/reports?limit=20"
```

**Subsequent requests:**

```bash
curl -H "X-API-Key: your-api-key" \
  "https://api.greenreporter.eu/v1/reports?cursor=eyJpZC...aIn0=&limit=20"
```

**Response:**

```json
{
  "success": true,
  "data": [...],
  "meta": {
    "pagination": {
      "cursor": "eyJpZC...aIn0=",
      "next_cursor": "eyJpZC...bGn1=",
      "previous_cursor": null,
      "limit": 20,
      "has_next": true,
      "has_previous": false,
      "total_items": 150
    }
  }
}
```

!!! note
    You cannot mix `page`/`page_size` with `cursor`/`limit`. Choose one strategy per request.

## 🔍 Filtering

### Common Filter Parameters

All list endpoints support these filters:

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `search` | string | Full-text search across relevant fields | `?search=sustainability` |
| `date_from` | date | Include items from this date (YYYY-MM-DD) | `?date_from=2024-01-01` |
| `date_to` | date | Include items up to this date (YYYY-MM-DD) | `?date_to=2024-12-31` |
| `status` | string | Filter by resource status | `?status=draft` |
| `created_by` | string | Filter by creator user ID | `?created_by=u_123...` |
| `tags` | string | Comma-separated tag filter | `?tags=VSME,environmental` |

### Endpoint-Specific Filters

#### Reports

| Parameter | Type | Values | Description |
|-----------|------|--------|-------------|
| `report_type` | string | `comprehensive`, `simplified`, `vsme` | Filter by report type |
| `reporting_period` | string | `2024`, `2023` | Filter by period |

#### Analytics / Metrics

| Parameter | Type | Values | Description |
|-----------|------|--------|-------------|
| `category` | string | `environmental`, `social`, `governance` | ESG category |
| `report_id` | string | Any report ID | Filter to specific report |

#### Suppliers

| Parameter | Type | Values | Description |
|-----------|------|--------|-------------|
| `industry` | string | Any industry name | Industry sector |
| `region` | string | Any region name | Geographic region |
| `sustainability_score_min` | number | 0–100 | Minimum sustainability score |

### Combined Filters

Filters can be combined. All filters are AND logic:

```bash
curl -H "X-API-Key: your-api-key" \
  "https://api.greenreporter.eu/v1/reports?status=draft&date_from=2024-01-01&report_type=comprehensive&search=Q4&page=1&page_size=20"
```

## ↕️ Sorting

### Sort Parameters

| Parameter | Type | Values | Default |
|-----------|------|--------|---------|
| `sort_by` | string | Field name | `created_at` |
| `sort_order` | string | `asc`, `desc` | `desc` |

### Sortable Fields by Endpoint

| Endpoint | Sortable Fields |
|----------|----------------|
| `/reports` | `created_at`, `updated_at`, `name`, `status`, `reporting_period` |
| `/analytics/metrics` | `created_at`, `value`, `name`, `category` |
| `/suppliers` | `created_at`, `name`, `industry`, `sustainability_score` |

### Sort Examples

```bash
# Newest first
curl "https://api.greenreporter.eu/v1/reports?sort_by=created_at&sort_order=desc"

# Alphabetical
curl "https://api.greenreporter.eu/v1/reports?sort_by=name&sort_order=asc"

# Highest emissions first
curl "https://api.greenreporter.eu/v1/analytics/metrics?sort_by=value&sort_order=desc"
```

## 📊 Field Selection

Reduce response size by selecting only the fields you need:

```bash
# Return only name and status
curl "https://api.greenreporter.eu/v1/reports?fields=name,status"
```

## Performance Tips

1. **Use cursor pagination for large datasets** — offset-based pagination slows down on high page numbers
2. **Limit page_size** — smaller pages (10-20 items) are faster and reduce bandwidth
3. **Filter early** — use server-side filters instead of fetching all data and filtering client-side
4. **Use field selection** — request only the fields you need
5. **Cache paginated results** — for data that rarely changes

---

**Next**: [Troubleshooting →](troubleshooting.md)
