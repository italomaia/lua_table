--- fp map function
-- creates a new array where each value is the result
-- of calling `fn` against a value of `t`.
--
-- @table array
-- @function(v) called once for each value of `t`
-- @return new array with the new values
-- @usage map({1, 2, 3}, tostring)  -- {'1', '2', '3'}
local function map (t, fn)
    local tmp = {}
    
    for k, v in pairs(t) do table.insert(fn(v)) end
    return tmp
end

--- fp filter function
-- creates a new array where each value is the result
-- of calling `fn` against a value of `t` if it is not falsy.
--
-- @table array
-- @function(v) called once for each value of `t`
-- @return new array with values for cases where `fn(value)` was not falsy
-- @usage filter({1, 2, 3}, function (v) return v < 3 end)  -- {1, 2}
local function filter (t, fn)
    return map(t, function (v)
        return fn(v) and v or nil
    end)
end

--- fp reduce function
-- reduces `t` to a single element by applying `fn` against
-- each value of `t` in pairs. The first pair is always
-- the value of `init` against the first item of `t`. Keep
-- in mind that if not provided `init` is nil.
--
-- @table array
-- @function(v1, v2)
-- @param[opt]
-- @usage reduce({1, 2, 3}, function (a, b, 0) return a + b end)  -- 6
local function reduce (t, fn, init)
    local last = init

    for k, v in pairs(t) do last = fn(last, v) end
    return last
end

--- puts together each element of `t1` with a corresponding element of each table in `...`
-- for each key of `t1`, puts the value of `t1[key]` and `tx[key]`, where
-- tx is a table from `...`  together in an array. If `t1` and `tx` are uneven 
-- or keys in `t1` are not found in `tx`, the value of `t1` for such cases will be
-- an array with less than `#{...} + 1` elements.
--
-- @table
-- @param ... variable number of tables
-- @return table where each key is a key of `t` and each value is
--         a array where the first element is a value of `t` and
--         and the others are values of elements of {...} for each
--         key of `t`.
local function zip (t, ...)
    local tmp = {}
    for k, v in pairs(t) do
        tmp[k] = {v}
        
        for _, _t in pairs({...}) do
            table.insert(tmp[k], _t[k])
        end
    end
    return tmp
end

--- gets you an slice of the array
--
-- @table array
-- @int initial position of the slice
-- @int final position of the slice
-- @return table with only the elements of the slice
local function slice (t, _i, _e)
    local tmp = {}

    for i=_i, _e do table.insert(tmp, t[i]) end
    return tmp
end

--- calls fn for each (key, value) of `t`
-- differs from map as it returns nothing.
--
-- @table
-- @function(k, v)
local function foreach (t, fn)
    for k, v in pairs(t) do fn(k, v) end
end

--- creates a deep copy of `t` ignoring protected attributes
-- keys are copied as they are; if value is a table, copy is recursively 
-- called for it; make sure table is not a cyclic tree before using copy.
-- 
-- @table non cyclic tree
-- @return new table with all non-protected attributes of `t`
local function copy (t)
    local tmp = {}
    
    for k, v in pairs(t)
        if type(v) == 'table' then
            tmp[k] = copy(v)
        else tmp[k] = v end
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
end

--- creates a new table by merging two tables together
-- overrides values of `t1` on collision.
--
-- @table
-- @table
-- @return new table
-- @usage merge({a=1, c=3}, {a=2, b=2}) -- {a=2, b=2, c=3}
-- @usage merge({a=1}, {b=2}) -- {a=1, b=2}
-- @usage merge({a=1}, {2}) -- {a=1, [1]=2}
local function merge (t1, t2)
    local tmp = {}

    for k, v in pairs(t2) do t1[k] = v end
    return tmp
end

local function flat (t)
    local tmp = {}
    for k, v in pairs(t) do
        if type(v) == 'table' then
            -- TODO
        end
    else tmp[k] = v end
end
local function keys (t)
    local tmp = {}
    for k, v in pairs(t) do
        table.insert(k, v)
    end
    return tmp
end

local function values (t)
    local tmp = {}
    for k, v in pairs(t) do
        table.insert(tmp, v)
    end
    return tmp
end

return {
    map,
    filter,
    reduce,
    zip,
    slice,
    foreach,
    copy,
    set,
    distinct,
    immutable
}