# Tech Stack

## Frontend

| Technology | Version | Purpose |
|------------|---------|---------|
| React | 18 | UI framework |
| TypeScript | 5 (strict) | Type safety |
| Next.js | 14+ App Router | Framework, SSR/SSG/ISR |
| Redux Toolkit | latest | Global client state |
| React Query (TanStack) | v5 | Server state / data fetching |
| React Hook Form | latest | Form state management |
| Zod | latest | Schema validation + type inference |
| MUI (Material UI) | v5 | Component library / styling |
| SCSS Modules | — | Domain and component styles |
| React ARIA ou Radis UI | — | Accessibility |

## Testing

| Tool | Purpose |
|------|---------|
| Jest | Unit and integration test runner |
| Testing Library | Component and hook testing |
| MSW (Mock Service Worker) | API mocking at network level |
| Playwright | E2E tests |

## Code quality

| Tool | Purpose |
|------|---------|
| ESLint | Linting (source of truth for rules) |
| Prettier | Formatting |
| TypeScript strict | Type checking |

## Monitoring (production)

- Error tracking: Sentry (or equivalent)
- Web Vitals: `web-vitals` npm package + reporting endpoint

---

## Forbidden

- Class-based React components
- Any state management outside Redux Toolkit (for global) or React Query (for server state)
- Raw `fetch` in domain code (use `apiClient` wrapper)
- `localStorage` / `sessionStorage` for tokens or sensitive data => NO, check security file for token (memory)
- CSS-in-JS libraries (Styled Components, Emotion) — use SCSS Modules + MUI `sx` prop only when necessary
- Any new library without justification and bundle size evaluation

---

## Allowed libraries (pre-approved)

- `dompurify` — HTML sanitization
- `@tanstack/react-virtual` — list virtualization
- `openapi-typescript` — type generation from Swagger
- `msw` — API mocking in tests
- `date-fns` — date manipulation (if needed, preferred over moment)
- `zod` — schema validation

Any library not listed requires a justification comment in the PR.s