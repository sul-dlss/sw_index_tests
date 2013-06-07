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
  
  
#  shared_examples_for 'exact title matches should be first' do | solr_params |
#    it "a" do
#      resp = solr_resp_ids_titles(solr_params)
#      resp.should include({'title_245a_display' => /^#{title}$/i}).in_each_of_first(exp_ids.size)
#      resp.should include(exp_ids).in_first(exp_ids.size + 2) # a little slop built in
#    end
#  end   

  shared_examples_for 'everything query, no format specified' do | title |
    it "exact title matches should be first" do
      resp = solr_resp_ids_titles({'q'=> title})
      resp.should include({'title_245a_display' => /^#{title}$/i}).in_each_of_first(exp_ids.size)
      resp.should include(exp_ids).in_first(exp_ids.size + 2) # a little slop built in
    end
  end   
  shared_examples_for 'everything query, format journal' do | title |
    it "exact title matches should be first" do
      resp = solr_resp_ids_titles({'q'=> title, 'fq'=>'format:Journal/Periodical'})
      resp.should include({'title_245a_display' => /^#{title}$/i}).in_each_of_first(exp_ids.size)
      resp.should include(exp_ids).in_first(exp_ids.size + 2) # a little slop built in
    end
  end
  shared_examples_for 'everything query, format newspaper' do | title |
    it "exact title matches should be first" do
      resp = solr_resp_ids_titles({'q'=> title, 'fq'=>'format:Newspaper'})
      resp.should include({'title_245a_display' => /^#{title}$/i}).in_each_of_first(exp_ids.size)
      resp.should include(exp_ids).in_first(exp_ids.size + 2) # a little slop built in
    end
  end

#  shared_examples_for 'title query, no format specified' do | title |
#    it "exact title matches should be first" do
#      resp = solr_resp_ids_titles(title_search_args(title).merge{'fl'=>'id,title_245a_display', 'facet'=>false, 'qt'=>'search'})
#      resp.should include({'title_245a_display' => /^#{title}$/i}).in_each_of_first(exp_ids.size)
#      resp.should include(exp_ids).in_first(exp_ids.size + 2) # a little slop built in
#    end
#  end   
  
  
  context "The Sentinel" do
    context "with 'The'" do
      before (:all) do
        @online = "8169876"  # 2044-6071, marcit brief record, type 'Other' as of 2013-06-06
        @green_microfiche = '482015'  # 0586-9811
        @green_microfilm = '485114'   # 0586-9811
        @movie = '6559601'
        @nigerian = '2920952'  
        @texan = '4655100'
        @movie2 = '5711017'
        @image_online = '8146603'  # format 'Book'
        @philippines = '388668'  # format 'Other'
        @medical_online = '8436136'
        @all = [@online, @green_microfiche, @green_microfilm, @movie, @nigerian, @texan, @movie2, @image_online, @philippines, @medical_online]
        @journal = [@green_microfiche, @green_microfilm, @nigerian, @medical_online] 
        @newspaper = [@texan]
      end
      describe "everything search" do
#        it_behaves_like "exact title matches should be first" do
#          let(:solr_params) { {'q'=>title} }
#          let(:exp_ids) {@all}
#        end
        it_behaves_like "everything query, no format specified", "The Sentinel" do
          let(:exp_ids) {@all}
        end
        it_behaves_like "everything query, format journal", "The Sentinel" do
          let(:exp_ids) {@journal}
        end
        it_behaves_like "everything query, format newspaper", "The Sentinel" do
          let(:exp_ids) {@newspaper}
        end
      end 
      describe "title search" do
#        it_behaves_like "title query, no format specified", "The Sentinel" do
#          let(:exp_ids) {@all}
#        end
#        it_behaves_like "title query, format journal", "The Sentinel" do
#          let(:exp_ids) {@journal}
#        end
#        it_behaves_like "title query, format newspaper", "The Sentinel" do
#          let(:exp_ids) {@newspaper}
#        end
        it "no format specified" do
          resp = solr_response @solr_args_w_the
          resp.should include({'title_245a_display' => /^The Sentinel$/i}).in_each_of_first(@all.size)
          resp.should include(@all).in_first(@all.size + 2)
        end
        it "with format journal" do
          resp = solr_response @solr_args_w_the.merge({'fq'=>'format:Journal/Periodical'})
          resp.should include(@journal).in_first(@journal.size + 2)
          resp.should include({'title_245a_display' => /^The Sentinel$/i}).in_each_of_first(@journal.size)
        end
        it "with format newspaper" do
          resp = solr_response @solr_args_w_the.merge({'fq'=>'format:Newspaper'})
          resp.should include(@newspaper).in_first(@newspaper.size + 2)
          resp.should include({'title_245a_display' => /^The Sentinel$/i}).in_each_of_first(@newspaper.size)
        end
      end # title
    end # with 'The'
    context "without 'The'" do
      context "everything search" do
        before(:all) do
          @solr_args_wo_the = {'q'=>"Sentinel", 'fl'=>'id,title_245a_display', 'facet'=>false, 'qt'=>'search'}          
        end
        it "no format specified" do
          resp = solr_response @solr_args_wo_the
          resp.should include({'title_245a_display' => /^The Sentinel$/i}).in_each_of_first(@all.size)
          resp.should include(@all).in_first(@all.size + 2)
        end
        it "with format journal" do
          resp = solr_response @solr_args_wo_the.merge({'fq'=>'format:Journal/Periodical'})
          resp.should include(@journal).in_first(@journal.size + 2)
          resp.should include({'title_245a_display' => /^The Sentinel$/i}).in_each_of_first(@journal.size)
        end
        it "with format newspaper" do
          resp = solr_response @solr_args_wo_the.merge({'fq'=>'format:Newspaper'})
          resp.should include(@newspaper).in_first(@newspaper.size + 2)
          resp.should include({'title_245a_display' => /^The Sentinel$/i}).in_each_of_first(@newspaper.size)
        end
      end
      context "title search" do
        before(:all) do
          @solr_args_wo_the = title_search_args('Sentinel').merge({'fl'=>'id,title_245a_display', 'facet'=>false, 'qt'=>'search'})
        end
        it "no format specified" do
          resp = solr_response @solr_args_wo_the
          resp.should include({'title_245a_display' => /^The Sentinel$/i}).in_each_of_first(@all.size)
          resp.should include(@all).in_first(@all.size + 2)
        end
        it "with format journal" do
          resp = solr_response @solr_args_wo_the.merge({'fq'=>'format:Journal/Periodical'})
          resp.should include(@journal).in_first(@journal.size + 2)
          resp.should include({'title_245a_display' => /^The Sentinel$/i}).in_each_of_first(@journal.size)
        end
        it "with format newspaper" do
          resp = solr_response @solr_args_wo_the.merge({'fq'=>'format:Newspaper'})
          resp.should include(@newspaper).in_first(@newspaper.size + 2)
          resp.should include({'title_245a_display' => /^The Sentinel$/i}).in_each_of_first(@newspaper.size)
        end
      end # title
    end # without 'The'
  end # context  The Sentinel
  

  it "'Times of London' - common words ... as a phrase  (it's actually a newspaper ...)" do
    resp = solr_resp_doc_ids_only(title_search_args('"Times of London"').merge({'fq' => 'format:Newspaper'}))
    resp.should include(['425948', '425951']).in_first(3)
  end
    
end