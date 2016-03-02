# encoding: utf-8

require 'spec_helper'

describe "wildcards in queries" do
  
  context "multi-char wildcard: *" do
    # (see also dollar sign in non_alpha_chars spec)
    it "byzantine figur* should >= Socrates result quality", :jira => 'VUF-598' do
      resp = solr_resp_doc_ids_only(title_search_args 'byzantine figur*')
      expect(resp).to include("3013697").as_first  # title_245a_display => "Byzantine figural processional crosses"      
      #  figur* occures before byzantine
      expect(resp).to include("2440554").in_first(6).results # title_245a_display => "Figures byzantines ..."
      expect(resp).to include("1498432").in_first(6).results # title_245a_display => "Proportion and structure of the human figure in Byzantine wall-painting and mosaic
      expect(resp).to include("8000235") # title_245a_display => "(...) Figures (...) Byzantine (...)"
      expect(resp).to include("5165378") # title_full_display => "Figure and likeness : on the limits of representation in Byzantine iconoclasm (...)"
      # all words not in 245
      expect(resp).to include("1423711") # Byzantine in 245a, 650a, figura in 490a and 830a
      expect(resp).to include("7769264") # 7769264: title has only byzantine; 505t has "figural"
      expect(resp).to include("7096823") # 7096823 has "Byzantine" "figurine" in separate 505t subfield 
      # $ is socrates truncation symbol
      resp2 = solr_resp_ids_titles(title_search_args 'byzantine figur$')
      resp3 = solr_resp_ids_titles(title_search_args 'byzantine figure')
      expect(resp.size).to be >= resp2.size
      expect(resp.size).to be >= resp3.size
    end 

    context "minimalis*", :jira => 'SW-937' do
      it "everything" do
        resp = solr_resp_ids_from_query 'minimalis*'
        expect(resp.size).to be >= 250
      end
      it "title search" do
        resp = solr_resp_doc_ids_only(title_search_args 'minimalis*')
        expect(resp.size).to be >= 150
      end
    end
    
    it "толст* should have results", :jira => 'SW-203' do
      resp = solr_resp_ids_from_query 'толст*'
      expect(resp.size).to be >= 100
    end

    it "asterix as query '*'" do
      # dismax:  returns 0 results
      # edismax:  returns all documents  (or timeout error?)
      resp = solr_resp_ids_from_query '*'  
      expect(resp.size).to be >= 6900000
    end    
  end
  
  context "single char wildcard: ?" do   
    it "толсто? should have results", :jira => 'SW-203' do
      resp = solr_resp_ids_from_query 'толсто?'
      expect(resp.size).to be >= 50
    end
    
    it "question mark as query '?'" do
      # dismax or icu tokenizer:  one result  (4085436)
      # edismax:  all documents
      resp = solr_resp_ids_from_query '?' # '?' 
      expect(resp.size).to be >= 6900000
    end
  end
  
end