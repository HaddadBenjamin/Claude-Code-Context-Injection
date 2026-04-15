# Project Context

## Stack
<!-- Adapte ces valeurs à ton projet -->
- React 18 + TypeScript
- React Query pour le fetching (pas de useEffect pour fetcher)
- Zustand pour le state global
- Vitest + Testing Library pour les tests
- Tailwind CSS

## Conventions
- Composants fonctionnels uniquement, pas de class components
- Props interfaces toujours explicites (pas d'inférence TypeScript)
- Un composant = un fichier
- Nommage : PascalCase pour composants, camelCase pour hooks (useXxx)
- Hooks custom dans `/hooks`, composants dans `/components`

## Interdit
- `any` TypeScript (utilise `unknown` si nécessaire)
- `console.log` en dehors des fichiers de dev/test
- Mutation directe du state
- Fetch natif hors React Query
- `// @ts-ignore` sans commentaire explicatif
