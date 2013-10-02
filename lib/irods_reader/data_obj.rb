class IrodsReader::DataObj

  attr_reader :filename

  def self.find(zone,metadata)
    parse(IrodsReader::ImetaQuery.new('d',zone,metadata).query,metadata)
  end

  def self.parse(results,metadata)
    results.map {|result| IrodsReader::DataObj.new(Hash[*result.split(/: |\n/)],metadata) }
  end

  def initialize(query_result,metadata)
    @metadata = metadata.map {|k,v| IrodsReader::Metadata.new(k,v)}
    @filename = "#{query_result['collection']}/#{query_result['dataObj']}"
  end

  def metadata(attribute)
    @metadata_store ||= Hash.new {|h,k| h[k] = @metadata.detect {|m| m.attribute==k} }
    @metadata_store[attribute.to_s].value
  end

  def retrieve(target='-')
    IrodsReader::IgetQuery.new(filename,target).query
  end

end
