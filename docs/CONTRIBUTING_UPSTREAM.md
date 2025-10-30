# 🤝 Contributing to Upstream (ruvnet/claude-flow)

## Overview

This guide helps AICraftWorks engineers contribute improvements back to the upstream **ruvnet/claude-flow** repository. Contributing upstream benefits the entire community and ensures our improvements are maintained as the project evolves.

## Quick Checklist

Before starting an upstream contribution:

- [ ] Feature benefits the broader community (not AICraftWorks-specific)
- [ ] No proprietary code, secrets, or AICraftWorks branding
- [ ] Well-tested with comprehensive test coverage
- [ ] Documentation updated
- [ ] Follows upstream coding standards
- [ ] Clean git history from `upstream-sync` branch

## Upstream Contribution Types

### 🐛 Bug Fixes
**Best candidates for upstream contribution**

**When to contribute**:
- Bug exists in upstream code (not our customization)
- Fix is clean and doesn't require AICraftWorks dependencies
- Well-tested with reproduction steps

**Process**:
1. Verify bug exists in latest upstream
2. Create minimal reproduction case
3. Develop fix with tests
4. Submit PR with clear description

**Example PR Title**: `fix: resolve memory leak in swarm coordinator`

### ✨ New Features
**Requires more evaluation**

**When to contribute**:
- Feature has broad applicability
- Implemented generically (no AICraftWorks specifics)
- Proven valuable in our production use
- Aligned with upstream roadmap

**Process**:
1. Discuss in upstream issues/discussions first
2. Get feedback on approach
3. Implement with comprehensive tests
4. Document thoroughly
5. Submit PR with use cases

**Example PR Title**: `feat: add Azure OpenAI provider support`

### 📚 Documentation Improvements
**Always welcome upstream**

**When to contribute**:
- Clarifications from your experience
- Examples from real usage
- Setup guides for specific environments
- API documentation improvements

**Process**:
1. Identify documentation gap
2. Write clear, concise content
3. Include examples where helpful
4. Submit PR

**Example PR Title**: `docs: add Windows installation troubleshooting guide`

### ⚡ Performance Improvements
**Great candidates for upstream**

**When to contribute**:
- Performance gain measurable and significant
- No breaking changes to API
- Well-benchmarked with before/after metrics
- Benefits all users, not just AICraftWorks setup

**Process**:
1. Benchmark current performance
2. Implement optimization
3. Benchmark improvement
4. Include metrics in PR
5. Document any tradeoffs

**Example PR Title**: `perf: optimize vector search with HNSW indexing (96x speedup)`

### 🧪 Test Improvements
**Always valuable upstream**

**When to contribute**:
- Increased test coverage
- Better test organization
- E2E test scenarios
- Edge case coverage

**Process**:
1. Identify coverage gaps
2. Add meaningful tests
3. Ensure tests pass reliably
4. Document test scenarios

**Example PR Title**: `test: add integration tests for swarm coordination`

## Step-by-Step Contribution Process

### Step 1: Preparation

```bash
# Ensure you have latest upstream
git fetch upstream
git checkout upstream-sync
git reset --hard upstream/main
git push origin upstream-sync --force

# Verify your development environment
npm install
npm run lint
npm run test
npm run build
```

### Step 2: Create Feature Branch

```bash
# Branch from clean upstream-sync
git checkout upstream-sync
git checkout -b upstream/your-feature-name

# Example:
# git checkout -b upstream/fix-memory-leak
# git checkout -b upstream/add-azure-provider
# git checkout -b upstream/improve-documentation
```

**Branch Naming Convention**:
- `upstream/fix-*` - Bug fixes
- `upstream/feat-*` - New features
- `upstream/docs-*` - Documentation
- `upstream/perf-*` - Performance
- `upstream/test-*` - Testing

### Step 3: Develop Feature

**Key Principles**:
1. **No AICraftWorks Dependencies**
   ```typescript
   // ❌ Bad - AICraftWorks-specific
   import { AzureClient } from '../integrations/aicraftworks/azure';
   
   // ✅ Good - Generic
   import { CloudProvider } from '../core/cloud-provider';
   ```

2. **Generic Configuration**
   ```typescript
   // ❌ Bad - Hardcoded for AICraftWorks
   const config = {
     provider: 'azure',
     endpoint: process.env.AICW_AZURE_ENDPOINT
   };
   
   // ✅ Good - Configurable
   const config = {
     provider: process.env.CLOUD_PROVIDER || 'default',
     endpoint: process.env.CLOUD_ENDPOINT
   };
   ```

3. **Follow Upstream Code Style**
   ```bash
   # Check upstream style
   npm run lint
   npm run format
   ```

