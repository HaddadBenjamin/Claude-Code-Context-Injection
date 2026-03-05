# API Integration – Conventions & Patterns

## Structure

API calls live exclusively in `domains/<domain>/api/`.
Never call APIs from components or hooks directly — only from domain `api/` files, consumed by domain hooks.

```
domains/<domain>/
  api/
    index.ts          # re-exports
    fetchXxx.ts       # one file per resource or logical group
    createXxx.ts
    updateXxx.ts
    deleteXxx.ts
```

---

## HTTP client

Use a shared `apiClient` instance from `shared/utils/api/apiClient.ts`.
Never use raw `fetch` directly in domain code.

```typescript
// shared/utils/api/apiClient.ts
const BASE_URL = process.env.NEXT_PUBLIC_API_URL;

export async function apiClient<T>(
  endpoint: string,
  options: RequestInit = {}
): Promise<T> {
  const token = tokenStore.get();

  const response = await fetch(`${BASE_URL}${endpoint}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...options.headers,
    },
  });

  if (!response.ok) {
    const error = await response.json().catch(() => ({}));
    throw new ApiError(response.status, error.message ?? 'Unknown error', error);
  }

  return response.json() as Promise<T>;
}
```

---

## Naming conventions

| Operation | Prefix | Example |
|-----------|--------|---------|
| Read (GET) | `fetch` | `fetchProducts`, `fetchUserById` |
| Create (POST) | `create` | `createOrder`, `createComment` |
| Update (PUT/PATCH) | `update` | `updateProfile`, `updateOrderStatus` |
| Delete (DELETE) | `delete` | `deleteArticle`, `deleteAccount` |

---

## Typed API functions

Every API function must have explicit input and return types.
Types live in `domains/<domain>/types.ts`.

```typescript
// domains/products/api/fetchProducts.ts
import { apiClient } from '@shared/utils/api/apiClient';
import type { Product, ProductsFilters } from '../types';

export async function fetchProducts(filters: ProductsFilters): Promise<Product[]> {
  const params = new URLSearchParams(filters as Record<string, string>);
  return apiClient<Product[]>(`/products?${params}`);
}
```

```typescript
// domains/products/api/createProduct.ts
import { apiClient } from '@shared/utils/api/apiClient';
import type { CreateProductPayload, Product } from '../types';

export async function createProduct(payload: CreateProductPayload): Promise<Product> {
  return apiClient<Product>('/products', {
    method: 'POST',
    body: JSON.stringify(payload),
  });
}
```

---

## Error typing

```typescript
// shared/utils/api/ApiError.ts
export class ApiError extends Error {
  constructor(
    public readonly status: number,
    message: string,
    public readonly data?: unknown,
  ) {
    super(message);
    this.name = 'ApiError';
  }

  get isUnauthorized(): boolean { return this.status === 401; }
  get isForbidden(): boolean { return this.status === 403; }
  get isNotFound(): boolean { return this.status === 404; }
  get isServerError(): boolean { return this.status >= 500; }
}
```

---

## Token injection & refresh

Access token is attached automatically by `apiClient` via `tokenStore.get()`.
On 401 response: intercept, call `refreshToken()`, retry once, then redirect to login.

```typescript
// In apiClient — 401 handling
if (response.status === 401 && !options._isRetry) {
  const newToken = await refreshToken();
  tokenStore.set(newToken);
  return apiClient<T>(endpoint, { ...options, _isRetry: true });
}
```

---

## CSRF (non-Server-Action calls)

```typescript
// shared/utils/api/getCsrfToken.ts
export function getCsrfToken(): string {
  return document.querySelector('meta[name="csrf-token"]')
    ?.getAttribute('content') ?? '';
}

// Add to apiClient for mutating methods
const isMutating = ['POST', 'PUT', 'PATCH', 'DELETE'].includes(
  options.method?.toUpperCase() ?? ''
);
if (isMutating) {
  headers['X-CSRF-Token'] = getCsrfToken();
}
```

---

## Types from Swagger

When a Swagger/OpenAPI spec is available:
- Generate types with `openapi-typescript`: `npx openapi-typescript swagger.json -o src/shared/types/api.generated.ts`.
- Import generated types in domain `types.ts` and re-export them with domain names.
- Never modify generated files manually — regenerate them.

```typescript
// domains/products/types.ts
import type { components } from '@shared/types/api.generated';

export type Product = components['schemas']['Product'];
export type CreateProductPayload = components['schemas']['CreateProductRequest'];
```

---

## Server Actions (Next.js)

Use Server Actions for mutations triggered from forms or UI that do not need React Query caching.

```typescript
// domains/contact/actions/submitContactForm.ts
'use server';

import { z } from 'zod';
import { contactFormSchema } from '../validations/contactFormSchema';

export async function submitContactForm(
  _prevState: unknown,
  formData: FormData
): Promise<{ success: boolean; error?: string }> {
  const parsed = contactFormSchema.safeParse(Object.fromEntries(formData));

  if (!parsed.success) {
    return { success: false, error: parsed.error.message };
  }

  await createContactRequest(parsed.data); // internal API call with server-side key
  return { success: true };
}
```

---

## Claude enforcement rules

- API call directly in a component (not in a hook/api file) = **Blocker**.
- API function without explicit return type = **Blocker**.
- Raw `fetch` in domain code instead of `apiClient` = **Blocker**.
- API key visible in client-side code = **Blocker**.
- Missing error handling (no try/catch or untyped error) = **Blocker**.
- API function file not in `domains/<domain>/api/` = **Blocker**.
- Generated types modified manually = **Warning**.