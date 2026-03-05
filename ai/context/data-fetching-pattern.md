# Data Fetching Patterns – React Query

## Stack

- **React Query v5** (`@tanstack/react-query`) for all server state.
- **Redux Toolkit** for global client state only (UI state, auth, preferences).
- Never store server data in Redux. Never store client UI state in React Query.

---

## Query key factory (mandatory pattern)

Every domain must define a query key factory. This ensures consistent cache invalidation and type safety.

```typescript
// domains/products/api/queryKeys.ts
export const productKeys = {
  all: ['products'] as const,
  lists: () => [...productKeys.all, 'list'] as const,
  list: (filters: ProductsFilters) => [...productKeys.lists(), filters] as const,
  details: () => [...productKeys.all, 'detail'] as const,
  detail: (id: string) => [...productKeys.details(), id] as const,
};

// Usage
useQuery({ queryKey: productKeys.detail(id), queryFn: () => fetchProduct(id) });
queryClient.invalidateQueries({ queryKey: productKeys.lists() });
```

---

## Query hook pattern

One hook per resource or logical data need. Lives in `domains/<domain>/hooks/`.

```typescript
// domains/products/hooks/useProducts.ts
import { useQuery } from '@tanstack/react-query';
import { fetchProducts } from '../api/fetchProducts';
import { productKeys } from '../api/queryKeys';
import type { ProductsFilters } from '../types';

interface UseProductsResult {
  products: Product[];
  isLoading: boolean;
  isError: boolean;
  error: ApiError | null;
}

export function useProducts(filters: ProductsFilters): UseProductsResult {
  const { data, isLoading, isError, error } = useQuery({
    queryKey: productKeys.list(filters),
    queryFn: () => fetchProducts(filters),
    staleTime: 5 * 60 * 1000, // 5 min
  });

  return {
    products: data ?? [],
    isLoading,
    isError,
    error: error as ApiError | null,
  };
}
```

---

## Mutation hook pattern

```typescript
// domains/products/hooks/useCreateProduct.ts
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { createProduct } from '../api/createProduct';
import { productKeys } from '../api/queryKeys';
import type { CreateProductPayload, Product } from '../types';

export function useCreateProduct() {
  const queryClient = useQueryClient();

  return useMutation<Product, ApiError, CreateProductPayload>({
    mutationFn: createProduct,
    onSuccess: () => {
      // Invalidate list cache after creation
      queryClient.invalidateQueries({ queryKey: productKeys.lists() });
    },
    onError: (error) => {
      // Error state is returned to caller — no silent failures
      console.error('[useCreateProduct]', error.message);
    },
  });
}

// Usage in component
const { mutate: createProduct, isPending, isError, error } = useCreateProduct();
```

---

## Optimistic updates

Use when the mutation is very likely to succeed and UX responsiveness matters.

```typescript
useMutation({
  mutationFn: updateProduct,
  onMutate: async (updated) => {
    // Cancel in-flight queries
    await queryClient.cancelQueries({ queryKey: productKeys.detail(updated.id) });

    // Snapshot current value for rollback
    const previous = queryClient.getQueryData(productKeys.detail(updated.id));

    // Optimistically update cache
    queryClient.setQueryData(productKeys.detail(updated.id), updated);

    return { previous };
  },
  onError: (_error, updated, context) => {
    // Rollback on failure
    queryClient.setQueryData(productKeys.detail(updated.id), context?.previous);
  },
  onSettled: (_data, _error, updated) => {
    // Always refetch to sync with server
    queryClient.invalidateQueries({ queryKey: productKeys.detail(updated.id) });
  },
});
```

---

## Pagination

```typescript
// Offset-based
export function useProductsPaginated(page: number, pageSize: number) {
  return useQuery({
    queryKey: productKeys.list({ page, pageSize }),
    queryFn: () => fetchProducts({ page, pageSize }),
    placeholderData: keepPreviousData, // v5: no flash on page change
  });
}

// Infinite scroll
export function useProductsInfinite(filters: Omit<ProductsFilters, 'page'>) {
  return useInfiniteQuery({
    queryKey: productKeys.list(filters),
    queryFn: ({ pageParam = 1 }) => fetchProducts({ ...filters, page: pageParam }),
    getNextPageParam: (lastPage) => lastPage.nextPage ?? undefined,
    initialPageParam: 1,
  });
}
```

---

## Prefetching on hover / route anticipation

```typescript
// Prefetch on hover (e.g., product card)
const queryClient = useQueryClient();

function onProductCardHover(id: string) {
  queryClient.prefetchQuery({
    queryKey: productKeys.detail(id),
    queryFn: () => fetchProduct(id),
    staleTime: 5 * 60 * 1000,
  });
}
```

---

## staleTime & cacheTime guidelines

| Data type | `staleTime` | Notes |
|-----------|-------------|-------|
| Static reference data (countries, categories) | `Infinity` | Never refetch |
| Slow-changing content (articles, catalog) | `5–60 min` | ISR equivalent on client |
| User-specific data (profile, cart) | `1–5 min` | Balance freshness vs requests |
| Real-time data (notifications, prices) | `0` | Always refetch on focus |

---

## Error handling in queries

```typescript
// In hook — typed error
const { error } = useQuery({ ... });
const apiError = error as ApiError | null;

// In component — never swallow errors
if (isError) {
  return <ErrorMessage message={apiError?.message ?? 'Something went wrong'} />;
}
```

---

## Global QueryClient config

```typescript
// app/providers.tsx
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 60 * 1000,        // 1 min default
      retry: 1,                     // retry once on failure
      refetchOnWindowFocus: false,  // disable unless explicitly needed
    },
    mutations: {
      retry: 0,                     // never retry mutations automatically
    },
  },
});
```

---

## Claude enforcement rules

- React Query used to store UI/client state = **Blocker**.
- Redux used to store server/fetched data = **Blocker**.
- No query key factory in a domain = **Warning**.
- Query key defined as raw string (not factory) = **Warning**.
- Mutation without `onError` handler = **Blocker**.
- Missing `invalidateQueries` after a mutation that modifies a list = **Blocker**.
- `staleTime` not set explicitly on a production query = **Warning**.