### Shared

`src/shared` contains ONLY code that is:

- Business-agnostic
- Domain-agnostic
- Reusable across multiple projects
- Portable without modification

If a file CANNOT be copy-pasted into another project → it MUST NOT be in shared.


### Shared internal structure

shared/
  components/   # generic UI components (no business meaning)
  hooks/        # generic hooks (no business naming)
  utils/        # pure functions only
  helpers/      # helpers
  constants/    # technical constants
  validations/  # generic validation rules
  classes/      # generic classes
  mocks/        # test mocks

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