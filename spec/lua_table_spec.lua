describe('append output is as expected', function ()
  local append = require('lua_table').append

  it("returns the same table", function ()
    local t1, t2 = {1}, {2}
    local rs = append(t1, t2)

    assert.are.equal(rs, t1)
    assert.are_not.equal(rs, t2)
  end)

  it('appends all items of t2 to t1', function ()
    assert.are.same(append({1, 2}, {2, 3}), {1, 2, 2, 3})
    -- keys of `t1` are preserved when joining non-arrays
    local t = append({a=1, b=2}, {b=3, c=4})
    assert.are.equal(t.a, 1)
    assert.are.equal(t.b, 2)
    -- appending non-arrays has unexpected results
    assert.are.is_true((t[1] == 3) or (t[1] == 4))
    assert.are.is_true((t[2] == 3) or (t[2] == 4))
  end)
end)

describe('copy output is as expected', function ()
  local copy = require('lua_table').copy

  it('creates a new table', function ()
    local t = {1, 2, 3}

    assert.are_not.equal(copy(t), t)
  end)

  it('copies all public attribute', function ()
    assert.are.same(copy({1, 2, 3}), {1, 2, 3})
    assert.are.same(copy({a=1, b=2, c=3}), {a=1, b=2, c=3})
  end)

  it('copies nested attributes', function ()
    assert.are.same(copy({1, {2, 3}}), {1, {2, 3}})
  end)
end)

describe('distinct output is as expected', function ()
  local distinct = require('lua_table').distinct

  it("creates a new table", function ()
    local t = {1, 2}

    assert.are.same(distinct(t), t)
    assert.are_not.equal(distinct(t), t)
  end)

  it('removes all repeated scalar values', function ()
    assert.are.same(distinct({1, 1, 2, 3}), {1, 2, 3})
  end)

  it("removes same instance", function ()
    local n = {2, 3}
    local t = {1, n, n}

    assert.are.same(distinct(t), {1, n})
  end)

  it("keeps same table", function ()
    local t = {1, {2, 3}, {2, 3}}

    assert.are.same(distinct(t), t)
  end)
end)

describe('same output is as expected', function ()
  local same = require('lua_table').same

  it('empty arrays are same', function ()
    assert.is_true(same({}, {}))
  end)

  it('compares flat same arrays as same', function ()
    assert.is_true(same({1, 2, 3}, {1, 2, 3}))
  end)

  it('compares non-flat same arrays as same', function ()
    assert.is_true(same({1, {2, 3}}, {1, {2, 3}}))
  end)

  it('compares different length arrays as not same', function ()
    assert.is_false(same({1, 2, 3}, {1, 2, 3, 4}))
  end)

  it('compares different flat arrays as not same', function ()
    assert.is_false(same({a=1, b=2}, {a=1, b=2, c=3}))
  end)

  it('compares different non-flat arrays as not same', function ()
    assert.is_false(same({1, 2}, {1, {2}}))
  end)
end)

describe('flat output is as expected', function ()
  local flat = require('lua_table').flat

  it('creates a new instance', function ()
    local t = {1, 2, 3}

    assert.are_not.equal(flat(t), t)
  end)

  it("doesn't change flat arrays", function ()
    local t = {1, 2, 3}

    assert.are.same(flat(t), t)
  end)

  it('flattens nested arrays', function ()
    assert.are.same(flat({1, {2, 3}}), {1, 2, 3})
  end)

  it('flattens one level by default', function ()
    assert.are.same(flat({1, {2, {3}}}), {1, 2, {3}})
  end)

  it('flattens up to max level', function ()
    assert.are.same(flat({1, {2, {3, {4}}}}, 2), {1, 2, 3, {4}})
  end)
end)

