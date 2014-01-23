require_relative "base_generator"
require 'forwardable'
module Obvious
  module Generators
    class ActionGenerator < BaseGenerator
      attr_reader :action, :description, :code_comments
      def initialize(action, description, code, args=ARGV)
        super(args)
        app.dir = "."
        app.verify_valid_app!

        @action = action
        @description = description
        @code = code

        @code_comments = []

        parse_code
      end

      def target_path
        app.actions_dir.join("#{action.underscore}.rb")
      end
      def target_spec_path
        app.actions_spec_dir.join("#{action.underscore}.rb")
      end

      def write_to_file!
        write_action_file
        write_action_spec_file
      end

      def generate
        write_to_file!
      end

      ### USED BY THE TEMPLATE ###
      def requirements
        entities.keys.map{|e| %Q{require_relative "../entities/#{e}"}}
      end
      def spec_requirements
        [%Q{require_relative "#{target_path.relative_path_from target_spec_path.dirname}"}]
      end
      def initializer_jacks
        jacks.keys.join(", ")
      end
      def assigning_jacks
        jacks.keys.map{|k| "@#{k} = #{k}"}
      end

      #######
      private
      #######

      def write_action_file
        result = ErbRender.render(action_template, binding)
        to_file(result, target_path)
      end
      def write_action_spec_file
        result = ErbRender.render(spec_template, binding)
        to_file(result, target_spec_path)
      end

      def action_template
        @action_template ||= File.read(Pathname.new(__FILE__).parent.parent.join("obvious", "files", "generators", "action.rb.erb"))
      end
      def spec_template
        @spec_template ||= File.read(Pathname.new(__FILE__).parent.parent.join("obvious", "files", "generators", "action_spec.rb.erb"))
      end

      def parse_code
        @code.each do |entry|
          write_comments_for entry
          process_requirements_for entry if entry['requires']
        end
      end

      def write_comments_for entry
        @code_comments << %Q{# #{entry['c']}#{"\n# use: #{entry['requires']}" if entry['requires']}}
      end

      def process_requirements_for entry
        requires = entry['requires'].split ','

        requires.each do |req|
          klass, method = req.strip.split('.', 2)
          if jack? klass
            app.add_jack(klass, method)
          else
            app.add_entity(klass, method)
          end
        end
      end

      def jack? value
        value.include?("Jack")
      end
    end
  end
end