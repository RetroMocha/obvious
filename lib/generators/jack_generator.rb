require_relative "base_generator"
module Obvious
  module Generators
    class JackGenerator < BaseGenerator

      class JackRenderHelper
        extend Forwardable
        def_delegators :@parent, :spec_requirements, :requirements, :doubles_requirements, :has_input?
        attr_reader :jack, :jack_methods
        def initialize(jack, methods, parent)
          @jack = jack
          @jack_methods = methods
          @parent = parent
        end
        def get_binding
          binding
        end
      end

      def initialize()
        super([])
        app.dir = "."
        app.verify_valid_app!
      end

      def target_path(name)
        app.jacks_dir.join("#{name.to_s.underscore}_jack_contract.rb")
      end
      def entity_path(name)
        app.entities_dir.join("#{name.to_s.underscore}.rb")
      end
      def doubles_path(name)
        app.support_doubles_dir.join("#{name.to_s.underscore}_double.rb")
      end
      def target_spec_path(name)
        app.jacks_spec_dir.join("#{name.to_s.underscore}_jack_contract_spec.rb")
      end

      def generate
        ensure_unique!
        jacks.each do |jack, values|
          write_file_for(jack, values)
          write_file_for(jack, values, target_spec_path(jack), spec_template)
          write_file_for(jack, values, doubles_path(jack), doubles_template)
        end
      end

      ### USED BY THE TEMPLATE ###
      def requirements(jack)
        [%Q{require_relative "#{entity_path(jack).relative_path_from(target_path(jack).dirname).sub_ext('')}"}]
      end
      def spec_requirements(jack)
        [
          %Q{require_relative "#{target_path(jack).relative_path_from(target_spec_path(jack).dirname).sub_ext('')}"},
          %Q{require_relative "#{doubles_path(jack).relative_path_from(target_spec_path(jack).dirname).sub_ext('')}"}
        ]
      end
      def doubles_requirements(jack)
        [%Q{require_relative "#{target_path(jack).relative_path_from(doubles_path(jack).dirname).sub_ext('')}"},]
      end

      def has_input? method
        !(["list", "all"].include? method.to_s)
      end

      #######
      private
      #######

      def ensure_unique!
        jacks.each do |key, values|
          values.uniq!
        end
      end

      def write_file_for(jack, values, path=target_path(jack), template=template)
        helper = JackRenderHelper.new(jack.to_s.camel_case, values, self)
        ErbRender.new().render_to_file(template, path, helper.get_binding)
      end

      def template
        @template ||= File.read(Pathname.new(__FILE__).parent.parent.join("obvious", "files", "generators", "jack.rb.erb"))
      end
      def spec_template
        @spec_template ||= File.read(Pathname.new(__FILE__).parent.parent.join("obvious", "files", "generators", "jack_spec.rb.erb"))
      end
      def doubles_template
        @doubles_template ||= File.read(Pathname.new(__FILE__).parent.parent.join("obvious", "files", "generators", "double.rb.erb"))
      end

    end
  end
end
