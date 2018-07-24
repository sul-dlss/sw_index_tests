describe 'Greek script' do
  context 'alpha A α' do
    it 'α in και' do
      resp = solr_response('q' => 'και', 'fl' => 'id,vern_title_245a_display', fq: 'date_cataloged:*', 'facet' => false)
      expect(resp.size).to be >= 20
      expect(resp).to include('vern_title_245a_display' => /\bκαι\b/i).in_each_of_first(6).documents
      expect(resp).to include('7822463')
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only('q' => 'κΑι', fq: 'date_cataloged:*'))
    end
  end
  #  context "beta Β β" do
  context 'gamma Γ γ' do
    it 'Γ as author initial', icu: true do
      resp = solr_response(author_search_args('Γ').merge('fl' => 'id,vern_author_person_display', 'facet' => false))
      expect(resp.size).to be >= 2
      # the following is in the 2nd result with icu tokenization, or with that data  2013-05-20
      expect(resp).to include('vern_author_person_display' => /\bΓ\b/i).as_first
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args('γ')))
    end
  end
  context 'delta Δ δ' do
    it 'Δ as author initial' do
      resp = solr_response(author_search_args('Δ').merge('fl' => 'id,vern_author_person_display', 'facet' => false))
      expect(resp.size).to be >= 2
      expect(resp).to include('vern_author_person_display' => /\bΔ\b/i).in_first(2).documents
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args('δ')))
    end
  end
  #  context "epsilon Ε ε" do
  #  context "zeta Ζ ζ" do
  context 'eta Η η' do
    it 'Η as a word' do
      resp = solr_response('q' => 'Η', 'fl' => 'id,vern_title_full_display', 'facet' => false)
      expect(resp.size).to be >= 8
      #FIXME: resp.should include('vern_title_full_display' => /\bΗ\b/i).in_each_of_first(3).documents
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only('q' => 'η'))
    end
    it 'η in τη' do
      resp = solr_response('q' => 'τη', 'fl' => 'id,vern_title_full_display', 'facet' => false)
      expect(resp.size).to be >= 2
      expect(resp).to include('vern_title_full_display' => /\bτη\b/i).in_each_of_first(1).documents
      expect(resp).to include('7881455', '7881464')
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only('q' => 'τΗ'))
    end
  end
  context 'theta Θ θ' do
    it 'Θ in θεων' do
      resp = solr_response('q' => 'θεων', 'fl' => 'id,vern_title_full_display', 'facet' => false)
      expect(resp).to include('7881464')
      expect(resp).to include('vern_title_full_display' => /\bθεων\b/i).in_each_of_first(1).documents
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only('q' => 'θεων'))
    end
  end
  context 'iota Ι ι' do
    it 'ι in και' do
      resp = solr_response('q' => 'και', 'fl' => 'id,vern_title_245a_display', fq: 'date_cataloged:*', 'facet' => false)
      expect(resp.size).to be >= 20
      expect(resp).to include('vern_title_245a_display' => /\bκαι\b/i).in_each_of_first(6).documents
      expect(resp).to include('7822463')
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only('q' => 'καΙ', fq: 'date_cataloged:*'))
    end
  end
  context 'kappa Κ κ' do
    it 'κ in και' do
      resp = solr_response('q' => 'και', 'fl' => 'id,vern_title_245a_display', fq: 'date_cataloged:*', 'facet' => false)
      expect(resp.size).to be >= 20
      expect(resp).to include('vern_title_245a_display' => /\bκαι\b/i).in_each_of_first(6).documents
      expect(resp).to include('7822463')
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only('q' => 'Και', fq: 'date_cataloged:*'))
    end
  end
  context 'lambda Λ λ' do
    it 'Λ as author initial' do
      resp = solr_response(author_search_args('Λ').merge('fl' => 'id,vern_author_person_display', 'facet' => false))
      expect(resp.size).to be >= 2
      expect(resp).to include('vern_author_person_display' => /\bΛ\b/i).in_first(2).documents
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args('λ')))
    end
  end
  #  context "mu Μ μ" do
  #  context "nu Ν ν" do
  #  context "xi Ξ ξ" do
  #  context "omicron Ο ο" do
  context 'pi Π π' do
    it 'Π in Πατουρα' do
      resp = solr_response('q' => 'Πατουρα', 'fl' => 'id,vern_title_full_display', 'facet' => false)
      expect(resp).to include('7881455')
      expect(resp).to include('vern_title_full_display' => /\bΠατουρα\b/i).in_each_of_first(1).documents
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only('q' => 'πατουρα'))
    end
  end
  #  context "rho Ρ ρ" do
  #  context "sigma Σ σς" do
  context 'tau Τ τ' do
    it 'τ in στο' do
      resp = solr_response('q' => 'στο', 'fl' => 'id,vern_title_full_display', 'facet' => false)
      expect(resp.size).to be >= 3
      expect(resp).to include('vern_title_full_display' => /\bστο\b/i).in_each_of_first(3).documents
      expect(resp).to include('7881455')
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only('q' => 'σΤο'))
    end
  end
  #  context "upsilon Υ υ" do
  context 'phi Φ φ' do
    it 'Φ as author initial' do
      resp = solr_response(author_search_args('Φ').merge('fl' => 'id,vern_author_person_display', 'facet' => false))
      expect(resp).to include('7901590')
      expect(resp).to have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args('φ')))
    end
  end
  #  context "chi Χ χ" do
  #  context "psi Ψ ψ" do
  #  context "omega Ω ω" do

  it 'επιμελεια' do
    resp = solr_resp_doc_ids_only('q' => 'επιμελεια')
    expect(resp).to include(%w(8774108 7822463 7739251 7739278 7901590 8923317))
  end

  it 'εκδοσης' do
    resp = solr_resp_doc_ids_only('q' => 'εκδοσης')
    expect(resp).to include(%w(7822463 7739278))
  end

  it 'Βυζαντιο' do
    resp = solr_resp_doc_ids_only('q' => 'Βυζαντιο')
    expect(resp).to include(%w(7822463 7881455 7902361))
  end
end
