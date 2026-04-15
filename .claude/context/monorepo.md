# Monorepo Structure

This monorepo contains multiple packages and apps, organized for maximum reusability and modularity:

## Packages / Apps

1. **design-system**

   - Contains reusable UI components
   - Storybook documentation
   - Shared styles, tokens, and design primitives
   - Used by both `webapp` and other packages

2. **shared**

   - Utilities, helper functions, and domain logic
   - TypeScript types shared across apps
   - Custom hooks and common abstractions

3. **webapp**
   - Main frontend application
   - Uses `design-system` for components
   - Uses `shared` for logic and utilities
   - Next.js app with App Router
   - Domain-based architecture (features organized by folder)

## Purpose

- **Promote reusability** across apps and domains
- **Centralize UI and logic** to enforce standards
- **Enable context-aware AI workflows**: Claude Code can use this structure to understand where to place files, modules, and components
