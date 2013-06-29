require_relative '../lib/obvious/obj'

class TestObj
  include Obvious::Obj 

  def initialize 
    @local = 'set!'
  end

  define :defined_method, with_foo: [:foo, String], also_bar: [:bar, Fixnum] do |input|
    input
  end

  define :defined_local do |input|
    @local
  end

end

describe Obvious::Obj do

  before do
    @test = TestObj.new
  end

  describe 'self.define' do
    it 'should do the right thing with correct input' do
      result = @test.defined_method with_foo: 'hello', also_bar: 12
      result.should eq foo: 'hello', bar: 12
    end

    it 'should have access to instance variables' do
      result = @test.defined_local
      result.should eq 'set!' 
    end

    it 'should raise an error for missing parameters' do
      expect { @test.defined_method with_foo: 'hello' }.to raise_error { |error| 
        error.should be_a ArgumentError
        error.message.should eq 'missing input field also_bar'
      }
    end

    it 'should raise an error for extra parameters' do
      expect { @test.defined_method with_foo: 'hello', also_bar: 12, and_extra: 'this is extra!' }.to raise_error { |error|
        error.should be_a ArgumentError
        error.message.should eq 'invalid input field and_extra'
      }
    end

    it 'should raise an error for invalid types' do
      expect { @test.defined_method with_foo: 1, also_bar: 12 }.to raise_error { |error|
        error.should be_a ArgumentError 
        error.message.should eq 'invalid type for with_foo expected String'
      }

      expect {@test.defined_method with_foo: 'hello', also_bar: nil }.to raise_error { |error|
        error.should be_a ArgumentError
        error.message.should eq 'invalid type for also_bar expected Fixnum'
      } 
    end
  end

end
