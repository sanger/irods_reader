class IrodsReader::Metadata

  attr_reader :attribute, :value, :unit

  def initialize(attribute,value,unit=nil)
    set_attribute(attribute)
    set_value(value)
    set_unit(unit)
  end

  def query
    "#{attribute} = '#{value}'"
  end

  private

  def set_attribute(attribute)
    raise IrodsReader::InvalidInput, "#{attribute} is not a valid attribute" unless /^[A-z0-9_]+$/===attribute.to_s
    @attribute = attribute.to_s
  end
  def set_value(value)
    raise IrodsReader::InvalidInput, "#{value} is not a valid value for #{attribute}" if /[;'""]/===value
    @value = value
  end
  def set_unit(unit)
    @unit = unit
  end
end
