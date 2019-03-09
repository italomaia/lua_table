--- inserts all values of `t2` to `t1`
--
-- @table array
-- @table array
-- @return `t1`
-- @usage a, b = {1}, {2}; union(a, b) -- {1, 2}
local function append (t1, t2)
  for k, v in pairs(t2) do
    table.insert(t1, v)
  end

  return t1
end

--- creates a deep copy of `t` ignoring protected attributes
-- keys are copied as they are; if value is a table, copy is recursively
-- called for it; make sure table is not a cyclic tree before using copy.
--
-- @table non cyclic tree
-- @return new table with all non-protected attributes of `t`
local function copy (t)
  local tmp = {}

  for k, v in pairs(t) do
      if type(v) == 'table' then
          tmp[k] = copy(v)
      else tmp[k] = v end
  end

  return tmp
end

--- calls `fn` for each (key, value) of `t`
--
-- @table
-- @function(k, v)
local function foreach (t, fn)
  for k, v in pairs(t) do
    fn(k, v)
  end
end

--- gets you an slice of the array
--
-- @table array
-- @int initial position of the slice
-- @int final position of the slice
-- @return table with only the elements of the slice
local function slice (t, _i, _e)
  local tmp = {}

  for i=_i, _e do
    table.insert(tmp, t[i])
  end

  return tmp
end

--- copies all public (key, value) of `t2` into `t1` and returns it
--
-- @table
-- @table
-- @return updated `t1`
-- @usage merge({a=1, c=3}, {a=2, b=2}) -- {a=2, b=2, c=3}
-- @usage merge({a=1}, {b=2}) -- {a=1, b=2}
-- @usage merge({a=1}, {2}) -- {a=1, [1]=2}
local function merge (t1, t2)
  for k, v in pairs(t2) do
    t1[k] = v
  end

  return t1
end

--- copies all public (key, value) of `t1` and `t2` into a new table and returns it
-- if `t1` and `t2` have key collision, `t2` value will have precedence
-- @table
-- @table
-- @return new table with the values of `t1` and `t2`
-- @usage join({a=1, c=3}, {a=2, b=2}) -- {a=2, b=2, c=3}
-- @usage join({a=1}, {b=2}) -- {a=1, b=2}
-- @usage join({a=1}, {2}) -- {a=1, [1]=2}
local function join (t1, t2)
  local tmp = {}

  for k, v in pairs(t1) do
    tmp[k] = v
  end

  for k, v in pairs(t2) do
    tmp[k] = v
  end

  return tmp
end

--- creates a new array without repeated values that ignores repeated values
--
-- @table[opt={}]
local function set (t)
    local tmp = t and distinct(t) or {}

    setmetatable(t, {

    })

    return tmp
end

---
--
-- @table array
-- @return new array without duplicate values
-- @usage distinct({1, 1, 2, 3}) -- {1, 2, 3}
local function distinct (t)
    local tmp = {}
    local v_tmp = {}

    for k, v in pairs(t) do
        if not v_tmp[v] then
            table.insert(tmp, v)
            v_tmp[v] = true
        end
    end

    return tmp
end

--- creates a immutable table
-- useful to create tuples.
--
-- @table
-- @return new immutable table
local function immutable (t)
  local mt = getmetatable(t) or {}

  mt.__index = copy(t)
  mt.__newindex = function (t, k, v)
    error("attempt to change immutable table")
  end

  return setmetatable({}, mt)
end

--- creates a new array with all values of `t1` and `t2`
-- @table
-- @table
-- @return new table
local function concat (t1, t2)
  local tmp = copy(t1)

  for k, v in pairs(t2) do
    table.insert(tmp, v)
  end

  return tmp
end

--- flattens up array items of `t` into single values
-- level controls how many levels of the array should be flattened
--
-- @table array
-- @int
-- @return
-- @usage flat({1, {2}})  -- {1, 2}
-- @usage flat({1, {2, {3}}})  -- {1, 2, {3}}
-- @usage flat({1, {2, {3}}}, 2)  -- {1, 2, 3}
local function flat (t, level)
  local tmp = {}
  level = level or 1

  for k, v in pairs(t) do
    if type(v) == 'table' and level > 0 then
      tmp = concat(tmp, flat(v, level-1))
    else tmp[k] = v end
  end

  return tmp
end

--- returns a new table with all keys in `t`
-- @table
-- @return new table
-- @usage values({3,4,5})  -- {1, 2, 3}
-- @usage values({a=1, b=2, c=3})  -- {'a', 'b', 'c'}
local function keys (t)
    local tmp = {}

    for k, v in pairs(t) do
      table.insert(tmp, k)
    end

    return tmp
end

--- returns a new table with all values in `t`
-- @table
-- @return new table
-- @usage values({3,4,5})  -- {3, 4, 5}
-- @usage values({a=1, b=2, c=3})  -- {1, 2, 3}
local function values (t)
  local tmp = {}

  for k, v in pairs(t) do
    table.insert(tmp, v)
  end

  return tmp
end

--- compares the values of `t1` and `t2` for each key of both
-- returns false if any of the values differ
-- @table
-- @table
-- @return whether all values are equal
-- @usage
local function equal (t1, t2)
  for _, key in distinct(append(keys(t1), keys(t2))) do
    if t1[key] ~= t2[key] then
      return false
    end
  end

  return true
end

return {
  append,
  concat,
  copy,
  distinct,
  equal,
  foreach,
  immutable,
  join,
  merge,
  set,
  slice,
}
