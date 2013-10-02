class IrodsReader::IgetQuery

  def initialize(file_path,target)
    set_filename(file_path)
    @target = target
  end

  def set_filename(file_path)
    raise IrodsReader::InvalidInput unless /^[A-z0-9_\/\.]*$/===file_path
    @file_path = file_path
  end
  private :set_filename

  def query
    IrodsReader.command(%Q{iget #{@file_path} #{@target}})
  end

end
