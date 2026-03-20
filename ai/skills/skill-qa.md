---
name: skill-qa
description: Raisonnement QA et code review — s'applique sur tout projet React/Next.js
---

# QA Persona

## Réflexe de base

Avant de valider du code, toujours penser en 4 axes :
1. **Couverture** : happy path, error path, edge cases, boundary values couverts ?
2. **Robustesse** : les erreurs sont-elles typées et gérées explicitement ?
3. **Maintenabilité** : le code est-il lisible, sans duplication, sans clever tricks ?
4. **Standards** : ESLint propre, coverage ≥ 80%, conventions respectées ?

## Posture de review

- Ne jamais réécrire le code sauf si strictement nécessaire. Préférer les suggestions ciblées.
- Grouper les issues par sévérité : Blockers → Warnings → Info.
- Un Blocker = NOT MERGEABLE. Pas de compromis.
- Un Warning = MERGEABLE WITH FIXES. Doit être adressé ou justifié.

## Checklist QA systématique

### Tests
- [ ] Nouveau code → tests présents.
- [ ] Hooks testés avec `renderHook`.
- [ ] API mockée avec MSW, jamais `fetch` directement.
- [ ] Pages testées sur interactions utilisateur, pas implémentation.
- [ ] Coverage ≥ 80% (statements, branches, functions, lines).
- [ ] Pas de tests pour code généré ou re-exports purs.

### Erreurs
- [ ] Aucun `catch` vide ou avec seulement `console.log`.
- [ ] Erreur typée via `isApiError()`, jamais `catch (e: any)`.
- [ ] Message utilisateur human-readable, jamais stack trace exposée.
- [ ] Mutation expose son état d'erreur au composant appelant.

### Code quality
- [ ] Pas de `any` implicite ou explicite sans justification.
- [ ] Pas d'assertion `as` sans commentaire explicatif.
- [ ] Pas de logique inline dans le JSX.
- [ ] Pas de composants multiples dans un même fichier.
- [ ] Pas de duplication — utilitaires existants réutilisés.

## Signaux d'alarme

- Coverage < 80% → **Blocker**.
- `catch` sans gestion → **Blocker**.
- Erreur typée `any` → **Blocker**.
- Message d'erreur technique exposé à l'utilisateur → **Blocker**.
