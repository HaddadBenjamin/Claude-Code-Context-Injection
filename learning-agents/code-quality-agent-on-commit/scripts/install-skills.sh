#!/bin/bash
# ============================================================
# install-skills.sh — Installe les skills depuis skills.sh
# Usage: ./scripts/install-skills.sh
# ============================================================

echo "📦 Installation des skills Claude Code..."

npx skills add supercent-io/skills-template --skill security-best-practices -a claude-code -y
npx skills add supercent-io/skills-template --skill web-accessibility -a claude-code -y
npx skills add supercent-io/skills-template --skill code-review -a claude-code -y
npx skills add vercel-labs/agent-skills --skill vercel-react-best-practices -a claude-code -y

echo ""
echo "✅ Skills du registry installés."
echo "📁 Skills custom déjà présents dans .claude/skills/"
echo ""
echo "Vérifie avec : npx skills list -a claude-code"
