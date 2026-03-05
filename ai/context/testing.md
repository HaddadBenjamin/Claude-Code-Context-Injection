# Testing Strategy

## Coverage requirements

- Global minimum: **80%** (statements, branches, functions, lines).
- Enforced by CI. A PR that lowers coverage is rejected.
- Exceptions: `index.ts` re-export files, generated code, pure type definitions.

---

## Testing pyramid

| Layer | Tool | Scope | Volume |
|-------|------|-------|--------|
| Unit | Jest + Testing Library | Functions, hooks, utils | High |
| Integration | Jest + Testing Library + MSW | Components with data | Medium |
| E2E | Playwright | Critical user journeys | Low |

---

## File conventions

- Unit/integration tests: `<filename>.test.ts` or `<filename>.test.tsx` alongside the file.
- E2E tests: `tests/e2e/<feature>.spec.ts`.
- Mocks: `domains/<domain>/mocks/` or `shared/mocks/`.
- Test naming: `describe('<ComponentOrFunction>')` > `it('should <behavior> when <condition>')`.

---

## What to test per file type

### Utils / pure functions
Every branch: happy path, edge cases, invalid inputs, boundary values.

### Hooks
Use `renderHook`. Mock API calls with MSW. Test loading, success, and error states.

### Components
Test behavior, not implementation. Use `getByRole`, `getByText`. Simulate user interactions.
Always include at least one accessibility assertion (`getByRole` counts).

### Redux slices
Test reducers as pure functions: initial state, each action, extraReducers for thunks.

### Validation schemas
Test valid input, each invalid field, and boundary values.

---

## MSW setup (never mock fetch directly)

```typescript
// tests/mocks/handlers.ts
import { http, HttpResponse } from 'msw';
export const handlers = [
  http.get('/products', () => HttpResponse.json(mockProducts)),
  http.post('/products', async ({ request }) => {
    const body = await request.json();
    return HttpResponse.json({ id: 'new-id', ...body }, { status: 201 });
  }),
];

// tests/mocks/server.ts
import { setupServer } from 'msw/node';
import { handlers } from './handlers';
export const server = setupServer(...handlers);

// jest.setup.ts
beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());
```

---

## Mocks & fixtures

Domain mocks live in `domains/<domain>/mocks/`. They must match the TypeScript types exactly.

```typescript
// domains/products/mocks/productMocks.ts
import type { Product } from '../types';

export const mockProduct: Product = {
  id: 'prod-1',
  name: 'Test Product',
  price: 100,
  category: 'electronics',
  createdAt: '2024-01-01T00:00:00Z',
};
```

---

## E2E (Playwright)

Cover critical user journeys only. Do not duplicate integration tests.
Use `getByRole` and `getByText` — never CSS selectors or test IDs unless unavoidable.

---

## What NOT to test

- Implementation details (internal state, private methods).
- Third-party library internals.
- Generated types or `index.ts` re-exports.
- Pass-through functions with no logic.

---

## Claude enforcement rules

- New feature or refactor without tests = **Blocker**.
- Coverage drops below 80% = **Blocker**.
- `fetch` mocked directly instead of MSW = **Warning**.
- Test that tests implementation (not behavior) = **Warning**.
- Missing error path test = **Warning**.