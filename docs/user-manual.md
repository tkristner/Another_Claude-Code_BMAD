---
layout: default
title: "Manuel Utilisateur - Another Claude-Code BMAD"
description: "Guide complet pour utiliser Another Claude-Code BMAD - workflows, commandes, bonnes pratiques"
keywords: "BMAD Method, Claude Code, manuel utilisateur, agile AI, développement assisté"
---

# Manuel Utilisateur - Another Claude-Code BMAD

**Version:** 1.3.0
**Date:** Février 2026

Ce manuel décrit l'utilisation d'Another Claude-Code BMAD, un fork optimisé des BMAD Skills pour Claude Code.

> **Attribution:** Ce projet est un fork du travail de aj-geddes, lui-même basé sur la BMAD Method créée par le BMAD Code Organization.

---

## Table des Matières

1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Concepts Fondamentaux](#concepts-fondamentaux)
4. [Les 4 Phases BMAD](#les-4-phases-bmad)
5. [Skills (Agents)](#skills-agents)
6. [Workflows Disponibles](#workflows-disponibles)
7. [Commandes Rapides](#commandes-rapides)
8. [Guide par Cas d'Usage](#guide-par-cas-dusage)
9. [Bonnes Pratiques](#bonnes-pratiques)
10. [Dépannage](#dépannage)

---

## Introduction

### Qu'est-ce que BMAD ?

**BMAD** (Breakthrough Method for Agile AI-Driven Development) est une méthodologie de développement logiciel structurée en phases qui utilise Claude Code comme assistant IA tout au long du cycle de vie du projet.

### Pourquoi BMAD ?

| Problème | Solution BMAD |
|----------|---------------|
| Projets sans structure | 4 phases claires avec gates |
| Documentation incomplète | Templates et validation automatique |
| Estimation hasardeuse | Story points + velocity tracking |
| Code sans tests | Minimum 80% de couverture |
| Reviews superficielles | Code review adversarial (3-10 issues min) |

### Architecture des Skills

```
bmad-skills/
├── bmad-orchestrator/     # Coordination et routing
├── business-analyst/      # Phase 1: Analyse
├── product-manager/       # Phase 2: Planification
├── system-architect/      # Phase 3: Solutioning
├── scrum-master/          # Phase 4: Sprint Planning
├── developer/             # Phase 4: Implémentation
├── ux-designer/           # Cross-phase: Design
├── creative-intelligence/ # Cross-phase: Brainstorming
├── builder/               # Meta: Créer des skills
└── shared/                # Templates et tâches partagées
```

---

## Installation

### Prérequis

- Claude Code installé et fonctionnel
- Git pour cloner le repository
- Terminal Bash (Linux/macOS/WSL)

### Installation Rapide

```bash
# Cloner le repository
git clone https://github.com/tkristner/Another_Claude-Code_BMAD.git
cd Another_Claude-Code_BMAD

# Linux/macOS/WSL (Windows: utiliser WSL)
./install-bmad-skills.sh
```

### Vérification

```bash
# Redémarrer Claude Code puis tester
claude
> /workflow-init
```

Si vous voyez le prompt d'initialisation, BMAD est installé.

---

## Concepts Fondamentaux

### Niveaux de Projet

BMAD adapte la complexité du processus selon le projet :

| Niveau | Nom | Stories | Documents Requis | Durée Typique |
|--------|-----|---------|------------------|---------------|
| 0 | Atomique | 1 | Tech Spec seulement | < 1 jour |
| 1 | Petit | 1-10 | Tech Spec | 1-2 semaines |
| 2 | Moyen | 5-15 | PRD + Architecture | 2-4 semaines |
| 3 | Complexe | 12-40 | PRD + Architecture + UX | 1-2 mois |
| 4 | Enterprise | 40+ | Workflow complet | 2+ mois |

### Décision : Quel Workflow Utiliser ?

```
┌─────────────────────────────────────────────┐
│ Quelle est la taille de votre changement ? │
└─────────────────────────────────────────────┘
              │
              ▼
    ┌─────────────────┐
    │ < 3 story points │───▶ /quick-spec + /quick-dev
    │   ou bug fix     │
    └─────────────────┘
              │ Non
              ▼
    ┌─────────────────┐
    │ 3-15 stories    │───▶ /tech-spec + /sprint-planning
    │ (Level 1-2)     │
    └─────────────────┘
              │ Non
              ▼
    ┌─────────────────┐
    │ > 15 stories    │───▶ Workflow BMAD complet
    │ (Level 3-4)     │     Phase 1 → 2 → 3 → 4
    └─────────────────┘
```

### Structure de Fichiers

Après initialisation BMAD :

```
votre-projet/
├── accbmad/
│   ├── config.yaml              # Configuration projet
│   ├── status.yaml              # Tracking des phases
│   ├── 1-analysis/              # Phase 1
│   │   └── product-brief-*.md
│   ├── 2-planning/              # Phase 2
│   │   ├── prd-*.md
│   │   └── tech-spec-*.md
│   ├── 3-solutioning/           # Phase 3
│   │   └── architecture-*.md
│   ├── 4-implementation/        # Phase 4
│   │   ├── sprint.yaml
│   │   └── stories/
│   ├── context/                 # Contexte partagé (subagents)
│   ├── outputs/
│   └── tmp/               # Temporary workflow state                 # Sorties des subagents
└── .claude/
    └── commands/accbmad/        # Commandes projet
```

---

## Les 4 Phases BMAD

### Phase 1 : Analyse

**Objectif :** Comprendre le problème et définir la vision produit.

**Skills impliqués :**
- `business-analyst` - Product brief, discovery
- `creative-intelligence` - Brainstorming, recherche

**Commandes :**

| Commande | Description | Output |
|----------|-------------|--------|
| `/product-brief` | Créer un brief produit complet | `accbmad/1-analysis/product-brief-*.md` |
| `/brainstorm` | Session de brainstorming structurée | `docs/brainstorm-*.md` |
| `/research` | Recherche marché/concurrence/technique | `docs/research-*.md` |

**Workflow typique :**

```
User: /product-brief

Business Analyst: Je vais vous aider à créer un brief produit.

## Résumé Exécutif
Quel problème résolvez-vous ? (2-3 phrases)
> Notre équipe perd 5h/semaine à synchroniser les inventaires
> entre Shopify et notre ERP.

## Public Cible
Qui sont vos utilisateurs ?
> PME e-commerce avec 100-1000 SKUs

## Énoncé du Problème
D'après votre description, les problèmes clés sont :
1. Synchronisation manuelle chronophage
2. Risque d'erreurs de stock
3. Pas de visibilité en temps réel

Est-ce correct ?
> Oui, ajoutez aussi les erreurs de commandes

[...suite interactive...]

Enregistré : accbmad/1-analysis/product-brief-inventory-sync-2026-02-02.md
```

---

### Phase 2 : Planification

**Objectif :** Définir les exigences détaillées et prioriser.

**Skills impliqués :**
- `product-manager` - PRD, tech spec, priorisation
- `ux-designer` - Design UX/UI

**Commandes :**

| Commande | Description | Quand l'utiliser |
|----------|-------------|------------------|
| `/prd` | Product Requirements Document complet | Level 2+ |
| `/tech-spec` | Spécification technique légère | Level 0-1 |
| `/quick-spec` | Spec rapide conversationnelle | Petites features |
| `/validate-prd` | Valider la qualité d'un PRD | Avant architecture |
| `/create-ux-design` | Design UX/UI | Projets avec interface |

**Nouveau : /quick-spec**

Pour les petites features (1-5 story points), utilisez `/quick-spec` :

```
User: /quick-spec

Product Manager: Décrivez ce que vous voulez implémenter.
> Ajouter un endpoint API pour lister les commandes par date

[Scan automatique du code existant]

J'ai trouvé :
- Framework: Express.js
- Modèle Order existant: src/models/order.js
- Pattern de routing: src/routes/api/v1/

Questions de clarification :
1. Format de date attendu ? (ISO 8601 recommandé)
2. Pagination nécessaire ?
3. Filtres additionnels ?

[...raffinement...]

Spec générée : accbmad/2-planning/tech-spec-quick-list-orders-2026-02-02.md

Prêt pour implémentation avec /quick-dev
```

**Nouveau : /validate-prd**

Avant de passer à l'architecture, validez votre PRD :

```
User: /validate-prd accbmad/2-planning/prd-inventory-sync.md

Product Manager: Validation du PRD...

## Rapport de Validation

| Dimension | Score | Status |
|-----------|-------|--------|
| Complétude | 9/10 | PASS |
| Mesurabilité | 6/10 | CONDITIONAL |
| Traçabilité | 8/10 | PASS |
| Clarté | 7/10 | PASS |

## Issues Critiques (À corriger)

1. **FR-007**: Critères d'acceptation manquants
2. **NFR-003**: "Performant" n'est pas mesurable → suggéré "< 200ms p95"

## Avertissements

1. FR-012 et FR-013 semblent dupliqués
2. Section "Risques" absente

Status Global: CONDITIONAL PASS (76%)

[F] Corriger maintenant
[R] Générer rapport complet
[S] Sauvegarder et continuer
```

---

### Phase 3 : Solutioning

**Objectif :** Concevoir l'architecture technique.

**Skills impliqués :**
- `system-architect` - Architecture système, choix technologiques

**Commandes :**

| Commande | Description |
|----------|-------------|
| `/architecture` | Créer l'architecture système |
| `/solutioning-gate-check` | Valider l'architecture vs requirements |

**Exemple :**

```
User: /architecture

System Architect: Je vais concevoir l'architecture basée sur votre PRD.

Chargement: accbmad/2-planning/prd-inventory-sync.md

## Vue d'Ensemble

Architecture microservices event-driven :

┌─────────────┐     ┌─────────────┐
│   Frontend  │────▶│   API GW    │
└─────────────┘     └──────┬──────┘
                           │
         ┌─────────────────┼─────────────────┐
         ▼                 ▼                 ▼
┌─────────────┐   ┌─────────────┐   ┌─────────────┐
│    Auth     │   │  Inventory  │   │    Sync     │
│   Service   │   │   Service   │   │   Engine    │
└─────────────┘   └─────────────┘   └─────────────┘

## Stack Technologique

| Composant | Choix | Justification |
|-----------|-------|---------------|
| Backend | Node.js | Expertise équipe, I/O async |
| Database | PostgreSQL | ACID, JSON support |
| Queue | Redis + Bull | Performance, fiabilité |
| Frontend | React | Écosystème, composants |

[...détails complets...]

Enregistré : accbmad/3-solutioning/architecture-inventory-sync-2026-02-02.md
```

---

### Phase 4 : Implémentation

**Objectif :** Planifier et exécuter le développement.

**Skills impliqués :**
- `scrum-master` - Sprint planning, stories
- `developer` - Implémentation, tests, code review

**Commandes Sprint Planning :**

| Commande | Description |
|----------|-------------|
| `/sprint-planning` | Planifier les sprints |
| `/create-story` | Créer une user story |
| `/create-epics-stories` | Transformer PRD en epics et stories |
| `/sprint-status` | Voir le status du sprint |
| `/velocity-report` | Métriques de vélocité |

**Nouveau : /create-epics-stories**

Transforme automatiquement un PRD en epics organisés par valeur utilisateur :

```
User: /create-epics-stories

Scrum Master: Je vais créer la décomposition en epics et stories.

Chargement: accbmad/2-planning/prd-inventory-sync.md

## Design des Epics

Principe : Organiser par VALEUR UTILISATEUR, pas par couche technique.

✅ BON : Epic 1 "Authentification" → L'utilisateur peut se connecter
❌ MAUVAIS : Epic 1 "Setup BDD" → Pas de valeur utilisateur directe

### Epic List Proposée

| Epic | Titre | FRs | Valeur Utilisateur |
|------|-------|-----|-------------------|
| 1 | Authentification | FR-001, FR-002 | Accès sécurisé |
| 2 | Gestion Produits | FR-003, FR-004, FR-005 | CRUD produits |
| 3 | Synchronisation | FR-006, FR-007, FR-008 | Sync temps réel |
| 4 | Dashboard | FR-009, FR-010 | Visibilité stock |

Couverture : 10/10 FRs (100%)

[A] Approuver et créer les stories
[R] Réviser les epics

User: A

Création des stories pour Epic 1...

### Story 1.1: Inscription Utilisateur

As a nouvel utilisateur,
I want m'inscrire avec mon email,
So that je puisse accéder à l'application.

**Acceptance Criteria:**

**Given** je suis sur la page d'inscription
**When** je soumets un email et mot de passe valides
**Then** mon compte est créé
**And** je reçois un email de confirmation

[...toutes les stories...]

Enregistré : docs/epics.md
```

**Commandes Développement :**

| Commande | Description |
|----------|-------------|
| `/dev-story STORY-ID` | Implémenter une story |
| `/dev-story-auto` | **Exécution autonome du sprint** |
| `/quick-dev` | Implémentation rapide (avec /quick-spec) |
| `/code-review` | Code review adversarial |
| `/qa-automate` | Génération de tests automatisée |

**Nouveau : /dev-story-auto (Mode Autonome)**

Exécute automatiquement **toutes les stories pending** du sprint :

```
User: /dev-story-auto

Developer: Démarrage du développement autonome...

╔══════════════════════════════════════════════════════════════╗
║  DEV-STORY-AUTO: Sprint 5 Progress                           ║
╠══════════════════════════════════════════════════════════════╣
║  Stories: 0/4 complete                                       ║
║  Current: VS-002-S18                                         ║
╠══════════════════════════════════════════════════════════════╣
║  → VS-002-S18  Screenshot Capture        [starting]          ║
║  ○ VS-002-S19  Multimodal Assessment     [queued]            ║
║  ○ VS-002-S20  Visual Threshold          [queued]            ║
╚══════════════════════════════════════════════════════════════╝

[Git] Branch créée: story/VS-002-S18
[Dev] Implémentation des critères d'acceptation...
[Dev] Tests: 15/15 passent
[Review] Code review adversarial...
[Review] 4 issues trouvées, correction auto...
[Review] ✓ Toutes les issues résolues
[Git] Commit: feat(capture): implement screenshot capture
[Review] Review de vérification... clean ✓
[Git] Merge vers develop
[Status] VS-002-S18 → done

✓ Story VS-002-S18 terminée

Starting VS-002-S19...
[...continue jusqu'à ce que toutes les stories soient done...]

═══════════════════════════════════════
Sprint Auto Terminé !
Stories: 4/4 ✓
═══════════════════════════════════════
```

**Boucle par story :**
1. Créer branche git `story/{id}`
2. Implémenter (code + tests)
3. **Code review obligatoire** (auto-fix, pas de prompt user)
4. Commit
5. **Review de vérification** (après commit, sécurité)
6. Merge vers develop
7. Mettre à jour sprint-status.yaml
8. Story suivante (loop)

**Options :**
```bash
/dev-story-auto              # Toutes les stories pending
/dev-story-auto --max 3      # Maximum 3 stories
/dev-story-auto --story S-18 # Une seule story
/dev-story-auto --dry-run    # Afficher le plan seulement
```

**Conditions d'arrêt (HALT) :**
- Plus de stories pending → Sprint terminé
- Code review échoue 3 fois → Intervention manuelle
- Conflit git → Résolution manuelle requise

**Nouveau : /quick-dev**

Pour les petites implémentations après `/quick-spec` :

```
User: /quick-dev accbmad/2-planning/tech-spec-quick-list-orders.md

Developer: Implémentation de "List Orders by Date"

## Mode : Tech Spec détecté

Chargement de la spec...

## Baseline

Commit de référence créé pour tracking du diff.

## Implémentation

1. Création du endpoint
   src/routes/api/v1/orders.js ✓

2. Service layer
   src/services/orderService.js (modifié) ✓

3. Tests unitaires
   tests/unit/orderService.test.js ✓

## Self-Check

Exécution des tests...
✓ 12 tests passent
✓ Couverture : 89%

## Code Review Intégré

[Activation du mode adversarial]

Issues trouvées : 4

| ID | Sévérité | Description |
|----|----------|-------------|
| M1 | MEDIUM | Pas de validation du format de date |
| M2 | MEDIUM | Index manquant sur created_at |
| L1 | LOW | Magic number "100" pour limit |
| L2 | LOW | Console.log de debug présent |

[F] Corriger automatiquement
[S] Ignorer et terminer
[D] Détails

User: F

Corrections appliquées ✓

Implémentation complète !
```

**Nouveau : /code-review**

Review adversarial avec minimum 3-10 issues :

```
User: /code-review

Developer: Code Review Adversarial

## Préparation

- Story/PR chargé : STORY-015
- Git diff analysé : 8 fichiers modifiés

## Mindset Adversarial

Je vais chercher ACTIVEMENT les problèmes.
Objectif : 3-10 issues minimum.
Zéro finding = review insuffisante.

## Validation Git vs Claims

| Fichier Claimé | Dans Git Diff |
|----------------|---------------|
| src/services/sync.js | ✓ |
| src/models/product.js | ✓ |
| tests/sync.test.js | ✓ |

Pas de divergence.

## Findings

| ID | Sévérité | Catégorie | Description | Localisation |
|----|----------|-----------|-------------|--------------|
| C1 | CRITICAL | Security | SQL injection possible | sync.js:45 |
| H1 | HIGH | Logic | Race condition dans sync | sync.js:78-92 |
| H2 | HIGH | Testing | Test sans assertion réelle | sync.test.js:34 |
| M1 | MEDIUM | Error | Exception silencieuse | product.js:112 |
| M2 | MEDIUM | Perf | N+1 query pattern | sync.js:156 |
| L1 | LOW | Style | Variable non utilisée | product.js:23 |

Total : 6 issues (1 Critical, 2 High, 2 Medium, 1 Low)

## Verdict

❌ BLOCKED - Issues critiques à corriger

[A] Auto-fix (Critical/High)
[S] Fix sélectif
[D] Détails par issue
```

**Nouveau : /qa-automate**

Génération automatique de tests :

```
User: /qa-automate src/services/

Developer: QA Automation

## Détection du Framework

- Test Framework : Jest
- Assertion : expect
- Mocking : jest.mock
- Config : jest.config.js

## Analyse des Services

| Service | Méthodes | Tests Existants | Couverture |
|---------|----------|-----------------|------------|
| orderService | 8 | 5 | 62% |
| productService | 6 | 6 | 85% |
| syncService | 12 | 3 | 25% |

## Génération de Tests

### syncService (prioritaire - couverture basse)

Création : tests/unit/syncService.test.js

```javascript
describe('SyncService', () => {
  describe('syncInventory', () => {
    it('should sync inventory for single channel', async () => {
      // Arrange
      const mockChannel = createMockChannel('shopify');
      const mockProducts = [createMockProduct()];

      // Act
      const result = await syncService.syncInventory(mockChannel, mockProducts);

      // Assert
      expect(result.synced).toBe(1);
      expect(result.errors).toHaveLength(0);
    });

    it('should handle channel API failure gracefully', async () => {
      // ...
    });

    // ...9 tests supplémentaires
  });
});
```

## Exécution

```bash
npm test -- --coverage
```

Résultats :
- Tests générés : 15
- Tests passants : 15
- Nouvelle couverture syncService : 78%

## Résumé

| Métrique | Avant | Après |
|----------|-------|-------|
| Tests total | 14 | 29 |
| Couverture moyenne | 57% | 82% |
| Services < 80% | 2 | 0 |
```

---

## Skills (Agents)

### Vue d'Ensemble

| Skill | Phase | Trigger Keywords |
|-------|-------|------------------|
| `bmad-orchestrator` | All | workflow status, initialize, what's next |
| `business-analyst` | 1 | product brief, brainstorm, research, discovery |
| `product-manager` | 2 | PRD, tech spec, requirements, prioritization, quick spec |
| `ux-designer` | 2-3 | wireframes, user flow, accessibility, design |
| `system-architect` | 3 | architecture, tech stack, API design, data model |
| `scrum-master` | 4 | sprint planning, story points, velocity, epics |
| `developer` | 4 | implement, dev story, code review, quick dev, tests |
| `creative-intelligence` | Any | brainstorm, SCAMPER, SWOT, mind map |
| `builder` | Meta | create agent, create workflow, customize |

### Activation Automatique

Claude Code active automatiquement le skill approprié basé sur vos mots-clés :

```
"Crée un PRD pour..."        → product-manager
"Review mon code"            → developer
"Planifie le prochain sprint" → scrum-master
"Brainstorm des idées pour..." → creative-intelligence
```

---

## Workflows Disponibles

### Workflows Complets (Full BMAD)

| Workflow | Commande | Phase | Description |
|----------|----------|-------|-------------|
| Product Brief | `/product-brief` | 1 | Brief produit complet |
| Brainstorm | `/brainstorm` | 1 | Session brainstorming structurée |
| Research | `/research` | 1 | Recherche marché/compétitive |
| PRD | `/prd` | 2 | Product Requirements Document |
| Tech Spec | `/tech-spec` | 2 | Spécification technique |
| UX Design | `/create-ux-design` | 2-3 | Design UX/UI |
| Architecture | `/architecture` | 3 | Architecture système |
| Sprint Planning | `/sprint-planning` | 4 | Planification des sprints |
| Dev Story | `/dev-story STORY-ID` | 4 | Implémentation story |
| **Dev Story Auto** | `/dev-story-auto` | 4 | **Exécution autonome du sprint** |

### Workflows Rapides (Quick Flow)

| Workflow | Commande | Description |
|----------|----------|-------------|
| Quick Spec | `/quick-spec` | Spec conversationnelle 15-45 min |
| Quick Dev | `/quick-dev` | Implémentation avec review intégré |
| Code Review | `/code-review` | Review adversarial 3-10 issues |
| QA Automate | `/qa-automate` | Génération tests automatique |

### Workflows de Validation

| Workflow | Commande | Description |
|----------|----------|-------------|
| Validate PRD | `/validate-prd` | Validation qualité PRD |
| Gate Check | `/solutioning-gate-check` | Validation architecture vs PRD |

### Workflows de Création

| Workflow | Commande | Description |
|----------|----------|-------------|
| Create Story | `/create-story` | Créer user story détaillée |
| Create Epics | `/create-epics-stories` | PRD → Epics + Stories |
| Create Agent | `/create-agent` | Créer skill personnalisé |
| Create Workflow | `/create-workflow` | Créer workflow personnalisé |

---

## Guide par Cas d'Usage

### Cas 1 : Bug Fix Urgent

**Scénario :** Corriger un bug en production rapidement.

```
# Pas besoin de /quick-spec pour un bug évident
User: /dev-story BUG-042

# Ou directement
User: Fix le bug de timeout sur l'endpoint /api/orders
      Le timeout est à 5s mais certaines requêtes prennent 10s.

Developer: Je vais corriger ce bug.

[Analyse du code...]
[Identification de la cause...]
[Correction...]
[Tests de non-régression...]

Correction appliquée. Voulez-vous que je fasse une code review ?
```

### Cas 2 : Petite Feature (1-3 jours)

**Scénario :** Ajouter un nouvel endpoint API.

```
User: /quick-spec

PM: Décrivez la feature.
> Endpoint pour exporter les commandes en CSV

[Questions de clarification...]
[Génération de la spec...]

User: /quick-dev accbmad/2-planning/tech-spec-quick-export-csv.md

Developer: Implémentation...
[Code + Tests + Review intégré]
```

### Cas 3 : Feature Moyenne (1-2 semaines)

**Scénario :** Système de notifications.

```
User: /tech-spec

PM: Pour quelle feature ?
> Système de notifications email et push

[Création tech spec détaillée...]

User: /sprint-planning

SM: Je vais planifier les stories.
[Décomposition en 5-8 stories...]
[Estimation et allocation...]

User: /dev-story STORY-001
...
User: /dev-story STORY-005

User: /code-review

Developer: Review finale du sprint...
```

### Cas 4 : Projet Complexe (1+ mois)

**Scénario :** Nouvelle plateforme e-commerce.

```
# Phase 1
User: /product-brief
User: /research

# Phase 2
User: /prd
User: /validate-prd
User: /create-ux-design

# Phase 3
User: /architecture
User: /solutioning-gate-check

# Phase 4
User: /create-epics-stories
User: /sprint-planning
User: /dev-story STORY-001
...
User: /code-review
User: /qa-automate
```

### Cas 5 : Audit de Code Existant

**Scénario :** Améliorer la qualité d'un projet existant.

```
User: /code-review src/services/

Developer: Review adversarial du répertoire services/

[Analyse de tous les fichiers...]
[28 issues trouvées...]

User: /qa-automate src/services/

Developer: Génération de tests manquants...

[+45 tests générés...]
[Couverture : 52% → 84%]
```

---

## Bonnes Pratiques

### 1. Choisir le Bon Niveau de Workflow

| Si... | Alors... |
|-------|----------|
| < 3 story points | `/quick-spec` + `/quick-dev` |
| 3-10 story points | `/tech-spec` + `/sprint-planning` |
| > 10 story points | Workflow BMAD complet |
| Bug fix évident | Direct `/dev-story` |
| Refactoring majeur | `/architecture` d'abord |

### 2. Valider Avant de Progresser

```
Phase 1 ──/product-brief──▶ Phase 2
                              │
                    /validate-prd  ◀── Valider ici !
                              │
Phase 2 ──────────────────▶ Phase 3
                              │
              /solutioning-gate-check ◀── Et ici !
                              │
Phase 3 ──────────────────▶ Phase 4
```

### 3. Code Review Systématique

**Règle :** Chaque story doit passer par `/code-review` avant d'être marquée "complete".

**Mindset adversarial :**
- 0 issue = review insuffisante, recommencer
- Minimum 3 issues attendu
- Maximum 10 pour rester actionnable

### 4. Tests Avant Merge

```bash
# Couverture minimum
Couverture globale >= 80%
Chaque fichier modifié >= 70%

# Types de tests
- Unit tests : Logique métier
- Integration tests : API endpoints
- E2E tests (si UI) : Parcours critiques
```

### 5. Documentation Continue

| Quand | Documenter |
|-------|------------|
| Nouvelle feature | Acceptance criteria dans story |
| API change | OpenAPI spec mise à jour |
| Architecture decision | ADR (Architecture Decision Record) |
| Breaking change | CHANGELOG.md |

---

## Dépannage

### Problème : Skill non reconnu

**Symptôme :** Claude ne comprend pas `/workflow-init`

**Solution :**
```bash
# Vérifier l'installation
ls ~/.claude/skills/

# Réinstaller si nécessaire
./install-bmad-skills.sh

# Redémarrer Claude Code
```

### Problème : Contexte perdu

**Symptôme :** Claude oublie le projet en cours

**Solution :**
```
# Recharger le contexte
User: /workflow-status

# Ou spécifier explicitement
User: Charge le contexte de accbmad/2-planning/prd-mon-projet.md
```

### Problème : Code review trouve 0 issues

**Symptôme :** `/code-review` dit "Aucun problème trouvé"

**Solution :**
Le code est probablement trop simple ou le review trop superficiel.
```
User: /code-review --deep

# Ou
User: Fais une code review adversariale de src/services/
      Cherche au moins 5 problèmes, même mineurs.
```

### Problème : Tests générés ne passent pas

**Symptôme :** `/qa-automate` génère des tests qui échouent

**Solution :**
```
User: Les tests générés échouent. Corrige-les.

# Ou regénérer avec plus de contexte
User: /qa-automate src/services/orderService.js
      Le service utilise une connexion PostgreSQL mockée avec pg-mock.
```

---

## Annexes

### A. Référence Rapide des Commandes

```
# Status
/workflow-status        # Voir le status du projet

# Phase 1
/product-brief         # Brief produit
/brainstorm            # Brainstorming
/research              # Recherche

# Phase 2
/prd                   # Product Requirements Document
/tech-spec             # Spec technique (Level 0-1)
/quick-spec            # Spec rapide conversationnelle
/validate-prd [path]   # Valider un PRD
/create-ux-design      # Design UX

# Phase 3
/architecture          # Architecture système
/solutioning-gate-check # Validation architecture

# Phase 4
/create-epics-stories  # PRD → Epics + Stories
/sprint-planning       # Planification sprints
/create-story          # Créer une story
/dev-story STORY-ID    # Implémenter une story
/dev-story-auto        # Exécution autonome du sprint (toutes stories)
/quick-dev [path]      # Implémentation rapide
/code-review [path]    # Code review adversarial
/qa-automate [path]    # Génération tests
/sprint-status         # Status sprint
/velocity-report       # Métriques vélocité
```

### B. Glossaire

| Terme | Définition |
|-------|------------|
| **Epic** | Grande fonctionnalité décomposable en stories |
| **Story** | Unité de travail implémentable en 1-3 jours |
| **Story Point** | Estimation relative de complexité (Fibonacci) |
| **PRD** | Product Requirements Document |
| **FR** | Functional Requirement (exigence fonctionnelle) |
| **NFR** | Non-Functional Requirement (performance, sécurité...) |
| **AC** | Acceptance Criteria (critères d'acceptation) |
| **Gate** | Point de validation avant de passer à la phase suivante |
| **Velocity** | Points complétés par sprint (moyenne glissante 3 sprints) |

### C. Liens Utiles

- [Repository GitHub](https://github.com/tkristner/Another_Claude-Code_BMAD)
- [BMAD Method Original](https://github.com/bmad-code-org/BMAD-METHOD)
- [Documentation Claude Code](https://docs.anthropic.com/claude-code)

---

*Ce manuel est généré pour Another Claude-Code BMAD v1.3.0 - Février 2026*
