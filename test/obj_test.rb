require 'minitest/autorun'
require_relative '../lib/obvious/obj'

class TestObj
  include Obvious::Obj

  def initialize
    @local = 'set!'
  end

  define :defined_method, foo: String, bar: Integer do |input|
    input
  end

  define :defined_local do |input|
    @local
  end

  define :early_return_example do |input|
    next true
    false
  end
end

class ObjTest < Minitest::Test
  def test_valid_input
    result = TestObj.new.defined_method foo: 'hello', bar: 12
    assert_equal({foo: 'hello', bar: 12}, result)
  end

  def test_access_instance_variables
    result = TestObj.new.defined_local
    assert_equal('set!', result)
  end

  def test_missing_parameters
    error = assert_raises ArgumentError do
      TestObj.new.defined_method foo: 'hello'
    end
    assert_equal('missing input field bar', error.message)
  end

  def test_extra_parameters
    error = assert_raises ArgumentError do
      TestObj.new.defined_method foo: 'hello', bar: 12, extra: 'fail'
    end
    assert_equal('invalid input field extra', error.message)
  end

  def test_invalid_types
    error = assert_raises ArgumentError do
      TestObj.new.defined_method foo: 1, bar: 12
    end
    assert_equal('invalid type for foo expected String', error.message)

    error = assert_raises ArgumentError do
      TestObj.new.defined_method foo: 'hello', bar: nil
    end
    assert_equal('invalid type for bar expected Integer', error.message)
  end

  def test_early_return
    assert(TestObj.new.early_return_example)
  end
end
