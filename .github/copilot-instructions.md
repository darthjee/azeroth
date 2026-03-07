# GitHub Copilot Instructions for Azeroth

## Project Overview

**Azeroth** is a Ruby gem that simplifies the creation of RESTful Rails controller endpoints.
By including `Azeroth::Resourceable` in a controller and calling `resource_for`, all standard
CRUD action methods (`index`, `show`, `create`, `update`, `delete`, `edit`, `new`) are
automatically generated.

Azeroth handles both **HTML** and **JSON** request formats:
- **JSON requests**: fetches/processes data from the database, applies a decorator, and renders JSON.
- **HTML requests**: skips database operations and delegates to the standard Rails view templates.

Controllers expose resources using `Azeroth::Decorator` subclasses that define exactly which
fields are serialised to JSON.

### Key Concepts

- `Azeroth::Resourceable` — module included in controllers; provides `resource_for` and `model_for`.
- `resource_for :name, **options` — generates all CRUD actions for the named resource.
- `Azeroth::Decorator` — base class for JSON decorators; fields are declared with `expose`.
- `config/check_specs.yml` — lists `lib/` files that are **intentionally excluded** from spec
  coverage checks (e.g. thin wrapper files or generated metaprogramming entry points).

### `resource_for` Options

| Option | Description |
|---|---|
| `only` | Whitelist of actions to generate (e.g. `only: %i[create index]`) |
| `except` | Blacklist of actions to skip (e.g. `except: :delete`) |
| `decorator` | Decorator class or `false` to disable decoration |
| `before_save` | Method name or Proc called before `create`/`update` |
| `after_save` | Method name or Proc called after `create`/`update` |
| `build_with` | Method name or Block used to build the resource on `create` |
| `update_with` | Method name or Block used to update the resource on `update` |
| `paginated` | `true` to enable pagination on `index` |
| `per_page` | Number of items per page when pagination is active |
| `id_key` | Key used to find a model (default: `id`) |
| `param_key` | Parameter key used to find the model |

---

## Language

All code, comments, commit messages, pull request titles and descriptions, code reviews,
and documentation **must be written in English**.

---

## Testing

- **Every new or modified `lib/` file must have a corresponding spec file** under `spec/`.
- Specs must exercise the real behaviour of the code, not just assert that methods exist.
- Use the existing test infrastructure: RSpec, FactoryBot, the dummy Rails application in
  `spec/dummy/`, and integration tests in `spec/integration/`.
- When a file genuinely cannot be unit-tested in isolation (e.g. a thin metaprogramming
  entry point), add it to `config/check_specs.yml` under the `ignore:` key instead of
  leaving it untested without explanation.
- Follow the same test patterns already present in the codebase:
  - Controller specs live in `spec/controllers/`.
  - Unit specs mirror the `lib/` path under `spec/lib/`.
  - YARD documentation examples that are executable live in `spec/integration/yard/`.

---

## Documentation

- Use **YARD** for all public API documentation.
- Every public method and class must have at least:
  - A one-line summary.
  - `@param` tags for each parameter.
  - A `@return` tag.
  - At least one `@example` block for non-trivial methods.
- Use `@api private` on internal helpers that are not part of the public interface.
- Keep YARD examples executable where possible (see `spec/integration/yard/`).
- The YARD coverage threshold is enforced via `config/yardstick.yml`.

---

## Design Principles

### Single Responsibility (Sandi Metz / *99 Bottles of OOP*)

- Keep classes and methods **small and focused**.
- A class should have one reason to change.
- A method should do one thing; if you need to describe it with "and", split it.
- Prefer many small, well-named private methods over a few large ones.
- Avoid large conditional blocks; favour polymorphism or small extracted objects.

### Law of Demeter

- A method should only call methods on:
  - `self`
  - Objects passed as arguments
  - Objects it creates itself
  - Direct instance variables / accessors
- Avoid chaining more than one message send on an external object (e.g. `a.b.c`).
- When you need data from a distant collaborator, add a delegating method or accessor
  closer to the caller.

### General Style

- Follow the project's existing RuboCop configuration (`.rubocop.yml`).
- Prefer composition over inheritance where practical.
- Keep the public interface of classes minimal; default to `private`.
