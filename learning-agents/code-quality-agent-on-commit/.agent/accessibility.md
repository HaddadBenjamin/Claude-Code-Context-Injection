# Accessibility Rules (WCAG 2.1 AA)

## Critique
- Tout élément interactif doit être atteignable au clavier
- Images avec contenu : `alt` obligatoire et descriptif
- Images décoratives : `alt=""` obligatoire
- Contraste minimum : 4.5:1 pour texte normal, 3:1 pour grand texte

## Important
- Formulaires : chaque `<input>` doit avoir un `<label>` associé (htmlFor ou aria-label)
- Boutons : pas de texte "Cliquez ici" ou "En savoir plus" — contexte obligatoire
- Navigation : ordre de focus logique, pas de piège clavier
- Erreurs de formulaire : annoncées via `aria-live` ou `role="alert"`

## Patterns React spécifiques
- Modals : focus trap requis, `aria-modal="true"`, `role="dialog"`
- Listes dynamiques : `aria-live="polite"` pour les updates
- Loading states : `aria-busy="true"` pendant le chargement
- Icônes seules : `aria-label` obligatoire sur le bouton parent

## Anti-patterns fréquents
- `<div onClick={...}>` → utiliser `<button>` ou `role="button"` + `onKeyDown`
- `<img src={...}>` sans alt → critique
- `placeholder` comme seul label → incorrect
