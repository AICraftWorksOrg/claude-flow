#!/bin/bash

# Prepare Upstream PR Helper Script
# Helps create clean branches for upstream contributions

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
UPSTREAM_REMOTE="upstream"
UPSTREAM_BRANCH="main"
BRANCH_PREFIX="upstream"

# Print colored message
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Print section header
print_header() {
    echo ""
    print_message "$BLUE" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_message "$BLUE" "$1"
    print_message "$BLUE" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

# Check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_message "$RED" "❌ Error: Not in a git repository"
        exit 1
    fi
}

# Ensure upstream remote exists
check_upstream() {
    if ! git remote | grep -q "^${UPSTREAM_REMOTE}$"; then
        print_message "$RED" "❌ Error: Upstream remote not configured"
        print_message "$YELLOW" "Run: git remote add upstream https://github.com/ruvnet/claude-flow.git"
        exit 1
    fi
    
    print_message "$YELLOW" "Fetching latest from upstream..."
    git fetch "$UPSTREAM_REMOTE"
    print_message "$GREEN" "✓ Upstream fetched"
}

# Validate feature name
validate_feature_name() {
    local name=$1
    
    if [ -z "$name" ]; then
        print_message "$RED" "❌ Error: Feature name required"
        exit 1
    fi
    
    # Check for AICraftWorks-specific naming
    if echo "$name" | grep -qi "aicraftworks\|aicw\|azure.*specific"; then
        print_message "$RED" "❌ Error: Feature name suggests AICraftWorks-specific code"
        print_message "$YELLOW" "Upstream contributions should be generic"
        print_message "$YELLOW" "Consider using a generic name instead"
        exit 1
    fi
}

# Determine branch type
get_branch_type() {
    echo ""
    print_message "$BLUE" "Select contribution type:"
    echo "  1) Bug fix (fix)"
    echo "  2) New feature (feat)"
    echo "  3) Documentation (docs)"
    echo "  4) Performance (perf)"
    echo "  5) Tests (test)"
    echo "  6) Refactor (refactor)"
    echo ""
    read -p "Enter number (1-6): " choice
    
    case $choice in
        1) echo "fix" ;;
        2) echo "feat" ;;
        3) echo "docs" ;;
        4) echo "perf" ;;
        5) echo "test" ;;
        6) echo "refactor" ;;
        *) echo "feat" ;;
    esac
}

# Create upstream branch
create_branch() {
    local feature_name=$1
    local branch_type=$2
    
    print_header "Creating Upstream Branch"
    
    # Ensure we have latest upstream
    git fetch "$UPSTREAM_REMOTE"
    
    # Check if upstream-sync exists, if not create from upstream/main
    if ! git show-ref --verify --quiet refs/heads/upstream-sync; then
        print_message "$YELLOW" "Creating upstream-sync branch..."
        git branch upstream-sync "${UPSTREAM_REMOTE}/${UPSTREAM_BRANCH}"
    else
        print_message "$YELLOW" "Updating upstream-sync branch..."
        git branch -f upstream-sync "${UPSTREAM_REMOTE}/${UPSTREAM_BRANCH}"
    fi
    
    # Create feature branch from upstream-sync
    local branch_name="${BRANCH_PREFIX}/${branch_type}-${feature_name}"
    
    print_message "$YELLOW" "Creating branch: $branch_name"
    git checkout -b "$branch_name" upstream-sync
    
    print_message "$GREEN" "✓ Branch created: $branch_name"
    echo ""
    
    echo "$branch_name"
}

