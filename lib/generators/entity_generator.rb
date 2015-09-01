require_relative "base_generator"
module Obvious
  module Generators
    class EntityGenerator < BaseGenerator

      class EntityRenderHelper
        extend Forwardable
        def_delegators :@parent, :spec_requirements
        attr_reader :entity
        def initialize(entity, parent)
          @entity = entity
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
        app.entities_dir.join("#{name.to_s.underscore}.rb")
      end
      def target_spec_path(name)
        app.entities_spec_dir.join("#{name.to_s.underscore}_spec.rb")
      end

      def generate
        ensure_unique!
        entities.each do |entity, values|
          write_file_for(entity)
          write_file_for(entity, target_spec_path(entity), spec_template)
        end
      end

      ### USED BY THE TEMPLATE ###
      def requirements(entity)
      end
      def spec_requirements(entity)
        [%Q{require_relative "#{target_path(entity).relative_path_from(target_spec_path(entity).dirname).sub_ext('')}"}]
      end

      #######
      private
      #######

      def ensure_unique!
        entities.each do |key, values|
          values.uniq!
        end
      end

      def write_file_for(entity, path=target_path(entity), template=template)
        helper = EntityRenderHelper.new(entity.to_s.camel_case, self)
        result = ErbRender.new().render_to_file(template, path, helper.get_binding)
      end

      def template
        @template ||= File.read(Pathname.new(__FILE__).parent.parent.join("obvious", "files", "generators", "entity.rb.erb"))
      end
      def spec_template
        @spec_template ||= File.read(Pathname.new(__FILE__).parent.parent.join("obvious", "files", "generators", "entity_spec.rb.erb"))
      end
    end
  end
end