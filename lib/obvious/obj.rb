module Obvious
  module Obj
    class << self
      def included(base)
        base.extend ClassMethods
      end
    end

    module ClassMethods

      def define method, input = {}, &block
        define_method(method) do |method_input = {}|
          block_input = {}
          method_input.each do |k,v|
            if input[k].nil?
              raise ArgumentError.new "invalid input field #{k}"
            end

            unless v.is_a? input[k]
              raise ArgumentError.new "invalid type for #{k} expected #{input[k]}"
            end
          end

          input.each do |k,v|
            if method_input[k].nil?
              raise ArgumentError.new "missing input field #{k}"
            end
          end

          self.instance_exec method_input, &block
        end
      end

    end
  end
end
