module ApplicationStructure
  APPLICATION_DIR = "app"
  SPEC_DIR = "spec"
  DIRS = {
    descriptors: 'descriptors',
    app: APPLICATION_DIR,
    actions: "#{APPLICATION_DIR}/actions",
    contracts: "#{APPLICATION_DIR}/contracts",
    entities: "#{APPLICATION_DIR}/entities",
    spec: SPEC_DIR,
    actions_spec:"#{SPEC_DIR}/#{APPLICATION_DIR}/actions",
    contracts_spec:"#{SPEC_DIR}/#{APPLICATION_DIR}/contracts",
    entities_spec:"#{SPEC_DIR}/#{APPLICATION_DIR}/entities",
    support_doubles: "#{SPEC_DIR}/support/doubles"
  }
  module ClassMethods

  end

  module InstanceMethods
    DIRS.each do |name, location|
      define_method "#{name}_dir" do
        dir.join(DIRS[name])
      end
      define_method "create_#{name}_directory" do
        path = send("#{name}_dir").expand_path
        FileUtils.mkdir_p path unless File.exists?(path)
      end
    end
    def create_directories
      DIRS.each do |name, location|
        send("create_#{name}_directory")
      end
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end