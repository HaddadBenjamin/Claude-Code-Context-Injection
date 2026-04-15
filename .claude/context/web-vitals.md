# Web Vitals & Performance – Context & Rules

## Why it matters

Core Web Vitals are a direct Google ranking factor.
They measure real user experience: loading speed, interactivity, visual stability.
Performance = SEO + UX + conversion rate.

---

## Core Web Vitals targets

| Metric | Good | Needs improvement | Poor |
|--------|------|-------------------|------|
| **LCP** – Largest Contentful Paint | ≤ 2.5s | 2.5s – 4s | > 4s |
| **INP** – Interaction to Next Paint | ≤ 200ms | 200ms – 500ms | > 500ms |
| **CLS** – Cumulative Layout Shift | ≤ 0.1 | 0.1 – 0.25 | > 0.25 |

All three must be in the **"Good"** range.

---

## LCP – Largest Contentful Paint

The largest visible element must load fast (hero image, H1, above-the-fold content).

### Rules
- Hero images: `priority` prop on `next/image` (preloads automatically).
- `<link rel="preload" as="image" href="hero.jpg" />` for critical images not using `next/image`.
- Minimize render-blocking CSS/JS: defer or async non-critical scripts.
- Use HTTP/2 or HTTP/3.
- Minify CSS; inline critical CSS above the fold.
- CDN for all static assets.
- Image formats: WebP or AVIF. Never serve JPEG/PNG without compression.

---

## INP – Interaction to Next Paint

Every interaction (click, keypress, tap) must respond quickly.

### Rules
- Heavy computations must be moved to **Web Workers** (off main thread).
- Event handlers must be lightweight: no synchronous API calls, no DOM thrashing.
- Use `useCallback` to memoize event handlers passed to children.
- Debounce inputs: `useDebounce` for search, filters, resize handlers.
- Avoid large JS bundles blocking the main thread.
- Use `startTransition` (React 18) for non-urgent state updates.
- `React.lazy` + `Suspense` for code splitting.

---

## CLS – Cumulative Layout Shift

Elements must not move unexpectedly after initial render.

### Rules
- All images and embeds: **always set explicit `width` and `height`** (or use `aspect-ratio` CSS).
- Use `next/image` which handles this automatically.
- Fonts: `font-display: swap` to prevent invisible text during load. Use `font-size-adjust` to minimize reflow.
- Preload web fonts: `<link rel="preload" as="font">`.
- Ads and dynamic content: reserve space with a container of fixed dimensions.
- Avoid injecting content above existing content after load.
- Skeleton screens instead of no placeholder.

---

## Bundle size & code splitting

- Every new dependency must be justified: evaluate bundle impact first (`webpack-bundle-analyzer`, `bundlephobia.com`).
- Route-based code splitting: automatic with Next.js App Router.
- Component-level splitting: `React.lazy` + `Suspense` for heavy components (charts, maps, rich text editors).
- Dynamic imports for non-critical third-party libs.
- Tree shaking: import named exports only. Never `import * from`.
- No unused dependencies: run `npm ls` and audit quarterly.

---

## Images

Images = 80% of page weight. Maximum ROI optimization.

### Rules
- Always use `next/image` instead of `<img>`. No exceptions.
- `next/image` handles: lazy loading, WebP/AVIF conversion, responsive sizes, CLS prevention.
- Provide `sizes` prop to serve appropriately sized images per viewport.
- Compress originals before upload: TinyPNG, ImageOptim, or Imagemin.
- Use `<picture>` + `<source>` for art direction (different crops per breakpoint).
- SVG for icons and illustrations: infinitely scalable, no pixel format needed.

---

## Rendering strategy (Next.js)

| Strategy | When to use |
|----------|-------------|
| **SSG** (Static Site Generation) | Marketing pages, blog posts, anything not user-specific |
| **ISR** (Incremental Static Regeneration) | Content that changes infrequently |
| **SSR** (Server-Side Rendering) | Personalized content, auth-gated pages |
| **CSR** (Client-Side Rendering) | Highly interactive widgets, non-SEO content only |

- Use `cache()` and `revalidate` in React Server Components.
- Prefetch important routes: `<Link prefetch>` in Next.js.
- Preload critical resources: `<link rel="preload">`.

---

## Memoization (React)

Use memoization judiciously — only when profiling shows a real bottleneck.

- `React.memo`: prevent re-render of pure components receiving same props.
- `useMemo`: memoize expensive computations (heavy filtering, sorting).
- `useCallback`: memoize callbacks passed to memoized children.
- Never memoize trivially cheap operations (premature optimization).

---

## Caching & CDN

- Static assets: `Cache-Control: public, max-age=31536000, immutable`.
- HTML pages: short-lived or `no-cache` with revalidation.
- Use CDN (Cloudflare, Vercel Edge, AWS CloudFront) for all static assets.
- API responses: use React Query's `staleTime` and `cacheTime` appropriately.

---

## Script loading

- Third-party scripts: use `<Script strategy="lazyOnload">` (Next.js Script component).
- Analytics: load after user interaction or with `requestIdleCallback`.
- Never block rendering with synchronous scripts in `<head>`.

---

## Pagination & infinite scroll

- Lists of more than 50 items must be paginated or virtualized.
- Use `react-virtual` or `@tanstack/react-virtual` for very long lists.
- Infinite scroll: use Intersection Observer, not scroll event listeners.

---

## Audit tools

- **Lighthouse** (Chrome DevTools or CI): comprehensive score.
- **PageSpeed Insights**: real-world CWV data.
- **Chrome DevTools Performance tab**: flame charts, main thread analysis.
- **webpack-bundle-analyzer**: bundle composition.
- **web-vitals** (npm): measure CWV in production code.

---

## Claude enforcement rules

- `<img>` without `next/image` = **blocking issue**.
- Image without explicit dimensions (risk of CLS) = **blocking issue**.
- No code splitting on heavy route = **warning**.
- `import *` from a large library = **warning**.
- New dependency without bundle size justification = **blocking issue**.
- Long event handler on critical interaction (> 50ms sync work) = **warning**.
- No skeleton/placeholder for async content = **warning**.
- Font loaded without `font-display: swap` = **warning**.