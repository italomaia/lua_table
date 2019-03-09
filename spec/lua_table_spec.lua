describe('append output is as expected', function ()
  local append = require('lua_table').append

  it("returns the same table", function ()
    local t1, t2 = {1}, {2}
    local rs = append(t1, t2)

    assert.are.equal(rs, t1)
    assert.are_not.equal(rs, t2)
  end)

  it('appends all items of t2 to t1', function ()
    local t1, t2 = {1, 2}, {2, 3}
    local rs = append(t1, t2)

    assert.are.equal(#rs, 4)
    assert.are.same(rs, {1, 2, 2, 3})
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

describe('equal output is as expected', function ()
  local equal = require('lua_table').equal

  it('empty arrays are equal', function ()
    assert.is_true(equal({}, {}))
  end)

  it('compares flat equal arrays as equal', function ()
    assert.is_true(equal({1, 2, 3}, {1, 2, 3}))
  end)

  it('compares non-flat equal arrays as equal', function ()
    assert.is_true(equal({1, {2, 3}}, {1, {2, 3}}))
  end)

  it('compares different length arrays as not equal', function ()
    assert.is_false(equal({1, 2, 3}, {1, 2, 3, 4}))
  end)

  it('compares different flat arrays as not equal', function ()
    assert.is_false(equal({a=1, b=2}, {a=1, b=2, c=3}))
  end)

  it('compares different non-flat arrays as not equal', function ()
    assert.is_false(equal({1, 2}, {1, {2}}))
  end)
end)

describe('flat output is as expected', function ()
  local flat = require('lua_table').flat
end)

describe('foreach output is as expected', function ()
  local foreach = require('lua_table').foreach
end)
describe('immutable output is as expected', function ()
  local immutable = require('lua_table').immutable
end)
describe('join output is as expected', function ()
  local join = require('lua_table').join
end)
describe('keys output is as expected', function ()
  local keys = require('lua_table').keys
end)
describe('merge output is as expected', function ()
  local merge = require('lua_table').merge
end)
describe('set output is as expected', function ()
  local set = require('lua_table').set
end)
describe('slice output is as expected', function ()
  local slice = require('lua_table').slice
end)
describe('union output is as expected', function ()
  local union = require('lua_table').union
end)
describe('values output is as expected', function ()
  local values = require('lua_table').values
end)
