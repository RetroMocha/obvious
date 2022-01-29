require 'minitest/autorun'
require_relative '../lib/obvious/entity'

class Thing < Obvious::Entity
  value :id, Integer
  value :name, String
end

class Thing2 < Obvious::Entity
  value :foo , String

  validation :something, -> {
    if foo != "hello world"
      msg = "Validation Error: Invalid value for foo, should be 'hello world'"
      raise Obvious::ValidationError.new msg
    end
  }

  def modify_foo
    @values[:foo] = 100
  end
end

class Thing3 < Obvious::Entity
  value :foo , String

  validation :something, -> {
    @values[:foo] = 12
  }
end


# Test code begins here

class EntityTest < Minitest::Test
  def test_valid_input
    t = Thing.new(name: 'Thing', id: 1)
    assert_equal('Thing', t.name)
    assert_equal(t.id, 1)
  end

  def test_invalid_input_types
    assert_raises Obvious::TypeError do
      Thing.new(name: nil, id: nil)
    end
  end

  def test_invalid_extra_field
    assert_raises Obvious::ShapeError do
      Thing.new(name: 'Thing', id: 1, extra: 'should explode')
    end
  end

  def test_method_modify_value
    assert_raises RuntimeError do
      Thing2.new(foo: 'hello world').modify_foo
    end
  end

  def test_to_hash
    t = Thing.new(name: 'Thing', id: 1)
    assert_equal({name: 'Thing', id: 1}, t.to_hash)
  end

  def test_failed_validation
    assert_raises Obvious::ValidationError do
      Thing2.new(foo: 'not valid I promise!')
    end
  end

  def test_modify_value_inside_validation
    assert_raises RuntimeError do
      Thing3.new(foo: 'hello world')
    end
  end
end
