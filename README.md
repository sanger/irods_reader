# IrodsReader

Provides an easy interface for interacting with the Sanger iRods service.

This gem provides a wrapper for the iRods command line interface. It is a fairly
minimal implementation, primarily designed for the retrieval of sequence information
from the Sanger iRods service.

## Installation

Add this line to your application's Gemfile:

    gem 'irods_reader'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install irods_reader

Ensure an iRods service is configured with appropriate permissions for the account under which your application is running.

## Usage

Find and retrieve iRods records:
records = IrodsReader::DataObj.find(zone,{:attribute=>value})

Retrieve the associated file:
records.first.retrieve

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
