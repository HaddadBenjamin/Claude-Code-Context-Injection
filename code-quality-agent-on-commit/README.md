# Agent Review Setup

Code review agent local pour Claude Code. Analyse le diff de ta branche vs `develop` selon plusieurs critères.

## Installation

### 1. Copie les fichiers dans ton projet
```bash
cp -r .agent .claude scripts .githooks /ton/projet/
```

### 2. Installe les skills depuis le registry
```bash
./scripts/install-skills.sh
```

### 3. (Optionnel) Active le hook pre-push
```bash
git config core.hooksPath .githooks
```

---

## Usage

### Rapport uniquement (recommandé pour commencer)
```bash
./scripts/agent-review.sh                  # vs develop (défaut)
./scripts/agent-review.sh main             # vs main
```

### Auto-fix + tests
```bash
./scripts/agent-review.sh develop --fix
```
⚠️ Le mode `--fix` modifie tes fichiers directement. Assure-toi d'avoir un état git propre avant.

---

## Structure

```
.agent/                     # Contexte projet (adapte à ton projet)
├── context.md              # Stack, conventions, règles générales
├── design-system.md        # Composants dispo, tokens, anti-patterns
├── security.md             # Règles sécu spécifiques
└── accessibility.md        # Standards a11y (WCAG 2.1 AA)

.claude/skills/             # Skills auto-chargés par Claude Code
├── web-vitals.md           # LCP, CLS, INP — patterns à détecter
└── coding-standards.md     # TypeScript, React, naming, duplication

scripts/
├── agent-review.sh         # Script principal
└── install-skills.sh       # Installe les skills du registry

.githooks/
└── pre-push                # Hook optionnel (déclenche review avant push)
```

---

## Adapter au projet

Le fichier le plus important à modifier : **`.agent/context.md`**

Change la stack, les conventions, et les règles selon ce que ton équipe utilise réellement.

Pour le design system : mets à jour **`.agent/design-system.md`** avec tes vrais composants.
