#require 'settings'
require "yaml"
require 'rsolr'

$LOAD_PATH.unshift(File.dirname(__FILE__))

RSpec.configure do |config|
  # FIXME:  hardcoded yml group
  solr_config = YAML::load_file('config/solr.yml')["test"]
  @@solr = RSolr.connect(solr_config)
  puts "Solr initialized with solr: #{@@solr.inspect}"
end

# send a GET request to the indicated Solr request handler with the indicated Solr parameters
# @param solr_params [Hash] the key/value pairs to be sent to Solr as HTTP parameters
# @param req_handler [String] the pathname of the desired Solr request handler 
# @return [RSpecSolr::SolrResponseHash] object for rspec-solr testing the Solr response 
def solr_response(solr_params, req_handler='select')  
  RSpecSolr::SolrResponseHash.new(@@solr.send_and_receive(req_handler, {:method => :get, :params => solr_params}))
end

