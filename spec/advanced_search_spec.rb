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
    it "subject (-congresses)", :fixme => true do
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
      resp.should have_at_least(800).results  # in situ, production
      # not true in Solr 3.6  or Solr 4.3 dismax
      resp.should have_at_most(900).results
    end
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