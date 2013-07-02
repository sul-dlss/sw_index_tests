require 'spec_helper'

describe "advanced search" do
  context "street art OR graffit", :jira => 'VUF-1013' do
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