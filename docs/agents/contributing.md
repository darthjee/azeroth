# Contributing

## Commit Guidelines

- **Atomic and Unitary:** Each commit must represent a single logical change.
  *Example:*
  - Good: `Add pagination headers to RequestHandler::Index`
  - Bad: `Add pagination headers and refactor Decorator logic`
- **No Unrelated Changes:** Do not mix unrelated changes in the same commit.
- **Separate Refactoring:** Whenever possible, separate refactoring commits from new feature or bugfix commits.

## Pull Requests

- **Descriptive Summary:** Every PR must include a clear and descriptive summary of its purpose and changes.
- **PR Description Files:** If a description cannot be provided directly in the PR, generate a file with the PR description (e.g., `docs/agents/issues/<issue_id>_description.md`), but do not commit this file.

## Definition of Done for PRs

A PR is considered complete when:

- The stated objective has been achieved.
- All tests are passing.
- Linting (RuboCop) passes without errors.
- Code coverage is as high as reasonably possible.
- Code is not overly complex:
  - Classes and methods should have clear, focused responsibilities.
  - If a class or method is taking on too many responsibilities, refactor to simplify.
  - Methods should be small and do exactly one thing. If a method is growing, extract parts into private helper methods or separate classes.
  - *Example:*
    ```ruby
    # Good: each method does one thing
    class Worker
      def fetch_job; end
      def process_job(job); end
    end

    # Bad: method does too much
    class Worker
      def run
        fetch_job
        process_job
        send_metrics
        cleanup
      end
    end
    ```
  - This requirement applies primarily to source code. For specs, refactor only if there is excessive duplication.

### CI Checks

Before a PR is considered complete, all CI checks relevant to the modified parts of the project must pass locally. This project has a single CircleCI pipeline (`.circleci/config.yml`) that runs against the whole gem — there are no per-folder path filters, so every check below applies regardless of which files were modified.

| CircleCI Job | Local Command(s) |
|--------------|-------------------|
| `test` (RSpec) | `bundle exec rspec` |
| `checks` — RuboCop | `bundle exec rubocop` |
| `checks` — Yardstick documentation coverage | `bundle exec rake verify_measurements` |
| `checks` — Unit test coverage check | `bundle exec check_specs` (see `config/check_specs.yml`) |
| `checks` — RubyCritic | `rubycritic.sh` (or `bundle exec rubycritic` locally) |

Run all of the above before opening a PR. If a new job or check is added to `.circleci/config.yml` in the future, add its local command to this table before merging changes that would be affected by it.

This same process must be followed when **planning how to resolve an issue**: include a final step in the plan that lists the CI commands above to run before opening a PR.

## Code Organization

### File Responsibility: Class Declarers vs Scripts

Every source file under `lib/` (excluding test files) must act as a **class or module declarer** — it should define one class or module and nothing else. Files must not act as **scripts** (i.e., they must not execute logic at load time or perform side effects directly).

`lib/azeroth.rb` is the gem's entrypoint: it `require`s dependencies and declares the `Azeroth` module with `autoload` statements for every other file. It does not perform side effects beyond loading.

*Example:*
```ruby
# Good: class declarer — defines a class, no side effects at load time
class RoutesBuilder < Sinclair::Model
  def append
    # ...
  end
end

# Bad: script — executes logic at file load time
builder = RoutesBuilder.new
builder.append
```

Spec files are exempt from this rule and may execute setup code freely (e.g. `RSpec.describe`, `let`, `before` blocks).

### File Naming: snake_case Matching the Class/Module Name

Files that define a class or module must use **snake_case** naming, matching the class/module name exactly, with nested namespaces mirrored as subdirectories.

*Examples:*

- `RoutesBuilder` → `lib/azeroth/routes_builder.rb`
- `Decorator::MethodBuilder` → `lib/azeroth/decorator/method_builder.rb`
- `RequestHandler::Index` → `lib/azeroth/request_handler/index.rb`

This applies to both source files and their corresponding spec files, mirrored under `spec/lib/`:
- `lib/azeroth/routes_builder.rb` → spec: `spec/lib/azeroth/routes_builder_spec.rb`
- `lib/azeroth/decorator/method_builder.rb` → spec: `spec/lib/azeroth/decorator/method_builder_spec.rb`

Non-class files (e.g. `config/*.rb` tooling config) use lowercase or snake_case at the author's discretion.

### Method Order: Public Before Private

Within a class, **public methods must be declared before private methods**. Private methods (below the `private` keyword) serve as implementation helpers and should appear at the end of the class body.

*Example:*
```ruby
# Good: public methods first, private methods last
class Worker
  def run
    prepare
    execute
  end

  def status
    # ...
  end

  private

  def prepare; end
  def execute; end
end

# Bad: private methods mixed in with or before public methods
class Worker
  private

  def prepare; end

  public

  def run
    prepare
    execute
  end
end
```

## Dependency Injection

Classes must receive their dependencies (data, configuration, collaborators) as constructor arguments (via `initialize` or `initialize_with`, as used by `Sinclair::Model` subclasses in this codebase). A class must never reach out to load files, read environment variables, or fetch configuration on its own.

**The entry points — `Resourceable::ClassMethods#resource_for`/`#model_for` — are responsible for gathering configuration** (the options hash passed by the including controller). They then pass the resolved data down to the builder and handler classes that need it.

This makes every class independently testable: tests simply instantiate the class with the data they need, without touching the filesystem, environment, or a real Rails app beyond the `spec/dummy` app used for integration specs.

*Example:*
```ruby
# Good: class receives its collaborators as constructor arguments — easy to test
class RoutesBuilder < Sinclair::Model
  initialize_with(:model, :builder, :options, writter: false)

  def append
    # uses @model, @builder, @options
  end
end

# Bad: class reaches out and resolves its own dependencies — hard to test
class RoutesBuilder
  def append
    model = Model.new(ApplicationController.resource_name, Options.new) # ❌
    # ...
  end
end
```

This principle applies to all classes — including builders and handlers. If a class needs data, it gets it through its constructor.

## Refactoring Guidelines

When refactoring, aim to:

- **Reduce Code Duplication:**
  *Example:* Move repeated setup code in specs to a factory (via `factory_bot`, already used under `spec/support/factories/`).
  ```ruby
  # Good
  FactoryBot.define do
    factory :publisher do
      name { 'Books Inc' }
    end
  end
  # In specs:
  let(:publisher) { create(:publisher, name: 'Other') }

  # Bad
  let(:publisher) { Publisher.create!(name: 'Other') }
  # ...repeated setup logic in many spec files
  ```
- **Extract Shared Behavior:** Use RSpec `shared_examples` (see `spec/support/shared_examples/`) instead of copy-pasting near-identical spec blocks across request handlers or builders.
- **Prefer Composition Over Inheritance:** Favor small collaborator objects (as this codebase already does with its builder classes) over deep inheritance hierarchies.
- **Keep RuboCop Clean:** Do not silence RuboCop offenses with inline disables; if a rule genuinely doesn't fit, add a documented exception to `.rubocop_todo.yml` or `.rubocop.yml` instead.
