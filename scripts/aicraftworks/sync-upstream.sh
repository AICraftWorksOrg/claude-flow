#!/bin/bash

# Upstream Sync Helper Script
# Helps manually sync changes from upstream ruvnet/claude-flow

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
UPSTREAM_REPO="https://github.com/ruvnet/claude-flow.git"
UPSTREAM_REMOTE="upstream"
UPSTREAM_BRANCH="main"
SYNC_BRANCH_PREFIX="sync/upstream"

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

# Setup upstream remote
setup_upstream() {
    print_header "Setting up upstream remote"
    
    if git remote | grep -q "^${UPSTREAM_REMOTE}$"; then
        print_message "$GREEN" "✓ Upstream remote already exists"
        git remote set-url "$UPSTREAM_REMOTE" "$UPSTREAM_REPO"
    else
        print_message "$YELLOW" "Adding upstream remote..."
        git remote add "$UPSTREAM_REMOTE" "$UPSTREAM_REPO"
    fi
    
    print_message "$YELLOW" "Fetching from upstream..."
    git fetch "$UPSTREAM_REMOTE"
    print_message "$GREEN" "✓ Upstream fetched successfully"
}

# Check for upstream changes
check_changes() {
    print_header "Checking for upstream changes"
    
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    local upstream_commit=$(git rev-parse ${UPSTREAM_REMOTE}/${UPSTREAM_BRANCH})
    
    # Check if upstream-sync exists
    if git show-ref --verify --quiet refs/heads/upstream-sync; then
        local sync_commit=$(git rev-parse upstream-sync)
        if [ "$sync_commit" = "$upstream_commit" ]; then
            print_message "$GREEN" "✓ Already up to date with upstream"
            return 1
        fi
    fi
    
    print_message "$YELLOW" "📊 Upstream changes detected"
    
    # Show summary of changes
    if git show-ref --verify --quiet refs/heads/upstream-sync; then
        local commits=$(git log --oneline upstream-sync..${UPSTREAM_REMOTE}/${UPSTREAM_BRANCH} | wc -l)
        print_message "$BLUE" "   New commits: $commits"
        echo ""
        print_message "$BLUE" "   Recent upstream commits:"
        git log --oneline --graph --max-count=5 ${UPSTREAM_REMOTE}/${UPSTREAM_BRANCH}
    fi
    
    return 0
}

# Update upstream-sync branch
update_sync_branch() {
    print_header "Updating upstream-sync branch"
    
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    
    # Stash any local changes
    if ! git diff --quiet; then
        print_message "$YELLOW" "Stashing local changes..."
        git stash push -m "Auto-stash before upstream sync"
    fi
    
    # Create or update upstream-sync
    if git show-ref --verify --quiet refs/heads/upstream-sync; then
        print_message "$YELLOW" "Updating existing upstream-sync branch..."
        git checkout upstream-sync
        git reset --hard ${UPSTREAM_REMOTE}/${UPSTREAM_BRANCH}
    else
        print_message "$YELLOW" "Creating upstream-sync branch..."
        git checkout -b upstream-sync ${UPSTREAM_REMOTE}/${UPSTREAM_BRANCH}
    fi
    
    print_message "$GREEN" "✓ upstream-sync updated"
    
    # Return to original branch
    git checkout "$current_branch"
}

# Create sync branch
create_sync_branch() {
    print_header "Creating sync branch"
    
    local timestamp=$(date +%Y%m%d-%H%M%S)
    local sync_branch="${SYNC_BRANCH_PREFIX}-${timestamp}"
    
    # Ensure we're on main and up to date
    git checkout main
    git pull origin main
    
    # Create new sync branch
    print_message "$YELLOW" "Creating branch: $sync_branch"
    git checkout -b "$sync_branch"
    
    print_message "$GREEN" "✓ Sync branch created: $sync_branch"
    echo "$sync_branch"
}

# Merge upstream changes
merge_upstream() {
    local sync_branch=$1
    
    print_header "Merging upstream changes"
    
    print_message "$YELLOW" "Attempting to merge upstream-sync..."
    
    if git merge upstream-sync --no-edit -m "chore: sync with upstream ruvnet/claude-flow"; then
        print_message "$GREEN" "✓ Merge completed successfully (no conflicts)"
        return 0
    else
        print_message "$YELLOW" "⚠️  Merge conflicts detected"
        echo ""
        print_message "$BLUE" "Conflicting files:"
        git diff --name-only --diff-filter=U
        echo ""
        print_message "$YELLOW" "Please resolve conflicts manually:"
        print_message "$BLUE" "  1. Edit conflicting files"
        print_message "$BLUE" "  2. git add <resolved-files>"
        print_message "$BLUE" "  3. git commit"
        print_message "$BLUE" "  4. Run this script again with --continue"
        echo ""
        print_message "$BLUE" "See docs/FORK_STRATEGY.md for conflict resolution strategies"
        return 1
    fi
}

