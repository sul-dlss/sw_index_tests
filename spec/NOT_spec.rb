require 'spec_helper'

describe "queries with NOT" do
  
  context "used to prohibit a clause" do
    before(:all) do
      @phrase_resp = solr_resp_ids_from_query('mark twain NOT "tom sawyer"')
    end
    it 'should work with quotes' do
      @phrase_resp.should have_at_least(1400).documents
    end
    it "should work with parens", :jira => 'VUF-379', :fixme => true do
      resp = solr_resp_ids_from_query('mark twain NOT (tom sawyer)')
      resp.should have_at_least(1400).documents
    end
    it "with parens inside quote" do
      resp = solr_resp_ids_from_query('mark twain NOT "(tom sawyer)"') # 0 documents
      resp.should have_at_least(1400).documents
      resp.should have_the_same_number_of_documents_as(@phrase_resp)
    end
    it "with parens outside quote", :fixme => true do
      resp = solr_resp_ids_from_query('mark twain NOT ("tom sawyer")') # 0 documents
      resp.should have_at_least(1400).documents
      resp.should have_the_same_number_of_documents_as(@phrase_resp)
    end
    it "with unmatched paren inside quotes" do
      @phrase_resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query('mark twain NOT "(tom sawyer"'))
      @phrase_resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query('mark twain NOT "tom( sawyer"'))
      @phrase_resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query('mark twain NOT "tom (sawyer"'))
      @phrase_resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query('mark twain NOT "tom sawyer("'))
      @phrase_resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query('mark twain NOT ")tom sawyer"'))
      @phrase_resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query('mark twain NOT "tom) sawyer"'))
      @phrase_resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query('mark twain NOT "tom )sawyer"'))
      @phrase_resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query('mark twain NOT "tom sawyer)"'))
    end
    it "with unmatched parent outside quote", :fixme => true do
      @phrase_resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query('mark twain NOT ("tom sawyer"'))
      @phrase_resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query('mark twain NOT "tom sawyer"('))
      @phrase_resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query('mark twain NOT )"tom sawyer"'))
      @phrase_resp.should have_the_same_number_of_documents_as(solr_resp_ids_from_query('mark twain NOT "tom sawyer")'))
    end
    it "with unmatched quote", :jira => 'VUF-379', :fixme => true do
      resp = solr_resp_ids_from_query('mark twain NOT "tom sawyer') # 0 documents
      resp = solr_resp_ids_from_query('mark twain NOT tom sawyer') # 0 documents
      resp.should have_at_least(1400).documents
    end
  end

end