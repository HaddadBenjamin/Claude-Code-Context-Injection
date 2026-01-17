#!/bin/bash
# feature.sh
# Usage: ./feature.sh <JIRA_LINK> <FIGMA_LINK> <SWAGGER_LINK>
# Claude Code feature generation using ai/claude.md + ai/context/reviews.md

JIRA_LINK=$1
FIGMA_LINK=$2
SWAGGER_LINK=$3

if [ -z "$JIRA_LINK" ] || [ -z "$FIGMA_LINK" ] || [ -z "$SWAGGER_LINK" ]; then
  echo "Usage: ./feature.sh <JIRA_LINK> <FIGMA_LINK> <SWAGGER_LINK>"
  exit 1
fi

echo "Preparing feature for ticket $JIRA_LINK ..."

# 1️⃣ Optional: Download or export content from JIRA, Figma, Swagger
# (For Claude, you need to provide textual description / JSON / local files)

# 2️⃣ Create temporary context for Claude
TEMP_CONTEXT="feature_context.md"
echo "Ticket: $JIRA_LINK" > $TEMP_CONTEXT
echo "Figma: $FIGMA_LINK" >> $TEMP_CONTEXT
echo "Swagger: $SWAGGER_LINK" >> $TEMP_CONTEXT

# 3️⃣ Run Claude Code to generate feature
claude --generate \
  --files ./ \
  --context ai/context/reviews.md \
  --claude-context ai/claude.md \
  --prompt-file $TEMP_CONTEXT \
  --output "feature_generated_review.md"

echo "Feature generation complete. Check feature_generated_review.md for output."
