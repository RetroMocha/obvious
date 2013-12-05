require_relative 'spec_helper'
require_relative '../lib/obvious/contract'


describe Hash do
  describe '#has_shape?' do
    it 'should return true for a valid shape' do
      { id: 1 }.has_shape?(id: Fixnum).should be true
    end
    
    it 'should return false for an invalid shape' do
      { id: 1 }.has_shape?(id: String).should be false
    end

    it 'should retrn the invalid field if return_field flag is set' do
      { id: 1 }.has_shape?({id: String}, true).should eq [false, :id]
    end

    it 'should allow for nil values to be returned' do
      { id: nil }.has_shape?({id: String}).should be true
    end 
  end
end

class TestContract < Obvious::Contract
  contract_for :test, {
    input: { id: Fixnum },
    output: { id: Fixnum, value: String }
  }

  def test input
    { id: 1, value: 'this is a test' } 
  end
end

describe Obvious::Contract do

  describe "#call_method" do
    it 'should return the correct output for valid input and output shapes' do
      tc = TestContract.new
      result = tc.test id: 1
      result.should eq id: 1, value: 'this is a test'
    end
  
    it 'should raise a contract input error with bad input' do
      tc = TestContract.new
      expect { tc.test Hash.new }.to raise_error ContractInputError
    end

    it 'should raise a DataNotFound error if {} is returned' do
      tc = TestContract.new
      tc.should_receive(:test_alias).and_return({}) 
      expect { tc.test id: 1 }.to raise_error DataNotFoundError
    end

    it 'should raise a contract output error if nil is returned' do
      tc = TestContract.new
      tc.should_receive(:test_alias).and_return(nil) 
      expect { tc.test id: 1 }.to raise_error ContractOutputError
    end

  end
end
