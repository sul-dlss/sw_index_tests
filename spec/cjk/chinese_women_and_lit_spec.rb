# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'rspec-solr'

describe "Chinese: Women and Literature:  婦女 (women)  與 (and)   文學 (literature)", :chinese => true, :fixme => true, :wordbreak => true do
  # 婦女與文學  traditional  婦女  與  文學
  #   女與   (BC chars)  has no meaning
  #   與文   (CD chars)  has no meaning on its own
  # 妇女与文学  simplified   妇女  与  文学
  
  shared_context "results" do
    shared_examples "great search results in title for 妇女与文学" do
      describe do
        it "gets the traditional char title 245 matches" do
          # 婦女與文學  traditional  婦女  與  文學
          resp.should include(["6343505", "8246653"])  # as is in 245a - sole contents
          resp.should include(["8250645", "4724601", "6343719", "6343720"])  # as is in 245a  (but other chars too)
        end
        it "gets the simplified char title 245, 246 matches" do
          # 妇女与文学  simplified   妇女  与  文学
          #    8802530	simpl  lit then women in 245a, and in 245b
          #    7944106	simpl  women in 245a, and in 245a, lit 245a, but char between women and and:  妇女观与文学
          #    7833961	simpl  lit then women in 245a, other chars between
          #    5930857  simpl  women in  245b, 246a, other 246a;   lit in 245b, 246a, other 246a;   chars between
          resp.should include(["8802530", "7944106", "7833961", "5930857"])
        end
        it "ranks highest the documents with adjacent words in 245a" do
          resp.should include(["6343505", "8246653"]).in_first(3).results  # trad  as is in 245a - sole contents
          resp.should include(["8250645", "4724601", "6343719", "6343720"]).in_first(7).results  # trad as is in 245a  (but other chars too)
        end
        it "ranks very high the documents with both words in 245a but not adjacent" do
          #    7944106	simpl  women in 245a, and in 245a, lit 245a, but char between women and and:  妇女观与文学
          #    7833961	simpl  lit then women in 245a, other chars between
          resp.should include(["7944106", "7833961"]).in_first(10).results
        end
        it "ranks high the documents with words in 245b or 246a" do
          #    8802530	simpl  lit then women in 245a, and in 245b
          #    5930857  simpl  women in  245b, 246a, other 246a;   lit in 245b, 246a, other 246a;   chars between
          resp.should include(["8802530", "5930857"]).in_first(15).results
        end
        
      end # describe
    end # shared_examples  great search results in title for 婦女與文學
  end # shared_context results

  context "title search" do
    shared_context "ts" do
      shared_examples "great title search results for 妇女与文学" do
        describe do
          it "gets a reasonable number of results" do
            resp.should have_at_least(10).documents
            resp.should have_at_most(15).documents
          end
        end 
      end
    end
    include_context "results"
    include_context "ts"

    context "traditional  婦女與文學 no spaces" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'婦女與文學', 'qt'=>'search_title', 'rows'=>'25'})
      end
      # soc:                         11
      # cjk1 (bigrams):           6,723
      # cjk7 (unigrams only):   102,211
      # cjk6cn (chinese dict):   32,505  
      it_behaves_like "great search results in title for 妇女与文学" do
        let (:resp) { @resp }
      end
      it_behaves_like "great title search results for 妇女与文学" do
        let (:resp) { @resp }
      end
    end

    context "traditional  婦女 與 文學 (spaces)" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'婦女 與 文學', 'qt'=>'search_title', 'rows'=>'25'})
      end
      # title spaces  婦女 與 文學
      # soc:                    11
      # cjk1 (bigrams):          0
      # cjk7 (unigrams):        61
      # cjk6cn (chinese dict):  13
      it_behaves_like "great search results in title for 妇女与文学" do
        let (:resp) { @resp }
      end
      it_behaves_like "great title search results for 妇女与文学" do
        let (:resp) { @resp }
      end
    end
    
    context "simplified  妇女与文学 no spaces" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'妇女与文学', 'qt'=>'search_title', 'rows'=>'25'})
      end
      it_behaves_like "great search results in title for 妇女与文学" do
        let (:resp) { @resp }
      end
      it_behaves_like "great title search results for 妇女与文学" do
        let (:resp) { @resp }
      end
    end
    
    context "simplified  妇女 与 文学  with spaces" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'妇女 与 文学', 'qt'=>'search_title', 'rows'=>'25'})
      end
      it_behaves_like "great search results in title for 妇女与文学" do
        let (:resp) { @resp }
      end
      it_behaves_like "great title search results for 妇女与文学" do
        let (:resp) { @resp }
      end
    end
    
  end # context title search

  context "everything search" do
    shared_context "es" do
      shared_examples "great everything search results for 妇女与文学" do
        describe do
          it "gets a reasonable number of results" do
            resp.should have_at_least(15).documents
            resp.should have_at_most(30).documents
          end
          it "gets the traditional char 5xx matches" do
            #    8234101	trad found in the 505, but not together
            #  8925289  trad  lit, women in 505a, but not together
            resp.should include(["8234101", "8925289"]) 
          end
          it "gets the simplified char 5xx matches" do
            #  8705135  simpl  lit x2 in 520a, women x2 in 520a, not together
            #  8625928  simpl  women, lit in 520a, not together
            #  8336358  simpl  women  in  245b, 246a, 520a;  lit in 520a
            #  7925586  simpl  lit then women in 520, not together
            #  6192248  simpl  lit, then women  in 505, not together
            resp.should include(["8705135", "8625928", "8336358", "7925586", "6192248"]) 
          end
        end 
      end
    end
    include_context "es"

    context "traditional  婦女與文學 no spaces" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'婦女與文學', 'rows'=>'25'})
      end
      # soc:                        17 
      # cjk1 (bigrams):          7,201
      # cjk7 (unigrams):       117,716
      # cjk6cn (chinese dict):  34,601
      it_behaves_like "great search results in title for 妇女与文学" do
        let (:resp) { @resp }
      end
      it_behaves_like "great everything search results for 妇女与文学" do
        let (:resp) { @resp }
      end
    end

    context "traditional  婦女 與 文學 (spaces)" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'婦女 與 文學', 'rows'=>'25'})
      end
      # "婦女 與 文學 (spaces)
      # soc:                    21
      # cjk1 (bigrams):          0
      # cjk7 (unigrams):       107
      # cjk6cn (chinese dict):  15
      it_behaves_like "great search results in title for 妇女与文学" do
        let (:resp) { @resp }
      end
      it_behaves_like "great everything search results for 妇女与文学" do
        let (:resp) { @resp }
      end
    end
    
    context "simplified  妇女与文学 no spaces" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'妇女与文学', 'rows'=>'25'})
      end
      it_behaves_like "great search results in title for 妇女与文学" do
        let (:resp) { @resp }
      end
      it_behaves_like "great everything search results for 妇女与文学" do
        let (:resp) { @resp }
      end
    end
    
    context "simplified  妇女 与 文学  with spaces" do
      before(:all) do
        @resp = solr_resp_doc_ids_only({'q'=>'妇女 与 文学', 'qt'=>'search_title', 'rows'=>'25'})
      end
      it_behaves_like "great search results in title for 妇女与文学" do
        let (:resp) { @resp }
      end
      it_behaves_like "great title search results for 妇女与文学" do
        let (:resp) { @resp }
      end
    end
    
  end # context everything search

  # soc title:                            11
  #    8802530	simpl  lit then women in 245a, and in 245b
  #    8234101	trad found in the 505, but not together
  #    7944106	simpl  women in 245a, and in 245a, lit 245a, but char between women and and:  妇女观与文学
  #    7833961	simpl  lit then women in 245a, other chars between
  #    8250645	trad as is in 245a  (but other chars too)
  #    8246653	trad as is in 245a - sole contents
  #    5930857  simpl  women in  245b, 246a, other 246a;   lit in 245b, 246a, other 246a;   chars between
  #    4724601	trad as is in 245a  (but other chars too)
  #    6343719	trad as is in 245a  (but other chars too)
  #    6343505	trad as is in 245a - sole contents
  #    6343720	trad as is in 245a  (but other chars too)
  
  # soc everything:   17
  #  8925289  trad  lit, women in 505a, but not together
  #    8802530	simpl  lit then women in 245a, 3rd in 245b
  #  8705135  simpl  lit x2 in 520a, women x2 in 520a, not together
  #  8625928  simpl  women, lit in 520a, not together
  #  8336358  simpl  women  in  245b, 246a, 520a;  lit in 520a
  #    8234101	trad found in the 505, but not together
  #    7944106	simpl  women in 245a, and in 245a, lit 245a, but char between women and and:  妇女观与文学
  #  7925586  simpl  lit then women in 520, not together
  #    7833961	simpl  lit then women in 245a, other chars between
  #    8250645	trad as is in 245a  (but other chars too)
  #    8246653	trad as is in 245a - sole contents
  #    5930857  simpl  women in  245b, 246a, other 246a;   lit in 245b, 246a, other 246a;   chars between
  #    4724601	trad as is in 245a  (but other chars too)
  #  6192248  simpl  lit, then women  in 505, not together
  #    6343719	trad as is in 245a  (but other chars too)
  #    6343505	trad as is in 245a - sole contents
  #    6343720	trad as is in 245a  (but other chars too)
  # cjk1 (bigrams):         6,723
  # cjk7 (unigrams):      102,211
  # cjk6cn (chinese dict): 32,505  
  
end