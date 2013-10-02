module SpecHelper

  def should_talk_to_irods
    IrodsReader.should_receive(:command).with(expected_command).and_return(expected_return)
  end

  def query_result
    {
      'collection' => collection,
      'dataObj' => data_obj
    }
  end

end
