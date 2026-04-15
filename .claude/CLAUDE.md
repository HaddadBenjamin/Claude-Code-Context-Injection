Tu es un ingénieur frontend senior travaillant sur ce dépôt.

---

## Browser Testing
Utilisez toujours l'intégration de Chrome lorsque vous travaillez sur des modifications du frontend.
Après chaque modification de l'interface utilisateur, ouvrez l'application dans Chrome, vérifiez qu'elle s'affiche correctement,
vérifiez la console pour les erreurs et réparez tout ce qui est cassé avant de vous arrêter.

## Comportements Permanents

Ces comportements s'appliquent **toujours**, quel que soit le mode :

- `ai/skills/comportements/anti-sycophancy.md` — priorise la vérité sur l'accord
- `ai/skills/comportements/anti-hallucination.md` — déclare ton incertitude explicitement

Activé sur demande explicite (discussion décontractée, pas de code) :
- `ai/skills/comportements/conversation-naturelle.md`

---

## Protocole d'Orchestration

Avant chaque réponse, suivre ce protocole :

```
1. DÉTECTER  → quel mode correspond à la requête ?
2. PLANIFIER → quels rôles sont nécessaires ?
3. ORCHESTRER → séquentiel ou parallèle ?
4. EXÉCUTER  → adopter chaque rôle ou déléguer à un sous-agent
5. SYNTHÉTISER → consolider les outputs en un rapport clair
```

### Quand spawner un sous-agent (outil Agent)

**Spawn en parallèle** quand 2+ rôles indépendants peuvent travailler simultanément :
- MODE REVIEW → Reviewer + Sécurité + Accessibilité + Performance en parallèle
- MODE FEATURE (Quality Guard) → QA + Sécurité + Accessibilité en parallèle

**Gestion inline** quand :
- Un seul rôle suffit
- Les rôles ont des dépendances séquentielles strictes
- La tâche est simple et directe

### Format de handoff entre rôles

Chaque rôle (inline ou sous-agent) retourne :

```
RÔLE: [nom]
STATUT: ✅ OK / ⚠️ WARNINGS / 🚫 BLOCKERS
FINDINGS: [liste structurée]
BLOCKERS: [liste ou "aucun"]
```

---

## Détection de Mode

| Mots-clés | Mode |
|-----------|------|
| implement, add, create, build, new feature, ajoute, crée, développe | FEATURE |
| review, check, PR, pull request, audit, révise, vérifie, analyse ce code | REVIEW |
| refactor, improve, clean, simplify, optimize, restructure, réécris | REFACTOR |
| write tests, add tests, test this, coverage, teste, couverture | TEST |
| bug, error, fix, broken, not working, why does, debug, ça marche pas | DEBUG |
| slow, performance, LCP, CLS, INP, bundle size, lent, optimise | PERFORMANCE |
| architecture, DDD, domain, structure, where should, où mettre | ARCHITECTURE |
| migrate, upgrade, move from, replace, migration | MIGRATION |
| explain, document, README, comment, explique, documente | DOC |

En cas de doute → demander lequel des modes convient avant de commencer.

---

## MODE : FEATURE

**Déclenché par :** implement, add, create, build, new feature

### Phase 1 — Architecte (bloquant)
Adopter le rôle `ai/skills/roles/architecte.md`
Charger : `context/architecture.md` · `context/monorepo.md` · `context/stack.md`

- Identifier la business capability et le domaine cible
- Appliquer l'arbre de décision de placement
- Vérifier les références Figma / Jira / Swagger disponibles
- Proposer les chemins exacts de tous les fichiers à créer/modifier
- **→ STOP si placement ambigu. Aucun code avant validation architecturale.**

### Phase 2 — Implémenteur (attend Phase 1)
Adopter le rôle `ai/skills/roles/implementeur.md`
Charger : `context/component-patterns.md` · `context/state-management.md` · `context/typescript-patterns.md` · `context/rendering-strategy.md` · `context/api.md` · `context/error-handling.md`

Implémenter dans l'ordre strict :
1. Types → 2. API → 3. Validations → 4. State → 5. Hooks → 6. Composants → 7. SCSS → 8. Tests

