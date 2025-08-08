#!/bin/sh

# Git Credentials Update Script
# Updates author name and email in recent commits for a given repository
# POSIX compatible shell script

set -e  # Exit on any error

# Color codes for output (if terminal supports it)
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    NC=''
fi

# Function to print colored output
print_color() {
    color="$1"
    shift
    printf "${color}%s${NC}\n" "$*"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 <repository_directory> <old_email> <new_name> <new_email>"
    echo ""
    echo "Parameters:"
    echo "  repository_directory  Path to the git repository"
    echo "  old_email            Email address to replace (commits with this email will be updated)"
    echo "  new_name             New author name to set"
    echo "  new_email            New email address to set"
    echo ""
    echo "Example:"
    echo "  $0 /path/to/repo old@example.com \"John Doe\" new@example.com"
    echo ""
    echo "Note: This script will check the last 50 commits and update any that match the old email."
    echo "      It will show you what changes will be made before applying them."
}

# Check if correct number of arguments provided
if [ $# -ne 4 ]; then
    print_color "$RED" "Error: Incorrect number of arguments"
    echo ""
    show_usage
    exit 1
fi

# Assign arguments to variables
REPO_DIR="$1"
OLD_EMAIL="$2"
NEW_NAME="$3"
NEW_EMAIL="$4"

# Validate repository directory
if [ ! -d "$REPO_DIR" ]; then
    print_color "$RED" "Error: Repository directory '$REPO_DIR' does not exist"
    exit 1
fi

# Check if it's a git repository
if [ ! -d "$REPO_DIR/.git" ]; then
    print_color "$RED" "Error: '$REPO_DIR' is not a git repository"
    exit 1
fi

# Change to repository directory
cd "$REPO_DIR"

print_color "$BLUE" "=== Git Credentials Update Script ==="
echo ""
print_color "$YELLOW" "Repository: $REPO_DIR"
print_color "$YELLOW" "Looking for commits with email: $OLD_EMAIL"
print_color "$YELLOW" "Will update to: $NEW_NAME <$NEW_EMAIL>"
echo ""

# Check if there are any commits
if ! git rev-parse HEAD >/dev/null 2>&1; then
    print_color "$RED" "Error: No commits found in repository"
    exit 1
fi

# Find commits with the old email in the last 50 commits
print_color "$BLUE" "Scanning last 50 commits for matching email addresses..."
echo ""

# Get list of commits with the old email (last 50 commits)
# Check both author and committer emails
MATCHING_COMMITS=$(git log --max-count=50 --pretty=format:"%H" --perl-regexp --grep="." --all-match | \
    while IFS= read -r commit_hash; do
        if [ -n "$commit_hash" ]; then
            author_email=$(git log --max-count=1 --pretty=format:"%ae" "$commit_hash" 2>/dev/null || true)
            committer_email=$(git log --max-count=1 --pretty=format:"%ce" "$commit_hash" 2>/dev/null || true)
            if [ "$author_email" = "$OLD_EMAIL" ] || [ "$committer_email" = "$OLD_EMAIL" ]; then
                echo "$commit_hash"
            fi
        fi
    done | head -50)

if [ -z "$MATCHING_COMMITS" ]; then
    print_color "$GREEN" "No commits found with email '$OLD_EMAIL' in the last 50 commits."
    print_color "$GREEN" "Nothing to update."
    exit 0
fi

# Count matching commits
COMMIT_COUNT=$(echo "$MATCHING_COMMITS" | wc -l | tr -d ' ')

print_color "$YELLOW" "Found $COMMIT_COUNT commit(s) with email '$OLD_EMAIL':"
echo ""

# Show details of commits that will be updated
echo "$MATCHING_COMMITS" | while IFS= read -r commit_hash; do
    if [ -n "$commit_hash" ]; then
        author_info=$(git log --max-count=1 --pretty=format:"%an <%ae>" "$commit_hash")
        committer_info=$(git log --max-count=1 --pretty=format:"%cn <%ce>" "$commit_hash")
        commit_subject=$(git log --max-count=1 --pretty=format:"%h - %s [%ad]" --date=short "$commit_hash")

        print_color "$YELLOW" "  $commit_subject"
        author_email=$(git log --max-count=1 --pretty=format:"%ae" "$commit_hash")
        committer_email=$(git log --max-count=1 --pretty=format:"%ce" "$commit_hash")

        if [ "$author_email" = "$OLD_EMAIL" ]; then
            print_color "$YELLOW" "    Author: $author_info ← WILL UPDATE"
        else
            print_color "$YELLOW" "    Author: $author_info"
        fi

        if [ "$committer_email" = "$OLD_EMAIL" ]; then
            print_color "$YELLOW" "    Committer: $committer_info ← WILL UPDATE"
        else
            print_color "$YELLOW" "    Committer: $committer_info"
        fi
    fi
done

echo ""
print_color "$BLUE" "These commits will be updated to use:"
print_color "$BLUE" "  Author: $NEW_NAME <$NEW_EMAIL>"
echo ""

# Ask for confirmation
printf "Do you want to proceed with updating these commits? (y/N): "
read -r confirmation
case "$confirmation" in
    [Yy]|[Yy][Ee][Ss])
        ;;
    *)
        print_color "$YELLOW" "Operation cancelled by user."
        exit 0
        ;;
