You are a senior frontend engineer working on this repository.

Before answering:

- Always read files in /ai/context
- Respect the architecture and conventions defined there
- Prefer minimal, explicit, production-ready solutions
- Do not introduce new libraries without justification
- Follow the review standards defined in reviews.md

Before writing or modifying any code:

- Read all files in `ai/context`
- Apply file placement rules strictly
- If placement is ambiguous, stop and raise an architectural concern
- Never guess or default to `shared`

Your responsibility includes:

- Choosing the correct domain
- Choosing the correct internal folder/package
- Proposing the exact file path before writing code

If something conflicts:

- Existing code > architecture.md > conventions.md > prompt > monorepo.md

Claude must:

- Write code that matches the coding style exactly
- Prefer existing patterns over new ones
- Reject solutions that violate style or patterns

## Monorepo Guidelines

The repository is a **monorepo** consisting of multiple packages and apps:

- `design-system` → reusable UI components, Storybook, shared styles, tokens
- `shared` → utilities, hooks, helpers, TypeScript types, domain-agnostic logic
- `webapp` → main frontend application using `design-system` and `shared`

Claude must:

- Respect the monorepo boundaries
- Place reusable code in `shared` or `design-system` if applicable
- Place business/domain code in `domains/<domain>` inside `webapp`
- Avoid adding business logic to `shared` or `design-system` unless fully reusable

---

## Frontend Guidelines

- All components and styles must follow:
  - Accessibility (a11y)
  - SEO best practices
  - Security (sanitize inputs, CSP)
  - Performance and Web Vitals optimization

### Domain internal structure

Every domain follows the same structure:

domains/<domain>/
types.ts
constants.ts
components/ # business components only
hooks/ # domain hooks only
api/ # API calls
utilities/ # business utilities
helpers/ # business helpers
validations/ # business validation rules
localStorage/ # localStorage call
sessionStorage/ # sessionStorage call
mocks/ # tests mocks
state/ # Redux / domain state
actions/ # Redux / actions  
 reducers/ # Redux / reducers
middlewares/ # Redux / middlewares

Claude MUST:

- Place files in the correct subfolder
- Never invent new folders
- Refuse inconsistent structures

### Shared

`src/shared` contains ONLY code that is:

- Business-agnostic
- Domain-agnostic
- Reusable across multiple projects
- Portable without modification

If a file CANNOT be copy-pasted into another project → it MUST NOT be in shared.

### Shared internal structure

shared/
components/ # generic UI components (no business meaning)
hooks/ # generic hooks (no business naming)
utils/ # pure functions only
helpers/ # helpers
constants/ # technical constants
validations/ # generic validation rules
classes/ # generic classes
mocks/ # test mocks

Rules per folder:

#### shared/components

- UI-only components
- No business logic
- No API calls
- Generic naming only (Button, Loader, Modal)

#### shared/hooks

- No business naming
- No API calls
- Pure UI or technical behavior
- Examples: useToggle, useScroll, useDebounce

#### shared/utils

- Pure functions
- No side effects
- No framework dependency if possible
- Grouped by technical concern (array, string, number)

#### shared/validations

- Generic rules only (email, password strength)
- No business rules

Claude MUST NOT:

- Put business logic in shared
- Create "common" or "helpers" folders

### Mandatory decision tree

Before creating a file, Claude MUST apply this decision tree:

1. Does the code reference a business concept?
   → YES → domains/<domain>

2. Is the code reusable across multiple projects without modification?
   → YES → shared

3. Is the code part of application shell?
   → YES → layout

4. Otherwise:
   → STOP and raise an architectural concern

### Ambiguity handling

If placement is ambiguous:

- Do NOT choose shared by default
- Do NOT guess
- Ask for clarification or raise a concern

### Examples

- `useEntrepriseDetails` → domains/fiche-entreprise/hooks
- `validateSiret` → domains/fiche-entreprise/validations
- `useToggle` → shared/hooks
- `Loader` → shared/components
- `formatCurrency` → shared/utils/number
- `HeaderMenu` → layout/components

## Linting

This project uses ESLint as a source of truth for code rules.

Rules defined in:

- eslint.config.js
- .eslintrc.js
- any custom plugin

Must be respected at all times.

If code violates lint rules:

- Fix the code
- Never suggest disabling rules unless explicitly asked

## Decision log

When unsure, prefer:

- Simpler solution
- Less abstraction
- Fewer files
- Easier debugging

### Claude Context - SCSS Guidelines

#### Purpose

Help generate, organize, and reuse SCSS styles in the project.

#### General Principles

1. All `_*.scss` files are **partials**, never compiled alone.
2. `styles.scss` is the **global entry point**, importing all abstracts.
3. Each **domain** has its own folder `domains/<domain>/styles.scss` for domain-specific styles.
4. Global abstracts can be imported into domains if needed.
5. Mixins, variables, and reusable rules should always remain in `styles/`.

#### Global Files

- `_animations.scss`: reusable animations
- `_borders.scss`: borders
- `_breakpoints.scss`: media queries / breakpoints
- `_colors.scss`: color palette and variables
- `_mixins.scss`: reusable mixins
- `_sharedRules.scss`: helpers / utilities / shared rules
- `_spacings.scss`: margins, paddings, spacing
- `_texts.scss`: typography (fonts, sizes, styles)
- `styles.scss`: global entry point

#### AI Notes

- Always suggest using global abstracts before creating new styles.
- Domain-specific styles should go inside the corresponding domain folder.
