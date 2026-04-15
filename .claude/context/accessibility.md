# Accessibility (A11y) – Context & Rules

## Why it matters

1 in 4 people has a disability (visual, auditory, motor, cognitive).
WCAG compliance is a legal requirement in many countries and a quality standard everywhere.
Accessibility = usability for everyone.

---

## Standard

**WCAG 2.1 – Level AA** is the mandatory target.
- Level A: minimum (required).
- Level AA: recommended and enforced here.
- Level AAA: excellent, apply when possible.

---

## Mandatory checklist (Claude must enforce)

### Semantic HTML

- Always use semantic elements: `<button>`, `<a>`, `<nav>`, `<header>`, `<main>`, `<footer>`, `<section>`, `<article>`.
- Never use `<div role="button">` when `<button>` can be used.
- `<button>` for actions, `<a href>` for navigation. They are not interchangeable.

### ARIA

- Use ARIA only when native HTML semantics are insufficient.
- Required attributes: `aria-label`, `aria-describedby`, `aria-hidden`, `role`, `aria-live`, `aria-expanded`, `aria-controls`.
- `aria-hidden="true"` on decorative icons/images.
- `aria-live="polite"` on dynamic content regions (notifications, errors).
- Never use ARIA to override native semantics incorrectly.

### Keyboard navigation

- All interactive elements must be reachable and operable via keyboard: `Tab`, `Shift+Tab`, `Enter`, `Space`, `Escape`, arrow keys.
- Tab order must be logical and match visual order.
- `tabIndex` must only be `0` or `-1`. Never use positive `tabIndex`.
- Modal/dialog: focus must be trapped inside when open; restored to trigger on close.
- Dropdown/menu: arrow key navigation mandatory.

### Focus management

- `:focus-visible` must be visible on all interactive elements. Never `outline: none` without a custom focus style.
- On route change (Next.js): focus must move to the main content area or page `<h1>`.
- Skip navigation link: `<a href="#main-content">Skip to main content</a>` as first element in `<body>`.

### Color contrast

- Text vs background minimum ratio: **4.5:1** (normal text), **3:1** (large text ≥ 18px or 14px bold).
- UI components and focus indicators: minimum **3:1**.
- Never convey information with color alone (add icon, text, or pattern).
- Tool: WebAIM contrast checker.

### Images & media

- All `<img>` used for content: `alt="descriptive text"`. Never `alt="image"` or `alt="photo"`.
- Decorative images: `alt=""` and `aria-hidden="true"`.
- Videos: captions required. Audio: transcripts required.
- SVG icons used as interactive elements: `aria-label` or `<title>` inside SVG.

### Forms

- Every `<input>`, `<select>`, `<textarea>` must have an associated `<label>` (via `for`/`id` or wrapping).
- Group related inputs with `<fieldset>` + `<legend>`.
- Error messages: linked to inputs via `aria-describedby`; must describe the issue clearly.
- Required fields: `aria-required="true"` + visual indicator (not only `*`).
- Autocomplete: use `autocomplete` attribute on common fields (name, email, address).

### Motion & animation

- Respect `prefers-reduced-motion` media query: disable or reduce animations.
- No flashing content (epilepsy risk): nothing flashing more than 3 times per second.

---

## Component-level rules

### Modals / Dialogs
- `role="dialog"` + `aria-modal="true"` + `aria-labelledby` pointing to title.
- Focus trap inside modal.
- Close on `Escape`.

### Tooltips
- Triggered by focus and hover.
- `role="tooltip"` + `aria-describedby` on trigger.

### Alerts / Notifications
- `role="alert"` or `aria-live="polite"` for non-critical updates.

### Tables
- `<th scope="col|row">` for headers.
- `<caption>` for table description.

---

## Audit tools

- **Lighthouse** (Chrome DevTools): automated score.
- **axe DevTools** (browser extension): detailed WCAG violations.
- **pa11y CLI**: automated CI checks.
- **NVDA** (Windows, free) / **VoiceOver** (Mac, built-in): manual screen reader testing.
- **WebAIM contrast checker**: contrast ratio verification.
- **Storybook a11y addon**: component-level audit.

---

## Claude enforcement rules

- Any interactive element not keyboard-accessible = **blocking issue**.
- Missing `alt` on content image = **blocking issue**.
- Missing `<label>` on form input = **blocking issue**.
- `outline: none` without custom focus style = **blocking issue**.
- Color contrast below 4.5:1 = **blocking issue**.
- `<div>` used as button/link = **blocking issue**.
- Missing `aria-label` on icon-only buttons = **blocking issue**.
- Missing focus trap in modal = **blocking issue**.
- Animation without `prefers-reduced-motion` support = **warning**.