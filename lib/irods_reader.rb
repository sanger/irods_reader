require "irods_reader/version"
require "irods_reader/metadata"
require "irods_reader/imeta_query"
require "irods_reader/iget_query"
require "irods_reader/data_obj"

module IrodsReader

  class InvalidCommand < StandardError; end
  class InvalidInput < StandardError; end
  class IrodsError < StandardError; end

  class << self
    def command(command)
      # Avoids the need of mocking the Kernal, and ensures use a single point of communication.
      raise InvalidCommand, 'Invalid input detected' unless valid?(command)
      `#{command}`.tap do |result|
        raise IrodsError, "iRods failed with code #{$?.stopsig}: #{result})" unless $?.success?
      end
    end

    def valid?(command)
      return false if /[;\n]/ === command
      /^imeta|iget/ === command
    end
    private :valid?
  end


end