# Create checklist file
create_checklist() {
    local feature_name=$1
    local branch_type=$2
    local branch_name=$3
    
    local checklist_file=".upstream-pr-checklist-${feature_name}.md"
    
    cat > "$checklist_file" << EOF
# Upstream Contribution Checklist: $feature_name

## Pre-Development
- [ ] Verified feature is generic (not AICraftWorks-specific)
- [ ] Checked existing issues/PRs for similar work
- [ ] Discussed approach in upstream discussions (if major change)
- [ ] Branched from clean upstream-sync

## Development
- [ ] Implemented feature without AICraftWorks dependencies
- [ ] Followed upstream code style
- [ ] Added comprehensive tests
- [ ] Updated documentation
- [ ] No hardcoded AICraftWorks values
- [ ] No secrets or credentials in code

## Code Quality
- [ ] Linting passes: \`npm run lint\`
- [ ] Type checking passes: \`npm run typecheck\`
- [ ] All tests pass: \`npm test\`
- [ ] Build succeeds: \`npm run build\`
- [ ] Code coverage maintained or improved

## Documentation
- [ ] README updated (if applicable)
- [ ] API documentation updated
- [ ] Added code comments for complex logic
- [ ] Included usage examples

## Testing
- [ ] Unit tests added
- [ ] Integration tests added (if applicable)
- [ ] Edge cases covered
- [ ] Manual testing completed

## Commit
- [ ] Conventional commit message format
- [ ] Clear, descriptive commit messages
- [ ] Single purpose per commit
- [ ] No merge commits

## Pull Request
- [ ] PR title follows format: \`$branch_type(scope): description\`
- [ ] PR description explains motivation
- [ ] PR includes test results
- [ ] PR references related issues
- [ ] Breaking changes documented (if any)

## Final Review
- [ ] Self-review of all changes
- [ ] No debug code or console.logs
- [ ] No commented-out code
- [ ] All TODOs addressed or documented

## Branch Information
- Branch: \`$branch_name\`
- Type: \`$branch_type\`
- Base: upstream-sync (from ruvnet/claude-flow)
- Target: ruvnet/claude-flow:main

## Useful Commands

\`\`\`bash
# Run all checks
npm run lint && npm run typecheck && npm test && npm run build

# Commit changes
git add .
git commit -m "$branch_type(scope): description"

# Push to fork
git push origin $branch_name

# Create PR
# Go to: https://github.com/ruvnet/claude-flow/compare/main...AICraftWorksOrg:claude-flow:$branch_name
\`\`\`

## Resources
- [Contributing Guide](./docs/CONTRIBUTING_UPSTREAM.md)
- [Fork Strategy](./docs/FORK_STRATEGY.md)
- [Upstream Issues](https://github.com/ruvnet/claude-flow/issues)

---

**Delete this file after PR is merged**
EOF

    print_message "$GREEN" "✓ Checklist created: $checklist_file"
    echo ""
    print_message "$BLUE" "Review checklist and check off items as you complete them"
}

# Show next steps
show_next_steps() {
    local branch_name=$1
    local feature_name=$2
    
    print_header "Next Steps"
    
    print_message "$GREEN" "✅ Branch ready for development!"
    echo ""
    print_message "$BLUE" "1. Develop your feature (no AICraftWorks-specific code)"
    print_message "$BLUE" "2. Write tests and documentation"
    print_message "$BLUE" "3. Run checks:"
    print_message "$YELLOW" "   npm run lint && npm run typecheck && npm test"
    print_message "$BLUE" "4. Commit with conventional format:"
    print_message "$YELLOW" "   git commit -m \"type(scope): description\""
    print_message "$BLUE" "5. Push to your fork:"
    print_message "$YELLOW" "   git push origin $branch_name"
    print_message "$BLUE" "6. Create PR to upstream:"
    print_message "$YELLOW" "   https://github.com/ruvnet/claude-flow/compare/main...AICraftWorksOrg:claude-flow:$branch_name"
    echo ""
    print_message "$BLUE" "📋 Follow the checklist in: .upstream-pr-checklist-${feature_name}.md"
}

# Show help
show_help() {
    cat << EOF
Prepare Upstream PR Helper Script

Usage: $0 <feature-name> [OPTIONS]

Arguments:
    feature-name    Name of the feature (e.g., azure-provider, fix-memory-leak)

Options:
    --type TYPE     Contribution type (fix, feat, docs, perf, test, refactor)
    --help          Show this help message

Examples:
    $0 add-cache-support
    $0 fix-memory-leak --type fix
    $0 improve-docs --type docs

This script will:
  1. Create a clean branch from upstream
  2. Generate a contribution checklist
  3. Provide guidance for upstream contribution

For more information, see docs/CONTRIBUTING_UPSTREAM.md
EOF
}

# Main execution
main() {
    local feature_name=""
    local branch_type=""
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --type)
                branch_type="$2"
                shift 2
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                if [ -z "$feature_name" ]; then
                    feature_name="$1"
                fi
                shift
                ;;
        esac
    done
    
    # Validate
    if [ -z "$feature_name" ]; then
        show_help
        exit 1
    fi
    
    check_git_repo
    validate_feature_name "$feature_name"
    check_upstream
    
    # Get branch type if not specified
    if [ -z "$branch_type" ]; then
        branch_type=$(get_branch_type)
    fi
    
    # Create branch
    local branch_name=$(create_branch "$feature_name" "$branch_type")
    
    # Create checklist
    create_checklist "$feature_name" "$branch_type" "$branch_name"
    
    # Show next steps
    show_next_steps "$branch_name" "$feature_name"
}

main "$@"
