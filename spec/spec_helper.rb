require "yaml"
require 'rsolr'

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec-solr'

RSpec.configure do |config|
  baseurl = ENV["URL"]
  if baseurl
    solr_config = {:url => baseurl}
  else
    yml_group = ENV["YML_GROUP"] ||= 'test'
    solr_config = YAML::load_file('config/solr.yml')[yml_group]
  end
  @@solr = RSolr.connect(solr_config)
  puts "Solr URL: #{@@solr.uri}"
end

# send a GET request to the default Solr request handler with the indicated query
# @param query [String] the value of the 'q' param to be sent to Solr
# @return [RSpecSolr::SolrResponseHash] object for rspec-solr testing the Solr response, with no facets, and only the id field for each Solr doc
def solr_resp_ids_from_query(query)
  resp = solr_resp_doc_ids_only({'q'=> query})
end

# send a GET request to the default Solr request handler with the indicated Solr parameters
# @param solr_params [Hash] the key/value pairs to be sent to Solr as HTTP parameters, in addition to 
#  those to get only id fields and no facets in the response
# @return [RSpecSolr::SolrResponseHash] object for rspec-solr testing the Solr response, with no facets, and only the id field for each Solr doc
def solr_resp_doc_ids_only(solr_params)
  solr_response(solr_params.merge(doc_ids_only))
end

# send a GET request to the default Solr request handler with the indicated Solr parameters
# @param solr_params [Hash] the key/value pairs to be sent to Solr as HTTP parameters, in addition to 
#  those to get only id fields and title_245a_display and no facets in the response
# @return [RSpecSolr::SolrResponseHash] object for rspec-solr testing the Solr response, with no facets, and only the id and short title field for each Solr doc
def solr_resp_ids_titles(solr_params)
  solr_response(solr_params.merge(doc_ids_short_titles))
end

def author_search_args(query_str)
  {'q'=>"{!qf=$qf_author pf=$pf_author pf2=$pf_author2 pf3=$pf_author3}#{query_str}", 'qt'=>'search'}
end
def callnum_search_args(query_str)
  {'q'=>"#{query_str}", 'defType'=>'lucene', 'df'=>'callnum_search', 'qt'=>'search'}
end
def subject_search_args(query_str)
  {'q'=>"{!qf=$qf_subject pf=$pf_subject pf2=$pf_subject2 pf3=$pf_subject3}#{query_str}", 'qt'=>'search'}
end
def series_search_args(query_str)
  {'q'=>"{!qf=$qf_series pf=$pf_series pf2=$pf_series2 pf3=$pf_series3}#{query_str}", 'qt'=>'search'}
end
def title_search_args(query_str)
  {'q'=>"{!qf=$qf_title pf=$pf_title pf2=$pf_title2 pf3=$pf_title3}#{query_str}", 'qt'=>'search'}
end
def author_title_search_args(query_str)
  {'q'=>"{!qf=author_title_search pf='author_title_search^10' pf2='author_title_search^20' pf3='author_title_search^30'}\"#{query_str}\"", 'qt'=>'search'}
end

private

# send a GET request to the indicated Solr request handler with the indicated Solr parameters
# @param solr_params [Hash] the key/value pairs to be sent to Solr as HTTP parameters
# @param req_handler [String] the pathname of the desired Solr request handler (defaults to 'select') 
# @return [RSpecSolr::SolrResponseHash] object for rspec-solr testing the Solr response 
def solr_response(solr_params, req_handler='select')  
  RSpecSolr::SolrResponseHash.new(@@solr.send_and_receive(req_handler, {:method => :get, :params => solr_params.merge("testing"=>"sw_index_test")}))
end

# use these Solr HTTP params to reduce the size of the Solr responses
# response documents will only have id fields, and there will be no facets in the response
@@doc_ids_only = {'fl'=>'id', 'facet'=>'false'}
@@doc_ids_short_titles = {'fl'=>'id,title_245a_display', 'facet'=>'false'}

# response documents will only have id fields, and there will be no facets in the response
# @return [Hash] Solr HTTP params to reduce the size of the Solr responses
def doc_ids_only
  @@doc_ids_only
end

# response documents will only have id and title_245a_display fields, and there will be no facets in the response
# @return [Hash] Solr HTTP params to reduce the size of the Solr responses
def doc_ids_short_titles
  @@doc_ids_short_titles
end

def solr_schema
  @@schema_xml ||= @@solr.send_and_receive('admin/file/', {:method => :get, :params => {'file'=>'schema.xml', :wt=>'xml'}}) 
end

def solr_config_xml
  @@solrconfig_xml = @@solr.send_and_receive('admin/file/', {:method => :get, :params => {'file'=>'solrconfig.xml', :wt=>'xml'}}) 
end

