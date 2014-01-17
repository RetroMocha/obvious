require 'yaml'

require_relative 'base_generator'
require_relative 'helpers/application'
require_relative 'descriptor_parser'

module Obvious
  module Generators
    class ApplicationGenerator < BaseGenerator
      def generate
        puts 'Generating the files...'

        Obvious::Generators::ApplicationGenerator.create_directories ['/', '/actions', '/contracts', '/entities',
                                                                      '/spec', '/spec/actions', '/spec/contracts', '/spec/entities',
                                                                      '/spec/doubles']

        unless File.exist? "#{@app.target_path}/Rakefile"
          puts 'Creating Rakefile...'
          `cp #{@app.lib_path}/obvious/files/Rakefile #{@app.target_path}/Rakefile`
        end

        unless File.exist? "#{@app.target_path}/external"
          puts 'Creating external directory'
          `cp -r #{@app.lib_path}/obvious/files/external #{@app.target_path}/external`
        end

        descriptors = Dir['descriptors/*.yml']

        puts 'Creating actions from descriptors... ' unless descriptors.length.zero?
        descriptors.each do |file|
          yaml = YAML.load_file(file)
          descriptor = Obvious::Generators::Descriptor.new yaml
          descriptor.to_file
        end

        @app.remove_duplicates

        puts 'Writing Entities scaffolds... '
        Obvious::Generators::ApplicationGenerator.write_entities

        puts 'Writing jacks scaffolds... '
        Obvious::Generators::ApplicationGenerator.write_jacks

        puts "Files are located in the `#{@app.dir}` directory."
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

          filename = "#{@app.dir}/entities/#{snake_name}.rb"
          File.open(filename, 'w') { |f| f.write(output) }

          output = %Q{require_relative '../../entities/#{snake_name}'

describe #{name} do
#{method_specs}
end
}

          filename = "#{@app.dir}/spec/entities/#{snake_name}_spec.rb"
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

          filename = "#{@app.dir}/contracts/#{snake_name}_contract.rb"
          File.open(filename, 'w') {|f| f.write(output) }

          output = %Q{require_relative '../../contracts/#{snake_name}_contract'

describe #{k}Contract do
#{method_specs}
end
}

          filename = "#{@app.dir}/spec/contracts/#{snake_name}_spec.rb"
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

          filename = "#{@app.dir}/spec/doubles/#{snake_name}_double.rb"
          File.open(filename, 'w') {|f| f.write(output) }

        end
      end # generate_jacks_code
    end
  end
end