esac

echo ""
print_color "$BLUE" "Updating commits..."

# Create the filter script for git filter-branch
FILTER_SCRIPT="
if [ \"\$GIT_AUTHOR_EMAIL\" = \"$OLD_EMAIL\" ]; then
    export GIT_AUTHOR_NAME=\"$NEW_NAME\"
    export GIT_AUTHOR_EMAIL=\"$NEW_EMAIL\"
    echo \"Updated author: \$GIT_COMMIT_SHA - \$GIT_AUTHOR_NAME <\$GIT_AUTHOR_EMAIL>\"
fi
if [ \"\$GIT_COMMITTER_EMAIL\" = \"$OLD_EMAIL\" ]; then
    export GIT_COMMITTER_NAME=\"$NEW_NAME\"
    export GIT_COMMITTER_EMAIL=\"$NEW_EMAIL\"
    echo \"Updated committer: \$GIT_COMMIT_SHA - \$GIT_COMMITTER_NAME <\$GIT_COMMITTER_EMAIL>\"
fi
"

# Backup current branch
CURRENT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || echo "HEAD")
print_color "$BLUE" "Current branch: $CURRENT_BRANCH"

# Get the commit hash from 50 commits ago (or first commit if less than 50)
SINCE_COMMIT=$(git log --max-count=50 --pretty=format:"%H" | tail -1)
if [ -n "$SINCE_COMMIT" ]; then
    SINCE_COMMIT="$SINCE_COMMIT^"
else
    SINCE_COMMIT=""
fi

# Check for existing filter-branch backup refs
if git for-each-ref refs/original/ >/dev/null 2>&1; then
    print_color "$YELLOW" "Found existing git filter-branch backup refs."
    printf "Do you want to remove them and continue? This will permanently delete the backup. (y/N): "
    read -r cleanup_confirmation
    case "$cleanup_confirmation" in
        [Yy]|[Yy][Ee][Ss])
            print_color "$BLUE" "Removing existing backup refs..."
            git for-each-ref --format='delete %(refname)' refs/original/ | git update-ref --stdin
            print_color "$GREEN" "✓ Backup refs removed"
            ;;
        *)
            print_color "$YELLOW" "Operation cancelled. To manually clean up backup refs, run:"
            print_color "$YELLOW" "  git for-each-ref --format='delete %(refname)' refs/original/ | git update-ref --stdin"
            exit 0
            ;;
    esac
fi

# Perform the rewrite using git filter-branch
print_color "$BLUE" "Executing git filter-branch..."
echo ""

# Use git filter-branch to rewrite history
if [ -n "$SINCE_COMMIT" ]; then
    if ! FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch \
        --env-filter "$FILTER_SCRIPT" \
        --tag-name-filter cat \
        -- "$SINCE_COMMIT..HEAD" 2>/dev/null; then
        print_color "$RED" "Error: git filter-branch failed"
        print_color "$RED" "This might happen if there are no commits to rewrite in the specified range"
        exit 1
    fi
else
    if ! FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch \
        --env-filter "$FILTER_SCRIPT" \
        --tag-name-filter cat \
        -- --all 2>/dev/null; then
        print_color "$RED" "Error: git filter-branch failed"
        exit 1
    fi
fi

echo ""
print_color "$GREEN" "✓ Commits have been successfully updated!"
echo ""

# Show the updated commits
print_color "$BLUE" "Verification - Updated commits now show:"
echo ""

echo "$MATCHING_COMMITS" | while IFS= read -r commit_hash; do
    if [ -n "$commit_hash" ]; then
        # Find the new commit hash after filter-branch
        new_commit_info=$(git log --max-count=50 --pretty=format:"%h - %s (%an <%ae>) [%ad]" --date=short | grep -F "$(git log --max-count=1 --pretty=format:"%s" "$commit_hash" 2>/dev/null || echo "COMMIT_NOT_FOUND")" | head -1 || echo "Could not find updated commit")
        print_color "$GREEN" "  $new_commit_info"
    fi
done

echo ""
print_color "$BLUE" "=== Summary ==="
print_color "$GREEN" "✓ Updated $COMMIT_COUNT commit(s)"
print_color "$GREEN" "✓ Changed email from: $OLD_EMAIL"
print_color "$GREEN" "✓ Changed to: $NEW_NAME <$NEW_EMAIL>"
echo ""

print_color "$YELLOW" "Important notes:"
print_color "$YELLOW" "- A backup of your original branch is stored as 'refs/original/'"
print_color "$YELLOW" "- If you need to undo changes: git reset --hard refs/original/$CURRENT_BRANCH"
print_color "$YELLOW" "- To remove backup refs: git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin"
print_color "$YELLOW" "- If this is a shared repository, you'll need to force push: git push --force-with-lease"

echo ""
print_color "$GREEN" "Operation completed successfully!"
