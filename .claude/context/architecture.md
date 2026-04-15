# Architecture – Domain Driven Design

## Structure Générale

```
src/
  domains/    # Business capabilities (bounded contexts)
  shared/     # Code réutilisable cross-projet
  layout/     # Application shell
```

---

## Arbre de décision (obligatoire avant tout nouveau fichier)

```
Code métier spécifique ?
  OUI → domains/<domain>/

Réutilisable cross-projet sans modification ?
  OUI → shared/

Shell applicatif / structure globale ?
  OUI → layout/

Sinon → STOP — lever une concern architecturale
```

Ne jamais deviner. Ne jamais defaulter vers `shared`. Ne jamais inventer de nouveaux dossiers.

---

## Domains

Chaque dossier dans `src/domains/` représente une business capability (bounded context).

**Quand placer dans un domain ?**
- Contient de la logique métier
- Spécifique à un concept business
- Utilise un nommage domain-specific
- Ne peut pas être réutilisé dans un autre projet sans modification

**Ce qu'un domain PEUT contenir :**

```
domains/<domain>/
  types.ts
  constants.ts
  index.ts          # API publique uniquement — jamais importer depuis l'intérieur
  components/       # composants business uniquement
  hooks/            # domain hooks uniquement
  api/              # appels API
  validations/      # règles de validation business
  state/            # Redux / state du domain
  actions/          # Redux actions
  reducers/         # Redux reducers
  middlewares/      # Redux middlewares
  utils/            # utilitaires business
  helpers/          # helpers business
  mocks/            # mocks de test
```

**Ce qu'un domain NE DOIT PAS faire :**
- Dépendre d'un autre domain (import cross-domain = Blocker)
- Contenir des utilitaires génériques
- Exposer sa structure interne directement (passer par `index.ts`)

---

## Shared

`src/shared/` contient UNIQUEMENT du code qui est :
- Business-agnostique
- Domain-agnostique
- Réutilisable dans plusieurs projets
- Portable sans modification

**Test :** si le fichier ne peut pas être copié-collé dans un autre projet → il ne va PAS dans shared.

**Structure interne :**

```
shared/
  components/   # UI generiques (Button, Loader, Modal) — pas de logique métier
  hooks/        # hooks generiques (useToggle, useScroll, useDebounce)
  utils/        # fonctions pures, pas d'effets de bord
  helpers/      # helpers
  constants/    # constantes techniques
  validations/  # règles génériques (email, password strength)
  classes/      # classes génériques
  mocks/        # mocks de test
```

**Claude NE DOIT PAS :**
- Mettre de logique métier dans shared
- Créer des dossiers "common" ou "helpers" à la racine

---

## Layout

`src/layout/` contient le shell applicatif et la structure UI globale. Pas de logique métier.

---

## Règles Absolues

- Import `domains/A` depuis `domains/B` = **Blocker immédiat**
- Logique métier dans `shared/` = **Blocker immédiat**
- Nouveau dossier hors arborescence = **Blocker immédiat**
- Ambiguïté de placement ignorée = **Blocker immédiat**
