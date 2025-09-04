# GreenReporter API Documentation

Welcome to the comprehensive API documentation for GreenReporter.eu, the leading sustainability reporting platform for EU compliance. Our API enables seamless integration with your existing systems to automate sustainability data collection, reporting, and analytics.

## 🚀 Quick Start

### New to the API?
Start here for a guided introduction:

1. **[Quick Start Guide](quick-start.md)** - Get up and running in 5 minutes
2. **[Authentication Guide](authentication.md)** - Learn how to securely connect
3. **[API Reference](api-reference.md)** - Complete endpoint documentation

### What You Can Build

- **Automated Reporting Systems** - Collect and submit sustainability data
- **Data Analytics Dashboards** - Visualize environmental and social metrics  
- **Supplier Management Portals** - Streamline supplier data collection
- **Compliance Monitoring Tools** - Track regulatory requirements
- **Integration Workflows** - Connect with existing business systems

## 📚 Documentation Overview

### Core Documentation
| Guide | Description | Time to Read |
|-------|-------------|---------------|
| [Quick Start](quick-start.md) | Your first API call in 5 minutes | 5 min |
| [Authentication](authentication.md) | API keys, JWT tokens, and security | 10 min |
| [API Reference](api-reference.md) | Complete endpoint documentation | 30 min |

### Integration Guides  
| Guide | Description | Best For |
|-------|-------------|----------|
| [SDK Integration](sdk-integration.md) | Official SDKs for Python, Node.js, Java | Developers |
| [Webhook Integration](webhook-integration.md) | Real-time event notifications | Automated workflows |
| [Troubleshooting](troubleshooting.md) | Common issues and solutions | Support |

## 🎯 Quick Examples

### Create Your First Report
```bash
curl -X POST \
  -H "X-API-Key: your-api-key" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Q4 2024 Sustainability Report",
    "report_type": "comprehensive",
    "reporting_period": "2024"
  }' \
  https://api.greenreporter.eu/v1/reports
```

### Get Analytics Data
```bash
curl -H "X-API-Key: your-api-key" \
  "https://api.greenreporter.eu/v1/analytics/metrics?category=environmental&date_from=2024-01-01"
```

### Set Up Webhooks
```bash
curl -X POST \
  -H "X-API-Key: your-api-key" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://your-app.com/webhooks",
    "events": ["report.created", "report.submitted"]
  }' \
  https://api.greenreporter.eu/v1/webhooks
```

## 🐍 Python SDK Example

```python
from greenreporter_api import GreenReporterClient

# Initialize client
client = GreenReporterClient(
    base_url="https://api.greenreporter.eu/v1",
    api_key="your-api-key-here"
)

# Create a report
report = client.reports.create({
    "name": "My Sustainability Report",
    "report_type": "comprehensive",
    "reporting_period": "2024"
})

# Add metrics
client.reports.update(report.data.id, {
    "metrics": {
        "carbon_emissions": 1250.5,
        "energy_consumption": 5000.0,
        "waste_generated": 250.0
    }
})

# Get analytics
metrics = client.analytics.get_metrics(
    category=["environmental"],
    date_from="2024-01-01"
)
```

## 🟢 Node.js SDK Example

```javascript
const { GreenReporterClient } = require('@greenreporter/api-client');

const client = new GreenReporterClient({
  baseUrl: 'https://api.greenreporter.eu/v1',
  apiKey: 'your-api-key-here'
});

// Create and update a report
const report = await client.reports.create({
  name: 'My Sustainability Report',
  reportType: 'comprehensive',
  reportingPeriod: '2024'
});

await client.reports.update(report.data.id, {
  metrics: {
    carbon_emissions: 1250.5,
    energy_consumption: 5000.0,
    waste_generated: 250.0
  }
});

// Get analytics
const metrics = await client.analytics.getMetrics({
  category: ['environmental'],
  dateFrom: '2024-01-01'
});
```

## 🔑 Key Features

### 📊 Comprehensive Reporting
- **Multiple Report Types** - Basic and comprehensive sustainability reports
- **Version Management** - Track changes and maintain audit trails  
- **Export Options** - PDF, XBRL, JSON, CSV, and Excel formats
- **Compliance Support** - EU CSRD and other regulatory frameworks

### 📈 Advanced Analytics
- **Real-time Metrics** - Track key sustainability indicators
- **Trend Analysis** - Historical data analysis and forecasting
- **Benchmarking** - Compare against industry standards
- **Custom Dashboards** - Build tailored analytics views

### 🏢 Supplier Management
- **Data Collection** - Streamlined supplier data gathering
- **Validation** - Automated data quality checks
- **Collaboration** - Multi-party data sharing workflows
- **Compliance Tracking** - Monitor supplier compliance status

### 🔔 Real-time Integration
- **Webhooks** - Instant event notifications
- **REST API** - Standard HTTP-based integration
- **SDKs** - Official libraries for major programming languages
- **Zapier Integration** - No-code workflow automation

## 📋 API Overview

### Base URL
```
https://api.greenreporter.eu/v1
```

### Core Endpoints

