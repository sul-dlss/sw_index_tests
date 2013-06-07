require 'spec_helper'

describe "journal/newspaper titles" do

  context "Nature" do
    it "as everything search", :jira => 'VUF-1515' do
      resp = solr_response({'q' => 'nature', 'fl'=>'id,title_display', 'facet'=>false})
      resp.should include({'title_display' => /^Nature \[print\/digital\]\./}).in_first(3)
    end

    it "as title search" do
      resp = solr_response(title_search_args('nature').merge({'fl'=>'id,title_display', 'facet'=>false}))
      resp.should include({'title_display' => /^Nature \[print\/digital\]\./}).in_first(3)
    end

    it "as title search with format journal" do
      resp = solr_response(title_search_args('nature').merge({'fq' => 'format:"Journal/Periodical"', 'fl'=>'id,title_display', 'facet'=>false}))
      resp.should have_at_most(1100).documents
      resp.should include({'title_display' => /^Nature \[print\/digital\]\./}).in_first(5)
      resp.should include({'title_display' => /^Nature; international journal of science/}).in_first(5)
    end
  end
  
  context "The Nation" do
    before(:all) do
      @green_current = 497417
      @green_micro = 464445
      @biz = 10039114
      @law = 3448713
    end
    
    it "as everything search", :edismax => true do
      resp = solr_resp_ids_from_query 'The Nation'
      resp.should include(['464445', '497417', '3448713']).in_first(4)
    end

    it "as title search", :fixme => true do
      resp = solr_response({'q'=>"{!qf=$qf_title pf=$pf_title}The Nation", 'fl'=>'id,title_245a_display', 'facet'=>false, 'qt'=>'search'})
#      resp = solr_resp_doc_ids_only(title_search_args('The Nation'))
      resp.should include({'title_245a_display' => /^The Nation$/i}).in_each_of_first(7)
      resp.should include(['464445', '497417', '3448713']).in_first(4)
    end

    it "as title search with format journal", :edismax => true do
#      resp = solr_resp_doc_ids_only(title_search_args('The Nation').merge({'fq' => 'format:Journal/Periodical'}))
      resp = solr_response({'q'=>"{!qf=$qf_title pf=$pf_title pf2=$pf_title}The Nation", 'fl'=>'id,title_245a_display', 'fq' => 'format:Journal/Periodical', 'facet'=>false, 'qt'=>'search'})
      resp.should include({'title_245a_display' => /^The Nation$/i}).in_each_of_first(7)
      resp.should include('3448713').in_first(3)
      resp.should include(['3448713', '497417']).in_first(5)
      resp.should include(['464445', '497417', '3448713']).in_first(7)
    end
  end
  
  
  shared_examples_for 'great search results' do | solr_params |
    it "exact title matches should be first" do
      orig_query_str = solr_params['q'].split('}').last
      resp = solr_resp_ids_titles(solr_params)
      resp.should include({'title_245a_display' => /^#{orig_query_str}$/i}).in_each_of_first(exp_ids.size)
      resp.should include(exp_ids).in_first(exp_ids.size + 2) # a little slop built in
    end
  end   

  shared_examples_for 'everything query, no format specified' do | title |
    it_behaves_like "great search results", {'q'=>title} 
  end   
  shared_examples_for 'everything query, format journal' do | title |
    it_behaves_like "great search results", {'q'=>title, 'fq'=>'format:Journal/Periodical'} 
  end
  shared_examples_for 'everything query, format newspaper' do | title |
    it_behaves_like "great search results", {'q'=>title, 'fq'=>'format:Newspaper'} 
  end

  shared_examples_for 'title query, no format specified' do | title |
    it_behaves_like "great search results", title_search_args(title) 
  end   
  shared_examples_for 'title query, format journal' do | title |
    it_behaves_like "great search results", title_search_args(title).merge({'fq'=>'format:Journal/Periodical'}) 
  end
  shared_examples_for 'title query, format newspaper' do | title |
    it_behaves_like "great search results", title_search_args(title).merge({'fq'=>'format:Newspaper'})
  end
  
  shared_examples_for 'great results for journal/newspaper' do | title|
    it_behaves_like "everything query, no format specified", title do
      let(:exp_ids) {all_formats}
    end
    it_behaves_like "everything query, format journal", title do
      let(:exp_ids) {journal_only}
    end
    it_behaves_like "everything query, format newspaper", title do
      let(:exp_ids) {newspaper_only}
    end
    it_behaves_like "title query, no format specified", title do
      let(:exp_ids) {all_formats}
    end
    it_behaves_like "title query, format journal", title do
      let(:exp_ids) {journal_only}
    end
    it_behaves_like "title query, format newspaper", title do
      let(:exp_ids) {newspaper_only}
    end
  end

  context "The Sentinel" do
    it_behaves_like "great results for journal/newspaper", "The Sentinel" do
      online = "8169876"  # 2044-6071, marcit brief record, type 'Other' as of 2013-06-06
      green_microfiche = '482015'  # 0586-9811
      green_microfilm = '485114'   # 0586-9811
      movie = '6559601'
      nigerian = '2920952'  
      texan = '4655100'
      movie2 = '5711017'
      image_online = '8146603'  # format 'Book'
      philippines = '388668'  # format 'Other'
      medical_online = '8436136'
      let(:all_formats) { [online, green_microfiche, green_microfilm, movie, nigerian, texan, movie2, image_online, philippines, medical_online] }
      let(:journal_only) { [green_microfiche, green_microfilm, nigerian, medical_online] }
      let(:newspaper_only) { [texan] }
    end
  end
  
  context "The Chronicle" do
    it_behaves_like "great results for journal/newspaper", "The Chronicle" do
      sal3_biz = "10044333"  # 0732-2038
      online = "8160954" # marcit brief record, type 'Other'
      online2 = "8533301" # marcit brief record, type 'Other', imprint APN News
      online3 = '8164657' # marcit brief record, type 'Other', imprint Goshen, NY
      online4 = '8160953'  # marcit brief record, type 'Other', imprint Centralia, WA
      ghana = '4694211'
      green_microfiche = '2506963' # Fed energy reg commis
      hebrew = '6501140'
      sal3_church = '356896' # imprint Poughkeepsie
      missionary = '385174' # london missionary society
      mannyng = '3372313'  # format 'Book'
      mannyng2 = '3376755'  # format 'Book'
      cairo = '448530' # am university at cairo
      hoover = '381532' # poughkeepsie
      cairo2 = '411229'
      let(:all_formats) { [sal3_biz, online, online2, online3, online4, ghana, green_microfiche, hebrew, sal3_church, missionary, mannyng, mannyng2, cairo2, hoover, cairo2] }
      let(:journal_only) { [sal3_biz, green_microfiche, hebrew, sal3_church] }
      let(:newspaper_only) { [ghana] }
    end
  end 
  

  it "'Times of London' - common words ... as a phrase  (it's actually a newspaper ...)" do
    resp = solr_resp_doc_ids_only(title_search_args('"Times of London"').merge({'fq' => 'format:Newspaper'}))
    resp.should include(['425948', '425951']).in_first(3)
  end
    
end