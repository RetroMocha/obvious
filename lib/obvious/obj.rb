module Obvious
  module Obj
    class << self
      def included(base)
        base.extend ClassMethods
      end
    end
   
    module ClassMethods

      def define method, input = {}, &block 
        define_method(method)  do |method_input = {}| 
          block_input = {}
          method_input.each do |k,v| 
            if input[k].nil? 
              raise ArgumentError.new "invalid input field #{k}"
            end 

            unless v.is_a? input[k][1]
              raise ArgumentError.new "invalid type for #{k} expected #{input[k][1]}"
            end 

            block_input[input[k][0]] = v
          end
   
          input.each do |k,v|
            if block_input[v[0]].nil?
              raise ArgumentError.new "missing input field #{k}"
            end
          end

          self.instance_exec block_input, &block 
        end
      end

    end
  end
end
