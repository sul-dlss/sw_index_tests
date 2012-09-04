# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Japanese only variants of han characters", :japanese => true, :fixme => true do

#  近世仮名遣い論の研究 ???
# cjk6ja   as title search,  38,900 results, but first one is excellent 7926218
# cjk8  as title search,  100,512 results, but first one is excellent
# cjk6cn (dict W pos filter) -  100,512 results, but first one is excellent
  
  context " 満 (U+6E80) and 鉄 (U+9244) are Modern Japanese-only variants for traditional Han  滿 (U+6EFF) and 鐵 (U+9435)" do
    context "南満州鉄道株式会社: The South Manchuria Railway Company (chars 2 and 4)" do
      # Current SearchWorks results for these terms:
      #  minami manshu tetsudo kabushiki kaisha - 881
      #  南滿洲鐵道株式會社 - 509
      #  南満州鉄道株式会社 - 48
      #  南満州 - 0
      #  南満州鉄道 - 3
      #  満鉄 - 7
      # 
      #   南満州鉄道株式会社
      #    has 2 japanese-only variants of han characters   (2nd and 4th chars)
      #   cjk6ja  as author seach   3967 results, 
      #   南滿洲鐵道株式會社 < -- chars 2 and 4 in traditional han   32035 results <-- more matches b/c it also matches chinese
      #       6359475   contributor matches
      #   cjk8 chinese    6507  results,   first one good
      # 
      # Socrates:
      #   南 滿 洲 鐵 道株式會社 (traditional) author:  513 
      #   南 満 州 鉄 道株式会社 (japanese var) author:  46 
      #  minami manshu tetsudo kabushiki kaisha author:  900 
      # Searchworks:
      #  南滿洲鐵道株式會社  (trad)  author: 481 
      #  南満州鉄道株式会社 (mod) author: 17 results
      #  "minami manshu tetsudo kabushiki kaisha" author:  779 
      #   first 54 it is the entire corporate author string (?)
      
      
      before(:all) do
        @resp_mod = solr_resp_doc_ids_only({'q'=>'南満州鉄道株式会社', 'qt'=>'search_author'}) 
      end

      it "南満州鉄道株式会社 (modern chars - Japanese variants: 2,4) should get great search results" do
        i_haz_great_search_results(@resp_mod)
        puts @resp_mod.inspect
      end

      it "南滿洲鐵道株式會社 (traditional chars 2,4) should also get the results for 南満州鉄道株式会社 (modern chars 2,4)" do
        i_haz_great_search_results(solr_resp_doc_ids_only({'q'=>'南滿洲鐵道株式會社', 'qt'=>'search_author'})) 
      end
      
      it "char 2 traditional, char 4 modern:  南滿洲鉄道株式會社" do
        i_haz_great_search_results(solr_resp_doc_ids_only({'q'=>'南滿洲鉄道株式會社', 'qt'=>'search_author'}))
      end

      it "char 2 modern, char 4 traditional:  南満洲鐵道株式會社" do
        i_haz_great_search_results(solr_resp_doc_ids_only({'q'=>'南満洲鐵道株式會社', 'qt'=>'search_author'}))
      end

      # simplified Chinese version of these two characters are 满 (U+6EE1) and 铁 (U+94C1). These are used in Chinese and not Japanese.
      # we don't care about  南满洲铁道株式會社 (simplified (non-Japanese) chars 2,4) - a Japanese query wouldn't have it
      
      # convenience method to capture notion of great search results for  南満州鉄道株式会社: The South Manchuria Railway Company
      def i_haz_great_search_results(resp)
        resp.should include("6359475").in_first(3).results 
        resp.should have_the_same_number_of_results_as(@resp_mod)
        
        # TODO:  need regex
        # all initial results should have  "minami manshu tetsudo kabushiki kaisha" as author?  
      end

    end    
  end

end