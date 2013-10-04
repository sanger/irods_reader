require 'irods_reader'
require 'spec_helper'
include SpecHelper

shared_examples "an illegal command" do
  it "raises an InvalidCommand exception" do
    expect { IrodsReader.command(expected_command) }.to raise_error(IrodsReader::InvalidCommand, 'Invalid input detected')
  end
end

describe IrodsReader do

  context "can mock commands" do

    let (:expected_command) { 'echo "testing"' }
    let (:expected_return)  { "mocked\n"}

    # include_examples "makes an irods request"

    it "sends bash commands" do
      should_talk_to_irods
      IrodsReader.command(expected_command).should eq(expected_return)
    end

  end

  context "non irods commands" do
    let (:expected_command) { 'echo "testing"' }
    it_behaves_like "an illegal command"
  end

  context "sneaky injection attempts" do
    let (:expected_command) { %Q{imeta -z test qu -d metaadata = 'val';echo 'boo'} }
    it_behaves_like "an illegal command"
  end

  context "another sneaky injection attempts" do
    let (:expected_command) { %Q{imeta -z test qu -d metaadata = 'val'|echo 'boo'} }
    it_behaves_like "an illegal command"
  end

  context "backtick injection attempts" do
    let (:expected_command) { %Q{imeta -z test qu -d metaadata = 'val`echo 'boo'`'} }
    it_behaves_like "an illegal command"
  end

end

describe IrodsReader::DataObj do

  shared_examples 'an irods find request' do
    it 'requests the relevant records' do
      should_talk_to_irods
      IrodsReader::DataObj.find(zone,metadata)
    end
  end

  shared_context 'with returned results' do
    let (:expected_return) {%Q{collection: /test/1000
dataObj: 1000_1.file
----
collection: /test/1000
dataObj: 1000_2.file
----
collection: /test/1000
dataObj: 1000_3.file
----
collection: /test/1000
dataObj: 1000_5.file
----
collection: /test/1000
dataObj: 1000_6.file
----
}}
    let (:expected_number_of_results) {5}
  end

  context 'with given zone and metadata' do

    let (:expected_command) { "imeta -z test qu -d metadata = 'value'" }
    let (:expected_return)  { '' }

    let (:zone)     { 'test' }
    let (:metadata) { {'metadata' => 'value'} }

    it_behaves_like 'an irods find request'

  end

  context 'with given zone and multiple metadata' do
    let (:expected_command) { "imeta -z test qu -d metadata = 'value' and other_metadata = 'value_2'" }
    let (:expected_return)  { '' }

    let (:zone)     { 'test' }
    let (:metadata) { {'metadata' => 'value', 'other_metadata' => 'value_2'} }

    it_behaves_like 'an irods find request'
  end

  context 'also accepts symbols' do
    let (:expected_command) { "imeta -z test qu -d metadata = 'value' and other_metadata = 'value_2'" }
    let (:expected_return)  { '' }

    let (:zone)     { 'test' }
    let (:metadata) { {:metadata => 'value', :other_metadata => 'value_2'} }

    it_behaves_like 'an irods find request'
  end

  context 'when receiving records' do

    let (:zone)     { 'test' }
    let (:metadata) { {:metadata => 'value', :other_metadata => 'value_2'} }

    include_context 'with returned results'

    it 'returns 5 irods results' do
      IrodsReader.should_receive(:command).and_return(expected_return)
      results = IrodsReader::DataObj.find(zone,metadata)
      results.count.should eq(expected_number_of_results)
      results.each do |result|
        expect(result).to be_an_instance_of(IrodsReader::DataObj)
      end
    end

    it 'populates records metadata' do
      IrodsReader.should_receive(:command).and_return(expected_return)
      results = IrodsReader::DataObj.find(zone,metadata)
      results.each do |result|
        result.metadata('metadata').should eq('value')
        result.metadata(:other_metadata).should eq('value_2')
      end
    end

    it 'sets the filename' do
      IrodsReader.should_receive(:command).and_return(expected_return)
      results = IrodsReader::DataObj.find(zone,metadata)
      results.first.filename.should eq('/test/1000/1000_1.file')
    end

  end

  context 'when no records are found' do
    let (:expected_command) { "imeta -z test qu -d metadata = 'value'" }
    let (:expected_return)  { "No rows found\n" }

    let (:zone)     { 'test' }
    let (:metadata) { {'metadata' => 'value' } }

    it 'returns an empty array' do
      should_talk_to_irods
      IrodsReader::DataObj.find(zone,metadata).should eq([])
    end

  end

  context 'an individual DataObj' do

    let (:collection) { '/test/1000' }
    let (:data_obj)   { '1000_1.file'}
    let (:metadata)   { []           }

    let (:expected_command) { 'iget /test/1000/1000_1.file -'}
    let (:expected_return)  { 'file_contents' }

    it 'should let us retrieve a file' do
      data_object = IrodsReader::DataObj.new(query_result,metadata)
      should_talk_to_irods
      data_object.retrieve.should eq(expected_return)
    end

  end

end

