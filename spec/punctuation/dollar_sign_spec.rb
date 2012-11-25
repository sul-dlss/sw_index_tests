require 'spec_helper'

describe "dollar signs in queries" do
  
  it "socrates truncation symbol: 'byzantine figur$' should >= Socrates result quality", :jira => 'VUF-598' do
    resp = solr_resp_doc_ids_only(title_search_args('byzantine figur$')) 
    # these four have (stemmed) byzantine figure in the title
    resp.should include(["2440554", "3013697", "1498432", "5165378"]).in_first(5).results    
    # 7769264: title has only byzantine; 505t has "figural"
    resp.should include(["3013697", "1498432", "5165378"]).before("7769264")
    # 7096823 has "Byzantine" "figurine" in separate 505t subfields.  
    #   apparently "figurine" does not stem to the same word as "figure" - this is in stemming spec
#    resp.should include(["2440554", "3013697", "1498432", "5165378"]).before("7096823")
  end  
  
  # TODO: see VUF-663  minimalis$

end