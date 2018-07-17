describe "Index Contents" do

  shared_examples_for 'collection has all its items' do | coll_val, min_num_exp |
    it "collection filter query should return enough results" do
      resp = solr_resp_doc_ids_only({'fq'=>"collection:#{coll_val}", 'rows'=>'0'})
      expect(resp.size).to be >= min_num_exp
    end
  end
  
  # note:  DOR collections have been moved to https://jenkinsqa.stanford.edu/view/SearchWorks/job/gdor-integration-tests/
  #    /afs/ir/dev/dlss/git/gryphondor/gdor-integration-tests.git  
  
  context "all MARC data from SIRSI (Symphony)" do
    it_behaves_like "collection has all its items", 'sirsi', 6950000
  end
    
end
