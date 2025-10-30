# 🍴 Fork and Sync Strategy Guide

## Overview

This document outlines the strategy for maintaining the **AICraftWorksOrg/claude-flow** fork while staying synchronized with the upstream **ruvnet/claude-flow** repository and managing AICraftWorks-specific customizations.

## Repository Structure

```
Upstream:     github.com/ruvnet/claude-flow (source of truth for core features)
Fork:         github.com/AICraftWorksOrg/claude-flow (your customized version)
```

## Branch Strategy

### Core Branches

#### 1. `main` (Protected)
- **Purpose**: Production-ready code with AICraftWorks customizations
- **Source**: Synced from upstream `main` + AICraftWorks customizations
- **Protection**: Require pull request reviews, status checks
- **Updates**: Via sync workflow + approved PRs

#### 2. `upstream-sync` (Auto-maintained)
- **Purpose**: Mirror of upstream/main for tracking upstream changes
- **Source**: Automated sync from `ruvnet/claude-flow:main`
- **Updates**: Automated daily via GitHub Actions
- **Usage**: Base for pulling upstream changes into main

#### 3. `aicraftworks-main` (Protected)
- **Purpose**: AICraftWorks-specific features and customizations
- **Source**: Custom configurations, Azure integrations, Playwright Service
- **Protection**: Require pull request reviews
- **Usage**: Merge into `main` after upstream sync

#### 4. Feature Branches

##### Upstream Contribution Branches
- **Naming**: `upstream/feature-name` or `contrib/feature-name`
- **Purpose**: Features intended for upstream contribution
- **Base**: `upstream-sync` (clean upstream code)
- **Process**:
  1. Branch from `upstream-sync`
  2. Develop feature without AICraftWorks-specific code
  3. Test thoroughly
  4. PR to upstream `ruvnet/claude-flow`
  5. After upstream merge, sync back naturally

##### AICraftWorks Feature Branches
- **Naming**: `feature/feature-name` or `aicw/feature-name`
- **Purpose**: AICraftWorks-specific features
- **Base**: `aicraftworks-main` or `main`
- **Process**:
  1. Branch from current main or aicraftworks-main
  2. Develop with AICraftWorks-specific configs
  3. PR to `aicraftworks-main` or `main`
  4. Never contribute these to upstream

##### Hotfix Branches
- **Naming**: `hotfix/issue-description`
- **Purpose**: Critical bug fixes
- **Base**: `main`
- **Process**: Fast-track to main, consider upstream contribution

## Sync Workflow

### Automated Daily Sync (Recommended)

The repository includes a GitHub Actions workflow that automatically:
1. Fetches latest changes from upstream
2. Creates/updates `upstream-sync` branch
3. Opens a PR to merge upstream changes into `main`
4. Handles merge conflicts gracefully

**Configuration**: `.github/workflows/sync-upstream.yml`

### Manual Sync Process

When you need to manually sync:

```bash
# 1. Add upstream remote (one-time setup)
git remote add upstream https://github.com/ruvnet/claude-flow.git
git fetch upstream

# 2. Update upstream-sync branch
git checkout upstream-sync
git reset --hard upstream/main
git push origin upstream-sync --force

# 3. Create sync PR to main
git checkout main
git pull origin main
git checkout -b sync/upstream-$(date +%Y%m%d)
git merge upstream-sync

# 4. Resolve conflicts (prioritize AICraftWorks customizations)
# Edit conflicting files to preserve AICraftWorks changes

# 5. Test thoroughly
npm install
npm run build
npm test

# 6. Push and create PR
git push origin sync/upstream-$(date +%Y%m%d)
# Create PR: sync/upstream-YYYYMMDD -> main
```

### Conflict Resolution Strategy

When conflicts occur during sync:

1. **Configuration Files** (package.json, tsconfig.json, etc.)
   - Preserve AICraftWorks customizations
   - Merge new upstream dependencies
   - Keep AICraftWorks-specific scripts

2. **Source Code**
   - Accept upstream changes by default
   - Re-apply AICraftWorks modifications on top
   - Document customizations with comments

3. **Documentation**
   - Keep AICraftWorks-specific docs separate
   - Merge upstream doc improvements
   - Add AICraftWorks addendum sections

4. **Tests**
   - Keep both upstream and AICraftWorks tests
   - Organize in separate directories if needed

## Customization Strategy

### File Organization for Customizations

```
claude-flow/
├── config/
│   └── aicraftworks/           # AICraftWorks-specific configs
│       ├── azure.config.json
│       ├── playwright.config.json
│       └── environment.template.env
├── src/
│   ├── integrations/
│   │   └── aicraftworks/       # AICraftWorks-specific integrations
│   │       ├── azure/
│   │       └── playwright-service/
│   └── ...                     # Upstream source code
├── docs/
│   └── aicraftworks/           # AICraftWorks-specific documentation
│       ├── CUSTOMIZATION_GUIDE.md
│       └── DEPLOYMENT.md
└── ...
```

