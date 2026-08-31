# DESIGN PHILOSOPHY

Project Atlas is built with a long-term mindset.

The objective is not simply to make the engine work, but to create a codebase that remains understandable, maintainable and extensible for years.

Every design decision should make future development easier, not harder.

---

# Principle 1 — Correctness First

Correctness always comes before performance.

A correct algorithm that is easy to understand is preferable to a faster algorithm with hidden complexity.

Optimization should only happen after correctness has been validated through automated tests.

---

# Principle 2 — Simplicity

Simple code is easier to test, debug and improve.

Whenever two solutions provide the same result, the simpler one should be preferred.

Complexity must always have a measurable benefit.

---

# Principle 3 — Immutability

Domain objects should be immutable whenever practical.

Operations should return new objects instead of modifying existing ones.

Benefits include:

* Predictable behavior
* Safer concurrency
* Easier testing
* Replay support
* Undo/Redo support
* Multiplayer synchronization

---

# Principle 4 — Single Responsibility

Every class should have one clear responsibility.

Large classes should be divided before they become difficult to understand.

If a class needs "and" in its description, it probably has more than one responsibility.

---

# Principle 5 — Composition Over Inheritance

Behavior should be composed from smaller objects whenever possible.

Inheritance is reserved for situations where there is a genuine "is-a" relationship.

Composition provides greater flexibility and lower coupling.

---

# Principle 6 — Explicit Code

Code should communicate intent.

Meaningful names are preferred over comments.

If a piece of code requires extensive explanation, it should probably be rewritten.

---

# Principle 7 — Testability

Every public behavior should be testable.

The engine should never depend on UI components, timing assumptions or external state that makes testing difficult.

Testing is considered part of development, not an optional activity.

---

# Principle 8 — Documentation as Code

Documentation evolves together with the source code.

Architectural decisions must be documented.

A feature is not complete until its documentation reflects its behavior.

---

# Principle 9 — Stable Public API

Public interfaces should evolve carefully.

Breaking changes should be minimized and documented.

Internal implementation may change freely as long as the public contract remains stable.

---

# Principle 10 — Engine Before Application

Atlas is an engine.

Applications consume the engine.

The engine must never contain assumptions about:

* Flutter widgets
* Screen layouts
* User interactions
* Platform-specific APIs

Keeping the engine independent guarantees long-term reuse.

---

# Code Review Checklist

Before merging new code, ask:

* Is it correct?
* Is it simple?
* Is it testable?
* Is it documented?
* Does it respect the architecture?
* Can another developer understand it quickly?

If the answer to any question is "no", the implementation should be revisited.

---

# Our Motto

> First make it correct.

> Then make it clean.

> Finally make it extraordinary.

This philosophy guides every contribution to Project Atlas.
