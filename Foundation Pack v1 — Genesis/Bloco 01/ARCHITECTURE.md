# ARCHITECTURE

Project Atlas is built around a single idea:

> The engine must be independent from every user interface.

The Atlas Engine contains no Flutter code, no widgets, no rendering logic and no platform-specific dependencies.

Its only responsibility is to model crossword puzzles and provide deterministic algorithms for generation, solving and gameplay.

---

# Architectural Goals

The engine has five primary objectives.

## 1. Platform Independence

The same engine must execute on:

* Mobile
* Desktop
* Web
* Command Line
* Automated Tests
* Server Environments

without modifications.

---

## 2. Predictability

The same input must always produce the same output.

Atlas avoids hidden state and unpredictable side effects.

---

## 3. Testability

Every public behavior must be testable through automated unit tests.

No feature is considered complete without tests.

---

## 4. Low Coupling

Modules communicate through well-defined interfaces.

Dependencies always point toward the domain.

---

## 5. Long-Term Maintainability

Readable code is preferred over clever code.

Architecture should reduce future complexity instead of increasing it.

---

# High-Level Architecture

```text
Applications
        │
        ▼
Flutter Adapter Layer
        │
        ▼
──────────────────────────
      Atlas Engine
──────────────────────────
        │
 ┌──────┴──────────┐
 │                 │
Generator       Solver
 │                 │
 └──────┬──────────┘
        │
      Board
        │
 ┌──────┴───────┐
 │              │
Cells         Words
 │
Position
```

---

# Engine Layers

The engine is divided into logical layers.

## Core

Contains foundational classes shared by the entire engine.

Examples:

* EngineConfig
* Version
* Status
* Exceptions

---

## Value Objects

Immutable objects without identity.

Examples:

* Position

Value Objects are compared by value.

---

## Entities

Objects with identity that represent domain concepts.

Examples:

* Cell
* Board
* Word

Entities evolve through immutable state transitions.

---

## Services

Domain operations that do not naturally belong to a single entity.

Examples:

* Generator
* Solver
* Validator

---

## Utilities

Pure helper functions without domain responsibility.

---

# Dependency Rules

Dependencies always flow downward.

```text
Applications

↓

Adapters

↓

Engine

↓

Board

↓

Cell

↓

Position
```

Lower layers never depend on upper layers.

---

# Domain Rules

The Board owns the crossword state.

Cells never own the Board.

Words never own Cells.

Position is immutable.

Generator never modifies existing Boards.

Solver never modifies existing Boards.

---

# Immutability

Atlas adopts immutable domain objects whenever practical.

Instead of changing existing objects, operations create new instances.

Example:

Board A

↓

placeLetter()

↓

Board B

The previous Board remains unchanged.

This simplifies:

* Undo/Redo
* Replay
* Multiplayer synchronization
* AI simulations
* Testing

---

# Flutter Separation

Flutter is not part of the engine.

Flutter is only one possible client.

Future clients may include:

* Desktop UI
* Web UI
* Dedicated Editor
* AI Workers
* Command Line Tools

All of them consume the same engine.

---

# Future Modules

The current architecture anticipates future expansion.

Planned modules include:

* Crossword Generator
* Crossword Solver
* Dictionary Builder
* Multiplayer Synchronization
* Replay System
* Atlas Studio
* Artificial Intelligence
* Benchmark Tools

These modules extend the engine without modifying its architectural foundations.

---

# Design Philosophy

Architecture is considered part of the source code.

Every architectural decision should reduce complexity for future contributors.

Whenever a design decision becomes permanent, it must be documented through an Architecture Decision Record (ADR).

The objective is not only to build software, but to build software that remains understandable years from now.
