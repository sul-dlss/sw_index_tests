# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Chinese: Women Marriage", :chinese => true, :fixme => true do

  # see also chinese_marriage_not_law spec for  women marriage law

  # woman:
  #   traditional:  婦女
  #   simplified:  妇女
  # 
  # marriage: 婚姻   (same for both)

  # Symphony:
  #  妇女婚姻 no spaces    
  #    SYMPH: 12  parsed to  妇女 same  婚姻   (same means same field)  2012-11
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
  #   SYMPH: 20  parsed to  妇女 and  婚姻     2012-11
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

  shared_examples_for "great results for woman marriage" do 
    it "should have matches for simplified 'woman' and 'marriage law'" do
      resp.should include("4200804") # woman (simp) 245c, 710a;  marriage law:  245a, 710a  (no other occurrence of marriage)
      resp.should include("4207254") # woman (simp) 245c; 260b, 710a   marriage law:  245c, 710b;  marriage  245a
    end
    it "should have matches for traditional 'woman' and 'marriage law'" do
      resp.should include("8722338") # woman (trad) 505t (many) ; marriage law: 505t, 505t ; marriage: diff 505t (mult)
# FIXME: 6202487, 6543154, 9956874 are not showing up on cjkbigram results without spaces  2013-08-13
#      resp.should include("6202487") # woman (trad) 245c 260b, 710a; marriage law:  245a, 500a, 710a  (no other occurrence of marriage)
#      resp.should include("6543154") # woman (trad) 245a, 245c, 710a; marriage law 710t
#      resp.should include("9956874") # woman (trad) 245a, 245c, 710a; marriage law 710t
    end
    it "should have matches for simplified 'woman' and 'marriage' and 'law' but not 'marriage law'" do
      resp.should include("4520813") # woman (simp) 505a, 740a ; marriage 245a, 505a, 740a;  law 245a, 260a, 505a, 740a
      resp.should include("8716123") # woman (simp) 520a, 245a ; marriage 520a; law 520a, 260b, 490a, 830a
    end
    it "should have matches for traditional 'woman' and 'marriage' and 'law' but not 'marriage law'" do
      resp.should include("9665009") # woman (trad) 505t (mult) ; marriage 505t (mult); law 505t
      resp.should include("9665014") # woman (trad) 505t (mult) ; marriage 505t (mult); law 505t, 520t
    end
    it "should have matches for simplified 'woman' and marrage, but not law" do
      resp.should include("9654720") # woman 245a, 520a;  marriage 520a
      resp.should include("9229845") # woman 245b, 246a;  marriage 245a
# FIXME
#      resp.should include("8839221") # woman 500a; marriage unlinked520a, 245a, 245a
#      resp.should include("8276633") # woman 490a, 830a; marriage 245a
      resp.should include("4401219") # woman 245a;  marriage 245a 
      resp.should include("7808424") # woman 245a, 246a;  marriage 245a, 246a
      resp.should include("4178814") # woman 245a;  marriage 245a
      resp.should include("4222208") # woman 245a, 490a, 830a;  marriage 245a
#      resp.should include("4220723") # woman 260b; marriage 245b
#      resp.should include("4205664") # woman 260b; marriage 245a
    end
    it "should have matches for traditional 'woman' and marrage, but not law", :fixme => true do
      resp.should include("8245869") # woman (as 婦女) 490a, 830a; marriage 245a
      resp.should include("6201069") # woman 505a (as  婦女);  marriage 505a
      resp.should include("6542987") # woman (as 婦女) 260b, 710a; marriage 245a
      resp.should include("6696574") # woman (as  婦女) 110a;  marriage 245a
      resp.should include("6543091") # woman (as  婦女) 110a, 260b; marriage 245a
      resp.should include("6343505") # woman (as  婦女) 245a;  marriage 505a
# FIXME
#      resp.should include("6543322") # woman (as  婦女) 245a, 260b, 500a; marriage 500a
    end
    it "should have a reasonable number of results with and without spaces", :fixme => true do
# FIXME:  16 results without spaces for cjkbigram  2013-08-13      
      resp.should have_at_least(20).documents
      resp.size.should be_within(3).of(solr_resp_ids_from_query('妇女 婚姻').size)
    end
    it "includes documents that have one term in a 245a and the other in a 5xx" do
      resp.should include(["9654720", "8716123", "6343505", "4520813"])
    end
    it "includes documents that have one term in 245a and other in a 260" do
      resp.should include(["6542987", "6543091"])
