# Security – Context & Rules

## Core principle

The frontend is a public surface. Never trust it as a security boundary.
All critical validation and authorization happens on the backend.
The frontend's job: minimize attack surface, protect user data, prevent injection.

---

## What NEVER to do (absolute rules)

- **Never** store sensitive data (tokens, API keys, secrets, PII) in: `localStorage`, `sessionStorage`, React state, Redux store, Context, `.env` exposed to client (`NEXT_PUBLIC_` variables).
- **Never** use `dangerouslySetInnerHTML` with unsanitized data.
- **Never** use `eval()`, `new Function()`, or `innerHTML` with user input.
- **Never** send API keys or secrets from the frontend to a backend (the key must live on the server only).
- **Never** commit secrets to git. No `.env` files with secrets in the repository.

---

## JWT & Authentication tokens

### Storage strategy
- Access token: **in-memory only** (JS variable, singleton pattern). Never in localStorage.
- Refresh token: **HttpOnly cookie** with `Secure`, `SameSite=Strict`.

### Cookie attributes (mandatory)
```
Set-Cookie: refreshToken=...; HttpOnly; Secure; SameSite=Strict; Path=/api/refresh
```
- `HttpOnly`: JS cannot read → protects against XSS.
- `Secure`: HTTPS only → prevents interception.
- `SameSite=Strict`: only sent from same origin → prevents CSRF.

### Token singleton (in-memory)
```typescript
// shared/utils/auth/tokenStore.ts
let accessToken: string | null = null;

export const tokenStore = {
  get: () => accessToken,
  set: (token: string) => { accessToken = token; },
  clear: () => { accessToken = null; },
};
```

### New tab / page refresh
- On app init: call `getRefreshToken()` to exchange refresh cookie for a new access token.
- This is the only way to restore the session after a refresh (no localStorage).

---

## XSS (Cross-Site Scripting)

### Attack vector
User input injected as `<script>` tag stored in DB → rendered to other users → steals cookies/data.

### Prevention
- **Sanitize all HTML before rendering**: use `DOMPurify.sanitize(html)` before any dynamic HTML display.
- Avoid `dangerouslySetInnerHTML`. If absolutely necessary: `{ __html: DOMPurify.sanitize(content) }`.
- Sanitize and validate all form inputs (client + server).
- Set CSP headers (see below).

```typescript
import DOMPurify from 'dompurify';

// Only acceptable usage of dangerouslySetInnerHTML
<div dangerouslySetInnerHTML={{ __html: DOMPurify.sanitize(userContent) }} />
```

---

## CSRF (Cross-Site Request Forgery)

### Attack vector
Malicious site triggers authenticated requests to your API using the victim's active session cookies.

### Prevention (if NOT using Next.js Server Actions)
1. Backend generates a CSRF token and sets it in a cookie (`SameSite=Strict`).
2. Frontend reads the token and adds it to every mutating request header (`X-CSRF-Token`).
3. Add token to `<meta name="csrf-token">` in `<head>`.

```typescript
// Read token from meta tag
const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');

// Add to every API call
headers: { 'X-CSRF-Token': csrfToken }
```

> **Note**: Next.js Server Actions handle CSRF protection automatically. No manual implementation needed for Server Actions.

---

## Clickjacking

### Attack vector
Attacker overlays an invisible iframe of your app over their page. User clicks trigger actions on your app unknowingly.

### Prevention (Next.js `next.config.js`)
```javascript
// next.config.js
const securityHeaders = [
  { key: 'X-Frame-Options', value: 'DENY' },
  { key: 'Content-Security-Policy', value: "frame-ancestors 'none'" },
];
```

---

## Content Security Policy (CSP)

CSP limits which resources can be loaded and from where.

### Recommended setup (Next.js)
Use `next-safe` package or configure manually in `next.config.js`:

```javascript
{
  key: 'Content-Security-Policy',
  value: [
    "default-src 'self'",
    "script-src 'self' 'nonce-{nonce}'",
    "style-src 'self' 'unsafe-inline'",  // adjust if using CSS-in-JS
    "img-src 'self' data: https:",
    "font-src 'self'",
    "connect-src 'self' https://api.yourdomain.com",
    "frame-ancestors 'none'",
  ].join('; ')
}
```

