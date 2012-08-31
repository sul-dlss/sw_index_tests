# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Japanese only variants of han characters", :japanese => true, :fixme => true do

  
#  近世仮名遣い論の研究
# cjk6ja   as title search,  38,900 results, but first one is excellent 7926218
# cjk8  as title search,  100,512 results, but first one is excellent
# cjk6cn (dict W pos filter) -  100,512 results, but first one is excellent
  
  
#  南満州鉄道株式会社
#    has 2 japanese-only variants of han characters   (2nd and 4th chars)
#   cjk6ja  as author seach   3967 results, 
#   南滿洲鐵道株式會社 < -- chars 2 and 4 in traditional han   32035 results <-- more matches b/c it also matches chinese
#       6359475   contributor matches
#   cjk8 chinese    6507  results,   first one good
# 
  context " 滿 and  鐵 are japanese-only variants for the han simplified  満 and  鉄  (南満州鉄道株式会社: The South Manchuria Railway Company)" do
    # Current SearchWorks results for these terms:
    #  minami manshu tetsudo kabushiki kaisha - 881
    #  南滿洲鐵道株式會社 - 509
    #  南満州鉄道株式会社 - 48
    #  南満州 - 0
    #  南満州鉄道 - 3
    #  満鉄 - 7

    it "南満州鉄道株式会社 (modern chars 2,4) should find 6359475" do
      resp = solr_resp_doc_ids_only({'q'=>'南満州鉄道株式会社', 'qt'=>'search_author'}) 
      resp.should include("6359475").in_first(3).results
    end

    it "南滿洲鐵道株式會社 (traditional chars 2,4) should also get the results for 南満州鉄道株式会社 (modern chars 2,4)" do
      resp = solr_resp_doc_ids_only({'q'=>'南滿洲鐵道株式會社', 'qt'=>'search_author'}) 
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'南満州鉄道株式会社'}, 'qt'=>'search_author'))
    end

    it "南滿洲鐵道株式會社 (traditional chars 2,4) should also get the results for 南満州鉄道株式会社 (modern chars 2,4)" do
      resp = solr_resp_doc_ids_only({'q'=>'南滿洲鐵道株式會社', 'qt'=>'search_author', 'rows'=>'1000'}) 
      resp.should include("6359475")
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'南満州鉄道株式会社'}, 'qt'=>'search_author'))
    end
    
    # TODO:  test all combos for chars 2 + 4  japanese-only variants vs. simplified 
    
    it "(The South Manchuria Railway Company) 南滿洲鐵道株式會社 should get the same results as 南満州鉄道株式会社" do
      #  滿 is traditional, 満 is the modern form; 鐵 is traditional, and 鉄 is the modern form)
      # (minami manshu tetsudo kabushiki kaisha) in latin?
      resp = solr_resp_doc_ids_only({'q'=>'南滿洲鐵道株式會社'}) # 513 in prod, 564 in soc
      resp.should have_at_least(881).documents
      resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'南満州鉄道株式会社'})) # 48 in prod, 52 in soc
    end
    
  end

end