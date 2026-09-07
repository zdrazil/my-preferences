---
name: write-tests
description: : Write, revise, or review automated tests for application and library runtime behavior. Use for regression coverage, test-scope decisions, and weak, flaky, redundant, or over-mocked tests. Exclude guarantees enforced by static type checking.
---

# Testing

- Test **public behavior**, not private implementation.
- Prioritize **realistic usage scenarios** over exhaustive edge cases.
- Write tests at the **lowest layer** that owns the logic.
- Mock through interfaces, not internals. Excessive or fragile mocks often signal tight coupling or poor abstraction. Prefer clear boundaries and design patterns (e.g., dependency injection, pure functions) that minimize the need for mocking.
- Don’t repeat the same behavior test across layers.
- Only test library behavior if you’re extending or integrating it.
- Keep tests fast, isolated, and deterministic.
- Name tests clearly and descriptively.
- Describe specific, observable behavior using concrete outcomes (e.g., returns 400 on missing email, rejects duplicate usernames).
- Avoid vague phrasing like “should”, “successfully”, or “correctly”.
- Write tests only for runtime behavior that cannot be statically verified by the type system.
