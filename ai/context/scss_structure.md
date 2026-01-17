# SCSS Structure & Best Practices

## 1️⃣ Global Styles (styles/)

- \_animations.scss: reusable CSS animations
- \_borders.scss: borders and outline styles
- \_breakpoints.scss: breakpoints / media queries
- \_colors.scss: color palette / variables
- \_mixins.scss: generic reusable mixins
- \_sharedRules.scss: global rules, helpers, utilities
- \_spacings.scss: margins, paddings, global spacing
- \_texts.scss: typography (fonts, sizes, text styles)
- styles.scss: global entry point, imports all abstracts

> `_*.scss` files are **partials**, never compiled alone.

## 2️⃣ Domain Styles (domains/)

Each domain or feature can have its own `styles.scss`:

---

## 3️⃣ `domains/domainA.md` – Domain-specific Context Example

```markdown
# DomainA - SCSS Guidelines

## Purpose

Contains styles specific to DomainA.

## Best Practices

1. Import only the necessary global abstracts (colors, mixins, etc.)
2. Do not modify global abstracts in this domain.
3. Place all domain-specific styles here.

## Example

@use '../../styles/\_colors' as colors;
@use '../../styles/\_mixins' as mixins;

.button {
background-color: colors.\$primary;
@include mixins.flexCenter;
}
```

## Frontend Guidelines for DomainA

- All components and styles must follow:
  - Accessibility (a11y)
  - SEO best practices
  - Security (sanitize inputs, CSP)
  - Performance and Web Vitals optimization
