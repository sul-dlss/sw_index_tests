describe "callnum search" do

  context "LC" do
    it "M452" do
      resp = solr_resp_doc_ids_only(callnum_search_args('M452'))
      expect(resp.size).to be >= 3500
      expect(resp.size).to be <= 4125
    end

    it "DC314 .L92 A4 1872", :jira => 'VUF-1940' do
      resp = solr_resp_doc_ids_only(callnum_search_args('"DC314 .L92 A4 1872"'))
      expect(resp).to include('6425766').in_first(3)
    end
    it "DC314 .L92 A4", :jira => 'VUF-1940' do
      resp = solr_resp_doc_ids_only(callnum_search_args('"DC314 .L92 A4"'))
      expect(resp).to include('6425766').in_first(3)
    end
    it "DC314 .L92", :jira => 'VUF-1940' do
      resp = solr_resp_doc_ids_only(callnum_search_args('"DC314 .L92"'))
      expect(resp).to include('6425766').in_first(3)
    end

    it "QH185 .V", :jira => 'VUF-1882' do
      resp = solr_resp_doc_ids_only(callnum_search_args('"QH185 .V"'))
      expect(resp).to include('9087723').in_first(3)
      expect(resp.size).to be <= 3
    end
  end # context LC

  context "SPEC (special collections) call number" do
    it "M1437", :jira => 'SW-78' do
      resp = solr_resp_doc_ids_only(callnum_search_args('M1437'))
      expect(resp).to include('6972310')
    end
  end

  context "ALPHANUM" do
    it "ZDVD 12741", :jira => 'SW-436' do
      resp = solr_resp_doc_ids_only(callnum_search_args('"ZDVD 12741"'))
      expect(resp).to include('6635999').as_first
      expect(resp.size).to be <= 1
    end
    it "MFILM N.S. 3078", :jira => 'SW-1493' do
      resp = solr_resp_doc_ids_only(callnum_search_args('"MFILM N.S. 3078"'))
      expect(resp).to include('580114').as_first
      expect(resp.size).to be <= 1
    end
    it "ZCS ENG 57 TAPE", :jira => 'SW-436' do
      resp = solr_resp_doc_ids_only(callnum_search_args('"ZCS ENG 57 TAPE"'))
      expect(resp).to include('3440375').as_first
      expect(resp.size).to be <= 1
    end
  end

end
