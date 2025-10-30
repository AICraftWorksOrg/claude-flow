# 🚀 Quick Reference: Fork & Sync Strategy

## Overview
This repository (AICraftWorksOrg/claude-flow) is a fork of ruvnet/claude-flow with AICraftWorks-specific customizations.

## Key Documents
- **[FORK_STRATEGY.md](./FORK_STRATEGY.md)** - Complete fork/sync strategy
- **[CONTRIBUTING_UPSTREAM.md](./CONTRIBUTING_UPSTREAM.md)** - How to contribute back to upstream
- **[CUSTOMIZATION_GUIDE.md](./aicraftworks/CUSTOMIZATION_GUIDE.md)** - AICraftWorks customizations

## Quick Commands

### Daily Workflow

```bash
# Check for upstream updates (automatic via GitHub Actions)
# Manual check: 
./scripts/aicraftworks/sync-upstream.sh --dry-run

# Sync upstream manually (if needed)
./scripts/aicraftworks/sync-upstream.sh --auto
```

### Contributing to Upstream

```bash
# Prepare a clean branch for upstream contribution
./scripts/aicraftworks/prepare-upstream-pr.sh feature-name

# Example: Bug fix
./scripts/aicraftworks/prepare-upstream-pr.sh fix-memory-leak --type fix

# Example: New feature
./scripts/aicraftworks/prepare-upstream-pr.sh add-azure-support --type feat
```

### AICraftWorks Development

```bash
# Setup environment
cp config/aicraftworks/templates/.env.template .env.aicraftworks
# Edit .env.aicraftworks with your values

# Install dependencies
npm install

# Run tests
npm test

# Build
npm run build
```

## Branch Strategy

| Branch | Purpose | Updates |
|--------|---------|---------|
| `main` | Production with AICraftWorks customizations | PRs + upstream sync |
| `upstream-sync` | Mirror of upstream/main | Automated daily |
| `aicraftworks-main` | AICraftWorks-specific features | PRs only |
| `upstream/*` | Upstream contributions | Manual, from upstream-sync |
| `feature/*` | AICraftWorks features | Manual, from main |

## Sync Workflow

1. **Automated Sync** (runs daily at 2 AM UTC)
   - GitHub Actions fetches upstream
   - Creates PR if changes detected
   - Handles merge conflicts gracefully

2. **Manual Sync** (when needed)
   ```bash
   ./scripts/aicraftworks/sync-upstream.sh --auto
   ```

3. **Review & Merge**
   - Review PR created by sync workflow
   - Test AICraftWorks-specific features
   - Merge when ready

## Contribution Workflow

### For Upstream (ruvnet/claude-flow)

1. **Prepare**
   ```bash
   ./scripts/aicraftworks/prepare-upstream-pr.sh my-feature
   ```

2. **Develop**
   - Write generic code (no AICraftWorks-specific)
   - Add tests
   - Update docs

3. **Test**
   ```bash
   npm run lint
   npm run typecheck
   npm test
   npm run build
   ```

4. **Push**
   ```bash
   git push origin upstream/my-feature
   ```

5. **Create PR**
   - Go to https://github.com/ruvnet/claude-flow
   - Create PR from your branch
   - Follow checklist

### For AICraftWorks-Only Features

1. **Branch**
   ```bash
   git checkout -b feature/my-aicw-feature main
   ```

2. **Develop**
   - Use AICraftWorks integrations freely
   - Add to `src/integrations/aicraftworks/`

3. **PR to main or aicraftworks-main**

## File Organization

```
claude-flow/
├── src/
│   └── integrations/
│       └── aicraftworks/          # Our customizations
│           ├── azure/
│           └── playwright-service/
├── config/
│   └── aicraftworks/              # Our configs
│       └── templates/
├── docs/
│   ├── FORK_STRATEGY.md           # This strategy
│   ├── CONTRIBUTING_UPSTREAM.md   # Upstream guide
│   └── aicraftworks/              # Our docs
└── scripts/
    └── aicraftworks/              # Our scripts
```

## Common Scenarios

### "Upstream has new features I want"
```bash
# Wait for automated sync (next day)
# OR trigger manual sync
./scripts/aicraftworks/sync-upstream.sh --auto
```

### "I want to contribute a fix to upstream"
```bash
# Create clean branch
./scripts/aicraftworks/prepare-upstream-pr.sh fix-issue-123 --type fix

# Develop without AICraftWorks dependencies
# Test thoroughly
# Push and create PR to ruvnet/claude-flow
```

### "I need an AICraftWorks-specific feature"
```bash
# Branch from main
git checkout -b feature/azure-integration main

# Develop using our integrations
# PR to aicraftworks-main or main
```

### "Sync created merge conflicts"
```bash
# Resolve conflicts following priority:
# 1. Config files → Keep our customizations
# 2. Source code → Accept upstream, re-apply customizations
# 3. Docs → Merge both
# 4. Tests → Keep both

# After resolving
git add .
git commit
./scripts/aicraftworks/sync-upstream.sh --continue
```

## Automated Processes

✅ **What's Automated**:
- Daily upstream sync check (2 AM UTC)
- PR creation for upstream changes
- Conflict detection

❌ **What Requires Manual Action**:
- Resolving merge conflicts
- Reviewing and merging sync PRs
- Testing after sync
- Creating upstream contributions

## Configuration

### GitHub Actions Secrets
- `GITHUB_TOKEN` - Automatically provided
- `SYNC_REVIEWERS` - (Optional) Comma-separated GitHub usernames

### Local Environment
```bash
# Copy and edit
cp config/aicraftworks/templates/.env.template .env.aicraftworks
```

## Troubleshooting

### Sync Workflow Failed
Check `.github/workflows/sync-upstream.yml` logs in GitHub Actions

### Tests Failing After Sync
```bash
# Check what changed
git diff origin/main

# Run specific tests
npm run test -- --testNamePattern="failing test"
```

### Can't Create Upstream Branch
```bash
# Ensure upstream remote exists
git remote add upstream https://github.com/ruvnet/claude-flow.git
git fetch upstream
```

## Resources

- **Upstream Repo**: https://github.com/ruvnet/claude-flow
- **Our Fork**: https://github.com/AICraftWorksOrg/claude-flow
- **Issues**: https://github.com/ruvnet/claude-flow/issues
- **Team Docs**: `docs/aicraftworks/`

## Need Help?

1. Check this guide first
2. Review detailed guides in `docs/`
3. Ask team in #claude-flow-support
4. Check upstream documentation

---

**Quick Tips**:
- ✅ Sync weekly, merge promptly
- ✅ Mark customizations clearly
- ✅ Test before merging syncs
- ✅ Contribute generic improvements upstream
- ❌ Don't modify core files unnecessarily
- ❌ Don't commit secrets
- ❌ Don't skip testing after sync

**Last Updated**: 2025-10-30
