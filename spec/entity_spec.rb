require 'obvious'

class Thing < Obvious::Entity
  value :id, Fixnum 
  value :name, String 
end

class Thing2 < Obvious::Entity
  value :foo , String

  validation :something, Proc.new {
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

  validation :something, Proc.new {
    @values[:foo] = 12
  }

end

# To test the entity, we are going to use classes that inherit from it instead
# of poking at it directly. In this case, I think that makes the most sense.
describe Thing do
  it 'should create a valid object with valid input' do
    input = { name: 'Thing', id: 1 }
    t = Thing.new input
    t.name.should eq 'Thing'
    t.id.should eq 1
  end

  it 'should raise an error with invalid input types' do
    input = { name: nil, id: nil }
    expect { Thing.new input }.to raise_error Obvious::TypeError
  end

  it 'should raise an error with extra fields in input' do
    input = { name: 'Thing', id: 1, extra: 'should explode' }
    expect { Thing.new input }.to raise_error Obvious::ShapeError
  end

  it 'should raise an error when a method tries to modify a value' do
    t = Thing2.new foo: 'hello world'
    expect { t.modify_foo }.to raise_error RuntimeError
  end

  describe '#to_hash' do
    it 'should return a hash representation of the object' do
      input = { name: 'Thing', id: 1 }
      t = Thing.new input
      t.to_hash.should eq input
    end
  end

  describe 'validation' do
    it 'should raise a validation error on a failed validation' do
      expect { Thing2.new foo: 'not valid I promise!' }.to raise_error Obvious::ValidationError
    end
    
    it 'should raise an error when trying to modify an object in a validation' do
      expect { Thing3.new foo: 'hello world' }.to raise_error RuntimeError
    end
  end
end
