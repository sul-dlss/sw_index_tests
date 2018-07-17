# collection is indexed, it will be "sirsi" for MARC records, a druid for MODS, and a ckey for MODS with MARC collection records
# collection_type will only ever be the value "Digital Collection"

describe 'Managed purls' do
  context 'MARC digital collection records' do
    it 'should have collection_type value' do
      resp = solr_resp_doc_ids_only({'fq'=>'collection_type:("Digital Collection")', 'q' => 'collection:("sirsi")'})
      expect(resp.size).to be >= 200
    end
  end
  context 'MODS digital collection records' do
    it 'should have collection_type value' do
      resp = solr_resp_doc_ids_only({'fq'=>'collection_type:("Digital Collection")', 'q' => 'collection:(-sirsi)'})
      expect(resp.size).to be >= 175
    end
  end
end