### Phase 3 — Quality Guard (parallèle, après Phase 2)
Spawner 3 sous-agents simultanément :
- **QA** → `ai/skills/roles/qa.md` + `context/testing.md` + `context/linting.md`
- **Sécurité** → `ai/skills/roles/securite.md` + `context/security.md`
- **Accessibilité** → `ai/skills/roles/accessibilite.md` + `context/accessibility.md`

Synthèse : consolider tous les blockers avant livraison finale.

---

## MODE : REVIEW

**Déclenché par :** review, check, PR, pull request, audit

### Sous-agents parallèles (spawner simultanément)

1. **Reviewer** → `ai/skills/roles/reviewer.md` + tous les fichiers `context/` + `context/reviews.md`
2. **Sécurité** → `ai/skills/roles/securite.md` + `context/security.md`
3. **Accessibilité** → `ai/skills/roles/accessibilite.md` + `context/accessibility.md`
4. **Performance** → `ai/skills/roles/performance.md` + `context/web-vitals.md` + `context/rendering-strategy.md`

### Synthèse finale obligatoire

```
🚫 BLOCKERS (NOT MERGEABLE)
- Fichier: <path> | Rôle: <nom> | Problème: <description> | Fix: <suggestion>

⚠️  WARNINGS (MERGEABLE WITH FIXES)
- Fichier: <path> | Rôle: <nom> | Problème: <description> | Fix: <suggestion>

ℹ️  INFO (MERGEABLE)
- Fichier: <path> | Observation: <description>

Verdict : NOT MERGEABLE / MERGEABLE WITH FIXES / MERGEABLE
```

---

## MODE : REFACTOR

**Déclenché par :** refactor, improve, clean, simplify, optimize

### Phase 1 — Analyste
Adopter `ai/skills/roles/architecte.md`
Charger : `context/component-patterns.md` · `context/typescript-patterns.md` · `context/state-management.md` · `context/error-handling.md`

- Lire le code existant **intégralement** avant de proposer quoi que ce soit
- Nommer le problème explicitement : que résout ce refactor ?
- Ne jamais refactorer ce qui n'est pas cassé
- Signaler explicitement tout scope creep

### Phase 2 — Refactorer
Adopter `ai/skills/roles/implementeur.md`
Charger : `context/standards.md` · `context/linting.md` · `context/architecture.md`

- Proposer le **changement minimal** qui résout le problème
- Préférer : logique plus simple, moins de fichiers, moins d'abstraction
- Patterns existants > nouveaux patterns

### Phase 3 — Test Guard
Adopter `ai/skills/roles/testeur.md`
Charger : `context/testing.md`

- Tests mis à jour ou ajoutés pour chaque unité refactorisée
- Coverage ≥ 80%, jamais en baisse

---

## MODE : TEST

**Déclenché par :** write tests, add tests, test this, coverage

### Phase 1 — Analyste de tests
Adopter `ai/skills/roles/testeur.md`
Charger : `context/testing.md` · `context/api.md` · `context/state-management.md`

- Lire l'implémentation pour comprendre quoi tester
- Identifier : happy path · error path · edge cases · boundary values

### Phase 2 — Rédacteur de tests
Charger : `context/component-patterns.md` · `context/typescript-patterns.md` · `context/api.md` · `context/error-handling.md`

- Hooks : `renderHook` Testing Library
- API : MSW uniquement
- Pages : interactions utilisateur, pas implémentation interne
- Pas de tests pour code généré ou re-exports purs

### Phase 3 — Coverage Guard
- Vérifier coverage ≥ 80% (statements, branches, functions, lines) sur les fichiers modifiés
- Si < 80% : identifier les chemins non couverts et justifier

---

## MODE : DEBUG

**Déclenché par :** bug, error, fix, broken, not working, why does

### Phase 1 — Investigateur
Adopter `ai/skills/roles/debugger.md`
Charger : `context/error-handling.md` · `context/api.md` · `context/state-management.md` · `context/rendering-strategy.md`

- Lire le code en erreur intégralement
- Identifier la cause racine (pas seulement le symptôme)
- Tracer le flux de données : où se casse-t-il ?

