require_relative "base_generator"
module Obvious
  module Generators
    class DescriptorGenerator < BaseGenerator
      def initialize(argv=[])
        super(argv)
        app.dir = "."
        app.verify_valid_app!
        @name = argv[1]
        raise MissingVariable.new("Unable to generate Descriptor without a name variable") if @name.nil?
        @destination = app.descriptors_dir.join("#{@name}.yml")
      end
      def descriptor_name
        @name.camel_case
      end
      def generate
        result = render(template, {action: descriptor_name})
        puts "Building descriptor #{@destination}"
        to_file(result,  @destination)
        puts "Done"
      end

      #######
      private
      #######
      def render(template, variables={})
        ErbRender.render_from_hash(template, variables)
      end
      def template
        @template ||= File.read(Pathname.new(__FILE__).parent.parent.join("obvious", "files", "generators", "descriptor.yml.erb"))
      end
    end
  end
end