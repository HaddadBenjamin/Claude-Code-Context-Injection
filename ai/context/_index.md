# Index des Fichiers de Contexte

17 fichiers — référence rapide pour savoir quoi charger et pourquoi.

---

## Architecture & Structure

| Fichier | Contenu | Charger quand |
|---------|---------|---------------|
| `architecture.md` | DDD, bounded contexts, domains, shared, placement rules | Toujours en FEATURE / ARCHITECTURE |
| `monorepo.md` | Structure des packages (design-system, shared, webapp) | Feature cross-packages |
| `stack.md` | Stack technique + librairies interdites/approuvées | Feature, debug dépendance |

---

## Standards de Code

| Fichier | Contenu | Charger quand |
|---------|---------|---------------|
| `standards.md` | Principes généraux, TypeScript, React, Hooks, naming | Toute écriture de code |
| `typescript-patterns.md` | Unions discriminées, generics, Zod, branded types | TS avancé, review TS |
| `linting.md` | Config ESLint et règles custom | Avant commit, review |

---

## React & Patterns

| Fichier | Contenu | Charger quand |
|---------|---------|---------------|
| `component-patterns.md` | Structure composants, composition, memoïsation | Tout nouveau composant |
| `rendering-strategy.md` | SSG / ISR / SSR / CSR — arbre de décision | Nouvelle page, choix de rendu |
| `state-management.md` | Redux Toolkit, React Query, useState — quand utiliser quoi | Feature avec state |

---

## API & Data

| Fichier | Contenu | Charger quand |
|---------|---------|---------------|
| `api.md` | Structure API, apiClient, React Query, mutations, pagination, staleTime | Toute intégration API ou data fetching |
| `error-handling.md` | Niveaux d'erreur, ApiError, boundaries, toast vs inline | Gestion d'erreurs |

---

## Qualité Frontend

| Fichier | Contenu | Charger quand |
|---------|---------|---------------|
| `reviews.md` | Checklist 14 critères | MODE REVIEW (toujours) |
| `testing.md` | Pyramide de tests, MSW, coverage 80%, fixtures | MODE TEST |
| `accessibility.md` | WCAG 2.1 AA, keyboard, ARIA, contrastes | Feature UI, review a11y |
| `security.md` | Tokens, XSS, CSRF, CSP, uploads, secrets | Feature auth/data, review sécurité |
| `seo.md` | Metadata, rendu, sitemap, structured data | Nouvelle page, SEO review |
| `web-vitals.md` | LCP / INP / CLS — règles et outils | MODE PERFORMANCE |

---

## Styles

| Fichier | Contenu | Charger quand |
|---------|---------|---------------|
| `scss_structure.md` | Structure styles globaux et domain | Question SCSS |

---

## Chargement par Mode (résumé)

```
FEATURE    → architecture + monorepo + stack
             + component-patterns + state-management + typescript-patterns
             + rendering-strategy + api + error-handling + standards
             + reviews + accessibility + security + testing + linting

REVIEW     → Tous les fichiers ci-dessus

REFACTOR   → component-patterns + typescript-patterns + state-management
             + error-handling + standards + linting + architecture + testing

TEST       → testing + api + state-management
             + component-patterns + typescript-patterns + error-handling

DEBUG      → error-handling + api + state-management + rendering-strategy
             + standards + typescript-patterns

PERFORMANCE → web-vitals + rendering-strategy + api
              + component-patterns + stack
```
