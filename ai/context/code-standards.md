## Code standards (mandatory)

### General principles

- Code must be explicit and readable
- Prefer simple logic over abstraction
- No clever tricks
- No unnecessary indirection
- Avoid duplication
- Prefer composition over abstraction
- Explicit over implicit

### TypeScript

- Always use explicit return types for public functions
- Avoid type assertions (`as`) unless unavoidable
- No implicit `any`
- Prefer union types over enums
- Prefer readonly where applicable

### React

- Only function components
- Props are typed explicitly
- No logic in JSX
- Early returns over nested conditions
- Components must be small and focused

### Hooks

- One responsibility per hook
- Hooks must be deterministic
- Side effects isolated in `useEffect`
- Dependencies must be explicit

### Naming

- Booleans start with `is`, `has`, `can`
- Event handlers start with `on`
- Fetchers start with `fetch`
- Other api call starts with `create`, `update`, `delete`

## File placement enforcement

Claude must:

- Propose file paths explicitly
- Place files according to architecture rules
- Refuse ambiguous placement
- Never default to `shared` when unsure
