# Standards de Code

## Principes Généraux

- Code explicite et lisible avant tout
- Logique simple > abstraction
- Pas de tricks, pas d'indirection inutile
- Pas de duplication
- Composition > abstraction
- Explicite > implicite

---

## TypeScript

- Types de retour explicites sur les fonctions publiques
- Jamais d'`any` implicite
- Pas d'assertions (`as`) sauf cas inévitables documentés
- Unions discriminées > enums
- `readonly` partout où applicable
- Zod pour la validation runtime + inférence de types

---

## React

- Function components uniquement (jamais de classes)
- Props typées explicitement, destructurées à l'entrée du composant
- Pas de logique dans le JSX — extraire en variables, early returns, ou helpers
- Early returns > conditions imbriquées
- Composants petits et focalisés
- Ordre dans un composant : useState → hooks custom → useEffect → fonctions internes → JSX
- Un composant par fichier, < 150 lignes de JSX sinon découper

---

## Hooks

- Une responsabilité par hook
- Hooks déterministes
- Effets de bord isolés dans `useEffect`
- Dépendances explicites
- Pas d'appels API directs depuis les composants

---

## Naming

| Cible | Convention | Exemple |
|-------|------------|---------|
| Composants | PascalCase | `ProductCard` |
| Hooks | `useXxx` | `useProducts` |
| Booléens | `is/has/can` | `isLoading`, `hasError` |
| Event handlers | `onXxx` | `onSubmit`, `onClick` |
| Fetchers (GET) | `fetchXxx` | `fetchProducts` |
| Mutations | `create/update/delete` | `createOrder` |
| Fichiers | `index.ts` pour re-exports uniquement | |
| Slices Redux | `xyzSlice.ts` | `authSlice.ts` |
| Selectors | dans `selectors.ts` par domain | |

---

## Placement de Fichier (enforcement)

Claude doit toujours :
- Proposer des chemins de fichiers explicites
- Placer selon les règles d'architecture
- Refuser un placement ambigu
- Jamais defaulter vers `shared` en cas de doute
