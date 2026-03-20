---
name: skill-security
description: Réflexes sécurité frontend — s'applique sur tout projet React/Next.js
---

# Security Persona

## Réflexe de base

Le frontend est une surface publique. Ne jamais lui faire confiance comme boundary de sécurité.
Toute validation critique et autorisation se fait côté serveur.
Rôle du frontend : minimiser la surface d'attaque, protéger les données utilisateur, prévenir l'injection.

## Questions systématiques à poser sur tout code

- Y a-t-il un token ou un secret qui pourrait finir côté client ?
- Y a-t-il du HTML dynamique rendu sans DOMPurify ?
- Y a-t-il une variable `NEXT_PUBLIC_` avec une clé d'API ?
- Y a-t-il un `eval()` ou `new Function()` ?
- Y a-t-il un upload de fichier sans validation MIME + taille ?

## Règles absolues

- Access token : **in-memory uniquement** via `tokenStore`. Jamais localStorage/sessionStorage.
- Refresh token : **cookie HttpOnly + Secure + SameSite=Strict** uniquement.
- `dangerouslySetInnerHTML` : **uniquement avec `DOMPurify.sanitize()`**.
- API keys : **server-side uniquement** via Server Actions ou Route Handlers.
- Fichiers `.env` avec secrets : **jamais committés**.
- Variables `NEXT_PUBLIC_` : **uniquement pour config non-sensible**.

## Checklist sécurité

- [ ] Aucun token/secret dans localStorage, sessionStorage, Redux, Context.
- [ ] `dangerouslySetInnerHTML` uniquement avec DOMPurify.
- [ ] Aucune clé API dans une variable `NEXT_PUBLIC_`.
- [ ] Aucun `eval()` ou `new Function()`.
- [ ] Upload fichier : MIME + extension + taille validés client ET serveur.
- [ ] Appels mutants (non-Server-Action) : CSRF token en header.
- [ ] Headers CSP configurés dans `next.config.js`.
- [ ] Aucun secret dans un fichier `.env` commité.
- [ ] `npm audit` propre (pas de vulnérabilités high/critical).

## Signaux d'alarme immédiats

- Token/secret dans localStorage → **Blocker**.
- `dangerouslySetInnerHTML` sans DOMPurify → **Blocker**.
- Clé API dans `NEXT_PUBLIC_` → **Blocker**.
- `eval()` ou `new Function()` → **Blocker**.
- Secret commité dans le repo → **Blocker**.
- Upload sans validation → **Blocker**.
