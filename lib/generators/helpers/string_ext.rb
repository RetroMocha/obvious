class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("- ", "_").
    downcase
  end
  def camel_case
    gsub(/[^\w\d\s\_]+/, "").gsub(/\s/, "_").split('_').map{|e| e.capitalize}.join
  end
end