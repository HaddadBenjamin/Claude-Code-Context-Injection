# TypeScript Patterns

## Guiding principles

- Explicit over implicit. If TypeScript infers it wrong, type it explicitly.
- No `any`. No type assertions (`as`) without justification.
- Types describe the shape of data. Validation (Zod) enforces it at runtime.

---

## Discriminated unions (prefer over enums)

```typescript
// ✅ DO — discriminated union
type RequestState<T> =
  | { status: 'idle' }
  | { status: 'loading' }
  | { status: 'success'; data: T }
  | { status: 'error'; error: ApiError };

// Usage — TypeScript narrows the type automatically
if (state.status === 'success') {
  console.log(state.data); // typed correctly
}

// ❌ DON'T — enum
enum RequestStatus { Idle, Loading, Success, Error }
```

---

## Branded types (prevent primitive confusion)

```typescript
// ✅ DO — prevent mixing up IDs of different entities
type UserId = string & { readonly _brand: 'UserId' };
type ProductId = string & { readonly _brand: 'ProductId' };

function createUserId(id: string): UserId {
  return id as UserId;
}

function fetchUser(id: UserId): Promise<User> { ... }

// fetchUser(productId) → compile error
```

---

## Type guards

```typescript
// ✅ DO — explicit type guard function
function isApiError(error: unknown): error is ApiError {
  return error instanceof ApiError;
}

// Usage
try {
  await fetchProduct(id);
} catch (error) {
  if (isApiError(error)) {
    console.log(error.status); // typed
  }
}
```

---

## Utility types — use, don't re-invent

```typescript
// Pick — subset of properties
type ProductSummary = Pick<Product, 'id' | 'name' | 'price'>;

// Omit — all except listed
type CreateProductPayload = Omit<Product, 'id' | 'createdAt'>;

// Partial — all optional (for update payloads)
type UpdateProductPayload = Partial<Omit<Product, 'id'>>;

// Required — all mandatory
type RequiredConfig = Required<AppConfig>;

// Readonly — immutable
type ImmutableUser = Readonly<User>;

// Record — typed key-value map
type ProductById = Record<ProductId, Product>;

// ReturnType — infer return type of a function
type QueryResult = ReturnType<typeof useProducts>;
```

---

## Generics — practical patterns

```typescript
// Generic API response wrapper
interface ApiResponse<T> {
  data: T;
  meta: { total: number; page: number };
}

// Generic hook return type
interface UseQueryResult<T> {
  data: T | null;
  isLoading: boolean;
  isError: boolean;
  error: ApiError | null;
}

// Generic form field type
type FormFields<T> = {
  [K in keyof T]: {
    value: T[K];
    error: string | null;
  };
};
```

---

## Explicit return types on public functions

```typescript
// ✅ DO
export function formatPrice(amount: number, currency: string): string {
  return new Intl.NumberFormat('fr-FR', { style: 'currency', currency }).format(amount);
}

// ❌ DON'T — inferred return type on public API
export function formatPrice(amount: number, currency: string) {
  return new Intl.NumberFormat('fr-FR', { style: 'currency', currency }).format(amount);
}
```

---

## Avoid type assertions (`as`)

```typescript
// ❌ DON'T — lying to TypeScript
const user = data as User;

// ✅ DO — validate then type
import { userSchema } from '../validations/userSchema';
const user = userSchema.parse(data); // Zod validates AND types
```

Exception: `as const` for literal inference is always fine.
```typescript
const ROUTES = {
  home: '/',
  products: '/products',
} as const;
```

---

## `readonly` arrays and objects

```typescript
// ✅ DO — prevent accidental mutation
function sortProducts(products: readonly Product[]): Product[] {
  return [...products].sort((a, b) => a.name.localeCompare(b.name));
}

// Readonly deep
type DeepReadonly<T> = {
  readonly [K in keyof T]: T[K] extends object ? DeepReadonly<T[K]> : T[K];
};
```

---

## Zod for runtime validation + type inference

```typescript
// domains/products/validations/productSchema.ts
import { z } from 'zod';

export const productSchema = z.object({
  id: z.string().uuid(),
  name: z.string().min(1).max(100),
  price: z.number().positive(),
  category: z.enum(['electronics', 'clothing', 'food']),
  createdAt: z.string().datetime(),
});

// Infer type from schema — single source of truth
export type Product = z.infer<typeof productSchema>;

// Usage
const product = productSchema.parse(apiResponse); // throws if invalid
const result = productSchema.safeParse(apiResponse); // returns { success, data, error }
```

---

## `never` for exhaustive checks

```typescript
// Ensures all union members are handled
function getStatusLabel(status: OrderStatus): string {
  switch (status) {
    case 'pending': return 'En attente';
    case 'confirmed': return 'Confirmée';
    case 'shipped': return 'Expédiée';
    case 'delivered': return 'Livrée';
    default: {
      const _exhaustive: never = status; // compile error if a case is missing
      return _exhaustive;
    }
  }
}
```

---

## Claude enforcement rules

- Implicit `any` in function parameter or return = **Blocker**.
- `as` type assertion without comment explaining why = **Blocker**.
- Enum used instead of union type = **Warning**.
- Public function without explicit return type = **Warning**.
- Runtime data (API response) cast with `as` instead of validated with Zod = **Blocker**.
- Missing type on `useState` when initial value is `null` or `[]` = **Warning**.