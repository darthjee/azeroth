# Folder Structure

## Project Root

| Directory / File | Description |
|-----------------|-------------|
| `lib/`           | Gem source code — the `Azeroth` module and all its classes. |
| `spec/`          | RSpec test suite, including a Rails dummy app used for integration tests. |
| `docs/agents/`   | Agent-facing documentation (architecture, flow, issues, plans). |
| `config/`        | Tooling configuration: `check_specs.yml` (spec coverage exceptions), `yardstick.yml`/`yardstick.rb` (YARD doc coverage), `rubycritc.rb` (RubyCritic config). |
| `bin/`           | Executable scripts, e.g. `bin/test`. |
| `.github/`       | GitHub PR/commit templates and dependency usage guides (`jace-usage.md`, `core_ext-usage.md`, `active_ext-usage.md`, `azeroth-usage.md`), plus `copilot-instructions.md` pointing to `AGENTS.md`. |
| `.circleci/`     | CircleCI pipeline configuration. |
| `doc/`           | Generated YARD API documentation (build output, not hand-maintained). |
| `measurement/`   | Generated YARD/yardstick coverage report (`report.txt`). |
| `rubycritic/`    | Generated RubyCritic code quality report. |
| `coverage/`      | Generated test coverage report (SimpleCov). |
| `AGENTS.md`      | Project instructions for AI coding agents (source of truth; `CLAUDE.md` and `.github/copilot-instructions.md` point here). |
| `README.md`      | Gem usage documentation and examples. |
| `azeroth.gemspec`| Gem specification (dependencies, metadata). |
| `Gemfile` / `Gemfile.lock` | Bundler dependency management. |
| `Rakefile`       | Rake tasks (tests, docs, etc). |
| `Dockerfile` / `docker-compose.yml` | Containerized dev/test environment. |
| `Makefile`       | Shortcut commands for common dev tasks. |

## lib/azeroth (Architecture)

| Subdirectory | Description |
|--------------|-------------|
| `resourceable/` | Implements `resource_for`/`model_for`, generating controller action methods. |
| `decorator/`     | Implements `Azeroth::Decorator`, controlling JSON serialization via `expose`. |
| `request_handler/` | Per-action request handling logic (create, show, index, update, delete, edit). |

## spec/ (Test Suite Layout)

| Subdirectory | Description |
|--------------|-------------|
| `dummy/`      | Minimal Rails application used as the host app for integration/controller specs. |
| `integration/`| End-to-end specs, including README example verification (`readme/`) and YARD doc checks (`yard/`). |
| `controllers/`| Controller specs exercising `resource_for`-generated actions. |
| `lib/azeroth/`| Unit specs mirroring the `lib/azeroth/` source layout. |
| `support/`    | Shared RSpec configuration: `factories/`, `matchers/`, `shared_examples/`, and a test `app/`. |
