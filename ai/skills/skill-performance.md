---
name: skill-performance
description: Réflexes Web Vitals et performance — s'applique sur tout projet React/Next.js
---

# Performance Persona

## Réflexe de base

Avant d'optimiser quoi que ce soit : **profiler d'abord, optimiser ensuite**.
Jamais de `React.memo`, `useMemo`, `useCallback` sans mesure préalable.
Identifier d'abord la métrique impactée : LCP / INP / CLS / bundle size.

## Cibles Core Web Vitals

| Métrique | Cible |
|----------|-------|
| LCP | ≤ 2.5s |
| INP | ≤ 200ms |
| CLS | ≤ 0.1 |

## Questions systématiques

- Y a-t-il un `<img>` sans `next/image` ?
- Y a-t-il une image sans dimensions explicites (risque CLS) ?
- Y a-t-il une nouvelle dépendance sans justification de bundle size ?
- Y a-t-il une liste > 50 items sans virtualisation ?
- Y a-t-il du travail synchrone lourd dans un event handler ?
- Y a-t-il un composant lourd sans `React.lazy` + `Suspense` ?

## Checklist performance

### LCP
- [ ] Images hero avec `priority` prop sur `next/image`.
- [ ] Pas de scripts bloquants dans `<head>`.
- [ ] Assets statiques servis via CDN.
- [ ] Images en WebP ou AVIF.

### CLS
- [ ] Toutes les images ont `width` et `height` explicites.
- [ ] `next/image` utilisé partout (gère CLS automatiquement).
- [ ] Fonts chargées avec `font-display: swap`.
- [ ] Skeleton screens pour contenu asynchrone.

### INP
- [ ] Event handlers légers — pas d'appels API synchrones.
- [ ] `startTransition` pour mises à jour non-urgentes (React 18).
- [ ] Calculs lourds dans Web Workers si nécessaire.
- [ ] Inputs debounced avec `useDebounce`.

### Bundle
- [ ] Nouvelle dépendance justifiée (bundlephobia vérifié).
- [ ] Imports nommés uniquement, jamais `import *`.
- [ ] `React.lazy` + `Suspense` sur composants lourds.
- [ ] Listes > 50 items : `@tanstack/react-virtual`.

## Signaux d'alarme

- `<img>` sans `next/image` → **Blocker**.
- Image sans dimensions → **Blocker**.
- Nouvelle dépendance sans justification bundle → **Blocker**.
- `import *` depuis une lib volumineuse → **Warning**.
- Liste > 50 items sans virtualisation → **Warning**.
- Pas de skeleton pour contenu async → **Warning**.
