class Contract
  @@disable_override = false

  # Provides a default empty array for method_added
  # Overriden by self.contracts
  def self.contract_list
    []
  end

  # Public: Sets the contracts
  #
  # contracts - a list of contracts, as String or as Symbols.
  #
  # Examples
  #
  #   class FooJackContract < Contract
  #     contracts :save, :get, :list
  #
  #   end
  #
  # Returns Nothing.
  def self.contracts *contracts
    singleton_class.send :define_method, :contract_list do
      contracts
    end
  end

  # Public: Defines a contract for a method
  #
  # method - a symbol representing the method name
  # contract - a hash with the keys :input and :output holding the respective shapes.
  #
  # Examples
  #
  #   class FooJackContract < Contract
  #
  #     contract_for :save, {
  #       :input  => Foo.shape,
  #       :output => Foo.shape,
  #     }
  #
  #   end
  #
  def self.contract_for method, contract
    method_alias    = "#{method}_alias".to_sym
    method_contract = "#{method}_contract".to_sym

    define_method method_contract do |*args|
      input = args[0]
      call_method method_alias, input, contract[:input], contract[:output]
    end

    contracts( *contract_list, method )
  end

  # This method will move methods defined in @contracts into new methods.
  # Each entry in @contracts will cause the method with the same name to
  # become method_name_alias and for the original method to point to
  # method_name_contract.
  def self.method_added name
    unless @@disable_override
      self.contract_list.each do |method|
        if name == method.to_sym
          method_alias = "#{method}_alias".to_sym
          method_contract = "#{method}_contract".to_sym

          @@disable_override = true # to stop the new build method
          self.send :alias_method, method_alias, name
          self.send :remove_method, name
          self.send :alias_method, name, method_contract

          @@disable_override = false
        else
          # puts self.inspect
          # puts "defining other method #{name}"
        end
      end
    end
  end

  # This method is used as a shorthand to mak the contract method calling pattern more DRY
  # It starts by checking if you are sending in input and if so will check the input shape for
  # errors. If no errors are found it calls the method via the passed in symbol(method).
  #
  # Output checking is more complicated because of the types of output we check for. Nil is
  # never valid output. If we pass in the output shape of true, that means we are looking for
  # result to be the object True. If the output shape is an array, that is actually a shorthand
  # for telling our output check to look at the output as an array and compare it to the shape
  # stored in output_shape[0]. If we pass in the symbol :true_false it means we are looking for
  # the result to be either true or false. The default case will just check if result has the shape
  # of the output_shape.
  def call_method method, input, input_shape, output_shape
    if input != nil && input_shape != nil
      has_shape, error_field = input.has_shape? input_shape, true
      unless has_shape 
        raise ContractInputError, "incorrect input data format field #{error_field}"
      end

      result = self.send method, input
    else
      result = self.send method
    end

    # check output
    # output should never be nil
    if result == nil
      raise ContractOutputError, 'incorrect output data format'
    end

    # we are looking for result to be a True object
    if output_shape === true
      if output_shape == result
        return result
      else
        raise ContractOutputError, 'incorrect output data format'
      end
    end

    # we want to check the shape of each item in the result array
    if output_shape.class == Array
      if result.class == Array
        inner_shape = output_shape[0]
        result.each do |item|
          has_shape, error_field = item.has_shape? inner_shape, true
          unless has_shape 
            raise ContractOutputError, "incorrect output data format field #{error_field}"
          end
        end

        return result
      end
      raise ContractOutputError, 'incorrect output data format'
    end

    # we want result to be true or false
    if output_shape == :true_false
      unless result == true || result == false
        raise ContractOutputError, 'incorrect output data format'
      end

      return result
    end

    # we want result to be output_shape's shape
    has_shape, error_field = result.has_shape? output_shape, true
    unless has_shape 
      raise ContractOutputError, "incorrect output data format field #{error_field}"
    end

    result
  end

end

# via https://github.com/citizen428/shenanigans/blob/master/lib/shenanigans/hash/has_shape_pred.rb
class Hash
  # Checks if a hash has a certain structure.
  #     h = { k1: 1, k2: "1" }
  #     h.has_shape?(k1: Fixnum, k2: String)
  #     #=> true
  #     h.has_shape?(k1: Class, k2: String)
  #     #=> false
  # It also works with compound data structures.
  #     h = { k1: [], k2: { k3: Struct.new("Foo") } }
  #     shape = { k1: Array, k2: { k3: Module } }
  #     h.has_shape?(shape)
  #     #=> true
  def has_shape?(shape, return_field = false)
    return_value = lambda { |r, f|
      if return_field
        return r, f
      else
        return r 
      end
    }
 
    # I added an empty check
    if self.empty?
      return return_value.call shape.empty?, nil
    end  
 
    self.each do |k, v|
      return return_value.call false, k if shape[k] == nil
    end 

    shape.each do |k, v|
      # hash_value
      hv = self[k]
      return return_value.call false, k unless self.has_key? k 

      next if hv === nil

      if Hash === hv 
        return hv.has_shape?(v, return_field) 
      else
        return return_value.call false, k unless v === hv
      end
    end

    return_value.call true, nil
  end

end

class ContractInputError < StandardError
end

class ContractOutputError < StandardError
end

