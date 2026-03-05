# Approved Patterns

## Data fetching

- Fetching logic lives in domain hooks. Never call APIs directly from components.
- Loading and error states handled in hooks, exposed as typed return values.
- React Query for server state. Redux Toolkit for global client state.
- API functions named: `fetchXxx` (GET), `createXxx`, `updateXxx`, `deleteXxx`.

## State

- Global state: Redux Toolkit only.
- Server state: React Query only.
- Local UI state: `useState`.
- No derived state stored — compute from source.

## Validation

- Business validation in `domains/<domain>/validations/`.
- UI validation close to the component (React Hook Form + Zod recommended).
- Generic validation rules (email, password) in `shared/validations/`.
- All validation runs both client-side AND server-side.

## Error handling

- Errors are typed (`ApiError`, domain-specific error types).
- No silent failures. Every error has an explicit state.
- User-facing errors are human-readable. Do not expose technical details.
- Boundary errors caught with React Error Boundaries on critical routes.

## Performance patterns

- Images: always `next/image`. Never raw `<img>`.
- Heavy components: `React.lazy` + `Suspense` with meaningful skeleton.
- Long lists: `@tanstack/react-virtual` for virtualization.
- Debounce: `useDebounce` (from `shared/hooks`) for search inputs and resize handlers.
- Expensive computations: `useMemo` (only when profiling shows a bottleneck).
- Non-urgent updates: `startTransition` (React 18) to keep UI responsive.
- Dynamic imports for third-party libs not needed on initial load.

## Security patterns

- Access token: in-memory singleton (`tokenStore`). Never in localStorage.
- Refresh token: HttpOnly + Secure + SameSite=Strict cookie.
- HTML from server: always sanitize with `DOMPurify.sanitize()` before rendering.
- API keys: server-side only, via Server Actions or Route Handlers.
- Mutating API calls: include CSRF token in header (unless using Next.js Server Actions).
- File uploads: validate MIME type, extension, and size on both client and server.

## SEO patterns

- Page metadata: use Next.js `generateMetadata()` per route.
- Dynamic OG images: use Next.js `opengraph-image.tsx` convention.
- Structured data: JSON-LD injected via `<script type="application/ld+json">` in page component.
- SSG by default, SSR for personalized pages, CSR only for non-SEO widgets.
- Internal navigation: always `<Link>` (Next.js), never programmatic push for primary links.

## Accessibility patterns

- Skip link: first child of `<body>` — `<a href="#main-content">Skip to main content</a>`.
- Focus management on route change: move focus to `<h1>` or main content.
- Icon-only buttons: `<button aria-label="Close dialog"><Icon aria-hidden="true" /></button>`.
- Form errors: linked via `aria-describedby`. Announced via `aria-live="polite"`.
- Modal: `role="dialog"`, `aria-modal="true"`, focus trap, close on Escape.
- Animations: wrap in `@media (prefers-reduced-motion: reduce)` or check with `useReducedMotion`.

## Component composition

- Prefer composition over configuration (render props, children, compound components).
- Extract logic to hooks. Keep JSX declarative.
- No logic in JSX — use variables, early returns, or helper functions.
- Props: typed explicitly. Destructured at component entry.