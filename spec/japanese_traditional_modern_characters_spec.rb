# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Japanese: Traditional and Modern Characters", :japanese => true do

  it "(bukkyogaku) Traditional chars 佛教學 should get the same results as simplified chars 仏教学" do
    resp = solr_resp_doc_ids_only({'q'=>'bukkyogaku'}) # 49 in prod
    resp.should have_at_least(40).documents
    resp.should have_at_most(60).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'佛教學'})) # 2 in prod, 279 in soc
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'仏教學'})) # 0 in prod, 46 in soc
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'佛教学'})) # 0 in prod, 279 in soc
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'佛教學'})) # 2 in prod, 279 in soc
  end
  
  it "(teikoku) Traditional chars 帝國 should get the same results as simplified chars 帝国" do
    resp = solr_resp_doc_ids_only({'q'=>'teikoku'}) # 1560 in prod, 1559 in soc
    resp.should have_at_least(1560).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'帝國'})) # 10 in prod, 1593 in prod
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'帝国'})) # 58 in prod, 1593 in prod
    # simplified  帝国  has some in Korean and Chinese ... is that wrong?
  end

end