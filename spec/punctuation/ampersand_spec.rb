require 'spec_helper'

describe "ampersands in queries" do

  shared_examples_for "ampersand ignored" do | q_with_amp, exp_ids, first_x |
    let(:q_no_amp) { q_with_amp.to_s.sub(' & ', ' ') }
    let(:resp) { solr_resp_ids_from_query(q_with_amp.to_s) }
    let(:presp) { solr_resp_ids_from_query("\"#{q_with_amp}\"") }
    let(:tresp) { solr_resp_doc_ids_only(title_search_args(q_with_amp)) }
    let(:ptresp) { solr_resp_doc_ids_only(title_search_args("\"#{q_with_amp}\"")) }
    it "should have great results for query" do
      expect(resp).to include(exp_ids).in_first(first_x).documents
      expect(presp).to include(exp_ids).in_first(first_x).documents
      expect(tresp).to include(exp_ids).in_first(first_x).documents
      expect(ptresp).to include(exp_ids).in_first(first_x).documents
    end
    it "should ignore ampersand in everything searches" do
      expect(resp).to have_the_same_number_of_documents_as(solr_resp_ids_from_query(q_no_amp))
    end
    it "should ignore ampersand in everything phrase searches" do
      expect(presp).to have_the_same_number_of_documents_as(solr_resp_ids_from_query("\"#{q_no_amp}\""))
    end
    it "should ignore ampersand in title searches" do
      expect(tresp).to have_the_same_number_of_documents_as(solr_resp_doc_ids_only(title_search_args(q_no_amp)))
    end
    it "should ignore ampersand in title phrase searches" do
      expect(ptresp).to have_the_same_number_of_documents_as(solr_resp_doc_ids_only(title_search_args("\"#{q_no_amp}\"")))
    end
  end

  context "2 term query 'Bandits & Bureaucrats'", :jira => 'VUF-831' do
    it_behaves_like "ampersand ignored", "Bandits & Bureaucrats", "2972993", 1
  end

  context "2 term query 'time & money'" do
    it_behaves_like "ampersand ignored", "time & money", "3042571", 2
  end

  context "3 term query 'of time & place' (former stopword 'of')" do
    it_behaves_like "ampersand ignored", "of time & place", "2186298", 3
    it_behaves_like "ampersand ignored", "of time & place", ["2186298", "9348274"], 6
  end

  context "3 term query 'ESRI data & maps'", :jira=>'SW-85' do
    it_behaves_like "ampersand ignored", "ESRI data & maps", ["5468146", "4244185", "5412572", "5412597", "4798829", "4554456", "7652136", "5675395", "6738945", "5958512"], 15
  end

  context "3 term query 'Crystal growth & design'", :jira=>'VUF-1057' do
    it_behaves_like "ampersand ignored", "Crystal growth & design", "4371266", 1
  end

  context "3 term query 'Fish & Shellfish Immunology'", :jira=>'VUF-1100' do
    it_behaves_like "ampersand ignored", "Fish & Shellfish Immunology", "2405684", 3
  end

  context "3 term query 'Environmental Science & Technology'", :jira=>'VUF-1150' do
    it_behaves_like "ampersand ignored", "Environmental Science & Technology", "2956046", 1
  end

  context "4 term query title search 'horn violin & piano'" do
    it_behaves_like "ampersand ignored", "horn violin & piano", ["2209617", "3395922"], 10
  end

  context "4 term query 'crosby stills nash & young'" do
    it_behaves_like "ampersand ignored", "crosby stills nash & young", "5627798", 10
  end

  context "4 term query 'steam boat & canal routes'" do
    # there's a bunch of relevant SDR objects that pop up.
    it_behaves_like "ampersand ignored", "steam boat & canal routes", "10451543", 15
  end

  context "5 term query 'horns, violins, viola, cello & organ'" do
    it_behaves_like "ampersand ignored", "horns, violins, viola, cello & organ", "6438612", 1
  end

  context "5 term query 'the truth about cats & dogs' (former stopword 'the')" do
    it_behaves_like "ampersand ignored", "the truth about cats & dogs", "5646609", 1
  end

  context "5 term query 'anatomy of the dog & cat' (former stopwords 'of', 'the')" do
    it_behaves_like "ampersand ignored", "anatomy of the dog & cat", "3324413", 1
  end

  context "6 term query 'horns, violins, viola, cello & organ continuo'" do
    it_behaves_like "ampersand ignored", "horns, violins, viola, cello & organ continuo", "6438612", 1
  end

  context "6 term query 'Dr. Seuss & Mr. Geisel : a biography' (former stopword 'a')" do
    it_behaves_like "ampersand ignored", "Dr. Seuss & Mr. Geisel : a biography", "2997769", 1
  end

  context "6 term query 'Zen & the Art of Motorcycle Maintenance' (former stopwords 'of', 'the')" do
    it_behaves_like "ampersand ignored", "Zen & the Art of Motorcycle Maintenance", ["1464048", "524822"], 5
  end

  context "7 term query 'Practical legal problems in music & recording industry' (former stopword 'in')" do
    it_behaves_like "ampersand ignored", "Practical legal problems in music & recording industry", "1804064", 1
  end

  context "multiple ampersands: 'Bob & Carol & Ted & Alice'" do
    it_behaves_like "ampersand ignored", "Bob & Carol & Ted & Alice", "5742243", 1
  end

end
