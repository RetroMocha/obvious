module Obvious
  module Generators
    class DescriptorFileExist < StandardError; end
    class MissingVariable < StandardError; end
    class InvalidDescriptorError < StandardError; end
    class FileNotFound < StandardError; end
    class SourceFileNotFound < FileNotFound; end
    class DestinationNotSpecified < StandardError; end
  end
end