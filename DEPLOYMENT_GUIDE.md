# GreenReporter API Documentation Deployment Guide

This guide provides comprehensive instructions for deploying the GreenReporter API documentation as a public-facing site at `docs.greenreporter.eu`.

## 🎯 Deployment Options

### Option 1: GitHub Pages (Recommended - Zero Setup Required)

#### Prerequisites
- GitHub account
- Repository with documentation files

#### Steps
1. **Create New Repository**:
   ```bash
   # Create a new repository for documentation only
   git init greenreporter-api-docs
   cd greenreporter-api-docs
   git remote add origin https://github.com/greenreporter/api-docs.git
   ```

2. **Copy Documentation Files**:
   ```bash
   # Copy all files from public-docs/ to the new repository
   cp -r public-docs/* .
   ```

3. **Push to GitHub**:
   ```bash
   git add .
   git commit -m "Initial documentation setup"
   git push -u origin main
   ```

4. **Enable GitHub Pages**:
   - Go to repository Settings
   - Scroll to "Pages" section
   - Select "GitHub Actions" as source
   - The workflow will automatically deploy

5. **Configure Custom Domain**:
   - Add CNAME file: `docs.greenreporter.eu`
   - Configure DNS: CNAME record `docs` → `greenreporter.github.io`
   - Enable "Enforce HTTPS" in GitHub Pages settings

### Option 2: Netlify (Drag & Drop Deployment)

#### Prerequisites
- Netlify account (free)
- Documentation files built locally

#### Steps
1. **Build Documentation** (if you have Python):
   ```bash
   # Install Python 3.8+ from python.org
   pip install -r requirements.txt
   mkdocs build
   ```

