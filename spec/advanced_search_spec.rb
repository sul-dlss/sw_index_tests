require 'spec_helper'

describe "advanced search" do
  context "street art OR graffiti", :jira => 'VUF-1013' do
    it "subject ((street art) OR graffiti OR mural)" do
      resp = solr_response({'q'=>"#{subject_query('(+street +art) OR graffiti OR mural')}"}.merge(solr_args))
      resp.should have_at_least(1000).results
      resp.should have_at_most(2000).results
    end
    it "keyword chicano" do
      resp = solr_response({'q'=>"#{description_query('+chicano')}"}.merge(solr_args))
      resp.should have_at_least(2300).results
      resp.should have_at_most(3000).results
    end
    it "subject ((street art) OR graffiti OR mural) and keyword chicano" do
      resp = solr_response({'q'=>"#{subject_query('(+street +art) OR graffiti OR mural')} AND #{description_query('+chicano')}"}.merge(solr_args))
      resp.should include(['3034294','525462','3120734','1356131','7746467'])
      resp.should have_at_most(10).results
    end
    # can't do quotes in a local params query
    it 'subject ("street art" OR graffiti OR mural) and keyword chicano', :fixme => true do
      resp = solr_response({'q'=>"#{subject_query('(+"street art") OR graffiti OR mural')} AND #{description_query('+chicano')}"}.merge(solr_args))
      resp.should include(['3034294','525462','3120734','1356131','7746467'])
      resp.should have_at_most(10).results
    end
  end
  
  context "subject -congresses, keyword IEEE xplore", :jira => 'SW-623' do
    it "subject -congresses" do
      # advanced qp currently doesn't support hyphen as NOT
      resp = solr_response({'q'=>"#{subject_query('(-congresses)')}"}.merge(solr_args))
      resp.should have_at_least(200000).results
    end
    it "subject NOT congresses" do
      resp = solr_response({'q'=>"NOT #{subject_query('congresses')}"}.merge(solr_args))
      resp.should have_at_least(200000).results
    end
    it "keyword IEEE xplore" do
      resp = solr_response({'q'=>"#{description_query('+IEEE +xplore')}"}.merge(solr_args))
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query("IEEE Xplore"))
      #  optional terms (no +)
      resp.should have_fewer_results_than(solr_response({'q'=>"#{description_query('IEEE xplore')}"}.merge(solr_args)))
      resp.should have_at_least(6000).results
      resp.should have_at_most(7250).results
    end
    it "subject NOT congresses and keyword IEEE xplore" do
      resp = solr_response({'q'=>"NOT #{subject_query('congresses')} AND #{description_query('+IEEE +xplore')}"}.merge(solr_args))
      resp.should have_at_least(800).results
      resp.should have_at_most(900).results
    end
  end
  
  context "subject home schooling, keyword Socialization", :jira => 'VUF-1352' do
    before(:all) do
      @sub_no_phrase = solr_response({'q'=>"#{subject_query('home schooling')}"}.merge(solr_args))
      @sub_phrase = solr_response({'q'=>"#{subject_query('"home schooling"')}"}.merge(solr_args))
    end
    it "subject home schooling" do
      @sub_phrase.should have_at_least(4500).results
      @sub_phrase.should have_at_most(6000).results
      @sub_no_phrase.should have_at_least(6000).results
      @sub_phrase.should have_fewer_results_than @sub_no_phrase
    end
    it "keyword Socialization" do
      resp = solr_response({'q'=>"#{description_query('+Socialization')}"}.merge(solr_args))
#      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query("Socialization"))
      #  optional single term (no +) same as required single term
      resp.should have_the_same_number_of_results_as(solr_response({'q'=>"#{description_query('Socialization')}"}.merge(solr_args)))
      resp.should have_at_least(400000).results
      resp.should have_at_most(500000).results
    end
    it "subject home schooling and keyword Socialization" do
      resp = solr_response({'q'=>"#{subject_query('"home schooling"')} AND #{description_query('+Socialization')}"}.merge(solr_args))
      resp.should have_fewer_results_than(@sub_no_phrase)
      resp.should have_at_least(1200).results
      resp.should have_at_most(1500).results
    end
  end
  
  context 'author phrase "Institute for Mathematical Studies in the Social Sciences"', :jira => 'VUF-1698' do
    before(:all) do
      @qterms = 'Institute for Mathematical Studies in the Social Sciences'
      @no_phrase = solr_response({'q'=>"#{author_query(@qterms)}"}.merge(solr_args))
      @phrase = solr_response({'q'=>"#{author_query('"' + @qterms + '"')}"}.merge(solr_args))
    end
    it "phrase compared to non-phrase" do
      @phrase.should have_at_least(750).results
      @phrase.should have_at_most(950).results
      @no_phrase.should have_at_least(900).results
      @phrase.should have_fewer_results_than @no_phrase
    end
    it "have the same number of results as a plain author query", :fixme => true do
      # not working because we use edismax???
      @no_phrase.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args(@qterms)))
      @phrase.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args('"' + @qterms + '"')))
    end
  end
    
  def author_query terms
    '_query_:"{!dismax qf=$qf_author pf=$pf_author pf3=$pf_author3 pf2=$pf_author2}' + terms + '"'
  end
  def subject_query terms
    '_query_:"{!dismax qf=$qf_subject pf=$pf_subject pf3=$pf_subject3 pf2=$pf_subject2}' + terms + '"'
  end
  def description_query terms
    '_query_:"{!dismax qf=$qf_description pf=$pf_description pf3=$pf_description3 pf2=$pf_description2}' + terms + '"'
  end
  def solr_args
    {"qt"=>"advanced"}.merge(doc_ids_only)
  end
end