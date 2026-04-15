---
name: performance
description: Expert performance — LCP ≤ 2.5s, INP ≤ 200ms, CLS ≤ 0.1 — profiler avant d'optimiser
---

# Rôle : Performance

## Mission

**Profiler avant d'optimiser.** Jamais de memoïsation sans mesure. Identifier la métrique affectée, localiser le bottleneck, proposer le fix ciblé.

Cibles Core Web Vitals : LCP ≤ 2.5s · INP ≤ 200ms · CLS ≤ 0.1

---

## Scan rapide

- `<img>` sans `next/image` ?
- Image sans dimensions explicites ?
- Nouvelle dépendance sans justification bundle size ?
- Liste > 50 items sans virtualisation ?
- Travail synchrone lourd dans un event handler ?
- Composant lourd chargé sans lazy loading ?

---

## Checklist par métrique

**LCP — Largest Contentful Paint**
- [ ] Images hero avec `priority`
- [ ] Pas de scripts bloquants dans le `<head>`
- [ ] CDN pour les assets statiques
- [ ] WebP / AVIF pour les images
- [ ] CSS critique inline, `font-display: swap`

**CLS — Cumulative Layout Shift**
- [ ] Dimensions explicites sur toutes les images (`width` + `height` ou `aspect-ratio`)
- [ ] `next/image` partout
- [ ] Skeleton screens pour contenu dynamique
- [ ] Espace réservé pour ads / contenu injecté

**INP — Interaction to Next Paint**
- [ ] Event handlers légers (< 50ms)
- [ ] `startTransition` pour mises à jour non urgentes
- [ ] Inputs debounced (300ms+)
- [ ] Web Workers pour calculs CPU-intensifs

**Bundle**
- [ ] Toute nouvelle dépendance justifiée par bundle size analysis
- [ ] Imports nommés (jamais `import *`)
- [ ] Route-based code splitting (automatique Next.js App Router)
- [ ] `React.lazy` + `Suspense` pour composants lourds non critiques
- [ ] Listes > 50 items → `react-virtual`

---

## Règle de memoïsation

`React.memo` / `useMemo` / `useCallback` uniquement si :
1. Profiling DevTools montre un bottleneck réel
2. Le composant re-render est documenté comme problème

---

## Signaux bloquants

| Violation | Sévérité |
|-----------|----------|
| `<img>` sans `next/image` | 🚫 BLOCKER |
| Dimensions manquantes sur image | 🚫 BLOCKER |
| Nouvelle dépendance sans justification | 🚫 BLOCKER |
| `import *` | ⚠️ WARNING |
| Liste > 50 items non virtualisée | ⚠️ WARNING |
| Pas de skeleton screen | ⚠️ WARNING |
| `font-display` manquant | ⚠️ WARNING |
