---Set of helpful table manipulation functions
-- @module lua_table
-- @author Italo Maia
-- @license MIT
-- @copyright IMAIA, 2019

-- @section functions

--- inserts all values of t2 in t1
-- keys of t2 are not preserved; t2 are inserted
-- in order only if t2 is an array.
--
-- @tparam array t1
-- @tparam array t2
-- @return t1
-- @usage a, b = {1}, {2}; union(a, b) -- {1, 2}
-- @see union
local function append (t1, t2)
  for _, v in pairs(t2) do
    table.insert(t1, v)
  end

  return t1
end

--- creates a deep copy of t; ignores metatable
-- keys are copied as they are; if value is a table, copy is recursively
-- called for it; make sure table is not a cyclic tree before using copy.
--
-- @tparam table t non cyclic table
-- @return new table with all attributes of `t`
local function copy (t)
  local tmp = {}

  for k, v in pairs(t) do
      if type(v) == 'table' then
          tmp[k] = copy(v)
      else tmp[k] = v end
  end

  return tmp
end

--- creates a new array without repeated values
--
-- @tparam array t
-- @return new array without duplicate values
-- @usage distinct({1, 1, 2, 3})  -- {1, 2, 3}
local function distinct (t)
  local tmp = {}
  local v_tmp = {}

  for _, v in pairs(t) do
      if not v_tmp[v] then
          table.insert(tmp, v)
          v_tmp[v] = true
      end
  end

  return tmp
end

--- creates a new array with all keys of t
--
-- @tparam table t
-- @return new table
-- @usage values({3,4,5})  -- {1, 2, 3}
-- @usage values({a=1, b=2, c=3})  -- {'a', 'b', 'c'}
-- @see values
local function keys (t)
  local tmp = {}

  for k, v in pairs(t) do
    table.insert(tmp, k)
  end

  return tmp
end

--- compares the values of t1 and t2 for each key of both
-- returns false if any of the values differ and works with nested
-- tables
--
-- @tparam table t1
-- @tparam table t2
-- @return whether all key/values are the same
-- @usage same({1, 2}, {1, 2})  -- true
-- @usage same({1, 2}, {2, 1})  -- false
-- @usage same({a=1, b=2}, {b=2, a=1})  -- true
-- @see distinct
-- @see append
-- @see keys
local function same (t1, t2)
  -- shortcircuit
  if #t1 ~= #t2 then return false end

  for _, key in pairs(distinct(append(keys(t1), keys(t2)))) do
    -- check type first
    if type(t1[key]) ~= type(t2[key]) then
      return false
    end

    -- compare tables?
    if type(t1[key]) == 'table' then
      if not same(t1[key], t2[key]) then
        return false
      end
    -- compare scalars!
    elseif t1[key] ~= t2[key] then
      return false
    end
  end

  return true
end

--- flattens up array items of t into single values
-- level controls how many levels of the array should be flattened
--
-- @tparam array t
-- @tparam int level
-- @return new flattened array
-- @usage flat({1, {2}})  -- {1, 2}
-- @usage flat({1, {2, {3}}})  -- {1, 2, {3}}
-- @usage flat({1, {2, {3}}}, 2)  -- {1, 2, 3}
local function flat (t, level)
  local tmp = {}
  level = level or 1

  for k, v in pairs(t) do
    if type(v) == 'table' and level > 0 then
      append(tmp, flat(v, level-1))
    else tmp[k] = v end
  end

  return tmp
end

--- calls fn for each (key, value) of t
--
-- @tparam table t
-- @tparam function fn (k, v) as params
-- @usage foreach({3,4,5}, function (k, v) print(k) end)
local function foreach (t, fn)
  for k, v in pairs(t) do
    fn(k, v)
  end
end

--- creates a table with protected values
-- use it to easely customize table value set and unset
--
-- @tparam table t
-- @tparam function newindex (t, k, v) as params
-- @tparam table base; use it for custom functions
-- @return proxied table
local function proxy (t, newindex, base)
  return setmetatable(base or {}, {
    __index = t,
    __newindex = function (_, k, v) return newindex(t, k, v) end,
    __len = function () return #t end,
    __pairs = function () return next, t, nil end,
  })
end

--- creates a immutable table
--
-- @tparam table t
-- @return new immutable table
-- @usage immutable({a=1, b=2, c=3})  -- constants map
-- @usage immutable({1, 2, 3})  -- tuple
local function immutable (t)
  -- copy `t` so changes to `t` do not not affect immutable
  return proxy(copy(t), function (t, k, v)
    error("attempt to change immutable table")
  end)
end

--- copies all public (key, value) of t1 and t2 into a new table and returns it
-- if t1 and t2 have key collision, t2 value will have precedence
--
-- @tparam table t1
-- @tparam table t2
-- @return new table with the values of t1 and t2
-- @usage join({a=1, c=3}, {a=2, b=2}) -- {a=2, b=2, c=3}
-- @usage join({a=1}, {b=2}) -- {a=1, b=2}
-- @usage join({a=1}, {2}) -- {a=1, [1]=2}
-- @see merge
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