# FIXME:  not showing up on cjkbigram results       
#      resp.should include(["4220723", "4205664"])
    end
    it "includes documents that have one term in 245a and other in 490a, 830a" do
      resp.should include(["8276633", "8245869"])
    end
    it "includes other relevant documents" do
      resp.should include("6201069")
      resp.should include(["4207254", "6696574"])
# FIXME
#      resp.should include(["6543322"])
    end
    
  end # shared_examples_for  great results for woman marriage

  shared_examples "great title results for woman marriage" do
    # woman  妇女 (simp)  婦女 trad
    # marriage  婚姻   (same for both) 
    # socrates as of 2012-11
    #   9229845 - woman 245b, 246a; marriage 245a 
    #   4401219 - woman 245a; marriage 245a   (3 chars between)    <--  has women and marriage 
    #   7808424 - woman 245b, 246a; marriage 245b, 246a  (1 char between)
    #   4178814 - woman 245a; marriage 245a  (out of order w char between)
    #   4222208 - woman (simp) 245a, 490a, 830a; marriage 245a (1 char between)  <-- has women-and-marriage in 245a
    it "gets a reasonable number of results", :fixme => true do
      resp.should have_at_least(5).documents
      resp.should have_at_most(10).documents
    end
    it "ranks highest the documents with both words in 245a (though not adjacent)" do
# FIXME?
#      resp.should include(["4222208", "4401219", "4178814"]).in_first(3).results
      resp.should include(["4222208", "4401219", "4178814"]).in_first(4).results
    end
    it "ranks higher the documents with one word in 245a and the other in 245b" do
      resp.should include("9229845").in_first(4).results
    end
    it "ranks highish the documents with both words in 245b" do
      resp.should include(["7808424"]).in_first(5).results
    end
    it "should put the 245 title matches first", :fixme => true do
      resp.should include('6202487').in_first(7)
    end
  end


  context "妇女 婚姻 simplified woman/marriage WITH spaces" do
    before(:all) do
      @resp = solr_resp_doc_ids_only({'q'=>"妇女 婚姻", 'rows'=>'40'})
      @tresp = solr_resp_doc_ids_only(title_search_args("妇女 婚姻").merge({'rows'=>'40'}))
    end
    it_behaves_like "great results for woman marriage" do
      let (:resp) { @resp }
    end
    it_behaves_like "great title results for woman marriage" do
      let (:resp) { @resp }
    end
    it_behaves_like "great title results for woman marriage" do
      let (:resp) { @tresp }
    end
  end
  context "妇女婚姻 simplified woman/marriage withOUT spaces" do
    before(:all) do
      @resp = solr_resp_doc_ids_only({'q'=>"妇女婚姻", 'rows'=>'40'})
      @tresp = solr_resp_doc_ids_only(title_search_args("妇 婚姻").merge({'rows'=>'40'}))
    end
    it_behaves_like "great results for woman marriage" do
      let (:resp) { @resp }
    end
    it_behaves_like "great title results for woman marriage" do
      let (:resp) { @resp }
    end
    it_behaves_like "great title results for woman marriage" do
      let (:resp) { @tresp }
    end
  end
  context "婦女 婚姻 traditional woman/marriage WITH spaces" do
    before(:all) do
      @resp = solr_resp_doc_ids_only({'q'=>"婦女 婚姻", 'rows'=>'40'})
      @tresp = solr_resp_doc_ids_only(title_search_args("婦女 婚姻").merge({'rows'=>'40'}))
    end
    it_behaves_like "great results for woman marriage" do
      let (:resp) { @resp }
    end
    it_behaves_like "great title results for woman marriage" do
      let (:resp) { @resp }
    end
    it_behaves_like "great title results for woman marriage" do
      let (:resp) { @tresp }
    end
  end
  context "婦女婚姻 traditional woman/marriage withOUT spaces" do
    before(:all) do
      @resp = solr_resp_doc_ids_only({'q'=>"婦女婚姻", 'rows'=>'40'})
      @tresp = solr_resp_doc_ids_only(title_search_args("婦女婚姻").merge({'rows'=>'40'}))
    end
    it_behaves_like "great results for woman marriage" do
      let (:resp) { @resp }
    end
    it_behaves_like "great title results for woman marriage" do
      let (:resp) { @resp }
    end
    it_behaves_like "great title results for woman marriage" do
      let (:resp) { @tresp }
    end
  end
  
  # TODO:  phrase (with and without spaces)
  #   AND query
  #   OR query

end