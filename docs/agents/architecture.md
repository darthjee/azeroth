# Architecture

## Overview

Azeroth is a Ruby gem that extends Rails controllers with generated CRUD-style
action methods. Including `Azeroth::Resourceable` and calling `resource_for`
(or `model_for`) triggers a chain of builder classes that append methods to
the controller for handling requests, params, routes/resources, and JSON
rendering — for both `.html` and `.json` formats.

All source code lives under `lib/azeroth/`, loaded lazily via `autoload` from
`lib/azeroth.rb`. Most classes carry `@api public` or `@api private` YARD
tags; only `Resourceable`, `Decorator`, `resource_for`, and `model_for` are
public API — everything else is an internal implementation detail and can
change without a major version bump.

## Source Code Layout

All application source code lives under `lib/azeroth/`.

### `resourceable.rb` / `resourceable/`

Public entry point. `Resourceable` is an `ActiveSupport::Concern` mixed into
controllers; `Resourceable::ClassMethods` exposes `resource_for` and
`model_for`. `EndpointsBuilder` and `ResourcesBuilder` orchestrate the other
builders (`RequestHandler`, `ParamsBuilder`, `RoutesBuilder`,
`ResourceBuilder`) to generate the requested action methods on the including
controller.

### `decorator.rb` / `decorator/`

Public JSON serialization layer. `Decorator` is subclassed per-resource and
uses the `expose` class method to declare which attributes render in JSON
responses. `HashBuilder` and `KeyValueExtractor` turn exposed attributes into
the output hash; `MethodBuilder` generates the reader methods for exposed
attributes; `Options` holds per-`expose` configuration (`as`, `if`,
`decorator`, `reader`, `override`).

### `dummy_decorator.rb`

Fallback decorator used when a resource has no explicit `Decorator` subclass
— delegates straight to the object's `as_json`.

### `request_handler.rb` / `request_handler/`

One class per controller action (`Create`, `Show`, `Index`, `Update`,
`Destroy`, `Edit`, `New`), each responsible for executing that action's logic
(building/finding/saving the resource, invoking `before_save`/`after_save`
hooks) and telling the controller how to respond. `Pagination` implements the
`paginated: true` opt-in behavior and the `pages`/`per_page`/`page` response
headers.

### `resource_builder.rb`, `routes_builder.rb`, `params_builder.rb`

`Sinclair::Model`-based builders invoked by `Resourceable` to append,
respectively: resource-listing/fetching methods, route-action methods, and
params-handling methods to the including controller.

### `model.rb`

Interface wrapping the resource's `ActiveRecord` model class, resolving it
from either a class or a name symbol/string passed to `resource_for`.

### `controller_interface.rb`

Thin wrapper around the including controller instance, used by request
handlers to set response headers and otherwise interact with the controller
without coupling directly to Rails internals.

### `options.rb`

`Azeroth::Options` (subclass of `Sinclair::Options`) holding the defaults and
validation for `resource_for`/`model_for` options (`only`, `except`,
`id_key`, `param_key`, `paginated`, `per_page`, `before_save`, `after_save`,
`build_with`, `update_with`, `decorator`).

### `version.rb`

Gem version constant.
