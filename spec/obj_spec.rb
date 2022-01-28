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

describe Obvious::Obj do

  before do
    @test = TestObj.new
  end

  describe 'self.define' do
    it 'should do the right thing with correct input' do
      result = @test.defined_method foo: 'hello', bar: 12
      expect(result).to eq foo: 'hello', bar: 12
    end

    it 'should have access to instance variables' do
      result = @test.defined_local
      expect(result).to eq 'set!'
    end

    it 'should raise an error for missing parameters' do
      expect { @test.defined_method foo: 'hello' }.to raise_error { |error|
        expect(error).to be_a ArgumentError
        expect(error.message).to eq 'missing input field bar'
      }
    end

    it 'should raise an error for extra parameters' do
      expect { @test.defined_method foo: 'hello', bar: 12, extra: 'this is extra!' }.to raise_error { |error|
        expect(error).to be_a ArgumentError
        expect(error.message).to eq 'invalid input field extra'
      }
    end

    it 'should raise an error for invalid types' do
      expect { @test.defined_method foo: 1, bar: 12 }.to raise_error { |error|
        expect(error).to be_a ArgumentError
        expect(error.message).to eq 'invalid type for foo expected String'
      }

      expect {@test.defined_method foo: 'hello', bar: nil }.to raise_error { |error|
        expect(error).to be_a ArgumentError
        expect(error.message).to eq 'invalid type for bar expected Integer'
      }
    end

    it 'should allow for early returns in control flow' do
      result = @test.early_return_example
      expect(result).to eq true
    end
  end

end
