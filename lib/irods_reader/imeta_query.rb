class IrodsReader::ImetaQuery

  attr_reader :zone

  def initialize(type,zone,metadata)
    set_zone(zone)
    @type = type
    @metadata = metadata.map {|k,v| IrodsReader::Metadata.new(k,v)}
  end

  def set_zone(zone)
    raise IrodsReader::InvalidInput unless /^[A-z0-9]*$/===zone
    @zone = zone
  end
  private :set_zone

  def meta_string
    @metadata.map(&:query).join(' and ')
  end

  def query
    IrodsReader.command(%Q{imeta qu -z #{zone} -#{@type} #{meta_string}}).split("\n----\n")
  end

end
