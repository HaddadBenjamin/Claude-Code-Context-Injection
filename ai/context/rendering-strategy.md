# Rendering Strategy – Next.js App Router

## Decision tree

```
Is the content the same for every user?
  YES → Is it updated frequently (< every hour)?
          YES → ISR (revalidate: 60)
          NO  → SSG (static, no revalidate)
  NO  → Does it need to be indexed by search engines?
          YES → SSR (generateMetadata + server component)
          NO  → CSR (client component, useEffect, React Query)
```

---

## Strategies at a glance

| Strategy | When | Next.js App Router | Cache |
|----------|------|-------------------|-------|
| **SSG** | Marketing pages, blog, docs, landing pages | Default for Server Components with no dynamic data | `force-cache` (default) |
| **ISR** | Content that changes infrequently (articles, catalog) | `export const revalidate = 3600` in page | Revalidated on schedule |
| **SSR** | Personalized, auth-gated, SEO-critical dynamic pages | `export const dynamic = 'force-dynamic'` | `no-store` |
| **CSR** | Dashboards, interactive widgets, non-SEO content | `'use client'` + React Query | Client-side only |

---

## Rules per page type

### Marketing / Landing pages → SSG
```typescript
// app/about/page.tsx — no export needed, static by default
export async function generateMetadata(): Promise<Metadata> {
  return { title: 'About Us', description: '...' };
}

export default async function AboutPage() {
  const data = await fetchStaticContent(); // cached forever
  return <AboutContent data={data} />;
}
```

### Blog / Article pages → ISR
```typescript
// app/blog/[slug]/page.tsx
export const revalidate = 3600; // revalidate every hour

export async function generateStaticParams() {
  const posts = await fetchAllPostSlugs();
  return posts.map((slug) => ({ slug }));
}
```

### User dashboard → SSR
```typescript
// app/dashboard/page.tsx
export const dynamic = 'force-dynamic';

export default async function DashboardPage() {
  const session = await getServerSession(); // auth check server-side
  if (!session) redirect('/login');
  const data = await fetchUserData(session.userId);
  return <Dashboard data={data} />;
}
```

### Interactive widget (no SEO) → CSR
```typescript
// app/analytics/page.tsx — shell is SSR, widget is CSR
import { Suspense } from 'react';
import { AnalyticsChart } from './AnalyticsChart'; // 'use client'

export default function AnalyticsPage() {
  return (
    <main>
      <h1>Analytics</h1>
      <Suspense fallback={<ChartSkeleton />}>
        <AnalyticsChart />
      </Suspense>
    </main>
  );
}
```

---

## Server Components vs Client Components

### Use Server Components (default) when:
- Fetching data directly from DB or API (no user interaction needed).
- Rendering static or SSR content.
- Using sensitive data (tokens, API keys must never reach the client).
- Reducing JS bundle size is a priority.

### Use Client Components (`'use client'`) when:
- Using browser APIs (`window`, `document`, `localStorage`).
- Using hooks (`useState`, `useEffect`, `useCallback`, React Query).
- Handling user interactions (click, input, form).
- Using third-party libs that require client context.

### ✅ DO
```typescript
// Server Component fetches, passes data down to Client Component
// app/products/page.tsx (Server)
import { ProductFilters } from './ProductFilters'; // 'use client'

export default async function ProductsPage() {
  const initialProducts = await fetchProducts();
  return <ProductFilters initialData={initialProducts} />;
}
```

### ❌ DON'T
```typescript
// Don't add 'use client' to a page just to use one interactive child
// Lift 'use client' to the smallest component that needs it
'use client'; // Wrong — entire page becomes CSR
export default function ProductsPage() { ... }
```

---

## Metadata

Every page must export `generateMetadata` or a static `metadata` object:

```typescript
// Static
export const metadata: Metadata = {
  title: 'Page Title',
  description: 'Page description',
  openGraph: { title: '...', description: '...', images: ['/og.jpg'] },
  alternates: { canonical: 'https://example.com/page' },
};

// Dynamic
export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const product = await fetchProduct(params.slug);
  return {
    title: product.name,
    description: product.description,
    alternates: { canonical: `https://example.com/products/${params.slug}` },
  };
}
```

---

## Caching in Server Components

```typescript
// Default: cached forever (SSG behavior)
const data = await fetch('https://api.example.com/data');

// ISR: revalidate every N seconds
const data = await fetch('https://api.example.com/data', {
  next: { revalidate: 3600 },
});

// SSR: never cache
const data = await fetch('https://api.example.com/data', {
  cache: 'no-store',
});

// Tag-based revalidation (on demand)
const data = await fetch('https://api.example.com/data', {
  next: { tags: ['products'] },
});
// Invalidate from Server Action: revalidateTag('products')
```

---

## Prefetching

```typescript
// Next.js <Link> prefetches by default on hover/visible in viewport
<Link href="/products">Products</Link>

// Disable prefetch for authenticated routes
<Link href="/dashboard" prefetch={false}>Dashboard</Link>

// Programmatic prefetch
import { useRouter } from 'next/navigation';
const router = useRouter();
router.prefetch('/heavy-page');
```

---

## Claude enforcement rules

- CSR-only for SEO-critical page = **Blocker**.
- Page without `metadata` or `generateMetadata` = **Blocker**.
- `'use client'` on a page when only a child needs it = **Warning**.
- Fetch without explicit cache strategy in dynamic context = **Warning**.
- Missing `generateStaticParams` on dynamic SSG route = **Blocker**.
- Sensitive data (token, API key) in a Client Component = **Blocker**.