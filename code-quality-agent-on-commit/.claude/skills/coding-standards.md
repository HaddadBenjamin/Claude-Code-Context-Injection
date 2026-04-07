---
name: coding-standards
description: Enforce project coding standards and detect anti-patterns. Use when reviewing any TypeScript/React code changes.
---

# Coding Standards

## TypeScript
- Pas de `any` — utiliser `unknown` + type guard si nécessaire
- Interfaces pour les props de composants, types pour les unions/intersections
- Return types explicites sur les fonctions publiques
- Enums string > enums numériques (debuggabilité)
- Pas d'assertion `!` non-null sans commentaire justificatif

## React
- Pas de `useEffect` pour synchroniser du state dérivé → calcul direct dans le render
- `useCallback` / `useMemo` uniquement si profiling montre un gain (pas par défaut)
- Keys dans les listes : jamais l'index si la liste est réordonnée/filtrée
- Pas de props drilling > 2 niveaux → context ou state manager

## Duplication
- Logique identique dans 2+ composants → extraire en hook custom
- JSX identique à > 5 lignes dans 2+ endroits → extraire en composant
- Constantes magiques répétées → extraire dans `/constants`

## Naming
- Handlers : `handleXxx` (pas `onXxx` sauf pour les props)
- Booleans : préfixe `is`, `has`, `can`, `should`
- Pas d'abréviations obscures (`usr`, `btn`, `cfg` → `user`, `button`, `config`)

## Structure fichiers
- Un seul composant exporté par défaut par fichier
- Types/interfaces dans le même fichier si utilisés uniquement là, sinon dans `/types`
- Tests co-localisés : `ComponentName.test.tsx` à côté de `ComponentName.tsx`
