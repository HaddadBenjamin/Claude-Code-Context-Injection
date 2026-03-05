# Component Patterns

## Core rules

- One component per file.
- Function components only. `FC<Props>` with explicit `Props` type above the component.
- Props: typed, destructured at entry, `readonly` when applicable.
- No logic in JSX — extract to variables, early returns, or helper functions.
- File internal order: `useState` → custom hooks → `useEffect` → internal functions → JSX.

---

## Props typing

```typescript
// ✅ DO — Props interface above component, local to file
interface Props {
  readonly title: string;
  readonly onClose: () => void;
  readonly isOpen?: boolean;
}

const Modal: FC<Props> = ({ title, onClose, isOpen = false }) => {
  ...
};

// ❌ DON'T — inline type, no destructuring
const Modal: FC<{ title: string; onClose: () => void }> = (props) => {
  console.log(props.title);
};
```

If the type is reused across files → move to `domains/<domain>/types.ts`.

---

## Early returns over nested conditions

```typescript
// ✅ DO
const ProductCard: FC<Props> = ({ product }) => {
  if (!product) return null;
  if (product.isArchived) return <ArchivedBadge />;

  return <div className="product-card">...</div>;
};

// ❌ DON'T
const ProductCard: FC<Props> = ({ product }) => {
  return (
    <div>
      {product ? (
        product.isArchived ? <ArchivedBadge /> : <div>...</div>
      ) : null}
    </div>
  );
};
```

---

## Extract logic from JSX

```typescript
// ✅ DO — compute outside JSX
const ProductList: FC<Props> = ({ products, searchQuery }) => {
  const filteredProducts = products.filter((p) =>
    p.name.toLowerCase().includes(searchQuery.toLowerCase())
  );
  const hasResults = filteredProducts.length > 0;

  return (
    <section>
      {hasResults ? (
        filteredProducts.map((p) => <ProductCard key={p.id} product={p} />)
      ) : (
        <EmptyState message="No products found" />
      )}
    </section>
  );
};

// ❌ DON'T — logic inline in JSX
return (
  <section>
    {products.filter(p => p.name.toLowerCase().includes(searchQuery.toLowerCase())).length > 0
      ? products.filter(...).map(...)
      : <EmptyState />}
  </section>
);
```

---

## Compound components (design-system level)

Use for components that share state and have a clear parent/child relationship.

```typescript
// design-system/components/Tabs/
// Tabs.tsx — context provider
// TabsList.tsx — container
// TabsTrigger.tsx — button
// TabsContent.tsx — panel

// Usage
<Tabs defaultValue="overview">
  <TabsList>
    <TabsTrigger value="overview">Overview</TabsTrigger>
    <TabsTrigger value="details">Details</TabsTrigger>
  </TabsList>
  <TabsContent value="overview"><Overview /></TabsContent>
  <TabsContent value="details"><Details /></TabsContent>
</Tabs>
```

---

## Controlled vs Uncontrolled

Prefer **controlled** for forms and interactive elements where the parent needs the value.
Use **uncontrolled** (React Hook Form `register`) for complex forms to minimize re-renders.

```typescript
// Controlled
const [value, setValue] = useState('');
<input value={value} onChange={(e) => setValue(e.target.value)} />

// Uncontrolled (React Hook Form)
const { register, handleSubmit } = useForm<FormValues>();
<input {...register('email', { required: true })} />
```

---

## Render props (when composition via children is not enough)

```typescript
// ✅ Acceptable for inversion of control
interface DataFetcherProps<T> {
  queryFn: () => Promise<T>;
  children: (data: T) => ReactNode;
  fallback?: ReactNode;
}

const DataFetcher = <T,>({ queryFn, children, fallback }: DataFetcherProps<T>) => {
  const { data, isLoading } = useQuery({ queryFn });
  if (isLoading) return fallback ?? <Loader />;
  if (!data) return null;
  return <>{children(data)}</>;
};
```

---

## Avoid HOCs (Higher-Order Components)

HOCs are harder to type and debug. Use hooks or composition instead.

```typescript
// ❌ Avoid HOC
const withAuth = (Component: FC) => (props: unknown) => {
  const { isAuthenticated } = useAuth();
  if (!isAuthenticated) return <Redirect to="/login" />;
  return <Component {...props} />;
};

// ✅ Prefer — guard component or hook
const AuthGuard: FC<{ children: ReactNode }> = ({ children }) => {
  const { isAuthenticated } = useAppSelector(selectIsAuthenticated);
  if (!isAuthenticated) return <Navigate to="/login" />;
  return <>{children}</>;
};
```

---

## Memoization — only when justified

```typescript
// React.memo — only if parent re-renders frequently AND props are stable
const ProductCard = React.memo<Props>(({ product, onSelect }) => {
  return <div onClick={() => onSelect(product.id)}>{product.name}</div>;
});

// useMemo — only for expensive computations
const sortedProducts = useMemo(
  () => [...products].sort((a, b) => a.price - b.price),
  [products]
);

// useCallback — only when passed to memoized child
const handleSelect = useCallback((id: string) => {
  dispatch(selectProduct(id));
}, [dispatch]);
```

**Do not memoize by default.** Profile first, optimize second.

---

## Component size rule

If a component:
- Has more than ~150 lines of JSX, or
- Has more than 3 distinct visual sections, or
- Has more than 5 `useState` calls

→ Split it. Extract sections into sub-components or logic into hooks.

---

## Design-system vs Domain components

| | Design System | Domain Component |
|---|---|---|
| **Location** | `design-system/components/` | `domains/<domain>/components/` |
| **Business logic** | Never | Yes |
| **API calls** | Never | Via hooks only |
| **Naming** | Generic (`Button`, `Card`, `Modal`) | Business (`ProductCard`, `OrderSummary`) |
| **Storybook** | Mandatory | Optional |
| **Reusability** | Cross-project | Domain-only |

---

## Claude enforcement rules

- Multiple components in one file = **Blocker**.
- Class component = **Blocker**.
- Props not destructured = **Warning**.
- Logic inside JSX (filter, map with conditions inline) = **Warning**.
- Business logic in a design-system component = **Blocker**.
- `React.memo` / `useMemo` without a profiling justification = **Warning**.
- HOC instead of hook or composition = **Warning**.
- Component > 150 lines without being split = **Warning**.