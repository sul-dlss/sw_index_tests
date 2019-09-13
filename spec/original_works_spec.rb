describe 'Original works relevancy ranking' do
  context 'Fred Vargas', jira: 'SW-1986', pending: :fixme do
    # we probably need a better solr field, like original and translated works, to support this
    it 'original works should be ranked above translated works' do
      resp = solr_resp_ids_uniform_titles(author_search_args('Vargas, Fred'))
      expect(resp).not_to include('title_uniform_display' => /.+/i).in_each_of_first(10).documents
    end
  end
end
