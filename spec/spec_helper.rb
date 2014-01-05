require 'fakefs/spec_helpers'
require 'mocha/api'

RSpec.configure do |c|
  c.mock_with :rspec 
end

def create_directories_necessary_for_descriptors
  # if these directories do not exist, 
  # the descriptor will not work
  Dir.mkdir("app")
  Dir.mkdir("app/actions")
  Dir.mkdir("app/spec")
  Dir.mkdir("app/spec/actions")
end
