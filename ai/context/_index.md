# Index des Fichiers de Contexte

Référence rapide — quel fichier charger et pourquoi.

---

## Architecture & Structure

| Fichier | Contenu | Charger quand |
|---------|---------|---------------|
| `architecture.md` | DDD, bounded contexts, règles de placement | Toujours en mode FEATURE / ARCHITECTURE |
| `domains.md` | Définition d'un domaine, ce qu'il peut contenir | Feature ou question sur le périmètre d'un domaine |
| `monorepo.md` | Structure des packages (design-system, shared, webapp) | Feature cross-packages, import questions |
| `shared.md` | Règles strictes de `shared/` | Quand on hésite à mettre du code dans shared |
| `stack.md` | Stack technique complète + librairies interdites | Feature, debug de dépendance, choix technique |

---

## Standards de Code

| Fichier | Contenu | Charger quand |
|---------|---------|---------------|
| `code-standards.md` | Principes généraux de lisibilité et simplicité | Refactor, review |
| `conventions.md` | Nommage (composants, hooks, fichiers, booleans) | Toute écriture de code |
| `typescript-patterns.md` | Types discriminés, generics, Zod, branded types | TypeScript avancé, review TS |
| `linting.md` | Configuration ESLint et règles custom | Avant commit, review |
| `patterns.md` | Patterns approuvés (data fetching, state, erreurs, perf) | Feature, refactor |

---

## React & Composants

| Fichier | Contenu | Charger quand |
|---------|---------|---------------|
| `component-patterns.md` | Structure des composants, memoïsation, composition | Tout nouveau composant |
| `rendering-strategy.md` | SSG / ISR / SSR / CSR — arbre de décision | Nouvelle page, question sur le rendu |
| `state-management.md` | Redux Toolkit, React Query, useState — quand utiliser quoi | State question, feature avec state |
| `frontend_guidelines.md` | Point d'entrée global front — référence vers autres fichiers | Overview rapide |

---

## Intégration & API

| Fichier | Contenu | Charger quand |
|---------|---------|---------------|
| `api-integration.md` | Structure appels API, apiClient, naming, CSRF, Swagger | Nouvelle intégration API |
| `data-fetching-pattern.md` | React Query v5, query key factory, mutations, optimistic | Tout data fetching |
| `error-handling.md` | Niveaux d'erreur, ApiError class, boundaries, toast vs inline | Gestion d'erreurs |

---

## Qualité & Standards Frontend

| Fichier | Contenu | Charger quand |
|---------|---------|---------------|
| `reviews.md` | Checklist complète 14 critères de review | MODE REVIEW (toujours) |
| `testing.md` | Pyramide de tests, MSW, coverage 80%, fixtures | MODE TEST, avant toute écriture de test |
| `accessibility.md` | WCAG 2.1 AA, keyboard, ARIA, contrastes | Feature avec UI, review a11y |
| `security.md` | Tokens, XSS, CSRF, CSP, uploads, secrets | Feature avec auth/data, review sécurité |
| `seo.md` | Metadata, rendu, sitemap, structured data | Nouvelle page, SEO review |
| `web-vitals.md` | LCP / INP / CLS — règles et outils | MODE PERFORMANCE |
| `scss_structure.md` | Structure styles globaux et domaine | SCSS question |

---

## Chargement par Mode (résumé)

```
FEATURE    → architecture + domains + conventions + monorepo + shared + stack
             + patterns + component-patterns + data-fetching + state + typescript
             + rendering + api-integration + error-handling + frontend_guidelines
             + reviews + accessibility + security + testing + linting

REVIEW     → Tous les fichiers ci-dessus

REFACTOR   → patterns + component-patterns + typescript-patterns + state-management
             + error-handling + code-standards + conventions + linting + architecture
             + testing

TEST       → testing + patterns + data-fetching-pattern + state-management
             + component-patterns + typescript-patterns + api-integration + error-handling

DEBUG      → error-handling + patterns + data-fetching-pattern + state-management
             + rendering-strategy + code-standards + typescript-patterns

PERFORMANCE → web-vitals + rendering-strategy + data-fetching-pattern
              + patterns + component-patterns + stack
```
