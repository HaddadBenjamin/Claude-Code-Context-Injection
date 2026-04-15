# Security Rules

## Critique (bloque la PR)
- Pas de secrets, tokens, clés API dans le code source (même en commentaire)
- Pas de `dangerouslySetInnerHTML` sans sanitisation explicite (DOMPurify)
- Pas d'eval() ou Function() avec input utilisateur
- Validation obligatoire côté serveur, jamais uniquement côté client
- Pas de données sensibles dans localStorage (tokens auth → httpOnly cookies)

## Important
- Toujours vérifier l'ownership avant d'exposer une resource (ex: `/api/users/:id`)
- Headers de sécurité requis sur les routes API (CSP, X-Frame-Options)
- Dépendances : pas d'import de packages non listés dans package.json
- SQL : paramètres bindés uniquement, jamais de string concatenation

## Patterns à détecter
- `localStorage.setItem('token', ...)` → critique
- `innerHTML = userInput` → critique
- `fetch('/api/' + userId)` sans vérification auth → important
- `console.log(user.password)` → critique
