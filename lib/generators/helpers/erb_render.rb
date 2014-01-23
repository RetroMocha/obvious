require 'erb'
require 'ostruct'
require 'pathname'
require 'fileutils'
class ErbRender < OpenStruct
  class << self
    def render_from_hash(template, hash)
      ErbRender.new(hash).render_with_binding(template)
    end
    def render_to_file_from_hash(template, hash, path)
      ErbRender.new(hash).render_to_file(template, path)
    end
    def render_with_binding(template, binding)
      ErbRender.new().render_with_binding(template, binding)
    end
    alias :render :render_with_binding
  end

  def render_with_binding(template, binding=binding)
    ERB.new(template).result(binding)
  end
  alias :render :render_with_binding

  def render_to_file(template, path, binding=binding)
    path = Pathname.new(path)
    FileUtils.mkdir_p(path.dirname) unless path.dirname.exist?
    result = ERB.new(template).result(binding)
    File.open(path.expand_path, "wb") {|f|
      f.write(result)
    }
    result
  end
end