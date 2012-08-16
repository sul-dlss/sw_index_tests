# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Japanese: Word Breaks", :japanese => true do

  it "query string  近世仮名遣い without spaces retrieves title  近世仮名  遣い論の研究  with spaces" do
    resp = solr_resp_doc_ids_only({'q'=>'近世仮名遣い'}) # 0 in prod, 1 in soc (7926218)
    resp.should include("7926218")  #  has title   近世仮名  遣い論の研究 
    resp.should have_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>' 近世仮名  遣い論の研究'})) # 0 in prod, 1 in soc
  end
  
  it "query string  釘貫 without spaces retrieves author name  釘  貫亨 with spaces" do
    resp = solr_resp_doc_ids_only({'q'=>'釘貫'}) # 0 in prod, 1 in soc (7926218)
    resp.should include("7926218")  #  has author   釘  貫亨 
    resp.should have_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>' 釘  貫亨'})) # 0 in prod, 1 in soc
  end
  
  it "shorter query string  近世仮名遣い should find match in string   近世仮名遣い論の研究  with no spaces" do
    resp = solr_resp_doc_ids_only({'q'=>'近世仮名遣い論の研究'}) # no word break:  1 in prod, 1 in soc 
    resp.should include("7926218") # _Kinsei kanazukairon no kenkyu_ by Kuginuki Toru
    resp2 = solr_resp_doc_ids_only({'q'=>'近世仮名遣い'}) # word break:  0 in prod, 1 in soc 
    resp2.should have_at_least(resp.size).documents
    resp2.should include("7926218")
  end
  
  it "shorter query string  釘貫 should find match in string  釘貫亨著 with no spaces" do
    resp = solr_resp_doc_ids_only({'q'=>'釘貫亨著'}) # 1 in prod, 1 in soc (7926218)
    resp.should include("7926218") # _Kinsei kanazukairon no kenkyu_ by Kuginuki Toru
    resp2 = solr_resp_doc_ids_only({'q'=>'釘貫亨'}) # 1 in prod, 1 in soc 
    resp.should have_at_least(resp.size).documents
    resp2.should include("7926218")
    resp3 = solr_resp_doc_ids_only({'q'=>'釘貫'}) # 0 in prod, 1 in soc 
    resp3.should have_at_least(resp2.size).documents
    resp3.should include("7926218")
  end
  
  it "word breaks for latin-ized japanese (kanazukairon)" do
    resp = solr_resp_doc_ids_only({'q'=>'Kinsei kanazukairon'}) # 1 in prod, 0 in soc
    resp.should include("7926218")
    resp2 = solr_resp_doc_ids_only({'q'=>'Kinsei kanazukai'})
    resp2.should have_at_least(resp.size).results  # 'Kinsei kanazukai'  also matches 6279261
    resp2.should include("7926218")
  end
    
end