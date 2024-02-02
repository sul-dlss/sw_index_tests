describe "Index Contents" do
  context "all MARC data from FOLIO" do
    it "collection filter query should return enough results" do
      resp = solr_resp_doc_ids_only({'fq'=>"collection:folio", 'rows'=>'0'})
      expect(resp.size).to be >= 6950000
    end
  end
end