describe('foreach output is as expected', function ()
  local foreach = require('lua_table').foreach

  it('returns nothing', function ()
    assert.is_nil(foreach({1}, function () end))
  end)

  it('does nothing for empty tables', function ()
    local count = 0

    foreach({}, function () count = count + 1 end)
    assert.are.equal(count, 0)
  end)

  it('runs once for each table item', function ()
    local count = 0
    local t = {1, 2, 3}

    foreach(t, function () count = count + 1 end)
    assert.are.equal(count, #t)
  end)

  it('provides key and value to callback', function ()
    local t = {a=1, b=2, c=3}
    local t_k = {}
    local t_v = {}

    foreach(t, function (k, v)
      table.insert(t_k, k)
      table.insert(t_v, v)
    end)

    table.sort(t_k)
    table.sort(t_v)

    assert.are.equal(#t_k, 3)
    assert.are.equal(t_k[1], 'a')
    assert.are.equal(t_k[2], 'b')
    assert.are.equal(t_k[3], 'c')

    assert.are.equal(#t_v, 3)
    assert.are.equal(t_v[1], 1)
    assert.are.equal(t_v[2], 2)
    assert.are.equal(t_v[3], 3)
  end)
end)

describe('immutable output is as expected', function ()
  local immutable = require('lua_table').immutable

  it('index lookup still works', function ()
    local t = immutable({a=1, b=2, c=3})

    assert.are.equal(t.a, 1)
  end)

  it('gives an error on new value', function ()
    local t = immutable({a=1, b=2, c=3})

    assert.has_errors(function () t.d = 4 end)
    assert.are.equal(t.d, nil)
  end)

  it('gives an error on value update attemp', function ()
    local t = immutable({a=1, b=2, c=3})

    assert.has_errors(function () t.c = 4 end)
    assert.are.equal(t.c, 3)
  end)

  it('gives an error on table insert', function ()
    local t = immutable({1, 2, 3})

    assert.has_errors(function () table.insert(t, 4) end)
    assert.are.equal(#t, 3)
  end)

  it('gives an error on table remove', function ()
    local t = immutable({1, 2, 3})

    assert.has_errors(function () table.remove(t) end)
    assert.are.equal(#t, 3)
  end)
end)

describe('join output is as expected', function ()
  local join = require('lua_table').join

  it('creates a new instance', function ()
    local t1, t2 = {a=1, b=2}, {b=3, c=4}

    assert.are_not.equal(join(t1, t2), t1)
    assert.are_not.equal(join(t1, t2), t2)
  end)

  it('does nothing for empty tables', function ()
    assert.are.same(join({}, {}), {})
    assert.are.same(join({1, 2, 3}, {}), {1, 2, 3})
    assert.are.same(join({}, {1, 2, 3}), {1, 2, 3})
  end)

  it('second table values overrides the first', function ()
    local t1, t2 = {a=1, b=2}, {b=3, c=4}

    assert.are.same(join(t1, t2), {a=1, b=3, c=4})
  end)
end)

describe('keys output is as expected', function ()
  local keys = require('lua_table').keys
  local sorted = require('lua_table').sorted

  it('works with empty tables', function ()
    assert.are.same(keys({}), {})
  end)

  it('returns keys as a array', function ()
    -- order is guaranteed for arrays
    assert.are.same(keys({4, 5, 6}), {1, 2, 3})
    -- order is not guaranteed for tables
    assert.are.same(sorted(keys({a=4, b=5, c=6})), {'a', 'b', 'c'})
  end)
end)

describe('merge output is as expected', function ()
  local merge = require('lua_table').merge

  it('re-uses first instance', function ()
    local t1, t2 = {a=1, b=2}, {b=3, c=4}

    assert.are.equal(merge(t1, t2), t1)
    assert.are_not.equal(merge(t1, t2), t2)
  end)

  it('does nothing for empty tables', function ()
    assert.are.same(merge({}, {}), {})
    assert.are.same(merge({1, 2, 3}, {}), {1, 2, 3})
    assert.are.same(merge({}, {1, 2, 3}), {1, 2, 3})
  end)

  it('second table values overrides the first', function ()
    local t1, t2 = {a=1, b=2}, {b=3, c=4}

    assert.are.same(merge(t1, t2), {a=1, b=3, c=4})
  end)
end)

describe('patch creates expected behavior', function ()
  local patch = require('lua_table').patch

  it('returns nothing', function ()
    local a, b = {a=1}, {b=2}
    assert.is_nil(patch(a, b))
  end)

  it('merges two tables', function ()
    local a, b = {a=1}, {b=2}

    patch(a, b)
    assert.are.same(a, {a=1, b=2})
  end)

  it('throws error on collision', function ()
    local a, b = {a=1}, {a=2}

    assert.has_errors(function ()
      patch(a, b)
    end)
  end)

  it('always throws error with arrays', function ()
    local a, b = {1}, {2}

    assert.has_errors(function ()
      patch(a, b)
    end)
  end)
end)

describe('proxy creates expected behavior', function ()
  local proxy = require('lua_table').proxy
  local same = require('lua_table').same

  it('newindex is always called', function ()
    local count = 0
    local t = {3, 4, 5}
    local p = proxy(t, function (t, k, v)
      t[k] = v
      count = count + 1
    end)

    table.insert(p, 10)
    assert.is_true(same(t, p))
    assert.are.equal(#t, 4)
    assert.are.equal(#p, 4)
    assert.are.equal(count, 1)
  end)

  it('allows to protect value set', function ()
    local t = {3, 4, 5}
    local p = proxy(t, function (t, k, v) end)

    table.insert(p, 10)
    assert.is_true(same(t, p))
    assert.are.equal(#t, 3)
    assert.are.equal(#p, 3)
  end)
end)

describe('set output is as expected', function ()
  local set = require('lua_table').set
  local same = require('lua_table').same

  it('behaves as regular tables', function ()
    assert.are.is_true(same(set({3, 4, 5}), {3, 4, 5}))
  end)

  it('removes repeated values', function ()
    local t = {3, 3, 4, 5}
    local s = set(t)

    assert.are_not.equal(#t, #s)
    assert.are.equal(#s, 3)
    assert.are.is_true(same(s, {3, 4, 5}))
  end)

  it("doesn't add repetead values", function ()
    local s = set({1, 2, 3})

    assert.are.equal(#s, 3)

    table.insert(s, 3)
    assert.are.equal(#s, 3)

    table.insert(s, 4)
    assert.are.equal(#s, 4)
  end)

  it('adds has method', function ()
    local s = set({1, 2, 3})

    assert.is_true(s:has(3))
    assert.is_false(s:has(5))
  end)
end)

describe('slice output is as expected', function ()
  local slice = require('lua_table').slice

  it('returns empty if index out-of-bound', function()
    local t = {1, 2, 3, 4, 5}

    assert.are.same(slice(t, 6, 8), {})
    assert.are.same(slice(t, -5, 0), {})
    assert.are.same(slice(t, -1, 2), {1, 2})
  end)

  it('slices if index in-bound', function ()
    local t = {1, 2, 3, 4, 5}

    assert.are.same(slice(t, 1, 3), {1, 2, 3})
  end)

  it('slices up to last item if end bound is not provided', function ()
    local t = {1, 2, 3, 4, 5}

    assert.are.same(slice(t, 3), {3, 4, 5})
  end)

  it('slices works for equal indexes', function ()
    local t = {1, 2, 3, 4, 5}

    assert.are.same(slice(t, 3, 3), {3})
  end)
end)

describe('sorted output is as expected', function ()
  local sorted = require('lua_table').sorted

  it('returns a new instance', function ()
    local t = {3, 4, 5}

    assert.are_not.equal(t, sorted(t))
  end)

  it('sorts', function ()
    assert.are.same(sorted({5, 4, 3}), {3, 4, 5})
  end)
end)

describe('union output is as expected', function ()
  local union = require('lua_table').union
  local sorted = require('lua_table').sorted

  it('creates a new instance instance', function ()
    local t1, t2 = {a=1, b=2}, {b=3, c=4}

    assert.are_not.equal(union(t1, t2), t1)
    assert.are_not.equal(union(t1, t2), t2)
  end)

  it('does nothing for empty tables', function ()
    assert.are.same(union({}, {}), {})
    assert.are.same(union({1, 2, 3}, {}), {1, 2, 3})
    assert.are.same(union({}, {1, 2, 3}), {1, 2, 3})
  end)

  it('second table values overrides the first', function ()
    -- values order is guaranteed for arrays
    assert.are.same(union({'a', 'b'}, {'b', 'c'}), {'a', 'b', 'b', 'c'})
    -- keys are not preserved; order is not guaranteed for non-arrays
    assert.are.same(sorted(union({a=1, b=2}, {b=3, c=4})), {[1]=1, [2]=2, [3]=3, [4]=4})
  end)
end)

describe('values output is as expected', function ()
  local values = require('lua_table').values
  local sorted = require('lua_table').sorted

  it('works with empty tables', function ()
    assert.are.same(values({}), {})
  end)

  it('returns keys as a array', function ()
    -- order is guaranteed for arrays
    assert.are.same(values({4, 5, 6}), {4, 5, 6})
    -- order is not guaranteed for tables
    assert.are.same(sorted(values({a=4, b=5, c=6})), {4, 5, 6})
  end)
end)
