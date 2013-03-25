class Thing < Obvious::Entity

  value :foo, String
  value :test, Fixnum

  validation :something, Proc.new {
    if foo != "hello world"
      msg = "Validation Error: Invalid value for foo, should be 'hello world'"
      raise StandardError.new msg 
    end
  }

end

class Thing2 < Obvious::Entity
  value :something, String
  value :else, TrueClass 
end


describe Thing do
  it 'should be a thing' do
    thing = Thing.new foo: 'hello world', test: 1
    puts thing.inspect
    puts Thing.shape
    puts thing.foo
    puts thing.test
    puts thing.to_hash 

    thing2 = Thing2.new something: 'funny', else: true
    puts thing2.inspect

  end
end
