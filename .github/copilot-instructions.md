# GitHub Copilot Instructions

## Language

All code, comments, documentation, commit messages, pull request titles, and
pull request descriptions **must be written in English**.

---

## Project Overview

**Azeroth** is a Ruby gem that simplifies the creation of RESTful Rails
controller endpoints. By including `Azeroth::Resourceable` in a controller and
calling `resource_for`, the gem automatically generates the standard CRUD
action methods (`create`, `show`, `index`, `update`, `delete`, `edit`, `new`).

### Key concepts

- **`Azeroth::Resourceable`** – A Rails concern that is included in controllers.
  It exposes the `resource_for` and `model_for` class methods.
- **`resource_for :<resource_name>, <options>`** – Generates all (or a subset
  of) CRUD actions for the named resource. Common options:
  - `only:` / `except:` – Restrict which actions are generated.
  - `decorator:` – Decorator class (or boolean) used for JSON serialization.
  - `before_save:` / `after_save:` – Hooks executed around save operations.
  - `build_with:` / `update_with:` – Custom build/update logic.
  - `paginated:` / `per_page:` – Enable pagination on the index action.
  - `id_key:` / `param_key:` – Custom parameter keys for resource lookup.
- **`Azeroth::Decorator`** – Base class for JSON serializers. Use the `expose`
  class method to declare which attributes (and how) should be included in the
  JSON response.

### HTML vs JSON request handling

- **JSON requests** (`.json` format or `format=json` param): The gem executes
  the full action lifecycle (database operations, decoration) and renders a
  JSON response with the appropriate HTTP status code.
- **HTML requests**: The gem skips the action logic and delegates rendering to
  the normal Rails view layer. HTML actions are intended for traditional
  template rendering without database side-effects; full HTML support is
  planned for future releases.

### Example usage

```ruby
# app/controllers/publishers_controller.rb
class PublishersController < ApplicationController
  include Azeroth::Resourceable
  skip_before_action :verify_authenticity_token

  resource_for :publisher, only: %i[create index]
end
```

```ruby
# app/controllers/games_controller.rb
class GamesController < ApplicationController
  include Azeroth::Resourceable
  skip_before_action :verify_authenticity_token

  resource_for :game, except: :delete

  private

  def games
    publisher.games
  end

  def publisher
    @publisher ||= Publisher.find(publisher_id)
  end

  def publisher_id
    params.require(:publisher_id)
  end
end
```

---

## Testing

- **Every new file must have a corresponding spec file.**
- Tests are written with **RSpec**.
- If a file does not have a spec, it **must** be listed in
  `config/check_specs.yml` under the `ignore` key so the spec-coverage check
  can pass. Only add files to that list when writing tests is genuinely
  impractical (e.g., pure configuration or version constants).
- Run the full test suite with `bundle exec rspec` before opening a pull
  request.

---

## Documentation

- All public classes, modules, and methods **must have YARD documentation**.
- Use YARD tags consistently:
  - `@param` for method parameters.
  - `@return` for return values.
  - `@example` for usage examples.
  - `@yield` / `@yieldparam` / `@yieldreturn` for blocks.
  - `@see` for cross-references.
- Documentation coverage is enforced via `config/yardstick.yml`. Ensure
  `bundle exec yardstick` passes without new violations.

---

## Design Principles

### Single Responsibility & small objects (Sandi Metz / *99 Bottles*)

- Keep classes and methods **small and focused**. Each class should have one
  reason to change; each method should do one thing.
- Prefer many small, well-named methods over a few large ones.
- Avoid deeply nested conditionals; extract them into well-named predicate
  methods.
- Follow the rule of thumb: methods should be no longer than 5 lines; classes
  should have no more than 100 lines.

### Law of Demeter

- An object should only call methods on:
  - itself,
  - objects it owns (instance variables / created locally),
  - objects passed as arguments.
- Avoid chained method calls that traverse unrelated objects
  (e.g., `a.b.c.do_something`). Introduce delegation or intermediate methods
  instead.

---

## Pull Requests

- Titles and descriptions must be in **English**.
- Reference the issue or feature being addressed.
- Include a brief description of *what* changed and *why*.
- Every PR must have passing CI checks and no new RuboCop offenses before
  merging.
