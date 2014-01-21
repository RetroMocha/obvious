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
        check_destination!
      end
      def descriptor_name
        @name.camel_case
      end
      def generate
        result = render(template, action: descriptor_name)
        puts "Building descriptor #{@destination}"
        save_template_to_file(result)
        puts "Done"
      end

      #######
      private
      #######
      def check_destination!
        raise DescriptorFileExist.new("'#{@destination}' already exists, remove it before re-running this command") if File.exists? @destination
      end
      def render(template, variables={})
        ErbRender.render_from_hash(template, variables)
      end
      def template
        @template ||= File.read(Pathname.new(__FILE__).parent.parent.join("obvious", "files", "generators", "descriptor.yml.erb"))
      end
      def save_template_to_file(rendering)
        check_destination!
        File.open(@destination.expand_path, "wb") {|f|
          f.write(rendering)
        }
      end
    end
  end
end