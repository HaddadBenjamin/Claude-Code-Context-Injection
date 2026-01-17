![alt text](image.png)

# 🎯 Objective

Build an AI assistant that:

- Understands your tech stack
- Respects your architecture
- Applies your coding standards
- Reviews code like you do
- Doesn't require repeating this information with every prompt
- Can work with existing project resources:
  - **Jira tickets** for requirements and acceptance criteria
  - **Figma mockups** for design fidelity
  - **Swagger / API documentation** for backend integration

Additionally, explore whether it is possible to **connect Claude Code or other AI agents directly to internal resources** (Jira, Swagger, Figma) to work efficiently and leverage live project data.

This is not RAG in the strict sense.  
👉 It's **context injection / prompt grounding via files**.  
RAG is more about APIs, databases, etc., for handling very large-scale data volumes.

---

## ⚠️ Status

**This project is a draft / work in progress.**  
It is an **exploratory project that took ~3 hours to assemble**.

It represents an initial exploration of formalizing AI-assisted development workflows and will evolve over time.

---

## 🔍 Vision

I want to formalize my coding and review methodology with AI so that it respects my standards for:

- **Code quality** — structure, organization, and modularity
- **Architecture** — patterns, separation of concerns, scalability
- **Code splitting** — optimized chunking and lazy loading
- **SEO** — semantic markup, meta tags, structured data
- **Web Vitals** — Core Web Vitals optimization (LCP, CLS, FID/INP)
- **Performance** — bundle size, runtime efficiency, caching strategies
- **Accessibility** — WCAG compliance, keyboard navigation, screen reader support
- **Test coverage** — maintaining high coverage standards
- **Design implementation** — using Figma mockups as the source of truth
- **Feature development from resources** — using Jira tickets, Figma, and Swagger/API to implement complete features with all necessary resources

### 💡 Why?

I'm convinced that if done properly, this approach will:

- **Save time** — for me and future teams on client projects
- **Standardize workflows** — enforce consistency across projects
- **Increase efficiency** — time is money

### 🚀 Long-term Goal

Eventually, we'll only need to **adapt the AI context injection per project** to normalize our entire workflow.

The developer's role will gradually shift to:

- **Reviewing** what the AI produces
- **Validating** the output against requirements
- **Fine-tuning** edge cases

This is the future of development — **AI as the builder, humans as the architects and validators**, fully integrated with existing project management, design, and API resources, while exploring the possibility of **direct AI connections to internal project tools** for maximum efficiency.

---

## 🔧 Points to continue exploring

- Connect Claude Code to **Jira** for project management, **Figma** for UX mockups, and **Swagger** for backend APIs.
- Generate a script **feature from A to Z** using a prompt example by providing the links to Jira, Figma, and Swagger.
- Perform a script **code review** by giving a link to a MR and let Claude Code perform the review automatically while respecting `ai/claude.md` and `ai/context/reviews.md`.
