describe "Stopwords such as 'the' 'a' 'or' should now work" do

  it "A Zukofsky", :jira => 'SW-501' do
    resp = solr_resp_doc_ids_only({'q'=>'A Zukofsky'})
    expect(resp).to include(["9082824", "1398728"]).in_first(20).results
  end

  it 'Zukofsky "A" (with quotes)', :jira => 'SW-501' do
    resp = solr_resp_doc_ids_only({'q'=>'"A" Zukofsky'})
    expect(resp).to include(["9082824", "1398728"]).in_first(20).results
  end

  it "Search for OR spektrum (must be with lowercase 'or', otherwise boolean without first clause)", :jira => 'SW-483' do
    resp = solr_resp_doc_ids_only({'q'=>'or spektrum'})
    expect(resp).to include("490100").in_first(3).results
    resp = solr_response({'q'=>'or spektrum', 'fq' => 'format_main_ssim:"Journal/Periodical"', 'fl' => 'id', 'facet' => 'false'})
    expect(resp).to include("490100").in_first(1).results
  end

  it "'to be or not to be' should get results", :jira => 'SW-613' do
    resp = solr_resp_doc_ids_only({'q'=>'to be or not to be'})
    expect(resp).to have_documents
  end

  it "'the one'", :jira => 'SW-613' do
    resp = solr_resp_doc_ids_only({'q'=>'the one'})
    expected = ['4805489', # video
                '10413330', # on order as of 2014-03
                '9171509', # book, sal
                '9583074', # book, music
                '6826825', # book, green
                # '9694740', # recording via aspresolver.com
                ]
    expect(resp).to include(expected).in_first(15).results
    expect(resp).not_to include("2860701").in_first(4) # "One"
  end

  it '"IT and Society"', :jira => 'SW-500' do
    resp = solr_resp_doc_ids_only({'q'=>'"IT and Society"'})
    expect(resp).to include("8167359").in_first(7).results
  end

  it '"IT *and* Society" defType=>lucene, description qf', :jira => 'SW-500', pending: ['fixme', 'used to work - data changed?'] do
    resp = solr_resp_doc_ids_only({'q'=>'{!qf=$qf_description pf=$qf_description pf3=$qf3_description pf2=$qf2_description}(IT and Society)', 'defType'=>'lucene'})
    expect(resp).to include("8167359").in_first(7).results
  end

  it '"IT *&* Society" defType=>lucene, description qf', :jira => 'SW-500', pending: ['fixme', 'used to work - data changed?'] do
    resp = solr_resp_doc_ids_only({'q'=>'{!qf=$qf_description pf=$qf_description pf3=$qf3_description pf2=$qf2_description}(IT & Society)', 'defType'=>'lucene'})
    expect(resp).to include("8167359").in_first(7).results
    resp = solr_resp_doc_ids_only({'q'=>'{!qf=$qf_description pf=$qf_description pf3=$qf3_description pf2=$qf2_description}(IT&Society)', 'defType'=>'lucene'})
    expect(resp).to include("8167359").in_first(7).results
  end

  it "query stopwords should not be dropped in subject searches", :jira => 'SW-372' do
    resp = solr_resp_doc_ids_only(subject_search_args('"Archaeology in literature"'))
    expect(resp).to include("8517619")
    expect(resp).not_to include(["8545853", "6653471"])
  end

end
