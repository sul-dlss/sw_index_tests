require 'spec_helper'

describe "wildcards in queries" do
  
  it "socrates truncation symbol: 'byzantine figur$' should >= Socrates result quality", :jira => 'VUF-598' do
    resp = solr_resp_doc_ids_only(title_search_args('byzantine figur$')) 
    #  note:  Solr probably ignores the $  so it is the same as  
#    resp = solr_resp_doc_ids_only(title_search_args('byzantine figure')) 
#    resp = solr_resp_doc_ids_only(title_search_args('byzantine figur')) 

    # these four have (stemmed) byzantine figure in the title
    resp.should include(["2440554", "3013697", "1498432", "5165378"]).in_first(5).results    
    # 7769264: title has only byzantine; 505t has "figural"
    resp.should include(["3013697", "1498432", "5165378"]).before("7769264")
    # 7096823 has "Byzantine" "figurine" in separate 505t subfields.  
    #   apparently "figurine" does not stem to the same word as "figure" - this is in stemming spec
#    resp.should include(["2440554", "3013697", "1498432", "5165378"]).before("7096823")
  end  
    
  context "multi-char wildcard: *" do
    it "byzantine figur* should >= Socrates result quality", :jira => 'VUF-598' do
      resp = solr_resp_doc_ids_only(title_search_args('byzantine figur*'))
      resp.should include("3013697").as_first  # title_245a_display => "Byzantine figural processional crosses"      
      #  figur* occures before byzantine
      resp.should include("2440554").in_first(5).results # title_245a_display => "Figures byzantines ..."
      resp.should include("1498432").in_first(5).results # title_245a_display => "Proportion and structure of the human figure in Byzantine wall-painting and mosaic
      resp.should include("8000235") # title_245a_display => "(...) Figures (...) Byzantine (...)"
      resp.should include("5165378") # title_full_display => "Figure and likeness : on the limits of representation in Byzantine iconoclasm (...)"
      # all words not in 245
      resp.should include("7769264") # 7769264: title has only byzantine; 505t has "figural"
      resp.should include("7096823") # 7096823 has "Byzantine" "figurine" in separate 505t subfield 
      
      # $ is socrates truncation symbol
      resp2 = solr_resp_ids_titles(title_search_args('byzantine figur$'))
      resp3 = solr_resp_ids_titles(title_search_args('byzantine figure'))
      resp.should have_at_least(resp2.size).results
      resp.should have_at_least(resp3.size).results
    end 

    context "minimalis*", :jira => 'VUF-663' do
      it "everything" do
        resp = solr_resp_ids_from_query('minimalis*')
        resp.should have_at_least(250).results
      end
      it "title search" do
        resp = solr_resp_doc_ids_only(title_search_args('minimalis*'))
        resp.should have_at_least(150).results
      end
    end 
  end
  
#  context "single char wildcard: ?" do   
#  end
  
end