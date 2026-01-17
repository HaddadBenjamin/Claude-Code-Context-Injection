# Frontend Code Guidelines

## Purpose

Ensure all frontend code is **accessible, SEO-friendly, secure, performant, and optimized for Web Vitals**.

## Principles

### 1. Accessibility (a11y)

- Use semantic HTML (`<header>`, `<main>`, `<footer>`, `<nav>`, etc.).
- Always provide `alt` text for images.
- Ensure sufficient color contrast.
- Use ARIA roles and labels when necessary.
- Keyboard navigation must work for all interactive elements.
- Forms must have `<label>` associated with inputs.

### 2. SEO

- Use proper headings hierarchy (`<h1>` → `<h2>` → `<h3>` …).
- Meta tags: `title`, `description`, `robots`, `canonical`
- Use `robots.txt`, `schema.org`
- Structured data (JSON-LD) for rich snippets if relevant.
- Lazy-load images but keep them indexable.
- Avoid duplicate content.
- SSR (Server-Side Rendering) or pre-rendering for critical content (Next.js: `getServerSideProps`, `getStaticProps`).

### 3. Security

- Sanitize all user input (XSS prevention).
- Avoid `dangerouslySetInnerHTML` unless sanitized.
- Use HTTPS and secure cookies.
- Set proper Content Security Policy (CSP) headers.
- Validate data both client-side and server-side.

### 4. Performance & Web Vitals

- Minimize bundle size: code-splitting, tree-shaking.
- Optimize images: WebP/AVIF, responsive sizes.
- Use `next/image` or lazy-loading images/components.
- Avoid layout shifts: set width/height for images and embeds.
- Use caching and CDN where possible.
- Monitor Core Web Vitals: LCP, CLS, FID.
- Use React.memo, useCallback, useMemo when necessary.

## 5. Best Practices

- Component-based design (React/Next.js).
- Use TypeScript for type safety.
- Follow naming conventions and modular SCSS architecture.
- Write unit and integration tests for critical code.
- Document components and styles clearly.
