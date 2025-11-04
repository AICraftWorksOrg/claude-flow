# AICraftWorks Fork & Sync Strategy

This document provides a comprehensive strategy for managing the AICraftWorksOrg/claude-flow fork while staying synchronized with the upstream ruvnet/claude-flow repository.

## 📋 Repository Overview

- **Upstream**: [github.com/ruvnet/claude-flow](https://github.com/ruvnet/claude-flow)
- **Fork**: [github.com/AICraftWorksOrg/claude-flow](https://github.com/AICraftWorksOrg/claude-flow)
- **Purpose**: Maintain AICraftWorks customizations (Azure, Playwright Service) while syncing upstream improvements

## 🚀 Quick Start

### For New Team Members

1. **Clone the repository**
   ```bash
   git clone https://github.com/AICraftWorksOrg/claude-flow.git
   cd claude-flow
   ```

2. **Setup environment**
   ```bash
   cp config/aicraftworks/templates/.env.template .env.aicraftworks
   # Edit .env.aicraftworks with your credentials
   ```

3. **Install dependencies**
   ```bash
   npm install
   ```

4. **Run tests**
   ```bash
   npm test
   ```

### Daily Workflow

- **Upstream Sync**: Automated daily at 2 AM UTC (GitHub Actions)
- **Review Sync PRs**: Check for new PRs labeled `upstream-sync`
- **Test & Merge**: Validate and merge sync PRs promptly

## 📚 Documentation

### Essential Guides

| Document | Purpose | When to Use |
|----------|---------|-------------|
| [FORK_STRATEGY.md](./docs/FORK_STRATEGY.md) | Complete fork/sync strategy | Understanding the system |
| [CONTRIBUTING_UPSTREAM.md](./docs/CONTRIBUTING_UPSTREAM.md) | Contributing back to upstream | Making upstream PRs |
| [FORK_SYNC_QUICKREF.md](./docs/FORK_SYNC_QUICKREF.md) | Quick reference guide | Day-to-day operations |
| [CUSTOMIZATION_GUIDE.md](./docs/aicraftworks/CUSTOMIZATION_GUIDE.md) | AICraftWorks customizations | Adding custom features |

### Quick Reference

```bash
# Check for upstream changes
./scripts/aicraftworks/sync-upstream.sh --dry-run

# Sync manually
./scripts/aicraftworks/sync-upstream.sh --auto

# Prepare upstream contribution
./scripts/aicraftworks/prepare-upstream-pr.sh feature-name

# After resolving conflicts
./scripts/aicraftworks/sync-upstream.sh --continue
```

## 🌳 Branch Strategy

### Core Branches

- **`main`**: Production-ready with AICraftWorks customizations
- **`upstream-sync`**: Mirror of upstream/main (auto-updated daily)
- **`aicraftworks-main`**: AICraftWorks-specific features

### Feature Branches

- **`upstream/*`**: For upstream contributions (branched from `upstream-sync`)
- **`feature/*`**: For AICraftWorks features (branched from `main`)
- **`sync/*`**: Automated sync branches (created by GitHub Actions)

## 🔄 Sync Process

### Automated (Recommended)

1. GitHub Actions runs daily at 2 AM UTC
2. Fetches latest from upstream
3. Creates/updates `upstream-sync` branch
4. Opens PR if changes detected
5. Labels PR with `upstream-sync`
6. Assigns reviewers (if configured)

### Manual (When Needed)

```bash
# Preview changes
./scripts/aicraftworks/sync-upstream.sh --dry-run

# Execute sync
./scripts/aicraftworks/sync-upstream.sh --auto

# If conflicts occur
# 1. Resolve conflicts manually
# 2. git add <resolved-files>
# 3. git commit
# 4. Run: ./scripts/aicraftworks/sync-upstream.sh --continue
```

## 🤝 Contributing

### To Upstream (ruvnet/claude-flow)

Use when your changes benefit the broader community:

```bash
# Prepare clean branch
./scripts/aicraftworks/prepare-upstream-pr.sh my-feature

# Develop without AICraftWorks dependencies
# Test thoroughly
# Push and create PR to ruvnet/claude-flow
```

**Guidelines**:
- ✅ Bug fixes, performance improvements, generic features
- ✅ Well-tested with comprehensive test coverage
- ✅ Documented with examples
- ❌ No AICraftWorks-specific code
- ❌ No proprietary business logic
- ❌ No hardcoded credentials

### To AICraftWorks Fork

For AICraftWorks-specific features:

```bash
# Branch from main
git checkout -b feature/my-feature main

# Develop using AICraftWorks integrations
# Add to src/integrations/aicraftworks/
# PR to main or aicraftworks-main
```

## 📁 File Organization

### AICraftWorks Customizations

```
src/integrations/aicraftworks/     # Custom integrations
├── azure/                          # Azure services
├── playwright-service/             # Playwright Service
└── agents/                         # Custom agents

config/aicraftworks/                # Configuration files
├── templates/                      # Templates (committed)
└── *.json                          # Actual configs (gitignored)

docs/aicraftworks/                  # AICraftWorks documentation

scripts/aicraftworks/               # Helper scripts
├── sync-upstream.sh                # Sync automation
└── prepare-upstream-pr.sh          # PR preparation
```

### Upstream Files

All other directories and files come from upstream and should be modified minimally.

## 🔒 Security

### Configuration Management

- ✅ Use `.env.aicraftworks` for local dev (gitignored)
- ✅ Use Azure Key Vault for prod secrets
- ✅ Use environment variables for configuration
- ❌ Never commit secrets to git
- ❌ Never hardcode credentials

### Sensitive Files (Gitignored)

- `.env.aicraftworks`
- `config/aicraftworks/*.json` (except templates)
- `.upstream-pr-checklist-*.md`

## 🧪 Testing

### After Upstream Sync

```bash
# Full test suite
npm run lint
npm run typecheck
npm test
npm run build

# AICraftWorks-specific tests
# (Add specific test commands as needed)
```

### Before Upstream Contribution

```bash
# Ensure no AICraftWorks dependencies
npm run lint
npm run typecheck
npm test
npm run build

# Verify clean git history
git log --oneline upstream-sync..HEAD
```

## 🚨 Troubleshooting

### Sync Conflicts

1. **Configuration Files**: Keep AICraftWorks customizations
2. **Source Code**: Accept upstream, re-apply customizations
3. **Documentation**: Merge both versions
4. **Tests**: Keep both sets of tests

See [FORK_STRATEGY.md](./docs/FORK_STRATEGY.md#conflict-resolution-strategy) for details.

### Sync Workflow Failed

Check GitHub Actions logs:
- Go to repository → Actions tab
- Find "Sync from Upstream" workflow
- Review error logs

### Lost Customizations

```bash
# Find customization commits
git log --all --grep="AICRAFTWORKS"

# Recover from specific commit
git show <commit>:<file> > recovered-file

# Or cherry-pick
git cherry-pick <commit>
```

## 📊 Monitoring

### What's Automated

- ✅ Daily upstream sync check
- ✅ PR creation for upstream changes
- ✅ Conflict detection
- ✅ Branch updates

### What Requires Manual Action

- ❌ Resolving merge conflicts
- ❌ Reviewing sync PRs
- ❌ Testing after sync
- ❌ Creating upstream contributions
- ❌ Deploying to prod

## 🔧 Maintenance Schedule

- **Daily**: Check for sync PRs
- **Weekly**: Review and merge sync PRs
- **Monthly**: Audit customizations, update dependencies
- **Quarterly**: Review fork strategy, security audit
- **Annually**: Evaluate contribution opportunities

## 📞 Support

### Resources

- **Documentation**: See `docs/` directory
- **Upstream Issues**: https://github.com/ruvnet/claude-flow/issues
- **Team Channel**: #claude-flow-support (internal)

### Common Questions

**Q: When should I contribute to upstream?**
A: When changes benefit the broader community and contain no AICraftWorks-specific code.

**Q: How often does sync happen?**
A: Automatically daily at 2 AM UTC, or manually on demand.

**Q: What if sync creates conflicts?**
A: Follow the conflict resolution strategy in FORK_STRATEGY.md, prioritizing AICraftWorks customizations.

**Q: Can I modify upstream files?**
A: Minimize modifications. Use extension patterns and mark changes clearly with comments.

## 🎯 Best Practices

### DO ✅

- Sync regularly (weekly minimum)
- Test thoroughly after sync
- Mark customizations clearly in code
- Document all changes
- Contribute generic improvements upstream
- Use configuration for customizations
- Keep secrets in Key Vault

### DON'T ❌

- Commit secrets to git
- Modify core files unnecessarily
- Skip testing after sync
- Ignore sync PRs
- Mix upstream and custom code without markers
- Hardcode AICraftWorks-specific values

## 📈 Success Metrics

- Sync PRs merged within 48 hours
- <5% merge conflict rate
- 100% test pass rate after sync
- ≥1 upstream contribution per quarter
- Zero secret leaks

## 🗺️ Roadmap

### Short Term (Q4 2025)
- [ ] Complete initial setup
- [ ] Document all customizations
- [ ] Establish sync cadence
- [ ] First upstream contribution

### Medium Term (Q1 2026)
- [ ] Automated testing pipeline
- [ ] Enhanced monitoring
- [ ] Streamlined contribution process
- [ ] Knowledge base expansion

### Long Term (Q2 2026+)
- [ ] Potential upstream merge of generic features
- [ ] Expanded AICraftWorks ecosystem
- [ ] Automated customization management

## 📝 Change Log

See [AICRAFTWORKS_CHANGELOG.md](./AICRAFTWORKS_CHANGELOG.md) for AICraftWorks-specific changes (to be created as changes are made).

---

## Summary

This repository strategy enables:
1. ✅ **Upstream Sync**: Automated daily sync with conflict detection
2. ✅ **Custom Features**: AICraftWorks-specific integrations (Azure, Playwright)
3. ✅ **Upstream Contributions**: Clean path for contributing improvements
4. ✅ **Separation of Concerns**: Clear organization of custom vs upstream code
5. ✅ **Security**: Gitignored secrets, Key Vault integration
6. ✅ **Automation**: GitHub Actions for sync, scripts for common tasks

**Get Started**: Read [FORK_SYNC_QUICKREF.md](./docs/FORK_SYNC_QUICKREF.md) for day-to-day operations.

---

**Maintained By**: AICraftWorks Engineering Team  
**Last Updated**: 2025-10-30  
**Review Schedule**: Quarterly  
**Next Review**: 2026-01-30
