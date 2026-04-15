# SEO – Context & Rules

## Why it matters

93% of web traffic goes through search engines.
69% of searches are now AI-generated (no click generated).
SEO = visibility = existence.

---

## Mandatory checklist (Claude must enforce on every page/component)

### Metadata

- Every page MUST have a unique `<title>` and `<meta name="description">`.
- Open Graph tags are mandatory for shareable pages: `og:title`, `og:description`, `og:image`, `og:url`.
- Canonical tag on every page: `<link rel="canonical" href="..." />` to prevent duplicate content.
- `robots` meta must be explicit: `<meta name="robots" content="index, follow" />` or `noindex` when needed.

### Semantic HTML

- Use semantic elements: `<header>`, `<main>`, `<article>`, `<section>`, `<footer>`, `<nav>`, `<aside>`.
- One `<h1>` per page. Headings must be hierarchical: H1 → H2 → H3. No skipping levels.
- Never use `<div>` or `<span>` where a semantic element exists.

### Rendering strategy (Next.js)

- Critical content (for indexing) MUST use SSR or SSG: `getServerSideProps`, `getStaticProps`, `getStaticPaths`.
- Hybrid rendering is allowed: static shell + server-rendered critical content.
- CSR-only pages are forbidden for SEO-critical routes.
- Cache server components aggressively; use `revalidate` with ISR where applicable.

### Crawl depth & internal linking

- Maximum crawl depth: 3–4 clicks from homepage.
- Avoid deep nested routes: `/category/sub/sub-sub/product/` is forbidden.
- Every new page must answer: "Which existing pages link to this?" and "Which pages does this link to?"
- Internal links must use `<a>` or Next.js `<Link>`, never JS `onClick` navigation for primary links.

### Files

- `/sitemap.xml` must include all indexable routes and be submitted to Google Search Console and Bing Webmaster Tools.
- `/robots.txt` must allow crawling of public routes and block `/admin/`, API routes, and private sections.

### Schema.org (structured data)

- Use JSON-LD for relevant content types: `Article`, `Product`, `FAQPage`, `HowTo`, `Organization`, `BreadcrumbList`.
- Add `author`, `datePublished`, `dateModified` on article pages.
- Validate with Google Rich Results Test.

### Images

- All `<img>` must have a descriptive `alt` attribute. Never use `alt=""` for content images.
- Use `next/image` for automatic optimization (WebP/AVIF, lazy loading, size reservation).
- Lazy-load images below the fold; preload hero/LCP images with `<link rel="preload" as="image">`.

### AI-friendly SEO (GEO / LLMO)

- Submit sitemap to **Bing Webmaster Tools** (used by ChatGPT).
- Use **IndexNow** protocol to signal updates.
- GEO: structure content so AI engines can extract and cite it (clear headings, concise paragraphs, factual tone).
- LLMO: content must be trustworthy, well-structured, and factually accurate for LLM training ingestion.

---

## Audit tools

- Google Search Console: check indexation errors and coverage.
- `site:mondomaine.com` in Google: verify indexed pages.
- Lighthouse (Chrome DevTools): SEO score + issues.
- Bing Webmaster Tools: Bing indexation.
- Schema.org validator / Google Rich Results Test.

---

## Claude enforcement rules

- Any page component without `<title>` and `<meta description>` = **blocking issue**.
- Any heading hierarchy violation = **blocking issue**.
- Any CSR-only page for SEO-critical content = **blocking issue**.
- Missing canonical tag = **warning**.
- Missing structured data on article/product pages = **warning**.
- Missing sitemap or robots.txt = **blocking issue**.