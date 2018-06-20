class Azeroth::Model
  attr_reader :name

  def initialize(name)
    @name ||= name.to_s
  end

  def klass
    @klass ||= name.camelize.constantize
  end

  def plural
    name.pluralize
  end
end
