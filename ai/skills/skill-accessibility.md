---
name: skill-accessibility
description: Réflexes accessibilité WCAG 2.1 AA — s'applique sur tout projet React/Next.js
---

# Accessibility Persona

## Réflexe de base

WCAG 2.1 niveau AA est la cible obligatoire.
Tester mentalement chaque composant interactif avec ces 3 questions :
1. Est-ce accessible au clavier uniquement ?
2. Est-ce compréhensible par un lecteur d'écran ?
3. Est-ce utilisable avec un contraste réduit ou en contexte dégradé ?

## Questions systématiques

- Y a-t-il un `<div>` utilisé comme bouton ou lien ?
- Y a-t-il un `<img>` sans `alt` ?
- Y a-t-il un `<input>` sans `<label>` associé ?
- Y a-t-il un `outline: none` sans style de focus de remplacement ?
- Y a-t-il un modal sans focus trap ?
- Y a-t-il un bouton icon-only sans `aria-label` ?

## Checklist accessibilité

### HTML sémantique
- [ ] `<button>` pour les actions, `<a href>` pour la navigation. Non interchangeables.
- [ ] Éléments sémantiques utilisés : `<nav>`, `<main>`, `<header>`, `<footer>`, `<section>`, `<article>`.
- [ ] Jamais de `<div role="button">` quand `<button>` est possible.

### Clavier
- [ ] Tous les éléments interactifs accessibles via Tab/Shift+Tab/Enter/Space/Escape.
- [ ] Ordre de tabulation logique et cohérent avec l'ordre visuel.
- [ ] `tabIndex` uniquement 0 ou -1. Jamais de valeur positive.
- [ ] Modal : focus trapé à l'intérieur, restauré au trigger à la fermeture.

### Focus
- [ ] `:focus-visible` visible sur tous les éléments interactifs.
- [ ] Jamais `outline: none` sans style de focus de remplacement.
- [ ] Skip link en premier enfant du `<body>` : `<a href="#main-content">Skip to main content</a>`.

### Images et médias
- [ ] Images de contenu : `alt` descriptif. Jamais `alt="image"`.
- [ ] Images décoratives : `alt=""` et `aria-hidden="true"`.
- [ ] Icônes SVG interactives : `aria-label` ou `<title>` dans le SVG.

### Formulaires
- [ ] Chaque `<input>`, `<select>`, `<textarea>` a un `<label>` associé.
- [ ] Erreurs liées aux inputs via `aria-describedby`.
- [ ] Champs requis : `aria-required="true"` + indicateur visuel.

### Contraste
- [ ] Ratio minimum 4.5:1 pour le texte normal.
- [ ] Ratio minimum 3:1 pour le texte large et les composants UI.
- [ ] Information jamais transmise par la couleur seule.

### Modals
- [ ] `role="dialog"` + `aria-modal="true"` + `aria-labelledby`.
- [ ] Focus trap actif quand ouvert.
- [ ] Fermeture sur Escape.

## Signaux d'alarme

- Élément interactif non accessible clavier → **Blocker**.
- `<img>` de contenu sans `alt` → **Blocker**.
- `<input>` sans `<label>` → **Blocker**.
- `outline: none` sans remplacement → **Blocker**.
- Contraste < 4.5:1 → **Blocker**.
- `<div>` utilisé comme bouton/lien → **Blocker**.
- Bouton icon-only sans `aria-label` → **Blocker**.
- Modal sans focus trap → **Blocker**.
