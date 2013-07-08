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
      # NOTE: advanced qp currently doesn't support hyphen as NOT
      resp = solr_response({'q'=>"#{subject_query('(-congresses)')}"}.merge(solr_args))
      resp.should have_at_least(200000).results
    end
    it "subject NOT congresses" do
      resp = solr_response({'q'=>"NOT #{subject_query('congresses')}"}.merge(solr_args))
      resp.should have_at_least(200000).results
    end
    it "keyword" do
      resp = solr_response({'q'=>"#{description_query('+IEEE +xplore')}"}.merge(solr_args))
      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query("IEEE Xplore"))
      resp.should have_at_least(6000).results
      resp.should have_at_most(7250).results
      #  optional terms (no +)
      resp.should have_fewer_results_than(solr_response({'q'=>"#{description_query('IEEE xplore')}"}.merge(solr_args)))
    end
    it "subject NOT congresses and keyword" do
      resp = solr_response({'q'=>"NOT #{subject_query('congresses')} AND #{description_query('+IEEE +xplore')}"}.merge(solr_args))
      resp.should have_at_least(800).results
      resp.should have_at_most(900).results
    end
  end
  
  context "subject home schooling, keyword Socialization", :jira => 'VUF-1352' do
    before(:all) do
      @sub_no_phrase = solr_response({'q'=>"#{subject_query('+home +schooling')}"}.merge(solr_args))
      # single term doesn't require +
      @sub_phrase = solr_response({'q'=>"#{subject_query('"home schooling"')}"}.merge(solr_args))
    end
    it "subject not as a phrase" do
      @sub_no_phrase.should have_at_least(575).results
      @sub_no_phrase.should have_at_most(650).results
      @sub_no_phrase.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args('home schooling')))
    end
    it "subject as a phrase", :fixme => true do
      # phrase searching doesn't work with advanced search (local params)
      @sub_phrase.should have_at_least(500).results
      @sub_phrase.should have_at_most(574).results
      @sub_phrase.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args('"home schooling"')))
      @sub_phrase.should have_fewer_results_than @sub_no_phrase
    end
    it "keyword" do
      resp = solr_response({'q'=>"#{description_query('+Socialization')}"}.merge(solr_args))
#      resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query("Socialization"))
      #  optional single term (no +) same as required single term
      resp.should have_the_same_number_of_results_as(solr_response({'q'=>"#{description_query('Socialization')}"}.merge(solr_args)))
      resp.should have_at_least(400000).results
      resp.should have_at_most(500000).results
    end
    it "subject not phrase and keyword" do
      #  optional single term (no +) same as required single term
      resp = solr_response({'q'=>"#{subject_query('+home +schooling')} AND #{description_query('Socialization')}"}.merge(solr_args))
      resp.should have_fewer_results_than(@sub_no_phrase)
      resp.should have_at_least(75).results
      resp.should have_at_most(150).results
    end
  end
  
  context 'author phrase "Institute for Mathematical Studies in the Social Sciences"', :jira => 'VUF-1698' do
    before(:all) do
      @qterms = 'Institute for Mathematical Studies in the Social Sciences'
      @no_phrase = solr_response({'q'=>"#{author_query('+Institute +for +Mathematical +Studies +in +the +Social +Sciences')}"}.merge(solr_args))
      #  optional single term (no +) same as required single term
      @phrase = solr_response({'q'=>"#{author_query('"Institute for Mathematical Studies in the Social Sciences"')}"}.merge(solr_args))
    end
    it "number of results with each term required, not as a phrase" do
      @no_phrase.should have_at_least(725).results
      @no_phrase.should have_at_most(800).results
    end
    it "number of results as a phrase", :fixme => true do
      # NOTE:  phrases aren't supposed to work with advanced search (local params)
      #    ?? phrase gets more due to allowed phrase slop?  long query, lots of common words
      @phrase.should have_at_least(900).results
      @phrase.should have_at_most(950).results
    end
    it "have the same number of results as a plain author query", :fixme => true do
      @no_phrase.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args(@qterms)))
      @phrase.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args('"' + @qterms + '"')))
    end
  end
  
  context "history man by malcolm bradbury", :jira => 'SW-805' do
    it "author malcolm bradbury" do
      resp = solr_response({'q'=>"#{author_query('+malcolm +bradbury')}"}.merge(solr_args))
      resp.should have_at_least(40).results
      resp.should have_at_most(60).results
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args('malcolm bradbury')))
    end
    it "title the history man" do
      resp = solr_response({'q'=>"#{title_query('+the +history +man')}"}.merge(solr_args))
      resp.should have_at_least(1200).results
      resp.should have_at_most(1300).results
    end
    it "author and title" do
      resp = solr_response({'q'=>"#{author_query('+malcolm +bradbury')} AND #{title_query('+the +history +man')}"}.merge(solr_args))
      resp.should include('1433520').as_first
      resp.should have_at_most(3).results
    end
  end
    
  def title_query terms
    '_query_:"{!dismax qf=$qf_title pf=$pf_title pf3=$pf_title3 pf2=$pf_title2}' + terms + '"'
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