require 'yaml'

require_relative 'helpers/application'
require_relative 'descriptor'

module Obvious
  module Generators
    class ApplicationGenerator
      class << self
        def generate
          @app = Obvious::Generators::Application.instance

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
            descriptor = Obvious::Generators::Descriptor.new file
            descriptor.to_file
          end

          @app.remove_duplicates

          puts 'Writing Entities scaffolds... '
          Obvious::Generators::ApplicationGenerator.write_entities

          puts 'Writing jacks scaffolds... '
          Obvious::Generators::ApplicationGenerator.write_jacks

          puts "Files are located in the `#{@app.dir}` directory."
        end # ::generate

        def create_directories directories
          directories.each do |dir|
            Dir.mkdir @app.dir + dir
          end
        end

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
            method_defs  = ''

            jack_double_default_methods = ''
            jack_double_badoutput_methods = ''

            v.each do |method|

              method_defs << "
  def #{method}_contract input
    input_shape = {}
    output_shape = {}
    call_method :#{method}_alias, input, input_shape, output_shape
  end
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

class #{k}Contract < Contract
  contracts :#{ v.join(', :')}
  #{method_defs}
end
}

            snake_name = name.gsub(/(.)([A-Z])/,'\1_\2').downcase

            filename = "#{@app.dir}/contracts/#{snake_name}_jack_contract.rb"
            File.open(filename, 'w') {|f| f.write(output) }

            output = %Q{require_relative '../../contracts/#{snake_name}_jack_contract'

describe #{k}Contract do
  #{method_specs}
end
}

            filename = "#{@app.dir}/spec/contracts/#{snake_name}_jack_spec.rb"
            File.open(filename, 'w') {|f| f.write(output) }

            output = %Q{require_relative '../../contracts/#{snake_name}_jack_contract'

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

            filename = "#{@app.dir}/spec/doubles/#{snake_name}_jack_double.rb"
            File.open(filename, 'w') {|f| f.write(output) }

          end
        end # generate_jacks_code
      end
    end
  end
end
