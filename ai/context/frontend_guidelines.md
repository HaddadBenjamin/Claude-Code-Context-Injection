# Frontend Code Guidelines

## Purpose

Ensure all frontend code is **accessible, SEO-friendly, secure, performant, and optimized for Web Vitals**.

> Each topic has a dedicated context file. This file is the entry point — always read the dedicated files for full rules.

---

## Dedicated context files

| Topic | File | Priority |
|-------|------|----------|
| Accessibility (A11y) | `accessibility.md` | Mandatory |
| SEO | `seo.md` | Mandatory |
| Web Vitals & Performance | `web-vitals.md` | Mandatory |
| Security | `security.md` | Mandatory |

---

## Principles (summary)

### 1. Accessibility (a11y) → see `accessibility.md`

- Semantic HTML. ARIA only when necessary.
- Keyboard navigation on all interactive elements.
- Color contrast ≥ 4.5:1. Focus always visible.
- Forms: every input has a `<label>`.
- WCAG 2.1 Level AA minimum.

### 2. SEO → see `seo.md`

- Every page: unique `<title>`, `<meta description>`, canonical tag.
- One `<h1>` per page. Hierarchy: H1 → H2 → H3.
- Critical content: SSR or SSG (not CSR).
- `/sitemap.xml` and `/robots.txt` mandatory.
- Schema.org JSON-LD for articles, products, FAQs.

### 3. Security → see `security.md`

- No tokens/secrets in localStorage, sessionStorage, or client env vars.
- Sanitize all HTML with DOMPurify before rendering.
- No `dangerouslySetInnerHTML` without sanitization.
- CSP headers. HTTPS mandatory. CSRF protection on mutating calls.
- API keys only on server-side proxy.

### 4. Performance & Web Vitals → see `web-vitals.md`

- LCP ≤ 2.5s · INP ≤ 200ms · CLS ≤ 0.1.
- `next/image` for all images. No raw `<img>`.
- Code split by route and on demand for heavy components.
- Memoize only where profiling shows a real bottleneck.
- CDN for static assets. Proper Cache-Control headers.

### 5. Best Practices

- TypeScript strict mode. Explicit types. No implicit `any`.
- Function components only. No class components.
- Component-based design. One component per file.
- Unit and integration tests for all critical logic (≥ 80% coverage).
- Document components via Storybook (design-system) or inline JSDoc.