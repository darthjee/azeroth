# Using `darthjee-core_ext` in Your Project

This file is intended to be copied into the `.github/` folder of other projects.
It provides GitHub Copilot (and developers) with a clear, actionable guide on how
to use the [`darthjee-core_ext`](https://github.com/darthjee/core_ext) Ruby gem.

---

## What Is `core_ext`?

`darthjee-core_ext` is a Ruby gem that extends Ruby's built-in (core) classes with
additional utility methods. It follows the convention of "core extensions" — monkey-patching
standard objects such as `Array`, `Hash`, `Symbol`, `Enumerable`, `Date`, `Object`,
`Numeric`, and `Math` with useful helpers, while maintaining predictable behavior.

- **Gem name**: `darthjee-core_ext`
- **Source**: <https://github.com/darthjee/core_ext>
- **YARD docs**: <https://www.rubydoc.info/gems/darthjee-core_ext>
- **Current stable release**: 3.0.0

---

## Adding the Gem to Your Project

### Via RubyGems (recommended)

Add to your `Gemfile`:

```ruby
gem 'darthjee-core_ext'
```

Or pin a specific version for reproducible builds:

```ruby
gem 'darthjee-core_ext', '~> 3.0'
```

### Via GitHub (source)

```ruby
gem 'darthjee-core_ext',
    github: 'darthjee/core_ext',
    branch: 'main'
```

---

## Installing

After adding the gem to your `Gemfile`, run:

```shell
bundle install
```

Or install it system-wide:

```shell
gem install darthjee-core_ext
```

---

## Loading the Gem

When using Bundler (Rails, typical Ruby apps), the gem is loaded automatically via
`Bundler.require`. No explicit `require` is needed.

In plain Ruby scripts or when Bundler auto-require is disabled, add:

```ruby
require 'darthjee/core_ext'
```

---

## Extensions Provided

### `Hash`

| Method | Description |
|---|---|
| `#append_to_keys` | Appends a string to every key |
| `#prepend_to_keys` | Prepends a string to every key |
| `#camelize_keys` / `#camelize_keys!` | Converts keys to CamelCase |
| `#lower_camelize_keys` / `#lower_camelize_keys!` | Converts keys to lowerCamelCase |
| `#underscore_keys` / `#underscore_keys!` | Converts keys to snake_case |
| `#change_keys` / `#change_keys!` | Transforms keys with a block |
| `#chain_change_keys` / `#chain_change_keys!` | Transforms keys by chaining method calls |
| `#change_values` / `#change_values!` | Transforms values with a block (optionally recursive) |
| `#chain_fetch` | Fetches nested keys in a chain |
| `#exclusive_merge` / `#exclusive_merge!` | Merges only existing keys |
| `#remap_keys` / `#remap_keys!` | Renames keys based on a mapping hash |
| `#sort_keys` / `#sort_keys!` | Sorts the hash by its keys |
| `#squash` / `#squash!` | Flattens a deep hash into a single-level hash |
| `#to_deep_hash` / `#to_deep_hash!` | Expands a squashed hash back into a deep hash |
| `#map_to_hash` | Maps values keeping original keys |
| `#transpose` / `#transpose!` | Swaps keys with values |

### `Array`

| Method | Description |
|---|---|
| `#as_hash` | Zips the array with a keys array into a Hash |
| `#average` | Returns the arithmetic average of the elements |
| `#chain_map` | Applies `.map` in a chain of method calls |
| `#mapk` | Maps by fetching nested keys from hashes inside the array |
| `#procedural_join` | Joins elements with a dynamically computed separator |
| `#random` | Returns a random element |
| `#random!` | Removes and returns a random element |

### `Symbol`

| Method | Description |
|---|---|
| `#camelize` | Camelizes the symbol (`:my_sym` → `:MySym`) |
| `#underscore` | Underscores a camelized symbol (`:MySym` → `:my_sym`) |

### `Enumerable` (available on `Array`, `Hash`, and any `Enumerable`)

| Method | Description |
|---|---|
| `#clean` | Returns a copy with empty values removed |
| `#clean!` | Removes empty values in place (recursive) |
| `#map_and_find` | Maps and stops at the first truthy result |
| `#map_and_select` | Maps and returns only truthy results |
| `#map_to_hash` | Maps values, using original elements as keys |

### `Object` (available on every Ruby object)

| Method | Description |
|---|---|
| `#is_any?` | Returns `true` if the object is an instance of any of the given classes |
| `#trueful?` | Returns `true` only when the object is not `nil` (unlike `#present?`, `[]` and `{}` are trueful) |

### `Date`

| Method | Description |
|---|---|
| `#days_between` | Returns the absolute number of days between two dates |

### `Math`

| Method | Description |
|---|---|
| `.average` | Calculates the (optionally weighted) average of values |

### `Class`

| Method | Description |
|---|---|
| `.default_value` | Adds a reader that returns the same default instance every time |
| `.default_values` | Adds multiple readers sharing the same default instance |
| `.default_reader` | Adds a reader that returns a default value only when the instance variable was never set |
| `.default_readers` | Adds multiple default readers sharing the same default value |

---

## Code Examples

### Hash key transformations

```ruby
# Converting API responses from camelCase to snake_case
response = { 'userId' => 1, 'firstName' => 'Alice' }
response.underscore_keys  # => { 'user_id' => 1, 'first_name' => 'Alice' }

# Preparing a payload for a camelCase API
params = { user_id: 1, first_name: 'Alice' }
params.lower_camelize_keys
# => { userId: 1, firstName: 'Alice' }

# Equivalent long form with explicit option
params.camelize_keys(uppercase_first_letter: false)
# => { userId: 1, firstName: 'Alice' }
```

### Fetching nested values safely

```ruby
config = { database: { primary: { host: 'localhost' } } }

config.chain_fetch(:database, :primary, :host)  # => 'localhost'
config.chain_fetch(:database, :replica, :host) { |key, _rest| "default-#{key}" }
# => 'default-replica'
```

### Flattening and restoring deep hashes

```ruby
deep = { a: { b: [1, 2] } }
flat = deep.squash   # => { 'a.b[0]' => 1, 'a.b[1]' => 2 }
flat.to_deep_hash    # => { 'a' => { 'b' => [1, 2] } }
```

### Exclusive merge (update only existing keys)

```ruby
defaults = { timeout: 30, retries: 3 }
overrides = { retries: 5, unknown_key: 'ignored' }

defaults.exclusive_merge(overrides)  # => { timeout: 30, retries: 5 }
```

### Array utilities

```ruby
# Zip an array with keys into a Hash
values = [10, 20, 30]
values.as_hash(%i[x y z])  # => { x: 10, y: 20, z: 30 }

# Chain map calls
[:hello, :world].chain_map(:to_s, :upcase)  # => ['HELLO', 'WORLD']

# Fetch nested keys from an array of hashes
records = [{ user: { id: 1 } }, { user: { id: 2 } }]
records.mapk(:user, :id)  # => [1, 2]
```

### Symbol utilities

```ruby
:my_method_name.camelize         # => :MyMethodName
:my_method_name.camelize(:lower) # => :myMethodName
:MyMethodName.underscore         # => :my_method_name
```

### Enumerable cleaning

```ruby
data = { name: 'Alice', nickname: nil, tags: [], meta: {} }
data.clean   # => { name: 'Alice' }

mixed = [1, nil, '', [], {}, 'hello']
mixed.clean  # => [1, 'hello']
```

### Object helpers

```ruby
value = 42
value.is_any?(String, Symbol)         # => false
value.is_any?(String, Symbol, Integer)  # => true

nil.trueful?          # => false
[].trueful?           # => true   (unlike blank?/present?)
''.trueful?           # => true
```

### Class default readers

```ruby
class Report
  attr_writer :title
  default_reader :title, 'Untitled Report'
end

r = Report.new
r.title         # => 'Untitled Report'
r.title = 'Q1'
r.title         # => 'Q1'
r.title = nil
r.title         # => nil  (nil is respected; differs from default_value)
```

### Math weighted average

```ruby
# Simple average
Math.average([10, 20, 30])  # => 20.0

# Weighted average (value => weight)
Math.average(10 => 1, 20 => 2, 30 => 1)  # => 20.0
```

---

## Best Practices and Caveats

### Monkey-patching awareness

`core_ext` extends Ruby's built-in classes globally. This means:

- All objects of the extended classes gain the new methods **throughout your entire application**, including third-party gems.
- **Name collision risk**: if another gem or your application already defines a method with the same name on the same class, the last `require`/`load` wins. Review the method list above before adoption and check for conflicts.
- In libraries (gems) intended for wide reuse, prefer not requiring `core_ext` at the top level unless you own all consumers.

### Recursive options

Several `Hash` methods (`change_keys`, `camelize_keys`, `underscore_keys`, `change_values`, `clean!`) operate recursively by default, descending into nested arrays and hashes. Pass `recursive: false` when you only need shallow transformation to avoid unintended side-effects on nested structures.

### Bang (`!`) methods vs. non-bang methods

Methods ending with `!` mutate the receiver **in place**. Use them when you are sure you do not need the original structure. Use the non-bang variants to return a transformed copy.

### Versioning

Pin to a minor version to avoid unexpected breaking changes:

```ruby
gem 'darthjee-core_ext', '~> 3.0'
```

Check the [CHANGELOG / releases page](https://github.com/darthjee/core_ext/releases) before upgrading.

---

## Running the Test Suite / Contributing

If you are contributing to `core_ext` itself or want to verify its behavior locally:

```shell
# Install dependencies
bundle install

# Run the full test suite
bundle exec rspec

# Run a single spec file
bundle exec rspec spec/lib/darthjee/core_ext/hash_spec.rb
```

Tests live under `spec/` and mirror the structure of `lib/`. Every public method must have a corresponding spec. See the [README](https://github.com/darthjee/core_ext/blob/main/README.md) and the repository's Copilot instructions (`.github/copilot-instructions.md`) for more details.
