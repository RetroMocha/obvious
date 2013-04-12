require 'yaml'

require_relative 'helpers/application'

module Obvious
  module Generators
    class InvalidDescriptorError < StandardError; end

    class Descriptor
      def initialize descriptor
        @descriptor = descriptor
        @app        = Obvious::Generators::Application.instance
      end

      def to_file
        validate_descriptor
        
        @jacks, @entities = {}, {}
        @code = ''

        @descriptor['Code'].each do |entry|
          write_comments_for entry
          process_requirements_for entry if entry['requires']
        end

        write_action
      end

      private
      def write_comments_for entry
        @code << "    \# #{entry['c']}\n"
        @code << "    \# use: #{entry['requires']}\n" if entry['requires']
        @code << "    \n"
      end

      def process_requirements_for entry
        requires = entry['requires'].split ','

        requires.each do |req|
          req.strip!
          infos = req.split '.'

          if infos[0].index 'Jack'
            @app.jacks[infos[0]] = [] unless @app.jacks[infos[0]]
            @jacks[infos[0]]    = [] unless @jacks[infos[0]]

            @app.jacks[infos[0]] << infos[1]
            @jacks[infos[0]] << infos[1]
          else
            @app.entities[infos[0]] = [] unless @app.entities[infos[0]]
            @entities[infos[0]]    = [] unless @entities[infos[0]]

            @app.entities[infos[0]] << infos[1]
            @entities[infos[0]] << infos[1]
          end
        end
      end # #process_requirements_for

      def write_action
        jacks_data   = process_jacks
        requirements = require_entities

        output = %Q{#{requirements}
class #{@descriptor['Action']}

  def initialize #{jacks_data[:inputs]}
#{jacks_data[:assignments]}  end

  def execute input
#{@code}  end
end
}

        snake_name = @descriptor['Action'].gsub(/(.)([A-Z])/,'\1_\2').downcase

        filename = "#{Obvious::Generators::Application.instance.dir}/actions/#{snake_name}.rb"
        File.open(filename, 'w') {|f| f.write(output) }

        output = %Q{require_relative '../../actions/#{snake_name}'

describe #{@descriptor['Action']} do

  it '#{@descriptor['Description']}'

  it 'should raise an error with invalid input'

end
        }

        filename = "#{Obvious::Generators::Application.instance.dir}/spec/actions/#{snake_name}_spec.rb"
        File.open(filename, 'w') {|f| f.write(output) }
      end

      def process_jacks
        jack_inputs = ''
        jack_assignments = ''

        @jacks.each do |k, v|
          name = k.chomp('Jack').downcase
          jack_inputs << "#{name}_jack, "
          jack_assignments << "    @#{name}_jack = #{name}_jack\n"
        end

        jack_inputs.chomp! ', '

        {
          inputs: jack_inputs,
          assignments: jack_assignments
        }
      end

      def require_entities
        entity_requires = ''

        @entities.each do |k, v|
          snake_name = k.gsub(/(.)([A-Z])/,'\1_\2').downcase
          entity_requires << "require_relative '../entities/#{snake_name}'\n"
        end

        entity_requires
      end

      def validate_descriptor
        raise InvalidDescriptorError unless @descriptor
        raise InvalidDescriptorError if @descriptor['Code'].nil?
        raise InvalidDescriptorError if @descriptor['Action'].nil?
        raise InvalidDescriptorError if @descriptor['Description'].nil?
      end
    end # ::Descriptor
  end
end
