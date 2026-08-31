# Project Atlas

> A modern, modular and immutable crossword engine written in pure Dart.

---

## Vision

Project Atlas is an engine designed to build crossword-style games that are fast, deterministic, testable and independent from any user interface.

The project is not tied to Flutter.

Instead, Atlas provides a reusable core capable of powering mobile, desktop, web and future server-side applications from a single codebase.

The long-term objective is to become a complete crossword platform including generation, solving, multiplayer synchronization and artificial intelligence.

---

## Core Principles

Atlas is built around five fundamental principles.

### Immutable by design

Core objects never mutate after creation.

Instead of modifying state, the engine produces new immutable objects.

---

### Pure Dart

The engine contains no Flutter dependencies.

This allows Atlas to execute in any Dart environment.

---

### Test First

Every feature added to the engine must be accompanied by automated tests.

Correctness always comes before optimization.

---

### Modular Architecture

Every module has a single responsibility.

Features evolve independently while sharing the same immutable foundation.

---

### Long-Term Maintainability

Readable code is preferred over clever code.

Every architectural decision must reduce future complexity.

---

## Current Architecture

```text
Applications
    │
    ▼
Flutter Adapter
    │
    ▼
Atlas Engine
    │
 ┌──┴──────────────┐
 │                 │
Generator       Solver
 │                 │
 └───────┬─────────┘
         │
       Board
         │
       Cells
         │
      Position
```

---

## Repository Structure

```text
packages/

    atlas_engine/

    atlas_shared/

apps/

    atlas_mobile/

    atlas_desktop/

    atlas_web/

tools/

docs/
```

---

## Current Status

Foundation Pack v1 (Genesis)

* Architecture defined
* Immutable Core in development
* Board implementation pending
* Generator pending
* Solver pending
* Artificial Intelligence pending

---

## Development Workflow

Every new feature follows the same lifecycle.

```
Architecture

↓

Implementation

↓

Tests

↓

Documentation

↓

Release
```

No feature is considered complete until every step has been completed.

---

## Philosophy

Project Atlas values correctness over speed.

Optimization happens only after correctness has been verified.

Documentation is considered part of the source code.

Every release should leave the project in a better state than it was found.

---

## License

MIT License