--- copies all (key, value) of t2 into t1 and returns it
--
-- @tparam table t1
-- @tparam table t2
-- @return updated t1
-- @usage merge({a=1, c=3}, {a=2, b=2}) -- {a=2, b=2, c=3}
-- @usage merge({a=1}, {b=2}) -- {a=1, b=2}
-- @usage merge({a=1}, {2}) -- {a=1, [1]=2}
-- @see join
local function merge (t1, t2)
  for k, v in pairs(t2) do
    t1[k] = v
  end

  return t1
end

--- creates a new array without repeated values that ignores repeated values
--
-- @tparam[opt={}] array t
-- @return new set table
-- @usage set({1, 1, 2, 2, 3})  -- {1, 2, 3}
local function set (t)
  local rev = {}  -- reverse index
  local tmp = distinct(t) or {}

  for _, v in pairs(tmp) do rev[v] = true end

  -- force newindex call with "emptish" table
  return proxy(tmp, function (_, k, v)
    if v == nil then  -- value is being removed
      rev[v], tmp[k] = nil, nil
    elseif rev[v] == nil then  -- new value
      rev[v], tmp[k] = true, v
    end  -- value is indexed; ignore
  end, {
    has = function (_, v)
      return rev[v] == true
    end
  })
end

--- copies all (key, value) of t2 into t1; throws an error on key collision
-- useful if you want to prevent collision
--
-- @tparam table t1
-- @tparam table t2
-- @tparam[opt] table rename - copy values of t2 to t1 to a different index;
--    {copy_t2_key=as_t1_key}
-- @tparam[opt] array only - only copy this subset of t2 values to t1
-- @tparam[opt] array exclude - do not copy this subset of t2 values to t1
-- @usage local a, b = {a=1}, {a=2}; patch(a, b)  -- error
-- @usage local a, b = {a=1}, {b=2, c=3}; patch(a, b)  -- {a=1, b=2, c=3}
-- @usage local a, b = {a=1}, {b=2}; patch(a, b, {b='c'})  -- {a=1, c=2}
-- @usage local a, b = {a=1}, {b=2, c=3}; patch(a, b, nil, {'c'})  -- {a=1, c=3}
-- @usage local a, b = {a=1}, {b=2, c=3}; patch(a, b, nil, nil, {'c'})  -- {a=1, b=2}
-- @see merge
-- @see join
local function patch (t1, t2, rename, only, exclude)
  only = only or keys(t2)
  exclude = set(exclude or {})
  rename = rename or {}

  for _, key in pairs(only) do
    if not exclude:has(key) then
      local name = rename[key] or key

      if t1[name] then error('key collision on patch') end

      t1[name] = t2[key]
    end
  end
end

--- gets you an slice of the array
-- negative indexes are not supported
--
-- @tparam array t
-- @tparam int _i initial position of the slice
-- @tparam int _e final position of the slice
-- @return table with only the elements of the slice
local function slice (t, _i, _e)
  local tmp = {}
  _i = math.max(_i, 1)
  _e = math.min(_e or #t, #t)

  for i=_i, _e do
    table.insert(tmp, t[i])
  end

  return tmp
end

--- creates a sorted copy of t
--
-- @tparam table t
-- @tparam function fn (a, b) as params; same as fn in table.sort(t, fn)
-- @return new sorted table
-- @usage sorted({4, 3})  -- {3, 4}
local function sorted (t, fn)
  local tmp = copy(t)

  table.sort(tmp, fn)

  return tmp
end

--- creates a new array with all values of t1 and t2
-- keys are not preserved; order of the values is not
-- guaranteed.
--
-- @tparam table t1
-- @tparam table t2
-- @return new table
-- @usage union({3, 4}, {1, 2})  -- {3, 4, 1, 2}
-- @see append
local function union (t1, t2)
  local tmp = {}

  for _, v in pairs(t1) do
    table.insert(tmp, v)
  end

  for _, v in pairs(t2) do
    table.insert(tmp, v)
  end

  return tmp
end

--- creates a new array with all values of t
--
-- @tparam table t
-- @return new table
-- @usage values({3,4,5})  -- {3, 4, 5}
-- @usage values({a=1, b=2, c=3})  -- {1, 2, 3}
-- @see keys
local function values (t)
  local tmp = {}

  for k, v in pairs(t) do
    table.insert(tmp, v)
  end

  return tmp
end

return {
  ['append']=append,
  ['copy']=copy,
  ['distinct']=distinct,
  ['same']=same,
  ['flat']=flat,
  ['foreach']=foreach,
  ['immutable']=immutable,
  ['join']=join,
  ['keys']=keys,
  ['merge']=merge,
  ['patch']=patch,
  ['proxy']=proxy,
  ['set']=set,
  ['slice']=slice,
  ['sorted']=sorted,
  ['union']=union,
  ['values']=values,
}
