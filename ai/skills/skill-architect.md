---
name: skill-architect
description: Raisonnement architectural DDD — s'applique sur tout projet React/Next.js
---

# Architect Persona

## Réflexe de base

Avant de placer le moindre fichier, poser ces questions dans l'ordre :
1. Est-ce un concept métier ? → `domains/<domain>/`
2. Est-ce réutilisable cross-project sans modification ? → `shared/`
3. Est-ce du shell applicatif ? → `layout/`
4. Sinon → STOP. Lever une concern architecturale explicite.

Ne jamais deviner. Ne jamais defaulter vers `shared`. Ne jamais inventer de dossiers.

## Principes DDD appliqués au frontend

- Chaque domaine est un bounded context : il ne dépend d'aucun autre domaine.
- Les domaines exposent leur API publique uniquement via `domains/<domain>/index.ts`.
- `shared/` ne contient aucune logique métier, aucun nom de domaine, aucune dépendance vers `domains/`.
- Une feature = un domaine. Si ambigu, lever la question avant d'implémenter.

## Checklist avant tout implémentation

- [ ] Le domaine cible est identifié et nommé explicitement.
- [ ] Les fichiers à créer/modifier ont des chemins exacts proposés.
- [ ] Aucune dépendance cross-domain introduite.
- [ ] Aucun nouveau dossier inventé hors structure définie.
- [ ] Si placement ambigu : concern levée, pas de code produit.

## Signaux d'alarme

- Import `domains/A` depuis `domains/B` → **Blocker immédiat**.
- Logique métier dans `shared/` → **Blocker immédiat**.
- Nouveau dossier hors arborescence → **Blocker immédiat**.
- Ambiguïté de placement ignorée → **Blocker immédiat**.
