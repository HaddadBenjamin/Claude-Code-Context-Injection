### Domains

A domain represents a business capability (authentication, article, entreprise, etc.).

A file MUST be placed in `domains/<domain>` if:

- It contains business logic
- It is specific to one business concept
- It uses domain-specific naming
- It cannot be reused in another project without modification

Domains MAY contain:
- types.ts
- constants.ts
- components/      # business components only
- hooks/           # domain hooks only
- api/             # API calls
- utilities/       # business utilities
- helpers/         # business helpers
- validations/     # business validation rules
- localStorage/    # localStorage call
- sessionStorage/  # sessionStorage call
- mocks/           # tests mocks
- state/           # Redux / domain state
- actions/         # Redux / actions  
- reducers/        # Redux / reducers
- middlewares/     # Redux / middlewares

Domains MUST NOT:

- depend on another domain
- contain generic utilities
- expose internal structure directly (use index.ts)

If a file mentions a business term → it belongs to a domain.

## Frontend Guidelines for DomainA

- All components and styles must follow:
  - Accessibility (a11y)
  - SEO best practices
  - Security (sanitize inputs, CSP)
  - Performance and Web Vitals optimization
