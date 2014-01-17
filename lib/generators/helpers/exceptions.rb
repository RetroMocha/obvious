module Obvious
  module Generators
    class DescriptorFileExist < StandardError; end
    class MissingVariable < StandardError; end
    class InvalidDescriptorError < StandardError; end
  end
end