| Endpoint | Description | Example |
|----------|-------------|---------|
| `GET /reports` | List sustainability reports | [View docs](api-reference.md#list-reports) |
| `POST /reports` | Create new report | [View docs](api-reference.md#create-report) |
| `GET /analytics/metrics` | Get sustainability metrics | [View docs](api-reference.md#get-metrics) |
| `GET /suppliers` | List suppliers | [View docs](api-reference.md#list-suppliers) |
| `POST /webhooks` | Create webhook | [View docs](webhook-integration.md) |

### Authentication
- **API Key**: `X-API-Key: gr_live_1234567890abcdef`
- **JWT Token**: `Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

## 🚦 Rate Limits

| Authentication Type | Requests/Minute | Requests/Hour |
|--------------------|-----------------|---------------|
| API Key | 100 | 1,000 |
| JWT Token | 100 | 1,000 |
| Public Endpoints | 200 | 2,000 |

## 📖 Use Cases

### 🏭 Manufacturing Company
"Collect sustainability data from 200+ suppliers and generate EU CSRD compliance reports"

**Implementation:**
- Use [Supplier API](api-reference.md#suppliers) for data collection
- Set up [webhooks](webhook-integration.md) for real-time updates
- Generate automated reports with [Export API](api-reference.md#export-report)

### 🌱 Consulting Firm  
"Manage sustainability reporting for multiple client companies"

**Implementation:**
- Multi-tenant setup with separate API keys
- [Python SDK](sdk-integration.md#python-sdk) for data processing
- Custom dashboards using [Analytics API](api-reference.md#analytics)

### 🏢 Enterprise Integration
"Integrate sustainability data into existing ERP systems"

**Implementation:**
- [REST API](api-reference.md) integration
- [Webhook notifications](webhook-integration.md) for data synchronization  
- Automated reporting workflows

## 🛠️ Development Tools

### SDKs & Libraries
- **Python**: `pip install greenreporter-api-client`
- **Node.js**: `npm install @greenreporter/api-client`
- **Java**: Available via Maven Central
- **Other Languages**: Auto-generated via OpenAPI

### Testing Tools
- **Postman Collection**: [Download here](https://docs.greenreporter.eu/postman)
- **OpenAPI Spec**: [View specification](openapi-spec.md)
- **Sandbox Environment**: Test without affecting production data

### Developer Resources
- **GitHub Examples**: [Code samples repository](https://github.com/greenreporter/api-examples)
- **Status Page**: [System status and uptime](https://status.greenreporter.eu)
- **Changelog**: [API updates and changes](https://docs.greenreporter.eu/changelog)

## 🚨 Common Issues & Solutions

### Authentication Problems
- **401 Unauthorized**: Check your API key format and permissions
- **403 Forbidden**: Contact administrator for access rights
- **Token Expired**: Use refresh token to get new access token

### Data Validation Issues
- **400 Bad Request**: Review required fields and data formats
- **422 Unprocessable**: Check business rules and constraints
- **413 Payload Too Large**: Reduce file size or split requests

### Rate Limiting
- **429 Too Many Requests**: Implement exponential backoff
- Check `X-RateLimit-Remaining` header for current status
- Use webhooks instead of polling for real-time updates

**See the [Troubleshooting Guide](troubleshooting.md) for detailed solutions.**

## 📞 Support & Community

### Getting Help
- **Documentation**: Browse these guides for detailed information
- **GitHub Issues**: [Report bugs and request features](https://github.com/greenreporter/api-docs/issues)
- **API Support**: [api-support@greenreporter.eu](mailto:api-support@greenreporter.eu)
- **Sales Inquiries**: [sales@greenreporter.eu](mailto:sales@greenreporter.eu)

### Response Times
- **Critical Issues**: 2 hours
- **High Priority**: 4 hours
- **Medium Priority**: 1 business day
- **Enhancement Requests**: 3 business days

### Community Resources
- **Developer Forum**: Share ideas and get help from other developers
- **Newsletter**: Monthly updates on API features and best practices
- **Webinars**: Regular training sessions and Q&A

## 📊 API Statistics

- **99.9% Uptime** - Reliable service you can depend on
- **<100ms Response Time** - Fast API responses globally
- **50+ Integrations** - Popular tools and platforms supported
- **10,000+ Developers** - Active developer community

## 🗺️ Roadmap

### Coming Soon
- **GraphQL API** - Alternative query interface
- **Real-time Analytics** - Live dashboards and streaming data
- **Mobile SDKs** - iOS and Android native libraries
- **Enhanced Filtering** - Advanced search and filtering options

### Planned Features
- **AI-Powered Insights** - Automated recommendations and alerts
- **Blockchain Integration** - Immutable audit trails
- **Advanced Visualizations** - Interactive charts and reports
- **Multi-language Support** - Localized documentation and UIs

---

## 🎯 Next Steps

1. **[Get your API credentials →](authentication.md)**
2. **[Make your first API call →](quick-start.md)**  
3. **[Explore SDK options →](sdk-integration.md)**
4. **[Set up webhooks →](webhook-integration.md)**
5. **[Join our community →](https://community.greenreporter.eu)**

**Ready to build something amazing? Let's get started!** 🚀
