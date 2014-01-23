require 'yaml'

require_relative 'base_generator'
require_relative 'helpers/application'
require_relative 'action_generator'

module Obvious
  module Generators
    class DescriptorProcessGenerator < BaseGenerator
      def generate
        descriptors = Dir['descriptors/*.yml']
        puts 'Creating actions from descriptors... ' unless descriptors.length.zero?
        descriptors.each do |file|
          yaml = YAML.load_file(file)
          ActionGenerator.new(@descriptor['Action'], @descriptor['Description'], @descriptor['Code']).generate
        end

        @app.remove_duplicates



        puts 'Writing Entities scaffolds... '
        write_entities

        puts 'Writing jacks scaffolds... '
        write_jacks

        puts "Files are located in the `#{@app.app_dir.expand_path}` directory."
      end # ::generate

      def write_entities
        @app.entities.each do |k, v|
          name          = k
          method_specs  = ''
          method_defs   = ''

          method_defs << '
def self.shape
  {}
end
'

          v.each do |method|
            method_defs << "
def #{method} input
  nil
end
  "

            method_specs << "
describe '.#{method}' do
  it 'should #{method} with valid input'

  it 'should raise an error with invalid input'

end
  "
          end

          output = %Q{class #{name}
#{method_defs}
end
}
          snake_name = name.gsub(/(.)([A-Z])/,'\1_\2').downcase

          filename = "#{@app.app_dir}/entities/#{snake_name}.rb"
          File.open(filename, 'w') { |f| f.write(output) }

          output = %Q{require_relative '../../entities/#{snake_name}'

describe #{name} do
#{method_specs}
end
}

          filename = "/spec/#{@app.app_dir}/entities/#{snake_name}_spec.rb"
          File.open(filename, 'w') {|f| f.write(output) }
        end
      end #write_entities

      def write_jacks
        @app.jacks.each do |k, v|
          name         = k.chomp('Jack').downcase
          method_specs = ''
          contract_defs  = ''

          jack_double_default_methods = ''
          jack_double_badoutput_methods = ''

          v.each do |method|

            contract_defs << "
contract_for :#{method}, {
  :input  => {},
  :output => {},
}
  "

            method_specs << "
describe '.#{method}_contract' do
  it 'should #{method} data with valid input'

  it 'should raise an error with invalid input'

  it 'should raise an error with invalid output'

end
  "

          jack_double_default_methods << "
def #{method} input
  {}
end
  "

          jack_double_badoutput_methods << "
def #{method} input
  nil
end
  "
          end

          output = %Q{require 'obvious'

class #{k}Contract < Obvious::Contract
#{contract_defs}
end
}

          snake_name = k.gsub(/(.)([A-Z])/,'\1_\2').downcase

          filename = "#{@app.app_dir}/contracts/#{snake_name}_contract.rb"
          File.open(filename, 'w') {|f| f.write(output) }

          output = %Q{require_relative '../../contracts/#{snake_name}_contract'

describe #{k}Contract do
#{method_specs}
end
}

          filename = "/spec/#{@app.app_dir}/contracts/#{snake_name}_spec.rb"
          File.open(filename, 'w') {|f| f.write(output) }

          output = %Q{require_relative '../../contracts/#{snake_name}_contract'

class #{k}Double
def self.create behavior
  case behavior
  when :bad_output
    #{k}_BadOutput.new
  when :default
    #{k}_Default.new
  end
end
end

class #{k}_Default < #{k}Contract
#{jack_double_default_methods}
end

class #{k}_BadOutput < #{k}Contract
#{jack_double_badoutput_methods}
end
}

          filename = "spec/#{@app.app_dir}/doubles/#{snake_name}_double.rb"
          File.open(filename, 'w') {|f| f.write(output) }

        end
      end # generate_jacks_code
    end
  end
end
