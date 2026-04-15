#!/bin/bash
# ============================================================
# agent-review.sh — Code review agent local
# Usage: ./scripts/agent-review.sh [base-branch] [--fix]
# ============================================================

set -e

BASE_BRANCH=${1:-develop}
MODE=${2:-""}

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}🔍 Agent Review — diff vs ${BASE_BRANCH}${NC}\n"

if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo -e "${RED}❌ Pas dans un repo git${NC}"
  exit 1
fi

DIFF=$(git diff ${BASE_BRANCH}...HEAD -- '*.ts' '*.tsx' '*.js' '*.jsx' '*.css')

if [ -z "$DIFF" ]; then
  echo -e "${YELLOW}⚠️  Aucun changement vs ${BASE_BRANCH}${NC}"
  exit 0
fi

FILES_CHANGED=$(git diff ${BASE_BRANCH}...HEAD --name-only -- '*.ts' '*.tsx' '*.js' '*.jsx' '*.css' | wc -l | tr -d ' ')
echo -e "📁 ${FILES_CHANGED} fichier(s) modifié(s)\n"

# Charger le contexte agent
CONTEXT=""
for f in .agent/*.md; do
  [ -f "$f" ] && CONTEXT="${CONTEXT}\n\n## $(basename $f)\n$(cat $f)"
done

if [ "$MODE" = "--fix" ]; then
  echo -e "${YELLOW}⚡ Mode auto-fix activé — les corrections seront appliquées${NC}\n"

  claude "
Tu es un code reviewer expert. Voici le contexte du projet :
${CONTEXT}

Voici le git diff à corriger (vs ${BASE_BRANCH}) :
${DIFF}

INSTRUCTIONS :
1. Identifie tous les problèmes (sécurité critique, accessibilité, standards, web vitals, duplication)
2. Pour chaque problème CRITICAL ou IMPORTANT : applique la correction directement dans le fichier
3. Après chaque correction, note le fichier modifié et pourquoi
4. Une fois toutes les corrections appliquées, lance : npm test
5. Si des tests échouent après une correction : revert uniquement ce fichier et explique pourquoi
6. Produis un rapport final : corrections appliquées / corrections revertées / problèmes INFO laissés pour revue manuelle

Sévérités :
- CRITICAL : sécurité, données exposées → toujours corriger
- IMPORTANT : accessibilité, standards majeurs → corriger
- INFO : style, optimisations mineures → signaler seulement, ne pas toucher
"

else
  echo -e "📋 Mode propose — rapport uniquement, aucune modification\n"

  claude --print "
Tu es un code reviewer expert. Voici le contexte du projet :
${CONTEXT}

Voici le git diff à analyser (vs ${BASE_BRANCH}) :
${DIFF}

Pour chaque fichier modifié, analyse selon ces critères :
1. 🔐 Sécurité
2. ♿ Accessibilité
3. ⚡ Web Vitals (LCP/CLS/INP)
4. 📐 Standards & conventions
5. 🔁 Duplication de code
6. 🎨 Design system (composants non utilisés)

Format de sortie pour chaque problème :
[CRITICAL|IMPORTANT|INFO] fichier:ligne — description courte
→ Fix suggéré : code ou explication concrète

À la fin : résumé avec comptage par sévérité.
Si aucun problème : output LGTM ✅
"
fi
