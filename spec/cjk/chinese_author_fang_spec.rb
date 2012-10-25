# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese Author Search (Fang, Baochuan)", :chinese => true, :fixme => true do

  shared_context "search tests" do
    shared_examples "great results" do
      describe do
        it "should get all the  方寶川 (traditional char) matches" do
          resp.should include(["5468624", "5482057", "5727562", "6650839", "9388854"]).in_first(10).results
        end
        it "should get all the 方宝川 (simplified char) matches" do
          resp.should include(["4160175"]).in_first(10).results
        end
        it "should get an appropriate number of documents" do
          resp.should have_at_least(6).documents
          resp.should have_at_most(15).documents
        end
        # 7 in soc
        #   9388854 - in 700a, 245c  trad
        #   6650839 - in 700a, 245c  trad
        #   5727562 - in 700a, 245c  trad
        #   5482057 - in 700a, 245c  trad
        #   8243512 - <-- Why does this match??
        #   5468624 - in 700a, 245c  trad
        #   4160175 - in 700a, 245c  simplified
        # 
        # cjk9a matches simplified and traditional separately
        #  AND
        # gets these for both
        # 1467632
    		# 1121907
    		# 1131798
    		# 6626069
    		# 6274452
    		# 1144876
    		# 146147
    		# 1130079
    		# 240893
    		# 579784
      end
    end
  end
  include_context "search tests"
  
  context "traditional  方寶川" do
    it_behaves_like "great results" do
      let (:resp) { solr_resp_doc_ids_only(author_search_args('方寶川')) }
    end
  end
  
  context "simplified  方宝川" do
    it_behaves_like "great results" do
      let (:resp) { solr_resp_doc_ids_only(author_search_args('方宝川')) }
    end
  end   
    
end