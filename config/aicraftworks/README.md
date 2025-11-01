# AICraftWorks Configuration

This directory contains AICraftWorks-specific configuration files for the claude-flow fork.

## Structure

```
config/aicraftworks/
├── templates/
│   └── .env.template          # Environment variables template
├── azure-openai.json          # Azure OpenAI configuration (gitignored)
├── azure-keyvault.json        # Azure Key Vault configuration (gitignored)
├── playwright.json            # Playwright Service configuration (gitignored)
└── README.md                  # This file
```

## Setup

### 1. Environment Variables

Copy the template and fill in your values:

```bash
cp templates/.env.template ../../.env.aicraftworks
# Edit .env.aicraftworks with your Azure credentials
```

### 2. Configuration Files

Create configuration files for your services. These are gitignored for security.

**Example `azure-openai.json`**:
```json
{
  "endpoint": "https://your-resource.openai.azure.com/",
  "apiKey": "your-api-key",
  "deploymentName": "gpt-4",
  "apiVersion": "2024-02-15-preview"
}
```

**Example `playwright.json`**:
```json
{
  "serviceUrl": "wss://your-service.playwright.ms",
  "token": "your-token",
  "timeout": 30000
}
```

## Security

⚠️ **IMPORTANT**: Configuration files with actual credentials are gitignored and should NEVER be committed.

For prod:
- Use Azure Key Vault for secrets
- Use environment variables for configuration
- Never hardcode credentials in code

## Loading Configuration

Configuration files are loaded by the AICraftWorks integration:

```typescript
import { AICraftWorksConfigLoader } from '../integrations/aicraftworks/config-loader';

const config = await new AICraftWorksConfigLoader().load();
```

## Documentation

See [Customization Guide](../../docs/aicraftworks/CUSTOMIZATION_GUIDE.md) for detailed setup instructions.

---

**Last Updated**: 2025-10-30
