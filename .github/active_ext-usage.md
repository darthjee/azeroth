# Using `darthjee-active_ext` in This Project

This project uses the [`darthjee-active_ext`](https://github.com/darthjee/active_ext) gem,
which adds utility methods to `ActiveRecord::Relation` and `ActiveRecord::Base`.

---

## Installation

Add to your `Gemfile`:

```ruby
gem 'darthjee-active_ext'
```

Then run:

```console
bundle install
```

---

## Methods Added

The gem adds the following methods to **`ActiveRecord::Relation`** and, by delegation,
to every **`ActiveRecord::Base`** subclass (i.e., every model):

| Method | Returns | Purpose |
|---|---|---|
| `#percentage(*filters)` | `Float` (0.0 – 1.0) | Fraction of records matching a condition within the current scope |
| `#pluck_as_json(*keys)` | `Array<Hash>` | Like `pluck`, but returns an array of hashes instead of an array of arrays |

---

## `#percentage`

Returns the fraction of records within the current relation that match the
given condition.  The result is a `Float` between `0.0` and `1.0`.
Returns `0` (integer) when the relation is empty, to avoid division by zero.

### Accepted filter forms

| Form | Example argument |
|---|---|
| Named scope (Symbol) | `:with_error` |
| Multiple chained scopes (Symbols) | `:active, :with_error` |
| Hash condition | `status: :error` |
| Raw SQL string | `"status = 'error'"` |

### Examples

```ruby
# Given a model and some data:
class Document < ActiveRecord::Base
  scope :with_error,   -> { where(status: :error) }
  scope :with_success, -> { where(status: :success) }
  scope :active,       -> { where(active: true) }
end

# 3 error documents, 1 success document (4 total)
Document.percentage(:with_error)          #=> 0.75
Document.percentage(status: :error)       #=> 0.75
Document.percentage("status = 'error'")   #=> 0.75

# Nested scope: among active documents only
Document.active.percentage(:with_error)   #=> 0.5

# Multiple scope filters chained together
Document.percentage(:active, :with_error) #=> 0.25

# Empty relation → returns 0, not a float, to avoid division by zero
Document.where(id: nil).percentage(:with_error) #=> 0
```

### When to use `percentage`

- Displaying statistics or progress indicators (e.g., "75% of tasks completed").
- Feature-flag rollout checks across a filtered user base.
- Any situation where you need a ratio of one subset to its parent scope.

---

## `#pluck_as_json`

Works like `ActiveRecord`'s built-in `pluck`, but returns an **array of hashes**
instead of an array of arrays.  Each hash maps column name (as a Symbol) to its
value.

When called **with no arguments**, it returns the full `as_json` representation
of every record in the relation (equivalent to `map(&:as_json)`).

### Examples

```ruby
# Standard pluck returns nested arrays — column order matters
Document.pluck(:id, :status)
#=> [[1, "error"], [2, "success"], [3, "success"]]

# pluck_as_json returns hashes — keys make meaning explicit
Document.pluck_as_json(:id, :status)
#=> [
#     { id: 1, status: "error"   },
#     { id: 2, status: "success" },
#     { id: 3, status: "success" }
#   ]

# Works with any ActiveRecord scope chain
Document.active.pluck_as_json(:id, :status)
#=> [{ id: 3, status: "success" }]

# No arguments — returns all columns for every record as JSON hashes
Document.pluck_as_json
#=> [
#     { id: 1, status: "error",   active: false, created_at: ..., updated_at: ... },
#     { id: 2, status: "success", active: false, created_at: ..., updated_at: ... },
#     { id: 3, status: "success", active: true,  created_at: ..., updated_at: ... }
#   ]
```

### When to use `pluck_as_json`

- Building JSON API responses without loading full ActiveRecord objects.
- Feeding data into serializers or view helpers that expect hashes.
- Any scenario where column position in a plain array would be fragile or unclear.

---

## Notes

- Both methods are available directly on model classes (`Document.percentage(...)`)
  **and** on any `ActiveRecord::Relation` (`Document.active.percentage(...)`),
  because the class-level methods are delegated to `Model.all`.
- `percentage` with Symbol arguments chains named scopes; with a Hash or String it
  uses `where`.  Do **not** mix Symbols with Hashes/Strings in a single call.
- The gem requires `darthjee-core_ext` (pulled in automatically as a dependency),
  which provides the `Array#as_hash` helper used internally by `pluck_as_json`.