4. **Write Tests**
   ```typescript
   // src/__tests__/unit/your-feature.test.ts
   import { describe, it, expect } from '@jest/globals';
   import { YourFeature } from '../your-feature';
   
   describe('YourFeature', () => {
     it('should handle basic case', () => {
       const feature = new YourFeature();
       expect(feature.execute()).toBe(expected);
     });
     
     it('should handle edge case', () => {
       // Test edge cases
     });
   });
   ```

5. **Update Documentation**
   ```markdown
   <!-- README.md or relevant docs -->
   ## New Feature
   
   Description of feature...
   
   ### Usage
   ```bash
   npm run your-feature
   ```
   
   ### Configuration
   | Option | Description | Default |
   |--------|-------------|---------|
   | ... | ... | ... |
   ```

### Step 4: Test Thoroughly

```bash
# Run all checks
npm run lint          # Check code style
npm run typecheck     # Check TypeScript types
npm run test          # Run all tests
npm run test:unit     # Run unit tests
npm run test:integration  # Run integration tests
npm run build         # Verify build works

# Test specific functionality
npm run test -- --testNamePattern="YourFeature"

# Coverage check
npm run test:coverage
```

**Testing Checklist**:
- [ ] All tests pass
- [ ] Added tests for new functionality
- [ ] No TypeScript errors
- [ ] No linting errors
- [ ] Build succeeds
- [ ] Coverage maintained or improved

### Step 5: Prepare Commit

```bash
# Stage changes
git add .

# Commit with conventional commit message
git commit -m "type(scope): description

Longer description if needed.

- Detail 1
- Detail 2

Fixes #123"
```

**Commit Message Format**:
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code style (formatting)
- `refactor`: Code refactoring
- `perf`: Performance improvement
- `test`: Adding tests
- `chore`: Maintenance

**Examples**:
```bash
git commit -m "fix(swarm): resolve memory leak in coordinator

The coordinator was not properly cleaning up event listeners,
causing memory to grow over time.

- Add cleanup method
- Call cleanup in destructor
- Add tests for cleanup

Fixes #456"

git commit -m "feat(azure): add Azure OpenAI provider support

Adds support for using Azure OpenAI as a provider alongside
the existing OpenAI integration.

- Add AzureOpenAIProvider class
- Add configuration options
- Add integration tests
- Update documentation

Closes #789"

git commit -m "docs(readme): add troubleshooting section

Added common issues and solutions based on user reports
and support tickets."
```

### Step 6: Push and Create PR

```bash
# Push to your fork
git push origin upstream/your-feature-name

# If you need to update after feedback
git push origin upstream/your-feature-name --force-with-lease
```

**Create PR via GitHub**:
1. Go to https://github.com/ruvnet/claude-flow
2. Click "New Pull Request"
3. Set base: `ruvnet/claude-flow:main`
4. Set compare: `AICraftWorksOrg/claude-flow:upstream/your-feature-name`
5. Fill out PR template

### Step 7: Write Great PR Description

**PR Title Format**: `type(scope): description`

**PR Description Template**:
```markdown
## Description
Brief description of what this PR does and why.

## Motivation
Why is this change needed? What problem does it solve?

## Changes
- Change 1
- Change 2
- Change 3

## Testing
- [ ] Added unit tests
- [ ] Added integration tests
- [ ] All tests pass
- [ ] Manual testing completed

### Test Results
```bash
npm test
# Paste relevant test output
```

## Documentation
- [ ] Updated README
- [ ] Updated API docs
- [ ] Added code comments
- [ ] Updated CHANGELOG

## Breaking Changes
- [ ] None
- [ ] Yes (describe below)

Description of breaking changes if any...

## Screenshots (if applicable)
Before:
[image]

After:
[image]

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review of code completed
- [ ] Tests added and passing
- [ ] Documentation updated
- [ ] No new warnings
- [ ] Dependent changes merged

## Additional Context
Any other context, considerations, or notes for reviewers.

## Related Issues
Fixes #123
Relates to #456
```

### Step 8: Respond to Review Feedback

**Best Practices**:
1. **Be Responsive**: Reply to comments within 24-48 hours
2. **Be Collaborative**: Welcome feedback and suggestions
3. **Be Clear**: Explain your reasoning when disagreeing
4. **Be Patient**: Reviews take time
5. **Be Professional**: Stay courteous and constructive

**Responding to Feedback**:
```bash
# Make requested changes
# Edit files...

# Commit changes
git add .
git commit -m "address review feedback: improve error handling"

# Push updates
git push origin upstream/your-feature-name
```

**Comment Responses**:
- ✅ "Good catch! Fixed in latest commit."
- ✅ "Updated as suggested. Let me know if this addresses your concern."
- ✅ "I kept the original approach because [reason]. Happy to discuss alternatives."
- ❌ "This is fine as is."
- ❌ "Why do I need to change this?"

