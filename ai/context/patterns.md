## Approved patterns

### Data fetching
- Fetching logic lives in domain hooks
- Components never call APIs directly
- Loading and error states handled in hooks

### State
- Global state via Redux Toolkit
- Local UI state via `useState`
- No derived state stored

### Validation
- Business validation lives in domain `validations`
- UI validation lives close to components

### Error handling
- Errors are typed
- No silent failures
- Explicit error states
