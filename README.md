*lua_table* is a friendly library to help you get more productive with Lua. It packs
common operations over tables that might save you some coding in the long run.

**compatibility:** lua5.3

## Why?

*lua_table* was created because I've not found a module that makes working
with `tables` more productive without adding to much to the stack. *lua_table*
attempts to provide just enough with good compatibility with Lua standard modules.

## Install

luarocks install lua_table

## Getting Started

[Documentation](https://italomaia.github.io/lua_table/)

*lua_table* usage is advised in one of the following ways:

```
-- as a module
local ltable = require('lua_table')

-- exteding table
require('lua_table').patch(table, ltable)

-- extending the environment
require('lua_table').patch(_G, ltable)
```

## Examples

```
local ltable = require('lua_table')
ltable.patch(_G, ltable)

local a1, a2 = {1, 2}, {3, 4}

assert(same(union(a1, a2), {1, 2, 3, 4}))
assert(same(distinct(union(a1, a1)), {1, 2}))
assert(same(sorted(keys({a=1, b=2, c=3})), {'a', 'b', 'c'}))
assert(same(sorted(values({a=1, b=2, c=3})), {1, 2, 3}))

local t1 = immutable({5, 6, 7})  -- creates a tuple
table.insert(t1, 8)  -- error

local s1 = set({5, 6, 7})
table.insert(s1, 7)
table.insert(s1, 8)
assert("#s1 == 4: ", #s1 == 4)
assert("s1:has(8): ", s1:has(8))
assert("s1:has(9): ", s1:has(9))

assert(same(flat({1, 2, {3}}), {1, 2, 3}))
assert(same(slice({5, 6, 7, 8, 9, 10}, 1, 2), {5, 6}))
```
