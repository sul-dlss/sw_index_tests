# encoding: utf-8

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

# send a GET request to the default Solr request handler with the indicated query
# @param query [String] the value of the 'q' param to be sent to Solr
# @return [RSpecSolr::SolrResponseHash] object for rspec-solr testing the Solr response, with no facets, and only the id and title_245a_display field for each Solr doc
def solr_resp_ids_titles_from_query(query)
  resp = solr_resp_ids_titles({'q'=> query})
end

# send a GET request to the default Solr request handler with the indicated query
# @param query [String] the value of the 'q' param to be sent to Solr
# @return [RSpecSolr::SolrResponseHash] object for rspec-solr testing the Solr response, with no facets, and only the id and title_full_display field for each Solr doc
def solr_resp_ids_full_titles_from_query(query)
  resp = solr_resp_ids_full_titles({'q'=> query})
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

# send a GET request to the default Solr request handler with the indicated Solr parameters
# @param solr_params [Hash] the key/value pairs to be sent to Solr as HTTP parameters, in addition to 
#  those to get only id fields and title_full_display and no facets in the response
# @return [RSpecSolr::SolrResponseHash] object for rspec-solr testing the Solr response, with no facets, and only the id and full title field for each Solr doc
def solr_resp_ids_full_titles(solr_params)
  solr_response(solr_params.merge(doc_ids_full_titles))
end

def author_search_args(query_str)
  {'q'=>"{!qf=$qf_author pf=$pf_author pf3=$pf_author3 pf2=$pf_author2}#{query_str}", 'qt'=>'search'}
end
def callnum_search_args(query_str)
  {'q'=>"#{query_str}", 'defType'=>'lucene', 'df'=>'callnum_search', 'qt'=>'search'}
end
def subject_search_args(query_str)
  {'q'=>"{!qf=$qf_subject pf=$pf_subject pf3=$pf_subject3 pf2=$pf_subject2}#{query_str}", 'qt'=>'search'}
end
def series_search_args(query_str)
  {'q'=>"{!qf=$qf_series pf=$pf_series pf3=$pf_series3 pf2=$pf_series2}#{query_str}", 'qt'=>'search'}
end
def title_search_args(query_str)
  {'q'=>"{!qf=$qf_title pf=$pf_title pf3=$pf_title3 pf2=$pf_title2}#{query_str}", 'qt'=>'search'}
end
def author_title_search_args(query_str)
  {'q'=>"{!qf=author_title_search pf='author_title_search^10' pf3='author_title_search^5' pf2='author_title_search^2'}#{query_str}", 'qt'=>'search'}
end


# if there are any CJK chars in str, return the number of CJK bigrams + CJK unigrams + non-CJK words in the str
# if there are no CJK chars in str, return nil
def cjk_bigram_tokens(str)
  num_uni = str.scan(/\p{Han}|\p{Katakana}|\p{Hiragana}|\p{Hangul}/).size
  if num_uni.nonzero?
    num_bi = 0
    (0..str.length-2).each { |i|
      num_bi += 1 if str[i,2].match(/(\p{Han}|\p{Katakana}|\p{Hiragana}|\p{Hangul}){2}/)
    }
    num_non_cjk = str.scan(/[[:alnum]]+/).size # this is tokens, not characters
    num_uni + num_bi + num_non_cjk
  else
    nil
  end
end

@@cjk_mm_val = '3<90%'
# NAOMI_MUST_COMMENT_THIS_METHOD
def cjk_mm_val
  @@cjk_mm_val
end
@@cjk_ps_val = 100
# NAOMI_MUST_COMMENT_THIS_METHOD
def cjk_ps_val
  @@cjk_ps_val
end

# NAOMI_MUST_COMMENT_THIS_METHOD
def cjk_mm_ps_params(str)
  num_uni = str.scan(/\p{Han}|\p{Katakana}|\p{Hiragana}|\p{Hangul}/).size
  if num_uni > 2
    {'mm' => @@cjk_mm_val, 'ps' => @@cjk_ps_val}
  else
    {}
  end
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
@@doc_ids_full_titles = {'fl'=>'id,title_full_display', 'facet'=>'false'}

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

# response documents will only have id and title_full_display fields, and there will be no facets in the response
# @return [Hash] Solr HTTP params to reduce the size of the Solr responses
def doc_ids_full_titles
  @@doc_ids_full_titles
end

def solr_schema
  @@schema_xml ||= @@solr.send_and_receive('admin/file/', {:method => :get, :params => {'file'=>'schema.xml', :wt=>'xml'}}) 
end

def solr_config_xml
  @@solrconfig_xml = @@solr.send_and_receive('admin/file/', {:method => :get, :params => {'file'=>'solrconfig.xml', :wt=>'xml'}}) 
end