### Recommended security headers bundle
```javascript
const securityHeaders = [
  { key: 'X-DNS-Prefetch-Control', value: 'on' },
  { key: 'Strict-Transport-Security', value: 'max-age=63072000; includeSubDomains; preload' },
  { key: 'X-Frame-Options', value: 'DENY' },
  { key: 'X-Content-Type-Options', value: 'nosniff' },
  { key: 'Referrer-Policy', value: 'strict-origin-when-cross-origin' },
  { key: 'Permissions-Policy', value: 'camera=(), microphone=(), geolocation=()' },
];
```

---

## API keys & secrets

- API keys must **never** be in client-side code or `NEXT_PUBLIC_` env vars.
- Use a **server-side proxy** to add the key server-side:
  - Next.js: Server Actions or Route Handlers (`/app/api/`).
  - Backend proxy: the key lives on the server, the client calls your backend.
- One key per environment (dev, staging, prod). Rotate on every leak.
- Use a **secrets manager** (Vault, Doppler, AWS Secrets Manager) to centralize and audit secrets.
- Sync secrets from the manager to your host (Vercel, Railway) automatically.

---

## Environment variables

- `.env` files must be in `.gitignore`. No exceptions.
- `NEXT_PUBLIC_` prefix = exposed to browser. Only use for non-sensitive config.
- Never put: API keys, JWT secrets, database URLs, passwords in `NEXT_PUBLIC_` vars.
- Validate env vars at build time using a schema (e.g., `zod`):

```typescript
// env.ts (server only)
import { z } from 'zod';

const envSchema = z.object({
  DATABASE_URL: z.string().url(),
  JWT_SECRET: z.string().min(32),
  API_KEY: z.string(),
});

export const env = envSchema.parse(process.env);
```

---

## Input validation & file uploads

- **Text inputs**: validate + sanitize client-side AND server-side.
- **File uploads**: verify MIME type, extension, and file size on both sides.
  - Never trust `file.type` alone (can be spoofed).
  - Whitelist allowed MIME types (e.g., `image/jpeg`, `image/png`, `application/pdf`).
  - Enforce max file size.

---

## Secret leak prevention

- Install `gitleaks` as a pre-commit hook to block commits containing secrets.
- If a secret was committed: **revoke immediately**, generate new one, clean git history with `git filter-repo`.
- Run `npm audit fix --audit-level=high` + `npx snyk fix` on every MR.

---

## HTTPS

- HTTPS is mandatory on all environments including staging.
- HSTS header: `Strict-Transport-Security: max-age=63072000; includeSubDomains; preload`.
- Target grade A on `ssllabs.com`.

---

## Obfuscation & minification

- JS/CSS must be minified in production (Next.js does this by default).
- Source maps: disable in production or restrict access to authorized team only.

---

## Audit tools

- `npm audit` + `npx snyk fix`: dependency vulnerabilities.
- `eslint-plugin-security`: static analysis for security anti-patterns.
- `trufflehog filesystem .`: scan codebase for leaked secrets.
- `gitleaks`: pre-commit secret scanning.
- **OWASP ZAP**: dynamic application security testing.
- **Lighthouse**: basic security headers check.
- `ssllabs.com`: TLS/SSL configuration audit.

---

## Claude enforcement rules

- Token/secret in `localStorage` or `sessionStorage` = **blocking issue**.
- `dangerouslySetInnerHTML` without `DOMPurify.sanitize()` = **blocking issue**.
- `NEXT_PUBLIC_` variable containing an API key = **blocking issue**.
- `eval()` or `new Function()` = **blocking issue**.
- Missing CSP headers = **warning**.
- Missing CSRF token on mutating API calls (non-Server-Action) = **blocking issue**.
- `.env` file with real secrets committed = **blocking issue**.
- File upload without MIME + size validation = **blocking issue**.
- HTTP (not HTTPS) in any environment = **blocking issue**.