### Configuration Management

Use environment variables and configuration files for customizations:

**Environment Variables** (`.env.aicraftworks`):
```bash
# Azure Configuration
AZURE_TENANT_ID=your-tenant-id
AZURE_CLIENT_ID=your-client-id
AZURE_SUBSCRIPTION_ID=your-subscription-id

# Playwright Service
PLAYWRIGHT_SERVICE_URL=https://your-service.playwright.ms
PLAYWRIGHT_SERVICE_TOKEN=your-token

# AICraftWorks Settings
AICW_ENVIRONMENT=production
AICW_REGION=eastus
```

**Configuration Files**:
- Keep AICraftWorks configs in `config/aicraftworks/`
- Use environment-based loading
- Never commit secrets (use Azure Key Vault)

### Code Customization Patterns

#### Pattern 1: Extension (Preferred)
Extend upstream functionality without modifying core:

```typescript
// src/integrations/aicraftworks/azure-agent.ts
import { BaseAgent } from '../../core/agents/base-agent';
import { AzureClient } from './azure-client';

export class AzureAgent extends BaseAgent {
  private azureClient: AzureClient;
  
  constructor(config: AzureAgentConfig) {
    super(config);
    this.azureClient = new AzureClient(config.azure);
  }
  
  // Add Azure-specific methods
}
```

#### Pattern 2: Plugin/Hook (Preferred)
Use existing plugin/hook systems:

```typescript
// src/integrations/aicraftworks/playwright-plugin.ts
import { PluginInterface } from '../../core/plugins';

export class PlaywrightPlugin implements PluginInterface {
  name = 'playwright-service';
  
  async initialize() {
    // Initialize Playwright Service connection
  }
  
  async execute(context) {
    // Execute with Playwright Service
  }
}
```

#### Pattern 3: Conditional Modification (Use Sparingly)
When you must modify upstream code:

```typescript
// src/core/some-upstream-file.ts
import { isAICraftWorks } from '../integrations/aicraftworks/utils';

export class UpstreamClass {
  async execute() {
    // Upstream logic
    
    // AICraftWorks modification - clearly marked
    if (isAICraftWorks()) {
      await this.executeWithAzure();
      return;
    }
    
    // Continue with upstream logic
  }
  
  // AICraftWorks addition - clearly marked
  private async executeWithAzure() {
    // Azure-specific implementation
  }
}
```

**Comment Markers**:
```typescript
// [AICRAFTWORKS-START] Description of customization
// ... custom code ...
// [AICRAFTWORKS-END]
```

## Contributing to Upstream

### When to Contribute Upstream

✅ **Good Candidates for Upstream Contribution**:
- Bug fixes that benefit all users
- Performance improvements
- New generic features (not AICraftWorks-specific)
- Documentation improvements
- Test coverage improvements
- Accessibility enhancements

❌ **Keep Private (AICraftWorks-specific)**:
- Azure-specific integrations
- Playwright Service integrations
- AICraftWorks branding/configuration
- Proprietary algorithms or business logic
- Customer-specific customizations

### Upstream Contribution Process

1. **Validate Upstream Value**
   ```bash
   # Ask yourself:
   # - Does this benefit the broader community?
   # - Is it free of AICraftWorks-specific code?
   # - Is it well-tested and documented?
   ```

2. **Create Clean Branch**
   ```bash
   # Branch from upstream-sync for clean history
   git checkout upstream-sync
   git pull origin upstream-sync
   git checkout -b upstream/your-feature-name
   ```

3. **Develop Feature**
   - Write code without AICraftWorks dependencies
   - Add comprehensive tests
   - Update documentation
   - Follow upstream coding standards

4. **Test Thoroughly**
   ```bash
   npm install
   npm run lint
   npm run typecheck
   npm run test
   npm run build
   ```

5. **Create Upstream PR**
   ```bash
   # Push to your fork
   git push origin upstream/your-feature-name
   
   # Create PR to ruvnet/claude-flow
   # Use GitHub UI to create PR:
   # - Base: ruvnet/claude-flow:main
   # - Head: AICraftWorksOrg/claude-flow:upstream/your-feature-name
   ```

6. **Upstream Review Process**
   - Respond to reviewer feedback
   - Make requested changes
   - Be patient and collaborative

7. **Post-Merge Sync**
   ```bash
   # After upstream merge, sync back
   git fetch upstream
   git checkout upstream-sync
   git reset --hard upstream/main
   git push origin upstream-sync --force
   
   # Merge into main
   git checkout main
   git merge upstream-sync
   git push origin main
   ```

### Proven Feature Development
If you want to test features in AICraftWorks before contributing upstream:

1. **Develop in AICraftWorks fork first**
   ```bash
   git checkout -b feature/experimental-feature
   # Develop and test with AICraftWorks setup
   ```

