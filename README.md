# greenreporter-api-docs
API documentation for GreenReporter.eu
# GreenReporter API Documentation

This repository contains the public-facing API documentation for GreenReporter.eu, the leading sustainability reporting platform for EU compliance.

## 🌐 Live Documentation

- **Documentation**: [https://docs.greenreporter.eu](https://docs.greenreporter.eu)
- **API Base URL**: [https://api.greenreporter.eu/v1](https://api.greenreporter.eu/v1)
- **Status Page**: [https://status.greenreporter.eu](https://status.greenreporter.eu)

## 🚀 Quick Start

### Local Development
```bash
# Install dependencies
pip install -r requirements.txt

# Start local development server
mkdocs serve

# Open browser to http://localhost:8000
```

### Windows PowerShell
```powershell
# Run the deployment script
.\deploy-docs.ps1
```

## 📁 Documentation Structure

```
docs/
├── index.md                    # Main landing page
├── quick-start.md             # 5-minute getting started guide
├── authentication.md          # Authentication documentation
├── api-reference.md           # Complete API reference
├── openapi-spec.md            # OpenAPI specification
├── sdk-integration.md         # Multi-language SDK guides
├── webhook-integration.md     # Webhook integration guide
├── rate-limiting.md           # Rate limiting documentation
├── api-versioning.md          # API versioning guide
├── pagination-filtering.md    # Pagination and filtering guide
├── troubleshooting.md         # Troubleshooting guide
└── error-handling.md          # Error handling documentation
```

## 🛠️ Build Commands

### Development
```bash
# Start development server with auto-reload
mkdocs serve

# Start on specific host and port
mkdocs serve --dev-addr=0.0.0.0:8000
```

### Production
```bash
# Build static site
mkdocs build

# Deploy to GitHub Pages
mkdocs gh-deploy
```

### Validation
```bash
# Validate documentation
mkdocs build --strict

# Check for broken links
mkdocs build --strict --verbose
```

## 🎨 Customization

### Theme Configuration
The documentation uses MkDocs Material theme. Configuration is in `mkdocs.yml`:

```yaml
theme:
  name: material
  palette:
    primary: green
    accent: light green
  features:
    - navigation.tabs
    - navigation.sections
    - search.highlight
    - content.code.copy
```

### Adding New Pages
1. Create a new Markdown file in the `docs/` directory
2. Add the page to the navigation in `mkdocs.yml`
3. Use proper heading structure for table of contents

### Styling
- Custom CSS can be added to `docs/stylesheets/extra.css`
- Material theme variables can be customized in `mkdocs.yml`

## 🚀 Deployment

### GitHub Pages (Automatic)
The documentation automatically deploys to GitHub Pages when changes are pushed to the main branch.

### Manual Deployment
```bash
# Build documentation
mkdocs build

# Deploy to GitHub Pages
mkdocs gh-deploy
```

### Custom Domain
The documentation is configured to use `docs.greenreporter.eu` as the custom domain.

## 📊 Features

### Complete API Coverage
- **Getting Started**: 5-minute quick start guide
- **API Reference**: Complete endpoint documentation
- **SDK Guides**: 10+ programming languages
- **Webhook Integration**: Real-time notifications
- **Advanced Features**: Rate limiting, versioning, pagination
- **Support**: Comprehensive troubleshooting

### Developer Experience
- **Search**: Full-text search across all content
- **Navigation**: Tabbed navigation with sections
- **Code Examples**: Copy-to-clipboard functionality
- **Responsive**: Mobile-friendly design
- **Fast**: Optimized for performance

### Maintenance
- **Auto-deployment**: GitHub Actions workflow
- **Version Control**: Git-based content management
- **Analytics**: Google Analytics integration
- **Monitoring**: Broken link detection

## 🔧 Configuration

### Environment Variables
```bash
# API base URL
export API_BASE_URL=https://api.greenreporter.eu/v1

# Documentation URL
export DOCS_URL=https://docs.greenreporter.eu

# GitHub repository
export GITHUB_REPO=https://github.com/greenreporter/api-docs
```

### Custom Domain
The documentation uses `docs.greenreporter.eu` as the custom domain:

1. CNAME file: `docs.greenreporter.eu`
2. DNS configuration: CNAME record `docs` → `greenreporter.github.io`
3. GitHub Pages settings: Custom domain enabled

## 📱 Responsive Design

### Mobile-First Approach
- Short, scannable sections
- Clear headings and subheadings
- Code examples with proper formatting
- Tables that work on mobile devices

### Progressive Disclosure
- Start with simple concepts
- Add complexity gradually
- Provide both quick examples and detailed explanations
- Include "Next Steps" sections

## 🔍 Maintenance

### Regular Updates
- **Weekly**: Check for broken links
- **Monthly**: Update API examples
- **Quarterly**: Review and update content

### Monitoring
- **Analytics**: Track page views and user engagement
- **Search**: Monitor search queries and results
- **Feedback**: Collect user feedback and suggestions

### Version Control
```bash
# Track changes
git add .
git commit -m "Update API documentation for v1.2.0"
git push origin main
```

## 📞 Support

### Documentation Issues
- **GitHub Issues**: [Report bugs and request features](https://github.com/greenreporter/api-docs/issues)
- **Email**: [docs-support@greenreporter.eu](mailto:docs-support@greenreporter.eu)

### API Support
- **API Questions**: [api-support@greenreporter.eu](mailto:api-support@greenreporter.eu)
- **Technical Issues**: [GitHub Issues](https://github.com/greenreporter/api/issues)

## 📈 Analytics

### Google Analytics
The documentation includes Google Analytics tracking for monitoring usage and user engagement.

### Custom Analytics
You can add custom analytics by modifying the theme or adding JavaScript to the documentation.

## 🎯 Success Metrics

### Developer Experience
- **Time to First API Call**: < 5 minutes
- **Documentation Completeness**: 100% endpoint coverage
- **Code Example Quality**: All examples are copy-paste ready

### Support Reduction
- **Self-Service Resolution**: 95% of common issues
- **Documentation Coverage**: 100% of API features
- **Error Prevention**: Proactive guidance for common mistakes

---

**Ready to contribute?** Check out our [Contributing Guidelines](CONTRIBUTING.md) and start improving the documentation! 🚀
