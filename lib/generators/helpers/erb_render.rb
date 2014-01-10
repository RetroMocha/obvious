require 'erb'
require 'ostruct'
class ErbRender < OpenStruct
  def self.render_from_hash(template, hash)
    ErbRender.new(hash).render(template)
  end

  def render(template)
    ERB.new(template).result(binding)
  end
end