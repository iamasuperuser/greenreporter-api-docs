# GreenReporter API Documentation Deployment Script
# This script sets up and deploys the public-facing documentation portal

Write-Host "🌱 GreenReporter API Documentation Deployment" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green

# Check if Python is installed
Write-Host "`n📋 Checking prerequisites..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✅ Python found: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Python not found. Please install Python 3.8+ and try again." -ForegroundColor Red
    Write-Host "Download from: https://python.org" -ForegroundColor Cyan
    exit 1
}

# Check if pip is available
try {
    $pipVersion = pip --version 2>&1
    Write-Host "✅ pip found: $pipVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ pip not found. Please install pip and try again." -ForegroundColor Red
    exit 1
}

# Install dependencies
Write-Host "`n📦 Installing dependencies..." -ForegroundColor Yellow
pip install -r requirements.txt

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Dependencies installed successfully" -ForegroundColor Green

# Validate documentation
Write-Host "`n🔍 Validating documentation..." -ForegroundColor Yellow
mkdocs build --strict

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Documentation validation failed" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Documentation validation successful" -ForegroundColor Green

# Build documentation
Write-Host "`n🏗️ Building documentation..." -ForegroundColor Yellow
mkdocs build

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Documentation build failed" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Documentation built successfully" -ForegroundColor Green

# Show deployment options
Write-Host "`n🚀 Deployment Options:" -ForegroundColor Yellow
Write-Host "1. GitHub Pages (Recommended):" -ForegroundColor Cyan
Write-Host "   - Push to GitHub repository" -ForegroundColor White
Write-Host "   - Enable GitHub Pages in repository settings" -ForegroundColor White
Write-Host "   - Documentation will be available at: https://docs.greenreporter.eu" -ForegroundColor White
Write-Host ""
Write-Host "2. Local Development Server:" -ForegroundColor Cyan
Write-Host "   - Run: mkdocs serve" -ForegroundColor White
Write-Host "   - Open: http://localhost:8000" -ForegroundColor White
Write-Host ""
Write-Host "3. Manual Deployment:" -ForegroundColor Cyan
Write-Host "   - Upload 'site' folder to your web server" -ForegroundColor White
Write-Host "   - Configure custom domain: docs.greenreporter.eu" -ForegroundColor White

# Ask user what they want to do
Write-Host "`nWhat would you like to do?" -ForegroundColor Yellow
Write-Host "1. Start local development server" -ForegroundColor White
Write-Host "2. Deploy to GitHub Pages" -ForegroundColor White
Write-Host "3. Just build (no server)" -ForegroundColor White
Write-Host "4. Exit" -ForegroundColor White

$choice = Read-Host "Enter your choice (1-4)"

switch ($choice) {
    "1" {
        Write-Host "`n🌐 Starting local development server..." -ForegroundColor Yellow
        Write-Host "📖 Documentation will be available at: http://localhost:8000" -ForegroundColor Cyan
        Write-Host "🛑 Press Ctrl+C to stop the server" -ForegroundColor Yellow
        Write-Host ""
        mkdocs serve --dev-addr=0.0.0.0:8000
    }
    "2" {
        Write-Host "`n🚀 Deploying to GitHub Pages..." -ForegroundColor Yellow
        Write-Host "Make sure you have:" -ForegroundColor Cyan
        Write-Host "- Git repository initialized" -ForegroundColor White
        Write-Host "- GitHub remote configured" -ForegroundColor White
        Write-Host "- GitHub Pages enabled in repository settings" -ForegroundColor White
        Write-Host ""
        $confirm = Read-Host "Continue with deployment? (y/n)"
        if ($confirm -eq "y" -or $confirm -eq "Y") {
            mkdocs gh-deploy
        } else {
            Write-Host "Deployment cancelled." -ForegroundColor Yellow
        }
    }
    "3" {
        Write-Host "`n✅ Documentation built successfully!" -ForegroundColor Green
        Write-Host "📁 Static files are in the 'site' directory" -ForegroundColor Cyan
        Write-Host "🌐 Upload these files to your web server" -ForegroundColor Cyan
    }
    "4" {
        Write-Host "`n👋 Goodbye!" -ForegroundColor Green
        exit 0
    }
    default {
        Write-Host "`n❌ Invalid choice. Please run the script again." -ForegroundColor Red
        exit 1
    }
}

Write-Host "`n🎉 Documentation setup complete!" -ForegroundColor Green
Write-Host "📚 For more information, visit: https://docs.greenreporter.eu" -ForegroundColor Cyan
