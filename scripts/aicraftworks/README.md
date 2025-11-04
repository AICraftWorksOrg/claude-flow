# AICraftWorks Scripts

Helper scripts for managing the claude-flow fork and upstream synchronization.

## Available Scripts

### 1. sync-upstream.sh

Automates synchronization with upstream ruvnet/claude-flow repository.

**Usage:**
```bash
# Preview what would be synced (recommended first step)
./scripts/aicraftworks/sync-upstream.sh --dry-run

# Execute complete automated sync
./scripts/aicraftworks/sync-upstream.sh --auto

# Continue after resolving merge conflicts
./scripts/aicraftworks/sync-upstream.sh --continue

# Show help
./scripts/aicraftworks/sync-upstream.sh --help
```

**Features:**
- ✅ Checks for upstream changes
- ✅ Updates upstream-sync branch
- ✅ Creates sync branch from main
- ✅ Attempts automatic merge
- ✅ Detects and reports conflicts
- ✅ Runs test suite
- ✅ Pushes and guides PR creation
- ✅ Colored output for clarity

**When to Use:**
- Need to manually trigger sync (GitHub Actions runs daily)
- Testing sync process
- Urgent upstream fix needs to be pulled
- Troubleshooting sync issues

### 2. prepare-upstream-pr.sh

Prepares a clean branch for contributing changes back to upstream.

**Usage:**
```bash
# Interactive mode (prompts for type)
./scripts/aicraftworks/prepare-upstream-pr.sh feature-name

# With explicit type
./scripts/aicraftworks/prepare-upstream-pr.sh feature-name --type TYPE

# Show help
./scripts/aicraftworks/prepare-upstream-pr.sh --help
```

**Types:**
- `fix` - Bug fixes
- `feat` - New features
- `docs` - Documentation
- `perf` - Performance improvements
- `test` - Test additions/improvements
- `refactor` - Code refactoring

**Examples:**
```bash
# Bug fix
./scripts/aicraftworks/prepare-upstream-pr.sh fix-memory-leak --type fix

# New feature
./scripts/aicraftworks/prepare-upstream-pr.sh add-cache-support --type feat

# Documentation improvement
./scripts/aicraftworks/prepare-upstream-pr.sh improve-setup-docs --type docs
```

**Features:**
- ✅ Creates branch from clean upstream-sync
- ✅ Validates feature name (catches AICW-specific names)
- ✅ Generates comprehensive checklist
- ✅ Provides next-step guidance
- ✅ Ensures clean history for upstream

**What It Creates:**
1. Clean branch: `upstream/TYPE-feature-name`
2. Checklist file: `.upstream-pr-checklist-feature-name.md`
3. Guidance for development and PR creation

**When to Use:**
- Contributing bug fixes to upstream
- Proposing new features to upstream
- Improving upstream documentation
- Any generic improvement that benefits community

## Prerequisites

Both scripts require:
- Git repository (checked automatically)
- Git configured with user.name and user.email
- Network access to GitHub

For `sync-upstream.sh`:
- `upstream` remote configured (script sets up if missing)
- Clean working directory (script will stash if needed)

For `prepare-upstream-pr.sh`:
- `upstream` remote configured
- No AICraftWorks-specific code in contribution

## Script Architecture

### sync-upstream.sh Flow

```
1. Check prerequisites
   ├── Git repository?
   ├── Remote configured?
   └── Network access?

2. Setup upstream remote
   ├── Add if missing
   └── Fetch latest

3. Check for changes
   ├── Compare upstream/main with upstream-sync
   └── Show summary of new commits

4. Update upstream-sync
   ├── Reset to upstream/main
   └── Force push to origin

5. Create sync branch
   ├── Branch from main
   └── Name: sync/upstream-YYYYMMDD-HHMMSS

6. Merge upstream-sync
   ├── Attempt automatic merge
   ├── Detect conflicts
   └── Provide resolution guidance

7. Run tests (if no conflicts)
   ├── npm install
   ├── npm run lint
   ├── npm run typecheck
   ├── npm test
   └── npm run build

8. Push and guide PR creation
   ├── git push origin branch
   └── Display PR creation URL
```

### prepare-upstream-pr.sh Flow

```
1. Validate inputs
   ├── Feature name provided?
   ├── Not AICraftWorks-specific?
   └── Valid contribution type?

2. Check prerequisites
   ├── Git repository?
   ├── Upstream remote?
   └── Network access?

3. Update upstream-sync
   ├── Fetch upstream
   ├── Create or update upstream-sync
   └── Force to upstream/main

4. Create feature branch
   ├── Branch from upstream-sync
   └── Name: upstream/TYPE-feature-name

5. Generate checklist
   ├── Pre-development tasks
   ├── Development guidelines
   ├── Testing requirements
   └── PR creation steps

6. Show next steps
   ├── Development guidance
   ├── Testing commands
   └── PR creation URL
```

## Error Handling

Both scripts include comprehensive error handling:

### Common Errors

**"Not in a git repository"**
```bash
# Solution: Run from repository root
cd /path/to/claude-flow
./scripts/aicraftworks/script-name.sh
```

**"Upstream remote not configured"**
```bash
# Solution: Add upstream remote
git remote add upstream https://github.com/ruvnet/claude-flow.git
```

**"Merge conflicts detected"**
```bash
# Solution: Follow conflict resolution guide
# 1. Edit conflicting files
# 2. git add <files>
# 3. git commit
# 4. ./scripts/aicraftworks/sync-upstream.sh --continue
```

**"Feature name suggests AICraftWorks-specific code"**
```bash
# Solution: Use generic name
# ❌ ./prepare-upstream-pr.sh azure-specific-feature
# ✅ ./prepare-upstream-pr.sh cloud-provider-support
```

