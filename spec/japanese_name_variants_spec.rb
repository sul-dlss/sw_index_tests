# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Japanese: variant chars for author, geographic place names, and subjects", :japanese => true do

  it "(minami manshu tetsudo kabushiki kaisha) 南滿洲鐵道株式會社 should get the same results as 満鉄" do
    # FIXME:  not right yet ...
    resp = solr_resp_doc_ids_only({'q'=>'ま南滿洲鐵道株式會社んが'}) # 513 in prod, 564 in soc
    resp.should have_at_least(560).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'minami manshu tetsudo kabushiki kaisha'})) # 969 in prod, 967 in soc
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'南滿洲鐵道株式會社'})) # 513 in prod, 564 in soc
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'南満州鉄道株式会社 '})) # 48 in prod, 52 in soc
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'南満州'})) # 0 in prod, 78 in soc
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'南満州鉄道'})) # 3 in prod, 54 in soc
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'満鉄'})) # 7 in prod, 156 in soc
  end
  
  it "(a name)  けいちゅう should get the results with author name  契沖" do
    resp2 = solr_resp_doc_ids_only({'q'=>'契沖', 'qt'=>'search_author'}) # 5 in prod, 5 in soc
    expected_results = ["6675613", "6675393", "7191966", "6274534", "4783602"]
    resp2.should include(expected_results)
    resp = solr_resp_doc_ids_only({'q'=>'けいちゅう'}) # 0 in prod, 1 in soc
    resp.should include(expected_results)  # has author name  契沖
  end

end