### Step 9: Merge and Sync Back

**After Upstream Merge**:
```bash
# Update upstream-sync
git fetch upstream
git checkout upstream-sync
git reset --hard upstream/main
git push origin upstream-sync --force

# Merge into your main
git checkout main
git merge upstream-sync

# Clean up feature branch
git branch -d upstream/your-feature-name
git push origin --delete upstream/your-feature-name
```

## Common Pitfalls to Avoid

### ❌ Including AICraftWorks-Specific Code
```typescript
// Don't do this in upstream PRs
import { AICraftWorksConfig } from './aicraftworks';
const config = new AICraftWorksConfig();
```

### ❌ Hardcoding AICraftWorks Values
```typescript
// Don't do this
const defaultRegion = 'eastus'; // Our Azure region
const organization = 'aicraftworks';
```

### ❌ Incomplete Testing
```typescript
// Don't submit without tests
export function newFeature() {
  // Complex logic with no tests
}
```

### ❌ Missing Documentation
```typescript
// Don't leave complex code undocumented
export function complexAlgorithm(data) {
  // 100 lines of complex code
  // No explanation of what it does or why
}
```

### ❌ Breaking Changes Without Discussion
```typescript
// Don't make breaking changes without upstream approval
export function execute(oldParam, newParam) {
  // Changed function signature breaks existing code
}
```

### ❌ Large Monolithic PRs
```bash
# Don't combine multiple unrelated changes
git commit -m "feat: add 10 new features, fix 5 bugs, refactor everything"
```

## Testing Your Contribution

### Local Testing
```bash
# Clean install
rm -rf node_modules package-lock.json
npm install

# Full test suite
npm run lint
npm run typecheck
npm test
npm run build

# Specific tests
npm run test:unit
npm run test:integration
npm run test:e2e
```

### Integration Testing
```bash
# Test with upstream examples
cd examples/your-example
npm install
npm test

# Test CLI
npm link
claude-flow --help
claude-flow your-command
```

### Real-World Testing
```bash
# Create test project
mkdir test-upstream-feature
cd test-upstream-feature
npm init -y
npm install ../claude-flow

# Test your feature
node test-feature.js
```

## Examples of Good Upstream PRs

### Example 1: Bug Fix
```
fix(memory): prevent duplicate entries in ReasoningBank

The memory system was allowing duplicate patterns to be stored,
causing inflated memory usage and slower queries.

Changes:
- Add uniqueness check before storing patterns
- Add index on pattern hash for faster lookups
- Add test for duplicate prevention

Performance impact:
- 15% reduction in memory usage
- 20% faster query times

Fixes #234
```

### Example 2: Feature Addition
```
feat(providers): add support for Anthropic Claude API

Adds first-class support for Anthropic's Claude API as an AI provider.

Motivation:
Users have requested native Claude support instead of requiring
OpenAI-compatible wrappers.

Changes:
- Add AnthropicProvider class implementing Provider interface
- Add configuration options for Claude models
- Add streaming support
- Add comprehensive tests
- Update documentation

Breaking Changes:
None - this is additive functionality.

Configuration example:
```json
{
  "provider": "anthropic",
  "model": "claude-3-opus-20240229",
  "apiKey": "sk-ant-..."
}
```

Testing:
- Unit tests: 98% coverage
- Integration tests with real API
- Tested with all Claude models

Closes #567
```

### Example 3: Documentation
```
docs(guides): add comprehensive Azure deployment guide

Many users deploy to Azure but documentation was lacking.
This adds a complete guide based on production experience.

Changes:
- New Azure deployment guide in docs/deployment/azure.md
- Configuration examples
- Troubleshooting section
- Best practices from production deployments

Addresses #890
```

## Getting Help

### Before Contributing
- Check existing issues and PRs
- Ask questions in upstream discussions
- Join community chat if available

### During Development
- Comment on related issue
- Ask for feedback early
- Request review from specific maintainers

### After Submission
- Monitor PR for feedback
- Respond to CI failures
- Ask for clarification when needed

## Resources

- **Upstream Contributing Guide**: Check if `ruvnet/claude-flow` has CONTRIBUTING.md
- **Code of Conduct**: Follow community guidelines
- **Issue Tracker**: https://github.com/ruvnet/claude-flow/issues
- **Discussions**: https://github.com/ruvnet/claude-flow/discussions

## Recognition

Your upstream contributions:
- Help the entire community
- Improve the ecosystem
- Build your reputation
- Ensure your features are maintained

Thank you for contributing back to open source! 🙌

---

**Maintained By**: AICraftWorks Engineering Team
**Last Updated**: 2025-10-30
