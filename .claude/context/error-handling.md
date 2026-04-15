# Error Handling

## Principles

- No silent failures. Every error has an explicit state.
- Errors are typed. Never catch `unknown` without narrowing.
- User-facing messages are human-readable. Never expose stack traces or technical details.
- Errors are handled at the right level — not too high (swallowing), not too low (leaking).

---

## Error levels

| Level | Tool | Scope |
|-------|------|-------|
| Network / API | `ApiError` class + React Query `onError` | Per request |
| Component subtree | React Error Boundary | Page section |
| Page-level | Next.js `error.tsx` | Per route segment |
| Global uncaught | `error.tsx` at root + monitoring | Entire app |
| Form validation | Zod + React Hook Form | Per field |

---

## Typed errors

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

// Type guard
export function isApiError(error: unknown): error is ApiError {
  return error instanceof ApiError;
}
```

---

## Error narrowing pattern

```typescript
// ✅ DO — always narrow before using
try {
  await createOrder(payload);
} catch (error) {
  if (isApiError(error)) {
    if (error.isUnauthorized) {
      dispatch(clearUser());
      router.push('/login');
      return;
    }
    setErrorMessage(error.message);
    return;
  }
  // Unexpected error — log and show generic message
  console.error('[createOrder] unexpected error:', error);
  setErrorMessage('Une erreur inattendue est survenue.');
}

// ❌ DON'T — untyped catch
} catch (e: any) {
  setError(e.message); // unsafe, may throw if e has no message
}
```

---

## React Error Boundaries

Wrap every major page section that can fail independently.

```typescript
// shared/components/ErrorBoundary/ErrorBoundary.tsx
import { Component, type ReactNode, type ErrorInfo } from 'react';

interface Props {
  children: ReactNode;
  fallback: ReactNode;
  onError?: (error: Error, info: ErrorInfo) => void;
}

interface State {
  hasError: boolean;
}

export class ErrorBoundary extends Component<Props, State> {
  state: State = { hasError: false };

  static getDerivedStateFromError(): State {
    return { hasError: true };
  }

  componentDidCatch(error: Error, info: ErrorInfo) {
    this.props.onError?.(error, info);
    // Send to monitoring (Sentry, Datadog, etc.)
    reportError(error, info);
  }

  render() {
    if (this.state.hasError) return this.props.fallback;
    return this.props.children;
  }
}

// Usage
<ErrorBoundary fallback={<SectionErrorFallback />}>
  <ProductList />
</ErrorBoundary>
```

---

## Next.js error files

```typescript
// app/error.tsx — catches errors in the current route segment
'use client';

import { useEffect } from 'react';

interface Props {
  error: Error & { digest?: string };
  reset: () => void;
}

export default function ErrorPage({ error, reset }: Props) {
  useEffect(() => {
    reportError(error); // send to monitoring
  }, [error]);

  return (
    <main role="main">
      <h1>Une erreur est survenue</h1>
      <p>Nous travaillons à résoudre le problème.</p>
      <button onClick={reset}>Réessayer</button>
    </main>
  );
}

// app/not-found.tsx — 404 page
export default function NotFound() {
  return (
    <main role="main">
      <h1>Page introuvable</h1>
      <p>La page que vous cherchez n'existe pas.</p>
    </main>
  );
}
```

---

## React Query error handling

```typescript
// In hook — expose typed error
const { data, isError, error } = useQuery({
  queryKey: productKeys.detail(id),
  queryFn: () => fetchProduct(id),
});

return { data, isError, error: error as ApiError | null };

// In component — handle explicitly
if (isError) {
  if (error?.isNotFound) return <NotFoundMessage />;
  return <ErrorMessage message={error?.message ?? 'Erreur de chargement'} />;
}
```

---

## Toast notifications vs inline errors

| Situation | Pattern |
|-----------|---------|
| Form field error | Inline, below the field, linked with `aria-describedby` |
| Form submit failure | Inline at top of form, `role="alert"` |
| Mutation success | Toast (non-blocking) |
| Mutation failure | Toast if non-critical, inline if critical |
| Page load failure | Full error state (not toast) |
| Network offline | Banner, persistent |

---

## Monitoring (production)

Errors must be reported to a monitoring service (Sentry, Datadog, etc.).

```typescript
// shared/utils/monitoring/reportError.ts
export function reportError(error: Error, context?: Record<string, unknown>): void {
  if (process.env.NODE_ENV === 'production') {
    Sentry.captureException(error, { extra: context });
  } else {
    console.error('[reportError]', error, context);
  }
}
```

Integrate in:
- `ErrorBoundary.componentDidCatch`
- `app/error.tsx` useEffect
- `apiClient` for 5xx errors

---

## Claude enforcement rules

- `catch` block with no error handling (empty or `console.log` only) = **Blocker**.
- Error typed as `any` in catch = **Blocker**.
- Technical error message shown to user = **Blocker**.
- No Error Boundary on critical page section = **Warning**.
- No `app/error.tsx` in a Next.js route segment with async data = **Warning**.
- Mutation without error state exposed to UI = **Blocker**.
- No monitoring call in production error handler = **Warning**.