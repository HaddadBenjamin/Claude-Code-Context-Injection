# API & Data Fetching

## Stack

- **React Query v5** (`@tanstack/react-query`) — toute la server state
- **Redux Toolkit** — state client global uniquement (UI state, auth, préférences)
- Jamais stocker des données serveur dans Redux. Jamais stocker du UI state dans React Query.

---

## Structure des appels API

Les appels API vivent exclusivement dans `domains/<domain>/api/`. Jamais depuis un composant ou un hook directement.

```
domains/<domain>/
  api/
    index.ts          # re-exports
    fetchXxx.ts       # un fichier par resource ou groupe logique
    createXxx.ts
    updateXxx.ts
    deleteXxx.ts
    queryKeys.ts      # query key factory (obligatoire)
```

**Naming :**

| Opération | Préfixe | Exemple |
|-----------|---------|---------|
| GET | `fetch` | `fetchProducts`, `fetchUserById` |
| POST | `create` | `createOrder` |
| PUT/PATCH | `update` | `updateProfile` |
| DELETE | `delete` | `deleteArticle` |

---

## HTTP Client

Utiliser `apiClient` depuis `shared/utils/api/apiClient.ts`. Jamais de `fetch` brut dans le code domain.

```typescript
export async function apiClient<T>(endpoint: string, options: RequestInit = {}): Promise<T> {
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

**Token refresh :** sur 401 → appeler `refreshToken()`, retry une fois, puis redirect login.

**CSRF :** lire depuis le meta tag, ajouter `X-CSRF-Token` sur les appels mutants (POST/PUT/PATCH/DELETE). Non nécessaire pour les Server Actions.

---

## Typed API Functions

Chaque fonction API doit avoir des types input/output explicites depuis `domains/<domain>/types.ts`.

```typescript
// domains/products/api/fetchProducts.ts
export async function fetchProducts(filters: ProductsFilters): Promise<Product[]> {
  return apiClient<Product[]>(`/products?${new URLSearchParams(filters as Record<string, string>)}`);
}
```

**Types depuis Swagger :** générer avec `openapi-typescript`, importer dans `types.ts`, ne jamais modifier les fichiers générés.

---

## Query Key Factory (obligatoire)

Chaque domain doit définir un query key factory dans `api/queryKeys.ts`.

```typescript
export const productKeys = {
  all: ['products'] as const,
  lists: () => [...productKeys.all, 'list'] as const,
  list: (filters: ProductsFilters) => [...productKeys.lists(), filters] as const,
  details: () => [...productKeys.all, 'detail'] as const,
  detail: (id: string) => [...productKeys.details(), id] as const,
};
```

---

## Query Hook Pattern

Un hook par resource, dans `domains/<domain>/hooks/`.

```typescript
export function useProducts(filters: ProductsFilters) {
  const { data, isLoading, isError, error } = useQuery({
    queryKey: productKeys.list(filters),
    queryFn: () => fetchProducts(filters),
    staleTime: 5 * 60 * 1000,
  });
  return { products: data ?? [], isLoading, isError, error: error as ApiError | null };
}
```

---

## Mutation Hook Pattern

```typescript
export function useCreateProduct() {
  const queryClient = useQueryClient();
  return useMutation<Product, ApiError, CreateProductPayload>({
    mutationFn: createProduct,
    onSuccess: () => queryClient.invalidateQueries({ queryKey: productKeys.lists() }),
    onError: (error) => console.error('[useCreateProduct]', error.message),
  });
}
```

---

## Optimistic Updates

```typescript
useMutation({
  mutationFn: updateProduct,
  onMutate: async (updated) => {
    await queryClient.cancelQueries({ queryKey: productKeys.detail(updated.id) });
    const previous = queryClient.getQueryData(productKeys.detail(updated.id));
    queryClient.setQueryData(productKeys.detail(updated.id), updated);
    return { previous };
  },
  onError: (_err, updated, context) =>
    queryClient.setQueryData(productKeys.detail(updated.id), context?.previous),
  onSettled: (_data, _err, updated) =>
    queryClient.invalidateQueries({ queryKey: productKeys.detail(updated.id) }),
});
```

---

## staleTime Guidelines

| Data | staleTime | Notes |
|------|-----------|-------|
| Données statiques (pays, catégories) | `Infinity` | Jamais refetch |
| Contenu lent (articles, catalogue) | `5–60 min` | |
| Données user (profil, panier) | `1–5 min` | |
| Temps réel (notifs, prix) | `0` | Toujours refetch |

---

## Global QueryClient Config

```typescript
const queryClient = new QueryClient({
  defaultOptions: {
    queries: { staleTime: 60_000, retry: 1, refetchOnWindowFocus: false },
    mutations: { retry: 0 },
  },
});
```

---

## Pagination

```typescript
// Offset-based
useQuery({ queryKey: productKeys.list({ page, pageSize }), placeholderData: keepPreviousData });

// Infinite scroll
useInfiniteQuery({
  queryKey: productKeys.list(filters),
  queryFn: ({ pageParam = 1 }) => fetchProducts({ ...filters, page: pageParam }),
  getNextPageParam: (lastPage) => lastPage.nextPage ?? undefined,
  initialPageParam: 1,
});
```

---

## Server Actions (Next.js)

Pour les mutations depuis des formulaires qui n'ont pas besoin du cache React Query.

```typescript
'use server';
export async function submitContactForm(_prevState: unknown, formData: FormData) {
  const parsed = contactFormSchema.safeParse(Object.fromEntries(formData));
  if (!parsed.success) return { success: false, error: parsed.error.message };
  await createContactRequest(parsed.data);
  return { success: true };
}
```

---

## Blockers

- Appel API direct depuis un composant (pas depuis un hook/api/) = **Blocker**
- `fetch` brut dans le code domain (pas `apiClient`) = **Blocker**
- Fonction API sans type de retour explicite = **Blocker**
- Clé API visible côté client = **Blocker**
- Mutation sans `onError` = **Blocker**
- Mutation sans `invalidateQueries` sur les listes = **Blocker**
- Redux utilisé pour stocker des données serveur = **Blocker**
- React Query utilisé pour du state client/UI = **Blocker**
- Pas de query key factory dans un domain = **Warning**
- `staleTime` non défini en production = **Warning**