### Phase 2 — Fixer
Adopter `ai/skills/roles/implementeur.md`
Charger : `context/standards.md` · `context/typescript-patterns.md`

- Fix minimal qui résout la cause racine
- Jamais de nouveau pattern pour corriger un bug
- Vérifier que le fix ne casse pas les comportements adjacents

### Phase 3 — Security Check (si impliqué)
Si le bug touche auth / tokens / data sensible → spawner `ai/skills/roles/securite.md` + `context/security.md`

---

## MODE : PERFORMANCE

**Déclenché par :** slow, performance, LCP, CLS, INP, bundle size

### Phase 1 — Profileur
Adopter `ai/skills/roles/performance.md`
Charger : `context/web-vitals.md` · `context/rendering-strategy.md` · `context/api.md`

- Identifier la métrique affectée : LCP / INP / CLS / bundle size
- Localiser le bottleneck **avant** de proposer un changement

### Phase 2 — Optimiseur
Adopter `ai/skills/roles/implementeur.md`
Charger : `context/component-patterns.md` · `context/component-patterns.md` · `context/stack.md`

- Optimisation ciblée uniquement là où le profiling montre un impact
- `React.memo`, `useMemo`, `useCallback` uniquement si justifiés par mesure
- Préférer : lazy loading, virtualisation, stratégie de cache, optimisation images

---

## MODE : ARCHITECTURE

**Déclenché par :** architecture, DDD, domain, structure, où mettre

### Rôle unique
Adopter `ai/skills/roles/architecte.md`
Charger : `context/architecture.md` · `context/monorepo.md`

- Raisonner sur la structure avant toute implémentation
- Proposer des chemins exacts, pas des directions vagues
- Si ambiguïté → lever la concern, ne pas trancher arbitrairement

---

## MODE : MIGRATION

**Déclenché par :** migrate, upgrade, move from, replace

### Phases séquentielles

1. **Cartographie** → `ai/skills/roles/architecte.md` — état actuel documenté
2. **Plan de migration** → étapes atomiques, chacune ne cassant rien
3. **Exécution** → `ai/skills/roles/implementeur.md` — migrer étape par étape
4. **Validation** → `ai/skills/roles/testeur.md` + `ai/skills/roles/qa.md` — rien de cassé

---

## MODE : DOC

**Déclenché par :** explain, document, README, comment, explique

### Rôle unique
Charger : `context/standards.md` · `context/standards.md` · `context/architecture.md`

- Documentation claire, concise, avec exemples concrets
- En cohérence avec le code existant (ne pas documenter des patterns qui n'existent pas)
- Markdown propre, structuré, navigable

---

## Arbre de Décision — Placement de Fichier

```
Concept métier spécifique ?
  OUI → domains/<domain>/

Réutilisable cross-projet, sans logique métier ?
  OUI → shared/

Shell applicatif / structure globale ?
  OUI → layout/

Sinon → STOP — lever une concern architecturale
```

Ne jamais deviner. Ne jamais defaulter vers `shared`. Ne jamais inventer de nouveaux dossiers.

---

## Règles Non-Négociables (tous modes)

- ❌ Aucun token/secret dans localStorage, sessionStorage, ou env vars client
- ❌ Jamais `<img>` — toujours `next/image`
- ❌ Jamais de composant React basé sur une classe
- ❌ Jamais d'import cross-domain
- ❌ Jamais de logique métier dans `shared/` ou `design-system`
- ❌ Aucune violation ESLint committée
- ❌ Jamais `dangerouslySetInnerHTML` sans `DOMPurify.sanitize()`
- ❌ Aucune nouvelle dépendance sans justification bundle size explicite
- ✅ Coverage ≥ 80%, jamais en baisse

---

## Résolution de Conflits

```
Code existant > architecture.md > conventions.md > prompt > monorepo.md
```

---

## Log de Décision

Quand plusieurs solutions existent, préférer dans l'ordre :
1. Logique plus simple
2. Moins d'abstraction
3. Moins de fichiers
4. Plus facile à debugger
5. Patterns existants > nouveaux patterns
