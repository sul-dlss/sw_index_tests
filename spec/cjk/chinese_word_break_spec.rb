# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese: Word Breaks", :chinese => true, :fixme => true do
  # TODO:  query time parsing  vs.   index time parsing
  # 
  # phrase search of unigrams
  
  it "should parse out 中国 (china)  经济 （economic)  政策 (policy)" do
    resp = solr_resp_doc_ids_only({'q'=>'中国经济政策'}) # 88 in soc as of 2012-11
    resp.should have_at_least(85).documents
    resp.size.should be_within(5).of(solr_resp_doc_ids_only({'q'=>'中国  经济  政策'}).size) # 194 in soc as of 2012-11
  end

  # 中国 AND 国经 AND 经济 AND 济政 AND 政策   gets 6 results

  it "should parse out 中国 (china)  经济 （economic)  政策 (policy) - title search" do
    resp = solr_resp_doc_ids_only(title_search_args('中国经济政策')) # 51 in soc  as of 2012-11
    # 中国  经济  政策:  9 in cjk1:   1,2,4,5, 9 are good    6820329, 9154183, 6780057, 6782474 - two terms in title, one in series ... not as good as we hoped
    #   seem to be missing tons of results, possibly due to not doing whole index regen
    # what about " 中国  经济  政策"  as a phrase  vs.  not?  Does that address autoGeneratePhraseQueries?
    resp.should have_at_least(50).documents
    resp.should have_at_most(75).documents
    resp.size.should be_within(5).of(solr_resp_doc_ids_only(title_search_args('中国  经济  政策')).size) # 51 in soc as of 2012-11
    resp.should have_fewer_results_than(solr_resp_doc_ids_only({'q'=>'中国经济政策'})) # 88 in soc as of 2012-11
    # 
    # "中 国 经 济 政 策" cjk1 (indexUnigrams true, autogenphraseq false) - 0 results
    # "中 国 经 济 政 策" cjk2 (indexUnigrams true, autogenphraseq true) - 0 results
    # cjk3 (indexUnigrams false, autogenphraseq false)
  end
  
  it "should parse out  妇女 (woman) 婚姻 (marriage)" do
    resp = solr_resp_doc_ids_only({'q'=>'妇女  婚姻'}) # 20 in soc as of 2012-11
    # 9229845 terms are in title;  other 19 records in soc are relevant
    resp.should have_at_least(20).documents
    resp.size.should be_within(3).of(solr_resp_doc_ids_only({'q'=>'妇女婚姻'}).size) # 12 in soc as of 2012-11
  end
  
  #  婦女與文學    has 17 hits in soc;  soc would put it in the 3 units
  #  婦女與文學    parses to  婦女 (women)  與 (and)   文學 (literature) 
  #   女與   (BC chars)  has no meaning
  #   與文   (CD chars)  has no meaning on its own
  
  
  # TODO:  two char terms.  three char terms.  longer terms.  phrase vs. non-phrase searching.
  # 
  # TODO  phrase searches for bigram pieces in query.   Tests for single last character, too.

#======
  it "FIXME   三國誌 (three kingdoms) should get the same results as simplified chars 三国志" do
    #  soc would do  三國  誌
    # 
    resp = solr_resp_doc_ids_only({'q'=>'三國誌'})  # 242 in soc as of 2012-11
    resp.should have_at_least(240).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'三国志'})) # 242 in soc as of 2012-11
  end

  # 中国地方志集成   breaks up to   中国  地方志   集成
  # 
  # 245  9206370  5 char in sub a   is 2 + 1 + 2
  # 
  # sirsi document:   people's republic of china

end