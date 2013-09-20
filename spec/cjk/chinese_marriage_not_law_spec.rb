# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Chinese: Marriage NOT Marriage Law", :chinese => true do

  #  " 婚姻法 (marriage law) in sirsi dict, but 婚姻 (marriage) is what we wanted" 
  #   because sirsi dictionary approach does length-first matching  

  shared_examples_for "great results for woman marriage law" do |resp|
    # woman:
    #   traditional:  婦女
    #   simplified:  妇女
    # 
    # marriage law: 婚姻法
    # marriage: 婚姻   (same for both)
    # law: 法   (same for both)    
    
    # socrates:  4  as of 2013-08-13
    #   8722338   woman (trad) 505t (many) ; marriage law: 505t, 505t ; marriage: diff 505t (mult)
    #   4207254   woman (simp) 245c; 260b, 710a   marriage law:  245c, 710b;  marriage  245a
    #   4200804   woman (simp) 245c, 710a;  marriage law:  245a, 710a  (no other occurrence of marriage)
    #   6202487   woman (trad) 245c 260b, 710a;  marriage law:  245a, 500a, 710a  (no other occurrence of marriage)
    
    it "should have matches for simplified 'woman' and 'marriage law'" do
      resp.should include("4200804") # woman (simp) 245c, 710a;  marriage law:  245a, 710a  (no other occurrence of marriage)
      resp.should include("4207254") # woman (simp) 245c; 260b, 710a   marriage law:  245c, 710b;  marriage  245a
    end
    it "should have matches for traditional 'woman' and 'marriage law'" do
      resp.should include("8722338") # woman (trad) 505t (many) ; marriage law: 505t, 505t ; marriage: diff 505t (mult)
      resp.should include("6202487") # woman (trad) 245c 260b, 710a; marriage law:  245a, 500a, 710a  (no other occurrence of marriage)
      resp.should include("6543154") # woman (trad) 245a, 245c, 710a; marriage law 710t
      resp.should include("9956874") # woman (trad) 245a, 245c, 710a; marriage law 710t
    end
    it "should have matches for simplified 'woman' and 'marriage' and 'law' but not 'marriage law'" do
      resp.should include("4520813") # woman (simp) 505a, 740a ; marriage 245a, 505a, 740a;  law 245a, 260a, 505a, 740a
      resp.should include("8716123") # woman (simp) 520a, 245a ; marriage 520a; law 520a, 260b, 490a, 830a
    end
    it "should have matches for traditional 'woman' and 'marriage' and 'law' but not 'marriage law'" do
      resp.should include("9665009") # woman (trad) 505t (mult) ; marriage 505t (mult); law 505t
      resp.should include("9665014") # woman (trad) 505t (mult) ; marriage 505t (mult); law 505t, 520t
    end
  end
  
  context "妇女 婚姻 法 simplified woman/marriage/law WITH spaces" do
    it_behaves_like "great results for woman marriage law", solr_resp_ids_from_query("妇女 婚姻 法")
  end
  context "妇女婚姻法 simplified woman/marriage/law withOUT spaces" do
    it_behaves_like "great results for woman marriage law", solr_resp_ids_from_query("妇女婚姻法")
  end
  context "婦女 婚姻 法 traditional woman/marriage/law WITH spaces" do
    it_behaves_like "great results for woman marriage law", solr_resp_ids_from_query("婦女 婚姻 法")
  end
  context "婦女 婚姻 法 traditional woman/marriage/law withOUT spaces" do
    it_behaves_like "great results for woman marriage law", solr_resp_ids_from_query("婦女婚姻法")
  end
  
  # TODO:  phrase (with and without spaces)
  #   AND query
  #   OR query

end