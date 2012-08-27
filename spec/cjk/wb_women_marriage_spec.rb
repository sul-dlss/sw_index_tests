# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese: Word Breaks - Women Marriage", :chinese => true, :fixme => true, :wordbreak => true do

  # cjk1 (indexUnigrams true, agenphraseq false)     searchworks-dev
  # cjk2 (indexUnigrams true, agenphraseq true)      searchworks-dev:3000
  # cjk3 (indexUnigrams false, agenphraseq false)   
  # cjk4 (as cjk1, but mm=2)         
  # cjk5 (add CJKBigram filter to textNoStem, indexUnigrams true, agenphraseq false)   searchworks-dev:3001

  context " 妇女 (woman)  婚姻 (marriage)" do
    #   婦女  is traditional chars for woman
    
    #  妇女婚姻 no spaces    
    #    SYMPH: 12  parsed to  妇女 same  婚姻   (same means same field)
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
    #   SYMPH: 20  parsed to  妇女 and  婚姻
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
    #  妇女婚姻 no spaces 
    #    CJK1: 679  (parsed  to   妇女  女婚  婚姻) 
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
    #  妇女婚姻 no spaces
    #    cjk2: 0  (parsed to "妇女 女婚 婚姻" as phrase)
    #    cjk3: 0  (parsed  to   妇女  女婚  婚姻)
    #    cjk4: 679  (parsed  to   妇女  女婚  婚姻) -- same as cjk1
    #    cjk5: 0  (parsed to 妇女婚姻 even though agpq=false)
    # 
    #  婦女婚姻 no spaces - traditional char
    #    cjk1: 935 (parsed to  婦女  女婚  婚姻)
    #    cjk2: 0 (parsed to "婦女  女婚  婚姻" as phrase)
    #    cjk3: 0 (parsed to  婦女  女婚  婚姻)
    #    cjk4: 935 (parsed to  婦女  女婚  婚姻) -- same as cjk1
    #    cjk5: 0 (parsed to  婦女婚姻 even though agpq=false)
    # 
    #  妇女 婚姻 space
    #    cjk1: 9   (treated as 2 separate terms)
    #       4222208   woman 245a, 490a, 830a;  marriage 245a
    #       9229845   woman 245b, 246a;  marriage 245a
    #       4401219   woman 245a;  marriage 245a 
    #       4178814   woman 245a;  marriage 245a
    #  !!!  4200804   woman 245c, 710a;  marriage 245a, 710a  (not in symph:   245 first 3 chars 婚姻法 are indexed together)
    #       4207254   woman 245c, 260a, 710a;  marriage 245a, 245c, 710b 
    #       4520813   woman 505a, 740a;  marriage 245a, 505a, 740a
    #  !!!  8276633   woman 490a, 830a; marriage 245a    (not in symph:  not in same field)
    #       7808424   woman 245a, 246a;  marriage 245a, 246a
    # 
    #  妇女 婚姻 space
    #    cjk2: 9 (treated as 2 separate terms)
    #    cjk3: 0 (treated as 2 separate terms)
    #    cjk4:   (parsed to ) -- same as cjk1
    #    cjk5: 0 (treated as 2 separate terms)
    # 
    
    #  should our query be  (妇女 OR 婦女) AND 婚姻
    
    
    # phrase no space
    # phrase space
    # AND query - request handler needed
    # OR query
    # positionfilter ...
    # overlapping tokens ...   what if they didn't overlap and were ANDed
    
    # ultimately, traditional vs simplified chars, too.
    #  should our ideal query be  (妇女 OR 婦女) AND 婚姻
  end
    
  # cjk1 (indexUnigrams true, agenphraseq false)     searchworks-dev
  # cjk2 (indexUnigrams true, agenphraseq true)      searchworks-dev:3000
  # cjk3 (indexUnigrams false, agenphraseq false)   
  # cjk4 (as cjk1, but mm=2)       
  # cjk5 (add CJKBigram filter to textNoStem, indexUnigrams true, agenphraseq false)   searchworks-dev:3001
  
  it "should parse out  妇女 (woman) 婚姻 (marriage)" do
    resp = solr_resp_doc_ids_only({'q'=>'妇女  婚姻'}) # 0 in prod, # 20 in soc, # 1 in cjk1
    # 9229845 terms are in title;  other 19 records in soc are relevant
    resp.should have_at_least(20).documents
    resp.size.should be_within(3).of(solr_resp_doc_ids_only({'q'=>'妇女婚姻'}).size) # 0 in prod, 12 in soc, 273 in cjk1
    #  top result in cjk1 has only 1 of the 2 words in the title
  end
  

end