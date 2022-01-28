require 'test_helper'
require_relative '../lib/obvious/obj'

class TestObj
  include Obvious::Obj

  def initialize
    @local = 'set!'
  end

  define :defined_method, with_foo: [:foo, String], also_bar: [:bar, Integer] do |input|
    input
  end

  define :defined_local do |input|
    @local
  end
end

class ObjTest < Minitest::Test
  def test_valid_input
    result = TestObj.new.defined_method with_foo: 'hello', also_bar: 12
    assert_equal(result, {foo: 'hello', bar: 12})
  end

  def test_access_instance_variables
    result = TestObj.new.defined_local
    assert_equal(result, 'set!')
  end

  def test_missing_parameters
    error = assert_raises ArgumentError do
      TestObj.new.defined_method with_foo: 'hello'
    end
    assert_equal(error.message, 'missing input field also_bar')
  end

  def test_extra_parameters
    error = assert_raises ArgumentError do
      TestObj.new.defined_method with_foo: 'hello', also_bar: 12, and_extra: 'fail'
    end
    assert_equal(error.message, 'invalid input field and_extra')
  end

  def test_invalid_types
    error = assert_raises ArgumentError do
      TestObj.new.defined_method with_foo: 1, also_bar: 12
    end
    assert_equal(error.message, 'invalid type for with_foo expected String')

    error = assert_raises ArgumentError do
      TestObj.new.defined_method with_foo: 'hello', also_bar: nil
    end
    assert_equal(error.message, 'invalid type for also_bar expected Integer')
  end
end