2. **Deploy to Netlify**:
   - Go to [netlify.com](https://netlify.com)
   - Drag and drop the `site/` folder
   - Set up custom domain: `docs.greenreporter.eu`

### Option 3: Vercel (Zero Configuration)

#### Prerequisites
- Vercel account (free)
- GitHub repository

#### Steps
1. **Connect Repository**:
   - Go to [vercel.com](https://vercel.com)
   - Import your GitHub repository
   - Vercel will auto-detect MkDocs

2. **Configure Build**:
   - Build Command: `pip install -r requirements.txt && mkdocs build`
   - Output Directory: `site`
   - Deploy automatically

### Option 4: Static Hosting (AWS S3, Azure Static Web Apps, etc.)

#### Prerequisites
- Cloud provider account
- Documentation built locally

#### Steps
1. **Build Documentation**:
   ```bash
   pip install -r requirements.txt
   mkdocs build
   ```

2. **Upload to Hosting**:
   - Upload contents of `site/` folder
   - Configure custom domain: `docs.greenreporter.eu`
   - Set up CDN for performance

## 🐍 Local Development Setup

### Windows Installation

#### Install Python
1. Download Python from [python.org](https://python.org)
2. Run installer with "Add Python to PATH" checked
3. Verify installation:
   ```cmd
   python --version
   pip --version
   ```

#### Install Dependencies
```cmd
pip install -r requirements.txt
```

#### Build Documentation
```cmd
mkdocs build
mkdocs serve
```

### macOS Installation

#### Using Homebrew
```bash
# Install Python
brew install python

# Install dependencies
pip install -r requirements.txt

# Build documentation
mkdocs build
mkdocs serve
```

### Linux Installation

#### Ubuntu/Debian
```bash
# Install Python and pip
sudo apt update
sudo apt install python3 python3-pip

# Install dependencies
pip3 install -r requirements.txt

# Build documentation
mkdocs build
mkdocs serve
```

## 📁 File Structure

```
greenreporter-api-docs/
├── docs/                          # Documentation source files
│   ├── index.md                   # Main landing page
│   ├── quick-start.md             # Quick start guide
│   ├── authentication.md          # Authentication guide
│   ├── api-reference.md           # API reference
│   ├── openapi-spec.md            # OpenAPI specification
│   ├── sdk-integration.md         # SDK integration guides
│   ├── webhook-integration.md     # Webhook integration
│   ├── rate-limiting.md           # Rate limiting guide
│   ├── api-versioning.md          # API versioning
│   ├── pagination-filtering.md    # Pagination and filtering
│   ├── troubleshooting.md         # Troubleshooting guide
│   ├── error-handling.md          # Error handling
│   └── CNAME                      # Custom domain configuration
├── mkdocs.yml                     # MkDocs configuration
├── requirements.txt               # Python dependencies
├── package.json                   # Node.js configuration
├── deploy-docs.ps1               # Windows deployment script
├── .github/workflows/docs.yml     # GitHub Actions workflow
└── README.md                     # Documentation README
```

## 🚀 Quick Deployment Commands

### Windows PowerShell
```powershell
# Run the deployment script
.\deploy-docs.ps1
```

### Command Line (Any OS)
```bash
# Install dependencies
pip install -r requirements.txt

# Build documentation
mkdocs build

# Start local server
mkdocs serve

# Deploy to GitHub Pages
mkdocs gh-deploy
```

## 🎨 Customization

### Branding
Update `mkdocs.yml` to customize:
- Site name and description
- Logo and favicon
- Color scheme
- Navigation structure

### Content
- Edit Markdown files in `docs/` directory
- Add images to `docs/images/`
- Update API examples as needed

### Styling
- Custom CSS in `docs/stylesheets/extra.css`
- Material theme customization in `mkdocs.yml`

## 🔧 Configuration

### Environment Variables
```bash
# Set in your deployment environment
export API_BASE_URL=https://api.greenreporter.eu/v1
export DOCS_URL=https://docs.greenreporter.eu
export GITHUB_REPO=https://github.com/greenreporter/api-docs
```

### Custom Domain
1. Add CNAME file to `docs/` directory:
   ```
   docs.greenreporter.eu
   ```

2. Configure DNS:
   - CNAME record: `docs` → `greenreporter.github.io`

3. Update `mkdocs.yml`:
   ```yaml
   site_url: https://docs.greenreporter.eu
   ```

## 📊 Features Included

### ✅ Complete Documentation
- **Getting Started**: 5-minute quick start guide
- **API Reference**: Complete endpoint documentation
- **SDK Guides**: 10+ programming languages
- **Webhook Integration**: Real-time notifications
- **Advanced Features**: Rate limiting, versioning, pagination
- **Support**: Comprehensive troubleshooting

### ✅ Developer Experience
- **Search**: Full-text search across all content
- **Navigation**: Tabbed navigation with sections
- **Code Examples**: Copy-to-clipboard functionality
- **Responsive**: Mobile-friendly design
- **Fast**: Optimized for performance

### ✅ Maintenance
- **Auto-deployment**: GitHub Actions workflow
- **Version Control**: Git-based content management
- **Analytics**: Google Analytics integration
- **Monitoring**: Broken link detection

## 🎯 Success Metrics

### Developer Experience
- **Time to First API Call**: < 5 minutes
- **Documentation Completeness**: 100% endpoint coverage
- **Code Example Quality**: All examples are copy-paste ready

### Support Reduction
- **Self-Service Resolution**: 95% of common issues
- **Documentation Coverage**: 100% of API features
- **Error Prevention**: Proactive guidance for common mistakes

## 🆘 Troubleshooting

### Common Issues

#### Python Not Found
```bash
# Windows: Install from python.org
# macOS: brew install python
# Linux: sudo apt install python3
```

#### Pip Not Found
```bash
# Windows: python -m pip install -r requirements.txt
# macOS/Linux: pip3 install -r requirements.txt
```

#### Build Errors
```bash
# Check Python version (3.8+ required)
python --version

# Install dependencies
pip install -r requirements.txt

# Validate configuration
mkdocs build --strict
```

#### GitHub Pages Not Updating
1. Check GitHub Actions workflow status
2. Verify repository settings
3. Check for build errors in Actions tab

## 📞 Support

### Documentation Issues
- **GitHub Issues**: [Report bugs and request features](https://github.com/greenreporter/api-docs/issues)
- **Email**: [docs-support@greenreporter.eu](mailto:docs-support@greenreporter.eu)

### API Support
- **API Questions**: [api-support@greenreporter.eu](mailto:api-support@greenreporter.eu)
- **Technical Issues**: [GitHub Issues](https://github.com/greenreporter/api/issues)

## 🎉 Ready to Deploy!

Choose your preferred deployment method and follow the steps above. The documentation is designed to be:

- **Easy to Deploy**: Multiple deployment options
- **Easy to Maintain**: Git-based content management
- **Easy to Customize**: Flexible configuration
- **Easy to Scale**: Cloud-based hosting

**Recommended**: Start with GitHub Pages for the easiest deployment experience! 🚀

## 🌐 Final URLs

After deployment, your documentation will be available at:
- **Primary**: https://docs.greenreporter.eu
- **API Base**: https://api.greenreporter.eu/v1
- **Status**: https://status.greenreporter.eu

---

**Ready to go live? Follow the GitHub Pages deployment steps above!** 🚀
