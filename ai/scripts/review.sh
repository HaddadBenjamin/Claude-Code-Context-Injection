#!/bin/bash
# review.sh
# Usage: ./review.sh <MR_LINK>
# Claude Code review using ai/claude.md + ai/context/reviews.md

MR_LINK=$1

if [ -z "$MR_LINK" ]; then
  echo "Usage: ./review.sh <MR_LINK>"
  exit 1
fi

echo "Fetching MR $MR_LINK ..."

# 1️⃣ Extract MR ID from GitLab link
MR_ID=$(echo $MR_LINK | awk -F'/' '{print $NF}')

# 2️⃣ Fetch MR branch (assumes repo cloned)
git fetch origin merge-requests/$MR_ID/head:mr-$MR_ID
git checkout mr-$MR_ID

# 3️⃣ Prepare list of modified files (diff)
MODIFIED_FILES=$(git diff --name-only origin/main...mr-$MR_ID)

echo "Modified files:"
echo "$MODIFIED_FILES"

# 4️⃣ Run Claude Code review
claude --review \
  --files $MODIFIED_FILES \
  --context ai/context/reviews.md \
  --claude-context ai/claude.md \
  --prompt "Perform a full code review of the modified files following architecture, SCSS, monorepo, accessibility, SEO, Web Vitals, performance and test coverage rules."

