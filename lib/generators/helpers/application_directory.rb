module ApplicationDirectory
  APPLICATION_DIR = "app"
  DIRS = {
    descriptors: 'descriptors',
    actions: "#{APPLICATION_DIR}/actions",
    contracts: "#{APPLICATION_DIR}/contracts",
    contracts: "#{APPLICATION_DIR}/contracts",
  }
  module ClassMethods

  end

  module InstanceMethods
    DIRS.each do |name, location|
      define_method "#{name}_dir" do
        dir.join(DIRS[name])
      end
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end