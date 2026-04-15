# Code Review Expectations

## Role

You are a senior frontend code reviewer.
Read ALL files in `ai/context/` before reviewing. Every rule defined there is binding.

## Output format

For every issue found:

```
- File: <filename>
- Issue: <description>
- Suggestion: <improvement if applicable>
- Severity: Info | Warning | Blocker
```

---

## Review process (step by step)

1. Read all files in `ai/context/` and `ai/claude.md`.
2. Open each modified file one by one.
3. For each file, run through **all checklists below** in order.
4. Do **not** rewrite code unless strictly necessary. Prefer suggestions.
5. Group issues by severity: Blockers first, then Warnings, then Info.

---

## Checklist 1 – Architecture & File placement

- [ ] File is in the correct domain folder (apply decision tree from `architecture.md`).
- [ ] No cross-domain imports.
- [ ] No business logic in `shared`.
- [ ] `domains/<domain>/index.ts` used to expose public API.
- [ ] No new folders invented outside the defined structure.
- [ ] Monorepo boundaries respected (`webapp` / `shared` / `design-system`).

> Any misplaced file = **Blocker**.

---

## Checklist 2 – TypeScript & Code standards

- [ ] Explicit return types on all public functions.
- [ ] No `any` (implicit or explicit without justification).
- [ ] No type assertions (`as`) unless unavoidable.
- [ ] Prefer union types over enums.
- [ ] `readonly` applied where applicable.
- [ ] Boolean variables start with `is`, `has`, `can`.
- [ ] Event handlers start with `on`.
- [ ] API fetchers named `fetch*`, `create*`, `update*`, `delete*`.

---

## Checklist 3 – React & Component structure

- [ ] Function components only. No class components.
- [ ] Props explicitly typed. Interface named `Props` if component-local.
- [ ] Props destructured.
- [ ] No logic in JSX (extract to variables or functions).
- [ ] Early returns over nested conditions.
- [ ] Component is small and focused (single responsibility).
- [ ] File order inside component:
  1. `useState` declarations
  2. Custom hooks
  3. `useEffect`
  4. Internal functions
  5. JSX return

---

## Checklist 4 – Hooks

- [ ] One responsibility per hook.
- [ ] No API calls inside components directly (hooks only, per `patterns.md`).
- [ ] `useEffect` dependencies explicit and correct.
- [ ] No derived state stored (`useState` for computed values is a bug).

---

## Checklist 5 – Accessibility → see `accessibility.md`

- [ ] Semantic HTML used (not `<div>` for interactive elements).
- [ ] All `<img>` have descriptive `alt`.
- [ ] All form inputs have associated `<label>`.
- [ ] All interactive elements keyboard-accessible.
- [ ] `outline: none` never without replacement focus style.
- [ ] Color contrast ≥ 4.5:1.
- [ ] ARIA attributes used correctly (not redundant, not overriding native semantics).
- [ ] Modal has focus trap + closes on `Escape`.
- [ ] Icon-only buttons have `aria-label`.

> Any keyboard or form accessibility issue = **Blocker**.

---

## Checklist 6 – SEO → see `seo.md`

- [ ] Page has unique `<title>` and `<meta name="description">`.
- [ ] Canonical tag present.
- [ ] One `<h1>` per page. Heading hierarchy correct (no skipping levels).
- [ ] Critical content rendered SSR or SSG (not CSR).
- [ ] `sitemap.xml` and `robots.txt` updated if new routes added.
- [ ] Open Graph tags on shareable pages.
- [ ] `alt` text on all images (also an SEO factor).
- [ ] No `noindex` accidentally set on public pages.
- [ ] Structured data (JSON-LD) on article/product/FAQ pages.

> Missing `<title>` or heading violation = **Blocker**.

---

## Checklist 7 – Web Vitals & Performance → see `web-vitals.md`

- [ ] All images use `next/image` (not raw `<img>`).
- [ ] All images have explicit `width` and `height` (CLS prevention).
- [ ] Hero/LCP images have `priority` prop.
- [ ] No large synchronous operations in event handlers (INP risk).
- [ ] New heavy component: is `React.lazy` + `Suspense` applied?
- [ ] New dependency: bundle size justified?
- [ ] No `import *` from large libraries.
- [ ] Lists > 50 items: virtualized or paginated.
- [ ] Fonts: `font-display: swap` applied.
- [ ] Skeleton/placeholder for async content (CLS prevention).

> `<img>` without `next/image` = **Blocker**. Missing dimensions = **Blocker**.

---

## Checklist 8 – Security → see `security.md`

- [ ] No tokens/secrets in `localStorage`, `sessionStorage`, or state.
- [ ] No `NEXT_PUBLIC_` variable containing an API key.
- [ ] `dangerouslySetInnerHTML` used with `DOMPurify.sanitize()` only.
- [ ] No `eval()` or `new Function()`.
- [ ] API calls with user-generated content: input sanitized.
- [ ] File upload: MIME + extension + size validated.
- [ ] CSRF token added to mutating calls (if not using Server Actions).
- [ ] CSP headers configured in `next.config.js`.
- [ ] No secret visible in committed `.env` files.
- [ ] `npm audit` clean (no high/critical vulnerabilities).

> Any secret exposure = **Blocker**. `dangerouslySetInnerHTML` without sanitization = **Blocker**.

---

## Checklist 9 – SCSS & Styles

- [ ] Domain styles in `domains/<domain>/styles.scss`.
- [ ] Global abstracts (colors, mixins, spacing) used before creating new ones.
- [ ] No inline styles except for dynamic values.
- [ ] No JS + styles mixed in the same file.
- [ ] Modular SCSS. No global selectors leaking between domains.

---

## Checklist 10 – Tests → see `testing.md`

- [ ] New feature or refactor includes tests.
- [ ] Coverage ≥ 80% (statements, branches, functions, lines).
- [ ] Edge cases covered.
- [ ] Tests are meaningful (not shallow coverage).
- [ ] No tests for generated code or pure re-exports.

> Coverage below 80% = **Blocker**.

---

## Checklist 11 – Linting

- [ ] No ESLint errors.
- [ ] ESLint warnings justified.
- [ ] No disabled rules without explanation.
- [ ] Configuration files (`package.json`, `.eslintrc`, `next.config.js`) not modified unexpectedly.

> Any ESLint error = **Blocker**.

---

## Checklist 12 – DRY & Readability

- [ ] No duplicated code — existing utilities reused.
- [ ] Multiple `setState` in same scope merged into one object.
- [ ] No clever tricks. Explicit over implicit.
- [ ] Indentation and formatting consistent.
- [ ] No multiple components in the same file.
- [ ] `React.memo`, `useMemo`, `useCallback` only where profiling justifies it.

---

## Checklist 13 – Rendering strategy → see `rendering-strategy.md`

- [ ] SEO-critical page uses SSR or SSG (not CSR).
- [ ] Page exports `metadata` or `generateMetadata`.
- [ ] `'use client'` is on the smallest component that needs it (not the page).
- [ ] Dynamic SSG routes have `generateStaticParams`.
- [ ] Fetch cache strategy is explicit (`no-store`, `revalidate`, or default).
- [ ] Sensitive data never reaches a Client Component.

---

## Checklist 14 – Data fetching → see `data-fetching-patterns.md`

- [ ] Domain has a query key factory (`queryKeys.ts`).
- [ ] Query keys use the factory (not raw strings).
- [ ] Mutation has `onError` handler.
- [ ] Mutation that modifies a list calls `invalidateQueries` on success.
- [ ] `staleTime` set explicitly.
- [ ] Server data not stored in Redux.