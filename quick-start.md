# Quick Start Guide

Get up and running with the GreenReporter API in under 5 minutes.

## 🎯 What You'll Build

By the end of this guide, you'll have:
- ✅ Made your first API call
- ✅ Created a sustainability report
- ✅ Retrieved analytics data
- ✅ Set up webhook notifications

## 📋 Prerequisites

- API credentials (contact your administrator)
- Basic knowledge of REST APIs
- Optional: Postman for testing

## 🚀 Step 1: Authentication

### Get Your API Key

Contact your system administrator to obtain your API key. It will look like:
```
gr_live_1234567890abcdef
```

### Test Your Connection

```bash
curl -H "X-API-Key: your-api-key-here" \
     https://api.greenreporter.eu/v1/health
```

**Expected Response:**
```json
{
  "success": true,
  "status": "healthy",
  "timestamp": "2024-01-15T10:30:00Z"
}
```

## 📊 Step 2: Create Your First Report

```bash
curl -X POST \
  -H "X-API-Key: your-api-key-here" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "My First Sustainability Report",
    "report_type": "comprehensive",
    "reporting_period": "2024",
    "description": "Getting started with the GreenReporter API"
  }' \
  https://api.greenreporter.eu/v1/reports
```

**Expected Response:**
```json
{
  "success": true,
  "data": {
    "id": "r_1234567890abcdef",
    "name": "My First Sustainability Report",
    "status": "draft",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

💡 **Save the `id` from the response - you'll need it for the next steps!**

## 📈 Step 3: Add Some Data

Add sustainability metrics to your report:

```bash
curl -X PUT \
  -H "X-API-Key: your-api-key-here" \
  -H "Content-Type: application/json" \
  -d '{
    "metrics": {
      "energy_consumption": 2500.5,
      "carbon_emissions": 150.0,
      "waste_generated": 75.2
    }
  }' \
  https://api.greenreporter.eu/v1/reports/r_1234567890abcdef
```

## 📋 Step 4: Retrieve Analytics

Get insights from your data:

```bash
curl -H "X-API-Key: your-api-key-here" \
     https://api.greenreporter.eu/v1/analytics/metrics?report_id=r_1234567890abcdef
```

## 🔔 Step 5: Set Up Webhooks (Optional)

Get notified when reports are updated:

```bash
curl -X POST \
  -H "X-API-Key: your-api-key-here" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://your-app.com/webhooks",
    "events": ["report.created", "report.submitted"]
  }' \
  https://api.greenreporter.eu/v1/webhooks
```

## 🎉 Next Steps

Great job! You've successfully:
- ✅ Connected to the GreenReporter API
- ✅ Created your first report
- ✅ Added sustainability data
- ✅ Retrieved analytics

### What's Next?

1. **[Explore the Python SDK](sdk-integration.md#python-sdk)** - For easier integration
2. **[Learn about Filtering](api-reference.md#filtering)** - Find specific data
3. **[Set up Supplier Data Collection](supplier-integration.md)** - Automate data gathering
4. **[Configure Advanced Webhooks](webhook-integration.md)** - Real-time notifications

## 🆘 Need Help?

- **Common Issues**: [Troubleshooting Guide](troubleshooting.md)
- **API Reference**: [Complete API Documentation](api-reference.md)
- **Support**: [api-support@greenreporter.eu](mailto:api-support@greenreporter.eu)

---

**Estimated Time**: 5 minutes  
**Difficulty**: Beginner  
**Prerequisites**: API credentials
