require 'test_helper'
require_relative '../lib/obvious/contract'

class TestContract < Obvious::Contract
  contract_for :test, {
    input: { id: Integer },
    output: { id: Integer, value: String }
  }

  def test input
    { id: 1, value: 'this is a test' }
  end
end

class ContractTest < Minitest::Test
  def test_valid_input
    result = TestContract.new.test(id: 1)
    assert_equal(result, {id: 1, value: 'this is a test'})
  end

  def test_invalid_input
    assert_raises Obvious::ContractInputError do
      TestContract.new.test(Hash.new)
    end
  end

  def test_empty_hash_return
    assert_raises Obvious::DataNotFoundError do
      tc = TestContract.new
      tc.stub :test_alias, {} do
        tc.test(id: 1)
      end
    end
  end

  def test_nil_return
    assert_raises Obvious::ContractOutputError do
      tc = TestContract.new
      tc.stub :test_alias, nil do
        tc.test(id: 1)
      end
    end
  end
end

class HashTest < Minitest::Test
  def test_valid_has_shape
    assert({id: 1}.has_shape?(id: Integer))
  end

  def test_invalid_has_shape
    refute({id: 1}.has_shape?(id: String))
  end

  def test_has_shape_allow_nil_values
    assert({id: nil}.has_shape?({id: String}))
  end

  def test_has_shape_return_invalid_field
    assert_equal({ id: 1 }.has_shape?({id: String}, true), [false, :id])
  end
end
