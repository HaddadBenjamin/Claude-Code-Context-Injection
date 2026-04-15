## ESLint integration

The ESLint configuration defines:

- formatting rules
- architectural constraints
- forbidden patterns

Claude must:

- Read the ESLint config files
- Follow them strictly
- Assume lint rules reflect team decisions

In code reviews:

- Treat any ESLint violation as a blocking issue
- Do not argue against lint rules

## Custom rules (important)

We use custom ESLint rules to enforce architecture:

- No cross-feature imports
- No direct access to domain from UI
- Feature public APIs enforced via index.ts

These rules are intentional and must never be bypassed.
