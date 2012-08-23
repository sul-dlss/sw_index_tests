# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese: Word Breaks", :chinese => true, :fixme => true, :wordbreak => true do

  # cjk1 (indexUnigrams true, agenphraseq false)     searchworks-dev
  # cjk2 (indexUnigrams true, agenphraseq true)      searchworks-dev:3000
  # cjk3 (indexUnigrams false, agenphraseq false)   
  # cjk4 (as cjk1, but mm=2)         searchworks-dev:3001

  context " 妇女 (woman)  婚姻 (marriage)" do
    #  妇女婚姻 no spaces    
    #    symph: 12  parsed to  妇女 same  婚姻   (same means same field)
    #       9654720   woman 245a, 520a;  marriage 520a
    #       9229845   woman 245b, 246a;  marriage 245a
    #       8716123   woman 245a;  marriage unlinked520a 
    #       4401219   woman 245a;  marriage 245a
    #       4520813   woman 505a, 740a;  marriage 245a, 505a, 740a
    #       7808424   woman 245a, 246a;  marriage 245a, 246a
    #       4178814   woman 245a;  marriage 245a
    #       4222208   woman 245a, 490a, 830a;  marriage 245a
    #       4207254   woman 245c, 260a, 710a;  marriage 245a, 245c, 710b
    #       6201069   woman (as  婦女) 505a;  marriage 505a
    #       6696574   woman (as  婦女) 110a;  marriage 245a
    #       6343505   woman (as  婦女) 245a;  marriage 505a
    # 
    #  妇女 婚姻 space
    #   symph: 20  parsed to  妇女 and  婚姻
    #       9654720   woman 245a, 520a;  marriage 520a
    #       9229845   woman 245b, 246a;  marriage 245a
    #   NEW 8839221   woman 500a; marriage unlinked520a, 245a, 245a
    #       8716123   woman 245a;  marriage unlinked520a 
    #   NEW 8276633   woman 490a, 830a; marriage 245a
    #   NEW 8245869   woman (as 婦女) 490a, 830a; marriage 245a
    #       4401219   woman 245a;  marriage 245a 
    #       4520813   woman 505a, 740a;  marriage 245a, 505a, 740a
    #       7808424   woman 245a, 246a;  marriage 245a, 246a
    #       4178814   woman 245a;  marriage 245a
    #       4222208   woman 245a, 490a, 830a;  marriage 245a
    #   NEW 4220723   woman 260b; marriage 245b
    #   NEW 4205664   woman 260b; marriage 245a
    #       4207254   woman 245c, 260a, 710a;  marriage 245a, 245c, 710b 
    #       6201069   woman 505a (as  婦女);  marriage 505a
    #   NEW 6542987   woman (as 婦女) 260b, 710a; marriage 245a
    #       6696574   woman (as  婦女) 110a;  marriage 245a
    #   NEW 6543091   woman (as  婦女) 110a, 260b; marriage 245a
    #       6343505   woman (as  婦女) 245a;  marriage 505a
    #   NEW 6543322   woman (as  婦女) 245a, 260b, 500a; marriage 500a
    # 
    # 
    # cjk1 (indexUnigrams true, agenphraseq false)     searchworks-dev
    # cjk2 (indexUnigrams true, agenphraseq true)      searchworks-dev:3000
    # cjk3 (indexUnigrams false, agenphraseq false)   
    # cjk4 (as cjk1, but mm=2)       searchworks-dev:3001

    
    #  should our query be  (妇女 OR 婦女) AND 婚姻
    
    # 
    #   妇女婚姻 no spaces 
    #    cjk1: 679  (parsed  to   妇女  女婚  婚姻) 
    #       4222208   woman 245a, 490a, 830a;  marriage 245a
    #   NEW 7867225   woman 245a; marriage NONE 
    #       4401219   woman 245a;  marriage 245a
    #       4178814   woman 245a;  marriage 245a
    #   NEW 7109022   woman NONE; marriage NONE;  女婚 245a, 780t 
    #   NEW 8245647   woman NONE; marriage 245a;  女婚 NONE   
    #   NEW 8251782   woman NONE; marriage 245a;  女婚 NONE
    #   NEW 4190407   woman NONE; marriage 245a;  女婚 NONE    
    #   NEW 4207740   woman NONE; marriage 245a;  女婚 NONE
    #           ...
    # 
    #   妇女婚姻 no spaces
    #    cjk2: 0  (parsed to "妇女 女婚 婚姻")
    #    cjk3: 0  (parsed  to   妇女  女婚  婚姻)
    #    cjk4: 679  (parsed  to   妇女  女婚  婚姻) -- same as cjk1
    # 
    #  妇女 婚姻 space
    #    cjk1: 9   
    #       4222208   woman 245a, 490a, 830a;  marriage 245a
    #       9229845   woman 245b, 246a;  marriage 245a
    #       4401219   woman 245a;  marriage 245a 
    #       4178814   woman 245a;  marriage 245a
    #    !! 4200804   woman 245c, 710a;  marriage 245a, 710a  (not in symph:   245 first 3 chars 婚姻法 are indexed together)
    #       4207254   woman 245c, 260a, 710a;  marriage 245a, 245c, 710b 
    #       4520813   woman 505a, 740a;  marriage 245a, 505a, 740a
    #    !! 8276633   woman 490a, 830a; marriage 245a    (not in symph:  not in same field)
    #       7808424   woman 245a, 246a;  marriage 245a, 246a

    # 
    # phrase no spaces
    # phrase space
    # AND query
    # OR query
    # overlapping tokens ...   what if they didn't overlap and were ANDed
  end
  
  context " 婦女 (women)  與 (and)   文學 (literature)" do
    #  婦女與文學    has 17 hits in soc;  soc would put it in the 3 units
    #  婦女與文學    parses to  婦女 (women)  與 (and)   文學 (literature) 
    #   女與   (BC chars)  has no meaning
    #   與文   (CD chars)  has no meaning on its own
    
  end
  
  context " 婚姻法 (marriage law) in sirsi dict, but 婚姻 (marriage) is what we wanted" do
    
  end
  
  context "舊小說  unigram then bigram  " do
    # 舊 (old)  小說 (fiction)
    # symph title search 11 records
    # 
    # cjk1, 4 (no space) everything search 3102 records;   cjk2, 3  3 records
    # cjk1, 2, 3, 4  舊  小說  0 records
  end
  
  
  it "should parse out  妇女 (woman) 婚姻 (marriage)" do
    resp = solr_resp_doc_ids_only({'q'=>'妇女  婚姻'}) # 0 in prod, # 20 in soc, # 1 in cjk1
    # 9229845 terms are in title;  other 19 records in soc are relevant
    resp.should have_at_least(20).documents
    resp.size.should be_within(3).of(solr_resp_doc_ids_only({'q'=>'妇女婚姻'}).size) # 0 in prod, 12 in soc, 273 in cjk1
    #  top result in cjk1 has only 1 of the 2 words in the title
  end
  
  #  婦女與文學    has 17 hits in soc;  soc would put it in the 3 units
  #  婦女與文學    parses to  婦女 (women)  與 (and)   文學 (literature) 
  #   女與   (BC chars)  has no meaning
  #   與文   (CD chars)  has no meaning on its own
  
  
  # TODO:  two char terms.  three char terms.  longer terms.  phrase vs. non-phrase searching.
  # 
  # TODO  phrase searches for bigram pieces in query.   Tests for single last character, too.

#======
  it "FIXME   三國誌 should get the same results as simplified chars 三国志" do
    #  soc would do  三國  誌
    # 
    resp = solr_resp_doc_ids_only({'q'=>'三國誌'})  # 0 in prod, 242 in soc
    resp.should have_at_least(240).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'三国志'})) # 23 in prod, 242 in soc
  end

  # 中国地方志集成   breaks up to   中国  地方志   集成
  # 
  # 245  9206370  5 char in sub a   is 2 + 1 + 2
  # 
  # sirsi document:   people's republic of china

end