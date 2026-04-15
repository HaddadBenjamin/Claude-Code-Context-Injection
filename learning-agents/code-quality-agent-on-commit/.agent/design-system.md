# Design System

<!-- Remplace avec les composants réels de ton design system -->

## Composants disponibles
- `<Button variant="primary|secondary|ghost" size="sm|md|lg" />`
- `<Input label="" error="" />`
- `<Modal isOpen onClose />`
- `<Toast type="success|error|warning" />`
- `<Spinner size="sm|md" />`

## Règles
- Ne jamais créer un bouton HTML natif — toujours `<Button>`
- Ne jamais créer un input natif — toujours `<Input>`
- Les couleurs via tokens uniquement (`text-primary`, `bg-surface`) — pas de valeurs hex directes
- Spacing : multiples de 4px via classes Tailwind (`p-4`, `gap-2`, etc.)

## Anti-patterns détectés fréquemment
- `<button className="bg-blue-500">` → utiliser `<Button variant="primary">`
- `style={{ color: '#333' }}` → utiliser token Tailwind
- Créer un composant modal from scratch → utiliser `<Modal>`
