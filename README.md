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

-- patch table with ltable, so all functions of ltable become available
-- from table
ltable.patch(table, ltable)

-- you can also patch _G and make all functions available globally
-- DON'T DO THIS FOR ANYTHING BUT SIMPLE SCRIPTS
ltable.patch(_G, ltable)

local a1, a2, a3 = {1, 2}, {3, 4}, {5, 6, 7}
local t1, t2, t3 = {a=1}, {b=2, c=3}, {d=4, e=5, f=6}

-- creates a new table with the items of a1 and a2
assert(same(union(a1, a2), {1, 2, 3, 4}))

-- creates a new table with the items of t1 and t2
assert(same(union(t1, t2), {a=1, b=2, c=3}))

-- distinct removes duplicate values
assert(same(union(a1, a1), {1, 2, 1, 2}))
assert(same(distinct(union(a1, a1)), {1, 2}))

-- keys and values behavior
assert(same(sorted(keys({a=1, b=2, c=3})), {'a', 'b', 'c'}))  -- keys
assert(same(sorted(values({a=1, b=2, c=3})), {1, 2, 3}))  -- keys
assert(same(keys(a2), {1, 2}))  -- values
assert(same(values(a2), {3, 4}))  -- values

-- create a immutable array (aka: tuple)
table.insert(immutable({5, 6, 7}), 8)  -- error

-- set ignores repeated values
local s1 = set({5, 6, 7})
table.insert(s1, 7)
table.insert(s1, 8)
assert("#s1 == 4: ", #s1 == 4)

-- checks if set contains value in O(1)
assert("s1:has(8): ", s1:has(8))
assert("s1:has(9): ", s1:has(9))

-- flattens nested arrays
assert(same(flat({1, 2, {3}}), {1, 2, 3}))

-- retrives a slice of an array
assert(same(slice({5, 6, 7, 8, 9, 10}, 1, 2), {5, 6}))

-- merges and returns first table
local m1, m2 = {a=1}, {b=2}

assert(m1 == merge(m1, m2))  -- same instance
assert(same(m1, {a=1, b=2}))  -- key/value pairs of m1 and m2

-- join
local j1, j2 = {a=1}, {b=2}
local j3 = join(j1, j2)
assert(j1 ~= j3)  -- join returns a new table
assert(same(j3, {a=1, b=2}))  -- behavior similar to merge

-- append is ideal to merge arrays
local ap1, ap2 = {3, 4, 5}, {4, 5, 6}
local ap3 = append(ap1, ap2)
assert(ap3 == ap1)  -- append reuses the instance
assert(same(ap3, {3, 4, 5, 4, 5, 6}))

-- patch
local p1, p2 = {a=1}, {b=2}

patch(p1, p1)  -- raises an error on key collision
assert(patch(p1, p2) == nil)  -- returns nil
assert(same(p1, {a=1, b=2}))  -- behavior similar to merge

-- sorted behaves like table.sort, but actually returns a new sorted array
assert(same(sorted({3, 2, 1}), {1, 2, 3}))

-- copy creates a new instance
assert(copy({2, 3, 4}) ~= {2, 3, 4})
assert(same(copy({2, 3, 4}), {2, 3, 4}))
```
