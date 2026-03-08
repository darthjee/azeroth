# GitHub Copilot Instructions for Azeroth

## Project Overview

Azeroth is a Ruby gem that simplifies the creation of Rails controller endpoints. The main feature is the `resource_for` method, which automatically generates controller action methods (`create`, `show`, `index`, `update`, `delete`, `edit`) and handles both HTML and JSON request formats transparently.

## Language Requirements

- All pull requests, comments, documentation, and code must be written in **English**.

## Testing Requirements

- **Tests are mandatory** for all code changes.
- Every new class, module, or method must have corresponding specs under `spec/`.
- Files without test coverage must be listed in `config/check_specs.yml` under the `ignore:` key.
- Use RSpec for all tests, following the conventions already established in the `spec/` directory.
- Ensure comprehensive test coverage for new features and changes, including edge cases.

## Documentation Requirements

- Use **YARD** format for all documentation.
- Document all public methods, classes, and modules with:
  - A summary line (single-line, ending with a period).
  - `@param` tags for each parameter.
  - `@return` tag describing the return value.
  - `@example` tags showing representative usage where appropriate.
  - `@api public` or `@api private` tags to mark visibility.
- Documentation coverage is enforced via `config/yardstick.yml` (threshold: 96.5%).

## Code Style and Design Principles

- Follow the principles from **Sandi Metz's "99 Bottles of OOP"**:
  - Prefer small, well-named methods with a single responsibility.
  - Avoid large, complex methods—break them into smaller, well-defined ones.
  - Aim for high cohesion and low coupling between classes.
- Respect the **Law of Demeter**: avoid chaining method calls across object boundaries.
- Keep classes focused; a class should do one thing and do it well.
- Prefer composition over inheritance where possible.
- Follow the **RuboCop** rules configured in `.rubocop.yml` (Ruby 3.3 target).

## Project-Specific Guidelines

- The gem is a **Rails** extension—follow Rails conventions and best practices.
- The core abstraction is `Azeroth::Resourceable` (mixed into controllers via `include Azeroth::Resourceable`), which exposes the `resource_for` class method.
- `Azeroth::Decorator` is used to control JSON serialization; use `expose` to declare which attributes are rendered.
- **Maintain backward compatibility** when modifying existing public APIs.
- Pagination is opt-in via `paginated: true` on `resource_for`; respect the `per_page` option and the pagination response headers (`pages`, `per_page`, `page`).
- New options added to `resource_for` or `model_for` must be documented and covered by integration specs (see `spec/integration/`).

## Using Jace for Event-Driven Hooks

Azeroth uses the [jace](https://github.com/darthjee/jace) gem to provide event-driven lifecycle hooks around controller actions. Refer to [`.github/jace-usage.md`](.github/jace-usage.md) for the full Jace API reference and usage patterns.

Key points when working with Jace inside Azeroth:

- Use `Jace::Registry` to register and trigger events.
- Register handlers with `registry.register(event, instant = :after, &block)`, where `instant` is `:before` or `:after`.
- Trigger events with `registry.trigger(event, context, &block)`; `:before` and `:after` handlers are `instance_eval`'d in `context`, while the main block is called in the surrounding scope.
- Triggering an event with no registered handlers is safe—the main block still runs.
