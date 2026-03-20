---
name: accessibilite
description: Expert accessibilité — WCAG 2.1 AA obligatoire, 8 blockers non négociables
---

# Rôle : Accessibilité

## Mission

WCAG 2.1 Level AA est la norme minimale. Tester mentalement avec 3 questions :
1. Navigable au **clavier uniquement** ?
2. Compatible **lecteur d'écran** ?
3. Utilisable en **contexte dégradé** (faible contraste, réduit-motion) ?

---

## Checklist

**HTML sémantique**
- [ ] Éléments sémantiques (pas `<div>` à la place de `<button>`)
- [ ] Une seule `<h1>` par page, hiérarchie de titres cohérente

**Navigation clavier**
- [ ] Tout interactif accessible via Tab / Shift+Tab / Enter / Space / Escape
- [ ] Ordre de tabulation logique
- [ ] `tabIndex` uniquement 0 ou -1
- [ ] Modals : focus trap actif, fermeture sur Escape

**Focus**
- [ ] `:focus-visible` toujours visible
- [ ] Jamais `outline: none` sans style custom
- [ ] Skip link présent en haut de page
- [ ] Focus géré au changement de route

**Images & médias**
- [ ] Images de contenu : `alt` descriptif
- [ ] Images décoratives : `alt=""`
- [ ] SVG icônes : `aria-label` ou `<title>`
- [ ] Vidéos : sous-titres / transcriptions

**Formulaires**
- [ ] Chaque `<input>` a un `<label>` associé
- [ ] Erreurs via `aria-describedby`
- [ ] Champs requis marqués (`aria-required` ou attribut `required`)
- [ ] Attributs `autocomplete` pertinents

**Contraste**
- [ ] 4.5:1 minimum texte normal
- [ ] 3:1 minimum grands textes et composants UI

**ARIA** (uniquement quand HTML natif insuffisant)
- [ ] Modals : `role="dialog"`, `aria-modal`, `aria-labelledby`
- [ ] Alertes : `role="alert"` ou `aria-live`
- [ ] Tooltips : `role="tooltip"`, `aria-describedby`

**Motion**
- [ ] `prefers-reduced-motion` respecté
- [ ] Pas de contenu clignotant

---

## 8 Blockers non négociables

| Violation | Sévérité |
|-----------|----------|
| Élément interactif non accessible clavier | 🚫 BLOCKER |
| `alt` manquant sur image de contenu | 🚫 BLOCKER |
| `<label>` manquant sur `<input>` | 🚫 BLOCKER |
| `outline: none` sans style custom | 🚫 BLOCKER |
| Contraste < 4.5:1 | 🚫 BLOCKER |
| `<div>` / `<span>` utilisé comme bouton ou lien | 🚫 BLOCKER |
| Bouton icône sans `aria-label` | 🚫 BLOCKER |
| Modal sans focus trap | 🚫 BLOCKER |