# Run tests
run_tests() {
    print_header "Running tests"
    
    print_message "$YELLOW" "Installing dependencies..."
    npm install
    
    print_message "$YELLOW" "Running linter..."
    npm run lint || {
        print_message "$YELLOW" "⚠️  Linting issues detected (non-fatal)"
    }
    
    print_message "$YELLOW" "Running type checker..."
    npm run typecheck || {
        print_message "$RED" "❌ Type checking failed"
        return 1
    }
    
    print_message "$YELLOW" "Running tests..."
    npm test || {
        print_message "$RED" "❌ Tests failed"
        return 1
    }
    
    print_message "$YELLOW" "Building project..."
    npm run build || {
        print_message "$RED" "❌ Build failed"
        return 1
    }
    
    print_message "$GREEN" "✓ All checks passed"
    return 0
}

# Push and create PR
push_and_pr() {
    local sync_branch=$1
    
    print_header "Pushing and creating PR"
    
    print_message "$YELLOW" "Pushing branch to origin..."
    git push origin "$sync_branch"
    
    print_message "$GREEN" "✓ Branch pushed successfully"
    echo ""
    print_message "$BLUE" "Next steps:"
    print_message "$BLUE" "  1. Go to: https://github.com/AICraftWorksOrg/claude-flow/compare/$sync_branch"
    print_message "$BLUE" "  2. Create a Pull Request to main"
    print_message "$BLUE" "  3. Review changes carefully"
    print_message "$BLUE" "  4. Test thoroughly before merging"
}

# Dry run mode
dry_run() {
    print_header "Dry Run Mode"
    
    setup_upstream
    
    if check_changes; then
        print_message "$BLUE" "Would update upstream-sync branch"
        print_message "$BLUE" "Would create sync branch"
        print_message "$BLUE" "Would attempt merge"
        echo ""
        print_message "$GREEN" "Run without --dry-run to execute sync"
    else
        print_message "$GREEN" "No changes to sync"
    fi
}

# Auto mode (complete sync)
auto_sync() {
    print_header "Automatic Sync Mode"
    
    setup_upstream
    
    if ! check_changes; then
        print_message "$GREEN" "Already up to date - nothing to do"
        exit 0
    fi
    
    update_sync_branch
    
    local sync_branch=$(create_sync_branch)
    
    if merge_upstream "$sync_branch"; then
        if run_tests; then
            push_and_pr "$sync_branch"
            print_message "$GREEN" "✅ Sync completed successfully!"
        else
            print_message "$RED" "❌ Tests failed - please fix and push manually"
            exit 1
        fi
    else
        print_message "$YELLOW" "⚠️  Resolve conflicts and run: $0 --continue"
        exit 1
    fi
}

# Continue after conflict resolution
continue_sync() {
    print_header "Continue Sync After Conflict Resolution"
    
    # Check if we're in the middle of a merge
    if ! git rev-parse -q --verify MERGE_HEAD > /dev/null; then
        print_message "$RED" "❌ No merge in progress"
        exit 1
    fi
    
    print_message "$YELLOW" "Checking for unresolved conflicts..."
    
    if git diff --name-only --diff-filter=U | grep -q .; then
        print_message "$RED" "❌ Unresolved conflicts still exist:"
        git diff --name-only --diff-filter=U
        exit 1
    fi
    
    print_message "$GREEN" "✓ All conflicts resolved"
    
    local sync_branch=$(git rev-parse --abbrev-ref HEAD)
    
    if run_tests; then
        push_and_pr "$sync_branch"
        print_message "$GREEN" "✅ Sync completed successfully!"
    else
        print_message "$RED" "❌ Tests failed - please fix before pushing"
        exit 1
    fi
}

# Show help
show_help() {
    cat << EOF
Upstream Sync Helper Script

Usage: $0 [OPTIONS]

Options:
    --auto          Run complete sync automatically
    --dry-run       Show what would be done without making changes
    --continue      Continue sync after resolving conflicts
    --help          Show this help message

Examples:
    $0 --dry-run    # Preview changes
    $0 --auto       # Complete automated sync
    $0 --continue   # Continue after resolving conflicts

For more information, see docs/FORK_STRATEGY.md
EOF
}

# Main execution
main() {
    check_git_repo
    
    case "${1:-}" in
        --auto)
            auto_sync
            ;;
        --dry-run)
            dry_run
            ;;
        --continue)
            continue_sync
            ;;
        --help)
            show_help
            ;;
        *)
            show_help
            exit 1
            ;;
    esac
}

main "$@"