2. **Prove value in production**
   - Deploy to AICraftWorks environment
   - Gather metrics and feedback
   - Validate stability and performance

3. **Extract generic version**
   ```bash
   git checkout upstream-sync
   git checkout -b upstream/experimental-feature
   # Reimplement without AICraftWorks-specific code
   ```

4. **Contribute clean version upstream**
   - Reference AICraftWorks experience in PR description
   - Include metrics/results if applicable

## Automation Scripts

### Sync Helper Script
Located at `scripts/sync-upstream.sh`:
```bash
./scripts/sync-upstream.sh          # Interactive sync
./scripts/sync-upstream.sh --auto   # Automatic sync
./scripts/sync-upstream.sh --dry-run # Preview changes
```

### Upstream PR Preparation
Located at `scripts/prepare-upstream-pr.sh`:
```bash
./scripts/prepare-upstream-pr.sh feature-name
# Creates clean branch and checklist
```

### Configuration Validator
Located at `scripts/validate-aicraftworks-config.sh`:
```bash
./scripts/validate-aicraftworks-config.sh
# Validates AICraftWorks configurations
```

## Best Practices

### 1. Keep Customizations Isolated
- Use separate directories for AICraftWorks code
- Minimize modifications to upstream files
- Use feature flags for conditional behavior

### 2. Document All Customizations
- Mark custom code with clear comments
- Maintain CUSTOMIZATION_LOG.md
- Update documentation with each change

### 3. Regular Sync Schedule
- Sync upstream weekly (automated)
- Review and merge sync PRs promptly
- Test thoroughly after each sync

### 4. Test Rigorously
- Run full test suite after sync
- Test AICraftWorks-specific features
- Validate in staging before production

### 5. Version Management
- Tag AICraftWorks releases separately
- Use semantic versioning with suffix: `v2.7.15-aicw.1`
- Document changes in AICRAFTWORKS_CHANGELOG.md

### 6. Secret Management
- Never commit secrets to repository
- Use Azure Key Vault for production secrets
- Use .env files for local development (gitignored)
- Document required secrets in config templates

## Troubleshooting

### Merge Conflicts During Sync
1. Identify conflict type (config, code, docs)
2. Apply conflict resolution strategy (see above)
3. Test thoroughly after resolution
4. Document resolution approach for future reference

### Breaking Changes from Upstream
1. Review upstream CHANGELOG.md
2. Identify impact on AICraftWorks customizations
3. Update customizations to work with new upstream
4. Add migration guide if needed

### Failed Tests After Sync
1. Identify failing tests (upstream vs custom)
2. For upstream tests: fix locally, consider contributing fix
3. For custom tests: update to work with new upstream
4. Never skip tests - fix or update them

### Lost Customizations After Sync
1. Check git history: `git log --all --grep="AICRAFTWORKS"`
2. Recover from previous commit: `git show <commit>:<file>`
3. Prevent future loss with clear markers and docs
4. Consider cherry-picking: `git cherry-pick <commit>`

## Rollback Procedures

### If Sync Breaks Production
```bash
# 1. Identify last good commit
git log --oneline

# 2. Create hotfix branch
git checkout -b hotfix/rollback-sync

# 3. Revert problematic changes
git revert <bad-commit-hash>

# 4. Test and deploy
npm test && npm run build

# 5. Fast-track to main
git push origin hotfix/rollback-sync
# Create and merge PR immediately
```

### If Customizations Lost
```bash
# Restore from previous good commit
git checkout <good-commit> -- path/to/lost/files

# Or cherry-pick specific changes
git cherry-pick <commit-with-customization>
```

## Monitoring and Alerts

### Set Up Alerts For:
1. New upstream releases (GitHub watch)
2. Sync workflow failures (GitHub Actions notifications)
3. Test failures after sync (CI/CD alerts)
4. Security advisories from upstream (Dependabot)

### Regular Reviews:
- Weekly: Review upstream changes
- Monthly: Audit customization sprawl
- Quarterly: Evaluate contribution opportunities
- Annually: Review and update strategy

## Resources

- **Upstream Repository**: https://github.com/ruvnet/claude-flow
- **Upstream Issues**: https://github.com/ruvnet/claude-flow/issues
- **Upstream Discussions**: https://github.com/ruvnet/claude-flow/discussions
- **Fork Repository**: https://github.com/AICraftWorksOrg/claude-flow
- **AICraftWorks Documentation**: `docs/aicraftworks/`

## Getting Help

- **Upstream Issues**: For bugs or feature requests that affect upstream
- **Internal Team**: For AICraftWorks-specific questions
- **This Guide**: Keep updated with lessons learned

---

**Last Updated**: 2025-10-30
**Maintained By**: AICraftWorks Engineering Team
**Review Schedule**: Quarterly
