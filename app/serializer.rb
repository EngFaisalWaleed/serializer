class Serializer
  class << self
    attr_reader :list
  end

  def self.object
    @@object
  end

  def self.attribute(attr, &block)
    @list ||= []

    list << (block_given? ? { key: attr, block: block } : attr)
  end

  def initialize(object)
    @@object = object
  end

  def serialize
    response = {}

    list.each do |attr|
      response[attr] = @@object.send(attr) if attr.instance_of?(Symbol)
      response[attr[:key]] = attr[:block].call if attr.instance_of?(Hash)
    end

    response
  end

  private

  def list
    self.class.list
  end
end
