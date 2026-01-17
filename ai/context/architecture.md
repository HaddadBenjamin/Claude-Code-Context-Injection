## Frontend architecture – Domain Driven Design

The frontend follows a strict domain-based architecture.

### Domains

- Each folder in `src/domains/` represents a business domain (bounded context).
- A domain contains all code related to a specific business capability.

Domains MUST NOT:
- depend on other domains
- contain generic or reusable utilities

### Shared

`src/shared/` contains ONLY cross-project reusable code.

Rules:
- No business logic
- No domain-specific naming
- No dependency on `domains`
- Code must be portable to another project without modification

### Layout

`src/layout/` contains application shell and global UI structure.

No business logic is allowed.

### Placement rules (mandatory)

When creating code, always apply this decision tree:
1. Business-specific → domains/<domain>
2. Cross-project reusable → shared
3. App shell / structure → layout
4. Otherwise → raise an architectural concern
