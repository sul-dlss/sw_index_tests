# this file is named aaa_blah so it executes first
describe "Output Solr Information from #{@@solr.uri}" do
  
  it "schema.xml retrieved from #{@@solr.uri}:\n#{solr_schema}", :fixme => 'true' do
    expect(solr_schema).not_to be_nil
  end

=begin  
  it "solrconfig.xml retrieved from #{@@solr.uri}:\n#{solr_config_xml}", :fixme => 'true' do
    solr_config_xml.should_not be_nil
  end
=end
  
end
