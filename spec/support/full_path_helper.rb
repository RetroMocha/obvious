require 'pathname'
module FullPathHelper
  def full_path_for(value)
    Pathname.new(value)
  end
end