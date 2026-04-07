---
name: web-vitals
description: Detect patterns that negatively impact Core Web Vitals (LCP, CLS, INP). Use when reviewing React components, image handling, layout code, or any rendering logic.
---

# Web Vitals — Code Patterns

## LCP (Largest Contentful Paint) — cible < 2.5s
- Images hero/above-the-fold : `loading="eager"` + `fetchpriority="high"` obligatoires
- Pas de lazy loading sur les images visibles sans scroll
- Fonts : `font-display: swap` dans le CSS, preload des fonts critiques
- Eviter les chaînes de redirects sur les ressources critiques

## CLS (Cumulative Layout Shift) — cible < 0.1
- Images et vidéos : dimensions `width` + `height` explicites toujours (ou `aspect-ratio`)
- Pas d'injection dynamique de contenu au-dessus du fold sans réservation d'espace
- Skeleton loaders avec dimensions fixes plutôt que contenu qui "push"
- Fonts : `size-adjust` ou `font-display: optional` pour éviter le FOUT

## INP (Interaction to Next Paint) — cible < 200ms
- Handlers d'événements lourds → déléguer au Web Worker ou découper avec `scheduler.yield()`
- Pas de traitement synchrone > 50ms dans un event handler
- `useDeferredValue` pour les updates non-urgentes en React
- Eviter les re-renders en cascade sur les interactions utilisateur

## Patterns React à détecter
- `<img src={...} />` sans width/height → CLS risk
- `useEffect` qui insère du DOM au-dessus du fold → CLS risk
- Event handlers qui font du calcul lourd en synchrone → INP risk
- Chargement conditionnel de fonts → CLS risk
