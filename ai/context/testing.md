## Testing strategy

### Coverage requirements

- Global minimum coverage: **80%**
- Applies to:
  - statements
  - branches
  - functions
  - lines

Coverage is mandatory and enforced by CI.

Exceptions:
- index.ts re-export files
- generated code
- pure type definitions

Any new feature or refactor must:
- include tests
- not decrease global coverage
- increase coverage when touching legacy code
