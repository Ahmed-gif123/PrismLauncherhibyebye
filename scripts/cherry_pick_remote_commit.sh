#!/bin/sh

set -eu

if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "Error: run this script inside a git repository."
    exit 1
fi

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 REMOTE_URL COMMIT [COMMIT ...]"
    echo "Example: $0 https://github.com/Ahmed-gif123/PrismLauncherhibyebye.git e8295e93"
    echo "Note: do not type literal angle brackets (< >) around values in Git Bash."
    echo "If you see: bash: syntax error near unexpected token newline, you used <commit_hash> literally."
    exit 1
fi

remote_url="$1"
shift

tmp_remote="tmp-cherry-pick-remote"

cleanup() {
    if git remote get-url "$tmp_remote" >/dev/null 2>&1; then
        git remote remove "$tmp_remote"
    fi
}
trap cleanup EXIT INT TERM

if git remote get-url "$tmp_remote" >/dev/null 2>&1; then
    git remote remove "$tmp_remote"
fi

git remote add "$tmp_remote" "$remote_url"
git fetch "$tmp_remote" --no-tags

for commit in "$@"; do
    case "$commit" in
        *"<"*|*">"*)
            echo "Invalid commit '$commit'. Remove angle brackets and pass the raw hash (e.g. e8295e93)."
            exit 2
            ;;
    esac

    if ! git cat-file -e "$commit^{commit}" 2>/dev/null; then
        echo "Commit '$commit' was not found after fetching '$remote_url'."
        echo "Make sure the hash exists in that remote and wasn't force-pushed away."
        exit 2
    fi
done

for commit in "$@"; do
    echo "Cherry-picking $commit"
    git cherry-pick "$commit"
done
