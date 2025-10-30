# 🔧 AICraftWorks Customization Guide

## Overview

This guide explains how to customize **claude-flow** with AICraftWorks-specific integrations including Azure services, Playwright Service, and other enterprise features while maintaining the ability to sync with upstream.

## Table of Contents

- [Architecture](#architecture)
- [Azure Integration](#azure-integration)
- [Playwright Service](#playwright-service)
- [Configuration Management](#configuration-management)
- [Custom Agents](#custom-agents)
- [Testing](#testing)
- [Deployment](#deployment)

## Architecture

### Integration Points

```
claude-flow (upstream)
├── Core functionality (from upstream)
└── AICraftWorks Extensions
    ├── Azure integrations
    ├── Playwright Service
    ├── Custom agents
    └── Enterprise configurations
```

### Design Principles

1. **Minimal Core Changes**: Extend, don't modify
2. **Configuration-Driven**: Use env vars and config files
3. **Pluggable Architecture**: Implement as plugins/providers
4. **Upstream Compatible**: Maintain sync-ability
5. **Secure by Default**: Never commit secrets

## Azure Integration

### Setup Instructions

Create Azure-specific configuration files in the designated directory:

**Directory Structure**:
```
config/aicraftworks/
├── azure-openai.json
├── azure-keyvault.json
└── azure-storage.json
```

### Environment Variables

Copy the template and configure:

```bash
cp config/aicraftworks/templates/.env.template .env.aicraftworks
# Edit .env.aicraftworks with your Azure credentials
```

## Playwright Service

### Configuration

Create Playwright Service configuration:

```bash
# See config/aicraftworks/playwright.json.template
```

## Quick Start

1. **Clone and Setup**
   ```bash
   git clone https://github.com/AICraftWorksOrg/claude-flow.git
   cd claude-flow
   npm install
   ```

2. **Configure AICraftWorks Settings**
   ```bash
   cp config/aicraftworks/templates/.env.template .env.aicraftworks
   # Edit .env.aicraftworks
   ```

3. **Run Tests**
   ```bash
   npm test
   ```

4. **Build**
   ```bash
   npm run build
   ```

## Detailed Documentation

For complete implementation examples and code samples, see the full customization guide in this repository's documentation structure.

Key integration points:
- Azure OpenAI Provider
- Azure Key Vault for secrets
- Azure Blob Storage for data
- Playwright Service for browser automation
- Custom agent implementations
- Configuration management
- Testing strategies

## Maintenance

### Regular Tasks

1. **Weekly**: Review upstream changes
2. **Monthly**: Update dependencies
3. **Quarterly**: Security audit
4. **Annually**: Architecture review

## Support

For AICraftWorks-specific issues:
- **Internal Documentation**: `docs/aicraftworks/`
- **Team Channel**: #claude-flow-support

---

**Maintained By**: AICraftWorks Engineering Team
**Last Updated**: 2025-10-30
