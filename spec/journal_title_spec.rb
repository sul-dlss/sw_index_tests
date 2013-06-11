require 'spec_helper'

describe "journal/newspaper titles" do

# -------   shared example groups --------
  
  shared_examples_for 'great search results' do | solr_params |
    it "exact title matches should be first" do
      orig_query_str = solr_params['q'].split('}').last
      resp = solr_resp_ids_titles(solr_params)
      resp.should include({'title_245a_display' => /^#{orig_query_str}\W*$/i}).in_each_of_first(exp_ids.size)
      resp.should include(exp_ids).in_first(exp_ids.size + 2) # a little slop built in
    end
  end   

  shared_examples_for 'everything query, no format specified' do | title, solr_params |
    my_params = {'q'=>title}
    my_params.merge!(solr_params) if solr_params
    it_behaves_like "great search results", my_params 
  end   
  shared_examples_for 'everything query, format journal' do | title, solr_params |
    my_params = {'q'=>title, 'fq'=>'format:Journal/Periodical'}
    my_params.merge!(solr_params) if solr_params
    it_behaves_like "great search results", my_params
  end
  shared_examples_for 'everything query, format newspaper' do | title, solr_params |
    my_params = {'q'=>title, 'fq'=>'format:Newspaper'}
    my_params.merge!(solr_params) if solr_params
    it_behaves_like "great search results", my_params
  end

  shared_examples_for 'title query, no format specified' do | title, solr_params |
    my_params = title_search_args(title) 
    my_params.merge!(solr_params) if solr_params
    it_behaves_like "great search results", my_params
  end   
  shared_examples_for 'title query, format journal' do | title, solr_params |
    my_params = title_search_args(title).merge({'fq'=>'format:Journal/Periodical'})
    my_params.merge!(solr_params) if solr_params
    it_behaves_like "great search results", my_params
  end
  shared_examples_for 'title query, format newspaper' do | title, solr_params |
    my_params = title_search_args(title).merge({'fq'=>'format:Newspaper'})
    my_params.merge!(solr_params) if solr_params
    it_behaves_like "great search results", my_params
  end
  
  shared_examples_for 'great results for format journal' do | title, solr_params |
    it_behaves_like "everything query, format journal", title, solr_params do
      let(:exp_ids) {journal_only}
    end
    it_behaves_like "title query, format journal", title, solr_params do
      let(:exp_ids) {journal_only}
    end
  end
  
  shared_examples_for 'great results for format newspaper' do | title, solr_params |
    it_behaves_like "everything query, format newspaper", title, solr_params do
      let(:exp_ids) {newspaper_only}
    end
    it_behaves_like "title query, format newspaper", title, solr_params do
      let(:exp_ids) {newspaper_only}
    end
  end
  
  
  shared_examples_for 'great results for journal/newspaper' do | title, solr_params |
    it_behaves_like "everything query, no format specified", title, solr_params do
      let(:exp_ids) {all_formats}
    end
    it_behaves_like "title query, no format specified", title, solr_params do
      let(:exp_ids) {all_formats}
    end
    it_behaves_like "great results for format journal", title, solr_params do
      let(:exp_ids) {journal_only}
    end
    it_behaves_like "great results for format newspaper", title, solr_params do
      let(:exp_ids) {newspaper_only}
    end
  end

  shared_examples_for 'good results for journal/newspaper' do | title, solr_params |
    it_behaves_like "great results for format journal", title, solr_params do
      let(:exp_ids) {journal_only}
    end
    it_behaves_like "great results for format newspaper", title, solr_params do
      let(:exp_ids) {newspaper_only}
    end
  end

# -------   actual tests --------

  context "The Nation" do
# -- OLD tests    
    before(:all) do
      @green_current = '497417'
      @green_micro = '464445'
      @biz = '10039114'
      @law = '3448713'
      @orig = [@green_micro, @green_current, @law]
    end

    it "as everything search", :edismax => true do
      resp = solr_resp_ids_from_query 'The Nation'
      resp.should include(@orig).in_first(4)
    end

    it "as title search", :fixme => true do
      resp = solr_response({'q'=>"{!qf=$qf_title pf=$pf_title}The Nation", 'fl'=>'id,title_245a_display', 'facet'=>false, 'qt'=>'search'})
#      resp = solr_resp_doc_ids_only(title_search_args('The Nation'))
      resp.should include({'title_245a_display' => /^The Nation$/i}).in_each_of_first(7)
      resp.should include(@orig).in_first(4)
    end

    it "as title search with format journal", :edismax => true do
#      resp = solr_resp_doc_ids_only(title_search_args('The Nation').merge({'fq' => 'format:Journal/Periodical'}))
      resp = solr_response({'q'=>"{!qf=$qf_title pf=$pf_title pf2=$pf_title}The Nation", 'fl'=>'id,title_245a_display', 'fq' => 'format:Journal/Periodical', 'facet'=>false, 'qt'=>'search'})
      resp.should include({'title_245a_display' => /^The Nation$/i}).in_each_of_first(7)
      resp.should include(@law).in_first(3)
      resp.should include([@law, @green_current]).in_first(5)
      resp.should include(@orig).in_first(7)
    end
# -- end OLD tests

    # split out to allow us to fine tune the fixmes
    it_behaves_like "great results for format newspaper", "The Nation" do
      news = [ '8217400', # malawi, green mfilm
              '4772643', # malawi, sal
              '2833546', # liberia, sal newark
              ]
      let(:newspaper_only) { news }
    end
    it_behaves_like "great results for format journal", "The Nation" do
      journal = [ '497417', # green current
                  '464445', # green micro 
                  '10039114', # biz
                  '3448713', # law
                  '405604', # gambia
                  '7859278', # swaziland
                  '381709', # hoover, south africa
                  '454276', # sierra leone
                  # problematic
                  #  9131572  245  a| Finances of the nation h| [electronic resource]
                  #  7689978  245 a| The Nation's hospitals h| [print]. 
                  #  6743421  245 a| State of the nation. 
                ]
      let(:journal_only) { journal }
    end
    context "fixme", :fixme => true do
      # works in production
      it_behaves_like "great results for journal/newspaper", "The Nation" do
        news = [ '8217400', # malawi, green mfilm
                '4772643', # malawi, sal
                '2833546', # liberia, sal newark
                ]
        let(:newspaper_only) { news }
        journal = [ '497417', # green current
                    '464445', # green micro 
                    '10039114', # biz
                    '3448713', # law
                    '405604', # gambia
                    '7859278', # swaziland
                    '381709', # hoover, south africa
                    '454276', # sierra leone
                    # problematic
                    #  9131572  245  a| Finances of the nation h| [electronic resource]
                    #  7689978  245 a| The Nation's hospitals h| [print]. 
                    #  6743421  245 a| State of the nation. 
                  ]
        let(:journal_only) { journal }
        format_other = [ '393626', # burma
                        '385051', # ireland, hoover
                        '385052', # hoover
                        '8412029', # fisher, online - galenet
                        # problematic
                        #  9211530   245 a| The Beat (The Nation)
                      ]
        book = ['2613193', # fed doc on floods
                '9296914', # mulford, online - galenet
                '7170814', # mulford, online - galenet
                '7815517', # lingeman  245 |a The Nation : b| guide to the Nation / c| by Richard Lingeman ; introduction by Victor Navasky and Katrina Vanden Heuvel ; original drawings by Ed Koren. 
                '2098094', # mulford 
                ]
        let(:all_formats) { news + journal + format_other + book }
      end
    end
    
  end # the Nation

  context "The Times" do
    # these are split out to allow us to fine-tune the fixmes
    it_behaves_like "great results for format newspaper", "The Times" do
      news = ['8376802', # richmond, online, 1941-2959 
              '425948', # london, green, 
              '425951', # london, database, green, 0140-0460 
              '395098', # malawi
              '414857', # london, hoover
              ]
      let(:newspaper_only) { news }
    end
    # there are no journal results
    it_behaves_like "great results for journal/newspaper", "The Times", {'rows' => 64 } do
      journal = []
      news = ['8376802', # richmond, online, 1941-2959 
              '425948', # london, green, 
              '425951', # london, database, green, 0140-0460 
              '395098', # malawi
              '414857', # london, hoover
              ]
      addl = [ '8161078', # marcit, other
                '8161079', # marcit, other
                '8161081', # marcit, other
                '924097', # past, present, future, book
                '8403328', # by church, via proquest, book
                '8414490', # by griffith, via proquest, book
                '8408126', # by sheppard via proquest, book
                '2076864', # by griffith green mprint, Book
                '1567112', # by a young bostonian, book
                '9278607', # by a young bostonian, book
                '8076504', # by churchill, book, galegroup
                '436542', # burma, hoover, Other
                '422929', # miniature, hoover, Other
                '2075947', # griffith, book
                '595274', # pinero, a comedy, book
                '8295498', # markoe poem, book, online
                '9293697', # markoe poem, book, galegroup
                '881209', # griffith, spec, book
                '8780228', # church, poem, book, galegroup
                '8271492', # church, poem, book, newsbank
                '8309459', # forrest, poem, book, newsbank
                '8068199', # churchill poem, book, galegroup
                '8345704', # odell, poem, book, nwesbank
                '2087934', # besemeres, book, spec
                '8295081', # markoe poem, book, newsbank
                '8780229', # markoe poem, book, galegroup
                '2399336', # thurs jun 22, 1815, book
                '8008957', #chester assoc, book, galegroup
                '8088504', # markoe poem, book, newsbank
                '8133607', # million men, book, american broadsides
                '8278424', # mankind, newsbank
                '8328773', # standish, book, newsbank
                '9294845', # standish, book, galegroup
              ]
      let(:all_formats) { journal + news + addl }
      let(:journal_only) { journal }
      let(:newspaper_only) { news }
    end
  end # the Times

  context "The Guardian" do
    # these are split out to allow us to fine-tune the fixmes
    it_behaves_like "great results for format newspaper", "The Guardian" do
      news = ['491941', #green mfilm
              '438344', # manchester, green
              '2873190', # nigeria
              '4720924', # tanzania
              '411072', # manchester, hoover
              ]
      let(:newspaper_only) { news }
    end
    context "fixme", :fixme => true do
      it_behaves_like "great results for format journal", "The Guardian" do
        journal = ['473061', # rare
                    '2046773', # rare
                    '2046781', # rare
                    '361891', #green mfilm
                    '361893', # green, philadelphia
                    # problematic:
                    #   '6541023'  #  245  6| 880-01 a| Dao bao. b| The Guardian.
                    ]
        let(:journal_only) { journal }
      end

      it_behaves_like "great results for journal/newspaper", "The Guardian", {'rows' => 64 } do
        journal = ['473061', # rare
                    '2046773', # rare
                    '2046781', # rare
                    '361891', #green mfilm
                    '361893', # green, philadelphia
                    # problematic:
                    #   '6541023'  #  245  6| 880-01 a| Dao bao. b| The Guardian.
                    ]
        news = ['491941', #green mfilm
                '438344', # manchester, green
                '2873190', # nigeria
                '4720924', # tanzania
                '411072', # manchester, hoover
                ]

        video = ['6739108']

        other = ['382502', # burma, format Other
                  '382501' # hoover, format Other
                ]

        # many of the book are from find.galegroup.com
        book = ['8415217', '8414328', '8402896', '8738551', '8744676', '8744669', '8318844', '2075676', '2075676', '3042946', '2074558', '2073994',
          '2817859', '8318845', '8054820', '8054819', '50179', '596533', '6982889', '8085274', '8737844', 
          '8061605', '8061610', '8061608', '8061609', '8033895', '8061606', '8061607', '8733947', '8009153', '8054821']
        # all of the below are online from find.galegroup.com
        ellipses = ['8074878', '8057381', '8076326', '8002481', '8029616', '8022667', '8002480', '8026648', '8026647', '8080945', '8002479', 
                    '8002478', '8026645', '8054818', '8057382', '8026646', '8076327', '8026644', '8078462', '' ]
        # problematic:
        #   '6541023'  #  245  6| 880-01 a| Dao bao. b| The Guardian.
        #   '8161510'  #  245  a| The Guardian (Charlottetown)

        let(:all_formats) { journal + news + video + other + book + ellipses }
        let(:journal_only) { journal }
        let(:newspaper_only) { news }
      end
    end
  end # the Guardian
  
  context "the state" do
    # these are split out to allow us to fine-tune the fixmes
    it_behaves_like "great results for format journal", "The state" do
      journal = ['8211682', # charlotte 0038-9994
                ]
      let(:journal_only) { journal }
    end
    # there are no news results
    context "fixme", :fixme => true do
      it_behaves_like "great results for journal/newspaper", "the state" do
        journal = ['8211682', # charlotte 0038-9994
                  ]
        news = []
        book = ['1337047', # hall, green
                '2981862', # hall, sal3
                '1125570', # de jasay, green
                '2183213', # wilson, spec
                '6308681', # theories and issues, green
                '1592583', # authority and autonomy, jordan, green
                '1502386', # its historic role, kropotkin, green
                '53622', # its historic role, kropotkin, sal1
                '7528556', # historical & political dim, ebrary
                '3458132', # philosophical and institutational found, ackron, sal1
                '504806', # poggi, green
                '1938247', # staat, hoover
                '2098084', # staat, sal3
                '1842827', # wilson, sal
                '8277', # oppenheimer, sal
                '1775309', # oppenheimer, law
                '7176892', # wilson, galegroup
                '5611740', # wilson, education
                '2142967', # wilson, sal
                '9310732', # roeser, galegroup
                '2917057', # lenin, sal
                '2916831', # lenin, hoover
                '61414', # lenin, sal
                '7170267', # wilson, galegroup
                ]
        other = ['389364', # hoover
                ]
        let(:all_formats) { journal + news + book + other }
        let(:journal_only) { journal }
        let(:newspaper_only) { news }
      end
    end
  end # the state

  context "The Sentinel" do
    it_behaves_like "great results for journal/newspaper", "The Sentinel" do
      journal = ['482015', # green microfiche 0586-9811
                  '485114', # green microfilm 0586-9811
                  '2920952', # nigerian
                  '8436136', # medical online
                ]
      news = ['4655100', # texan
              ]
      addl = ['8169876', # 2044-6071, marcit brief record, type 'Other' as of 2013-06-06
              '6559601', # movie
              '5711017', # movie
              '8146603', # online image but format 'Book'
              '388668', # philippines, format 'Other'
              ]
      let(:all_formats) { journal + news + addl }
      let(:journal_only) { journal }
      let(:newspaper_only) { news }
    end
  end
  
  context "The Chronicle" do
    it_behaves_like "great results for journal/newspaper", "The Chronicle" do
      journal = ['10044333', # biz sal3 0732-2038
                '2506963', # Fed energy reg commis, green microfiche
                '6501140', # hebrew
                '356896', # imprint Poughkeepsie, church, sal3
                ]
      news = ['4694211', # ghana
              ]
      addl = ['8160954', # marcit brief record, type 'Other'
              '8533301', # marcit brief record, type 'Other', imprint APN News
              '8164657', # marcit brief record, type 'Other', imprint Goshen, NY
              '8160953', # marcit brief record, type 'Other', imprint Centralia, WA
              '385174', # london missionary society
              '3372313', # mannyng book
              '3376755', # mannyng book
              '448530', # am university at cairo
              '381532', # poughkeepsie
              '411229', # cairo
              ]
      let(:all_formats) { journal + news + addl }
      let(:journal_only) { journal }
      let(:newspaper_only) { news }
    end
  end 

  it "'Times of London' - common words ... as a phrase  (it's actually a newspaper ...)" do
    resp = solr_resp_doc_ids_only(title_search_args('"Times of London"').merge({'fq' => 'format:Newspaper'}))
    resp.should include(['425948', '425951']).in_first(3)
  end
  
  context "ScienceDirect" do
    shared_examples_for 'great ScienceDirect results' do | query |
      before(:all) do
        @resp = solr_resp_ids_from_query query
      end
      it "everything search should include the database record" do
        @resp.should include("7716332").in_first(3)
      end
      it "everything search should include the Lane/Medical record" do
        @resp.should include("9928933").in_first(5)
      end
    end   
    
    it_behaves_like "great ScienceDirect results", 'Science Direct'

    context "ScienceDirect (one word)" do
      it_behaves_like "great ScienceDirect results", 'ScienceDirect'

      before(:all) do
        @tresp = solr_resp_doc_ids_only(title_search_args 'ScienceDirect')        
      end
      it "title search should include the database record" do
        @tresp.should include("7716332").in_first(2)
      end
      it "title search should include the Lane/Medical record" do
        @tresp.should include("9928933").in_first(2)
      end 
    end
  end # ScienceDirect
  
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
  
end