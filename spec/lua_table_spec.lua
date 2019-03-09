describe('testing equal', function ()
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