## Best Practices

### For sync-upstream.sh

1. **Always dry-run first**
   ```bash
   ./sync-upstream.sh --dry-run
   ```

2. **Review changes before merging**
   ```bash
   # After dry-run, check upstream CHANGELOG
   git log upstream-sync..upstream/main
   ```

3. **Keep working directory clean**
   ```bash
   git status
   # Commit or stash changes before sync
   ```

4. **Test thoroughly after sync**
   ```bash
   npm test
   # Test AICW-specific features
   ```

### For prepare-upstream-pr.sh

1. **Use descriptive names**
   ```bash
   # ❌ ./prepare-upstream-pr.sh fix
   # ✅ ./prepare-upstream-pr.sh fix-memory-leak-in-coordinator
   ```

2. **Choose correct type**
   ```bash
   # Bug fix
   --type fix
   
   # New feature
   --type feat
   
   # Documentation
   --type docs
   ```

3. **Follow the checklist**
   ```bash
   # Script generates .upstream-pr-checklist-FEATURE.md
   # Check off items as you complete them
   ```

4. **Test before pushing**
   ```bash
   npm run lint
   npm run typecheck
   npm test
   npm run build
   ```

## Configuration

### Environment Variables

**SYNC_REVIEWERS** (for GitHub Actions)
```bash
# In GitHub repository secrets
SYNC_REVIEWERS=user1,user2,user3
```

### Script Variables

Both scripts define these at the top (can be customized):

**sync-upstream.sh:**
```bash
UPSTREAM_REPO="https://github.com/ruvnet/claude-flow.git"
UPSTREAM_REMOTE="upstream"
UPSTREAM_BRANCH="main"
SYNC_BRANCH_PREFIX="sync/upstream"
```

**prepare-upstream-pr.sh:**
```bash
UPSTREAM_REMOTE="upstream"
UPSTREAM_BRANCH="main"
BRANCH_PREFIX="upstream"
```

## Troubleshooting

### Script Won't Execute

```bash
# Check if executable
ls -l scripts/aicraftworks/sync-upstream.sh

# If not executable, fix it
chmod +x scripts/aicraftworks/*.sh
```

### Coloroutput Not Working

```bash
# Colors work in most terminals
# If seeing escape codes, terminal may not support ANSI colors
# Scripts still work, just without colors
```

### Script Hangs

```bash
# Ctrl+C to cancel
# Check network connection
# Check git credentials
# Try with --help first
```

## Integration with GitHub Actions

The `sync-upstream.sh` script complements the automated GitHub Actions workflow:

**GitHub Actions** (`.github/workflows/sync-upstream.yml`):
- Runs daily at 2 AM UTC
- Creates PRs automatically
- Handles most sync operations

**Manual Script** (`sync-upstream.sh`):
- On-demand sync
- Testing and troubleshooting
- When Actions workflow fails
- Urgent updates needed

## Examples

### Complete Sync Workflow

```bash
# 1. Preview changes
./scripts/aicraftworks/sync-upstream.sh --dry-run

# 2. Review upstream changes
git log upstream-sync..upstream/main --oneline
cat CHANGELOG.md # Check upstream CHANGELOG

# 3. Execute sync
./scripts/aicraftworks/sync-upstream.sh --auto

# 4. If conflicts:
#    - Resolve manually
#    - git add <files>
#    - git commit
./scripts/aicraftworks/sync-upstream.sh --continue

# 5. Verify and merge PR
```

### Complete Upstream Contribution Workflow

```bash
# 1. Prepare branch
./scripts/aicraftworks/prepare-upstream-pr.sh add-retry-logic --type feat

# 2. Develop feature
# Edit files...
# No AICraftWorks-specific code

# 3. Add tests
# Write comprehensive tests

# 4. Test
npm run lint
npm run typecheck
npm test
npm run build

# 5. Commit
git add .
git commit -m "feat(core): add retry logic with exponential backoff"

# 6. Push
git push origin upstream/feat-add-retry-logic

# 7. Create PR at:
# https://github.com/ruvnet/claude-flow/compare/main...AICraftWorksOrg:claude-flow:upstream/feat-add-retry-logic
```

## Maintenance

### Updating Scripts

When updating scripts:
1. Test thoroughly in development
2. Update version comments in script
3. Update this README
4. Commit changes together

### Testing Scripts

```bash
# Create test branch for experimentation
git checkout -b test/script-testing main

# Test sync script (dry-run is safe)
./scripts/aicraftworks/sync-upstream.sh --dry-run

# Test PR prep script
./scripts/aicraftworks/prepare-upstream-pr.sh test-feature --type feat
# Then delete test branch: git branch -D upstream/feat-test-feature
```

## Support

For issues with scripts:
1. Check this README
2. Run with `--help` flag
3. Check [FORK_STRATEGY.md](../docs/FORK_STRATEGY.md)
4. Review script source code (well-commented)
5. Ask in #claude-flow-support

## Related Documentation

- [Fork Strategy](../docs/FORK_STRATEGY.md) - Overall strategy
- [Contributing Upstream](../docs/CONTRIBUTING_UPSTREAM.md) - Upstream guide
- [Quick Reference](../docs/FORK_SYNC_QUICKREF.md) - Daily operations
- [Visual Overview](../docs/FORK_STRATEGY_VISUAL.md) - Diagrams

---

**Maintained By**: AICraftWorks Engineering Team  
**Last Updated**: 2025-10-30  
**Script Versions**: 
- sync-upstream.sh v1.0
- prepare-upstream-pr.sh v1.0
