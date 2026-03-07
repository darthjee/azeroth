# GitHub Copilot Instructions

## Project Overview

**Azeroth** is a Ruby gem that simplifies the creation of Rails controller endpoints.
It provides the `Azeroth::Resourceable` concern, which adds the `resource_for` class
method to controllers. This method automatically generates standard CRUD action methods
(`index`, `show`, `create`, `update`, `edit`, `new`, `destroy`) without the need for
repetitive boilerplate code.

Azeroth is designed to handle both **HTML** and **JSON** request formats:

- **JSON requests** (`.json` format): the gem processes the request, performs the
  appropriate database operations, decorates the resource using an
  `Azeroth::Decorator` subclass, and renders the JSON response.
- **HTML requests** (`.html` format): the gem returns early without performing any
  database operations, delegating rendering to standard Rails view templates.

### Key Components

- **`Azeroth::Resourceable`** – A Rails controller concern. Include it in a controller
  and call `resource_for :resource_name` to generate all CRUD actions.
- **`Azeroth::Decorator`** – Base class for JSON serialization. Subclass it and use
  `expose` to declare which fields should be included in the JSON response.
- **`resource_for` options**: `only`, `except`, `decorator`, `before_save`,
  `after_save`, `build_with`, `update_with`, `paginated`, `per_page`, `id_key`,
  `param_key`.

### Example

```ruby
class GamesController < ApplicationController
  include Azeroth::Resourceable
  skip_before_action :verify_authenticity_token

  resource_for :game, except: :delete
end
```

```ruby
class Game::Decorator < Azeroth::Decorator
  expose :id
  expose :name
  expose :publisher_name, as: :publisher
end
```

---

## Language

All code, comments, documentation, commit messages, pull request titles and
descriptions, and issue comments **must be written in English**.

---

## Tests

- Every new class, module, or method **must have a corresponding spec file**.
- Use **RSpec** following the existing conventions in the `spec/` directory.
- Tests are organized under `spec/lib/` for unit tests, `spec/controllers/` for
  controller integration tests, and `spec/integration/` for full integration tests.
- When adding a new file under `lib/` that does not yet have a corresponding spec,
  add it to `config/check_specs.yml` under the `ignore:` key **only as a temporary
  measure** until the spec is created. Do not leave files permanently in that list
  without a spec.
- Controller action behaviour for both JSON and HTML formats must be covered by tests.

---

## Documentation

- Use **YARD** for all public API documentation.
- Every public class and method must have a YARD doc comment.
- Use the following YARD tags as appropriate:
  - `@api public` / `@api private`
  - `@param name [Type] description`
  - `@option options [Type] :key description`
  - `@return [Type] description`
  - `@example` – include at least one usage example for public APIs
  - `@see` – cross-reference related classes or methods
- Documentation coverage is verified in CI via `bundle exec rake verify_measurements`.
  Files excluded from that check are listed in `config/check_specs.yml`.

---

## Design Principles

### Single Responsibility (Sandi Metz / *99 Bottles of OOP*)

- Keep classes and methods **small and focused on a single responsibility**.
- Prefer many small, well-named methods over fewer large ones.
- Extract behaviour into dedicated classes rather than adding more responsibilities
  to an existing class.
- Avoid long parameter lists; use option objects or keyword arguments instead.

### Law of Demeter

- Avoid chaining method calls on objects that are not direct collaborators
  (e.g. `a.b.c` should be avoided).
- Delegate behaviour to the object that owns it rather than reaching through it.
- Use wrapper/delegation methods to hide the internal structure of collaborators.

---

## Code Style

- Follow the project's existing **RuboCop** configuration (`.rubocop.yml`).
- Ruby version: **>= 3.3.1**.
- Rails/ActiveSupport version: **~> 7.2.x**.
- Use `frozen_string_literal: true` at the top of every Ruby file (already enforced
  by RuboCop).
