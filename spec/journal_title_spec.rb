describe "journal/newspaper titles" do
  context "The Nation" do
# -- OLD tests
    before(:all) do
      @green_current = '497417'
      @green_micro = '464445'
      @biz = '10039114'
      @law = '3448713'
      @orig = [@green_micro, @green_current, @biz]
    end

    it "as everything search" do
      resp = solr_resp_ids_from_query 'The Nation'
      expect(resp).to include(@orig).in_first(6)
    end

    it "as title search" do
      resp = solr_resp_ids_titles(title_search_args "The Nation")
      expect(resp).to include({'title_245a_display' => /^The Nation$/i}).in_each_of_first(7)
      expect(resp).to include(@orig).in_first(4)
    end

    it "as title search with format journal" do
      resp = solr_resp_ids_titles(title_search_args('The Nation').merge({'fq' => 'format_main_ssim:Journal/Periodical'}))
      expect(resp).to include({'title_245a_display' => /^The Nation$/i}).in_each_of_first(7)
      expect(resp).to include(@law).in_first(7)
      expect(resp).to include([@law, @green_current]).in_first(7)
      expect(resp).to include(@orig).in_first(7)
    end
# -- end OLD tests

    it "has good results with or without a trailing period" do
      journals = [ '497417', # green current
                  '464445', # green micro
                  '10039114', # biz
                  '3448713', # law
                  '405604', # gambia
                  '7859278', # swaziland
                  '381709', # hoover, south africa
                  '454276', # sierra leone
                  # marcit records:
                  '10560869',
                  '12119944',
                  '12115052'
                ]
      resp = solr_resp_ids_titles(title_search_args('The Nation.').merge({'fq' => 'format_main_ssim:Journal/Periodical'}))
      resp_wo = solr_resp_ids_titles(title_search_args('The Nation').merge({'fq' => 'format_main_ssim:Journal/Periodical'}))
      expect(resp).to have_the_same_number_of_results_as(resp_wo)
      expect(resp).to include({'title_245a_display' => /^the nation\W*$/i}).in_each_of_first(journals.size)
      expect(resp).to include(journals).in_first(journals.size + 3) # a little slop built in
    end
  end # the Nation

  context "The Times" do
    it 'has good results for "The Times" with the newspaper facet' do
      expect(solr_resp_doc_ids_only(title_search_args('The Times').merge({'fq' => 'format_main_ssim:Newspaper'}))).to include([
        '8376802', # richmond, online, 1941-2959
        '425948', # london, green,
        '425951', # london, database, green, 0140-0460
        '395098', # malawi
      ]).in_first(10)
    end

    it 'boosts the title matches above everything else' do
      titles = solr_resp_doc_ids_only(title_search_args('The Times').merge({'fq' => 'format_main_ssim:Newspaper' }))
      expect(solr_resp_doc_ids_only(everything_search_args('The Times').merge({'fq' => 'format_main_ssim:Newspaper'}))).to include(titles.dig('response', 'docs').map { |doc| doc['id'] }.first(5)).in_first(7)
    end

#     it_behaves_like "great results for journal/newspaper", "The Times", {'rows' => 100 } do
#       journal = []
#       news = ['8376802', # richmond, online, 1941-2959
#               '425948', # london, green,
#               '425951', # london, database, green, 0140-0460
#               '395098', # malawi
#               ]
#       addl = [ '8161079', # marcit, other
#                 '8161081', # marcit, other
#                 '924097', # past, present, future, book
#                 '8403328', # by church, via proquest, book
#                 '8414490', # by griffith, via proquest, book
#                 '8408126', # by sheppard via proquest, book
#                 '2076864', # by griffith green mprint, Book
#                 '1567112', # by a young bostonian, book
#                 '9278607', # by a young bostonian, book
#                 '8076504', # by churchill, book, galegroup
#                 '436542', # burma, hoover, Other
#                 '422929', # miniature, hoover, Other
#                 '2075947', # griffith, book
#                 '595274', # pinero, a comedy, book
#                 '8295498', # markoe poem, book, online
#                 '9293697', # markoe poem, book, galegroup
#                 '881209', # griffith, spec, book
#                 '8780228', # church, poem, book, galegroup
#                 '8271492', # church, poem, book, newsbank
#                 '8309459', # forrest, poem, book, newsbank
#                 '8068199', # churchill poem, book, galegroup
#                 '8345704', # odell, poem, book, nwesbank
#                 '2087934', # besemeres, book, spec
#                 '8295081', # markoe poem, book, newsbank
#                 '8780229', # markoe poem, book, galegroup
#                 '2399336', # thurs jun 22, 1815, book
#                 '8008957', #chester assoc, book, galegroup
#                 '8088504', # markoe poem, book, newsbank
#                 '8133607', # million men, book, american broadsides
#                 '8278424', # mankind, newsbank
# #                '8328773', # standish, book, newsbank
#                 '9294845', # standish, book, galegroup
#                 '10544242', # Nineteenth Century, book, online
#               ]
#       let(:all_formats) { journal + news + addl }
#       let(:journal_only) { journal }
#       let(:newspaper_only) { news }
#     end
    it "'Times of London' - common words ... as a phrase  (it's actually a newspaper ...)" do
      resp = solr_resp_doc_ids_only(title_search_args('"Times of London"').merge({'fq' => 'format_main_ssim:Newspaper'}))
      expect(resp).to include(['425948', '425951']).in_first(3)
    end
  end # the Times

  context "The Guardian" do
    it 'has good results for "The Guardian" with the newspaper facet' do
      expect(solr_resp_doc_ids_only(title_search_args('The Guardian').merge({'fq' => 'format_main_ssim:Newspaper'}))).to include(['491941', '438344', '2873190', '4720924', '411072']).in_first(10)
    end

    it 'has good results for "The Guardian" with the journal facet' do
      expect(solr_resp_doc_ids_only(title_search_args('The Guardian').merge({'fq' => 'format_main_ssim:Journal/Periodical'}))).to include(['473061', '2046773', '2046781', '361891']).in_first(10)
    end

    it 'boosts the title matches above everything else' do
      titles = solr_resp_doc_ids_only(title_search_args('The Guardian').merge({'fq' => 'format_main_ssim:Newspaper' }))
      expect(solr_resp_doc_ids_only(everything_search_args('The Guardian').merge({'fq' => 'format_main_ssim:Newspaper'}))).to include(titles.dig('response', 'docs').map { |doc| doc['id'] }.first(5)).in_first(7)
    end
  end # the Guardian

  context "the world" do
    # linked 880 for 245 is skewing the results for this search
    # per some cataloging rule, we have multi-lingual text in both
    # the 245 and linked 880, hence record with "the world" in both
    # fields is treated as more relevant and ranked #1 in the results
    it 'has good results for "the world" with the journal facet' do
      expect(solr_resp_doc_ids_only(title_search_args('the world').merge({'fq' => 'format_main_ssim:Journal/Periodical'}))).to include([
        '2131497', # st marks 0043-8154, green
        '4514062', # fitz-adam, spec
        '4443623', # south africa, hoover
      ]).in_first(10)
    end

    it 'has good results for "The world" with the newspaper facet' do
      expect(solr_resp_doc_ids_only(title_search_args('The world').merge({'fq' => 'format_main_ssim:Newspaper'}))).to include([
        '8204854', # coos bay, 1062-8495, online
        '2455657', # bennington, green micro
        '3053234', # ny, green micro
        '3053230', # ny, green mfilm
        '3053225', # ny, green mfilm
      ]).in_first(10)
    end

    it 'boosts the title matches above everything else' do
      titles = solr_resp_doc_ids_only(title_search_args('The World').merge({'fq' => 'format_main_ssim:Newspaper' }))
      expect(solr_resp_doc_ids_only(everything_search_args('The World').merge({'fq' => 'format_main_ssim:Newspaper'}))).to include(titles.dig('response', 'docs').map { |doc| doc['id'] }.first(5)).in_first(7)
    end
  end # the world

  context "The Sentinel" do
    it 'has good results for "The Sentinel"' do
      expect(solr_resp_doc_ids_only(title_search_args('The Sentinel'))).to include([
        '482015', # green microfiche 0586-9811
        '485114', # green microfilm 0586-9811
        '2920952', # nigerian
        '8436136', # medical online
        '4655100', # texan
        '8169876', # 2044-6071, marcit brief record, type 'Other' as of 2013-06-06
        '10474493', # federal document
        '5711017', # movie
        '8146603', # online image but format 'Book'
        '10476010', # federal document
      ]).in_first(15)
    end

    it 'has good results for "The Sentinel" with the newspaper facet' do
      expect(solr_resp_doc_ids_only(title_search_args('The Sentinel').merge({'fq' => 'format_main_ssim:Newspaper'}))).to include([
        '4655100', # texan
      ]).in_first(10)
    end

    it 'has good results for "The Sentinel" with the journal facet' do
      expect(solr_resp_doc_ids_only(title_search_args('The Sentinel').merge({'fq' => 'format_main_ssim:Journal/Periodical'}))).to include([
        '482015', # green microfiche 0586-9811
        '485114', # green microfilm 0586-9811
        '2920952', # nigerian
        '8436136', # medical online
      ]).in_first(10)
    end

    it 'boosts the title matches above everything else' do
      titles = solr_resp_doc_ids_only(title_search_args('The Sentinel').merge({'fq' => 'format_main_ssim:Newspaper' }))
      expect(solr_resp_doc_ids_only(everything_search_args('The Sentinel').merge({'fq' => 'format_main_ssim:Newspaper'}))).to include(titles.dig('response', 'docs').map { |doc| doc['id'] }.first(5)).in_first(7)
    end
  end

  context "The Chronicle" do
    it 'has good results for "The Chronicle"' do
      expect(solr_resp_doc_ids_only(title_search_args('The Chronicle'))).to include([
        '10044333', # biz sal3 0732-2038
        '2506963', # Fed energy reg commis, green microfiche
        '6501140', # hebrew
        '356896', # imprint Poughkeepsie, church, sal3
        '4694211', # ghana
        '385174', # london missionary society
        '448530', # am university at cairo
        '381532', # poughkeepsie
        '411229', # cairo
      ]).in_first(20)
    end

    it 'has good results for "The Chronicle" with the newspaper facet' do
      expect(solr_resp_doc_ids_only(title_search_args('The Chronicle').merge({'fq' => 'format_main_ssim:Newspaper'}))).to include([
        '4694211', # ghana
      ]).in_first(10)
    end

    it 'has good results for "The Chronicle" with the journal facet' do
      expect(solr_resp_doc_ids_only(title_search_args('The Chronicle').merge({'fq' => 'format_main_ssim:Journal/Periodical'}))).to include([
        '10044333', # biz sal3 0732-2038
        '2506963', # Fed energy reg commis, green microfiche
        '6501140', # hebrew
        '356896', # imprint Poughkeepsie, church, sal3
      ]).in_first(10)
    end

    it 'boosts the title matches above everything else' do
      titles = solr_resp_doc_ids_only(title_search_args('The Sentinel').merge({'fq' => 'format_main_ssim:Journal/Periodical' }))
      expect(solr_resp_doc_ids_only(everything_search_args('The Sentinel').merge({'fq' => 'format_main_ssim:Journal/Periodical'}))).to include(titles.dig('response', 'docs').map { |doc| doc['id'] }.first(5)).in_first(7)
    end
  end

  context "the week" do
    it 'has good results for "the week" with the journal facet' do
      expect(solr_resp_doc_ids_only(title_search_args('the week').merge({'fq' => 'format_main_ssim:Journal/Periodical'}))).to include([
        '391183', # nottingham, hoover
        '400249', # london hoover
        '6917648', # london, hoover mfilm
        '4000948', # brussels, green
        '2996238', # brussels, sal
      ]).in_first(10)
    end

    it 'boosts the title matches above everything else' do
      titles = solr_resp_doc_ids_only(title_search_args('The week').merge({'fq' => 'format_main_ssim:Journal/Periodical' }))
      expect(solr_resp_doc_ids_only(everything_search_args('The week').merge({'fq' => 'format_main_ssim:Journal/Periodical'}))).to include(titles.dig('response', 'docs').map { |doc| doc['id'] }.first(5)).in_first(7)
    end
  end

  context "the news" do
    it 'has good results for "the news" with the newspaper facet' do
      expect(solr_resp_doc_ids_only(title_search_args('the news').merge({'fq' => 'format_main_ssim:Newspaper'}))).to include([
        '5713602', # liberia, green mfilm
        '2479216', # liberia
      ]).in_first(10)
    end

    it 'has good results for "the news" with the journal facet' do
      expect(solr_resp_doc_ids_only(title_search_args('the news').merge({'fq' => 'format_main_ssim:Journal/Periodical'}))).to include([
        '2803490', # nigeria, green, 1116-7157
        '371779', # cincinatti
      ]).in_first(10)
    end

    it 'has good results for "the news" without a format specified' do
      expect(solr_resp_doc_ids_only(title_search_args('the news'))).to include([
        '2803490', # nigeria, green, 1116-7157
        '371779', # cincinatti
        '5713602', # liberia, green mfilm
        '2479216', # liberia
        '8584851', # steven, green
        '3770397', # myers, green
        '4698417', # wachtel, green
        '8627911', # city of buffalo, creeley, spec
        '385473', # lisbon, other
      ]).in_first(20)
    end
  end

  context "the star" do
    it 'has good results for "the star" with the newspaper facet' do
      expect(solr_resp_doc_ids_only(title_search_args('the star').merge({'fq' => 'format_main_ssim:Newspaper'}))).to include([
        '9861955', # tinley park, online
        '4533025', # johannesburg, hoover
        '423194', # johannesburg, sal newark
      ]).in_first(10)
    end

    it 'has good results for "the star" with the journal facet' do
      expect(solr_resp_doc_ids_only(title_search_args('the star').merge({'fq' => 'format_main_ssim:Journal/Periodical'}))).to include([
        '461027', # uganda, sal
        '10553130', # Carville, online
      ]).in_first(10)
    end

    it 'has good results for "the star" without a format specified' do
      expect(solr_resp_doc_ids_only(title_search_args('the star'))).to include([
        '461027', # uganda, sal
        '10553130', # Carville, online
        '9861955', # tinley park, online
        '4533025', # johannesburg, hoover
        '423194', # johannesburg, sal newark
        '11931578', # london, sal3
        '8161058', # marcit
        '8227544', # marcit
        '5960691', # video
        '10354180', # marcit
      ]).in_first(20)
    end
  end

  context "the herald" do
    it 'has good results for "the herald" with the newspaper facet' do
      expect(solr_resp_doc_ids_only(title_search_args('the herald').merge({'fq' => 'format_main_ssim:Newspaper'}))).to include([
        '9333628', # sharon, pa, online
        '4367458', # london, hoover micro
        '4789791', # zimbabwe
        '2870984', # zimbabwe micro
        '484762', # ny, green
      ]).in_first(15)
    end

    it 'has good results for "the herald" with the journal facet' do
      expect(solr_resp_doc_ids_only(title_search_args('the herald').merge({'fq' => 'format_main_ssim:Journal/Periodical'}))).to include([
        '8201184', # conroe, tex, online
        '8504925', # ghana
        '460847', # australia, hoover
        '362256', # vestnik, hoover
        '362254', # pronunciation and amended speling
      ]).in_first(10)
    end

    it 'has good results for "the herald" without a format specified' do
      expect(solr_resp_doc_ids_only(title_search_args('the herald'))).to include([
        '8201184', # conroe, tex, online
        '8504925', # ghana
        '460847', # australia, hoover
        '362256', # vestnik, hoover
        '362254', # pronunciation and amended speling
        '9333628', # sharon, pa, online
        '4367458', # london, hoover micro
        '4789791', # zimbabwe
        '2870984', # zimbabwe micro
        '484762', # ny, green
        '1017231', # shaara, green
        '381577', # karachi, hoover
        '448407', # lake geneva, hoover
      ]).in_first(25)
    end
  end

  context "the journal" do
    it 'has good results for "the journal" with the journal facet', pending: 'fixme' do
      expect(solr_resp_doc_ids_only(title_search_args('the journal').merge({'fq' => 'format_main_ssim:Journal/Periodical'}))).to include([
        '4144519', # bar assoc dc, law
        '441812', # mecca, green
        '9696658', # cleveland, heinonline
        '9705114', # oklahoma, heinonline
        '495155', # canada, edu
        '498469', # kansas, green
        '667465', # metal polishers, green micro
        '667361', # metal polishers, green mfilm
        '667316', # metal polishers, green mfilm
        '354858', # burma, sal3
        '2941201', # tech horiz, educ, 0192-592x
        '11699410', # Seychelles, sal3
        '10553544', # marcit
      ]).in_first(15)
    end

    it 'has good results for "the journal" with the newspaper facet' do
      expect(solr_resp_doc_ids_only(title_search_args('the journal').merge({'fq' => 'format_main_ssim:Newspaper'}))).to include([
        '10354148', # marcit
        '11939504', # marcit
      ]).in_first(10)
    end

    it 'has good results for "the journal" without a format specified', pending: 'fixme' do
      expect(solr_resp_doc_ids_only(title_search_args('the journal'))).to include([
        '1186556', # dana, green
        '1293085', # 1721, green mfilm
        '4374587', # columbus, green
        '8161373' # marcit
      ]).in_first(25)
    end
  end

  context "the atlantic" do
    it 'has good results for "the atlantic" with the journal facet' do
      expect(solr_resp_doc_ids_only(title_search_args('the atlantic').merge({'fq' => 'format_main_ssim:Journal/Periodical'}))).to include([
        '454930', # boston, sal, 0276-9077
        '10006758', # biz, 1072-7825
        '454928', # sal3, spec, 1060-6506
      ]).in_first(10)
    end

    it 'has good results for "the atlantic" without a format specified' do
      expect(solr_resp_doc_ids_only(title_search_args('the atlantic'))).to include([
        '454930', # boston, sal, 0276-9077
        '10006758', # biz, 1072-7825
        '454928', # sal3, spec, 1060-6506
        '4104255', # butel, green, ebrary
        '128007', #outhwaite, green
      ]).in_first(10)
    end
  end

  context "the economist" do
    it 'has good results for "the economist" with the journal facet' do
      expect(solr_resp_doc_ids_only(title_search_args('the economist').merge({'fq' => 'format_main_ssim:Journal/Periodical'}))).to include([
        '3442788', # london, law, 0013-0613
        '593360', # database, 0013-0613
        '382177', # hoover, 0013-0613
        '10040858', # biz, 0013-0613
        '359366', # latin ed, sal3
        '359364', # communism 1821, sal3
      ]).in_first(10)
    end

    it 'has good results for "the economist" without a format specified' do
      expect(solr_resp_doc_ids_only(title_search_args('the economist'))).to include([
        '3442788', # london, law, 0013-0613
        '593360', # database, 0013-0613
        '382177', # hoover, 0013-0613
        '10040858', # biz, 0013-0613
        '359366', # latin ed, sal3
        '359364', # communism 1821, sal3
        '1329961', # neufeldt, green, milibrary
        '8016615', # gentlemen of experience, galegroup
        '8751936', # gentlemen of experience, galegroup
        '8751937', # gentlemen of experience, galegroup
      ]).in_first(20)
    end
  end

  context "the cosmopolitan" do
    it 'has good results for "the cosmopolitan" with the journal facet' do
      expect(solr_resp_doc_ids_only(title_search_args('the cosmopolitan').merge({'fq' => 'format_main_ssim:Journal/Periodical'}))).to include([
        '361713', # green mfilm
        # '361712', # branner, 0740-6444; no longer a journal?
      ]).in_first(15)
    end

    it 'has good results for "the cosmopolitan" without a format specified' do
      expect(solr_resp_doc_ids_only(title_search_args('the cosmopolitan'))).to include([
        '361713', # green mfilm
        '361712', # branner, 0740-6444
        '7711785', # stonecipher, green
      ]).in_first(10)
    end
  end

  context "the wall street journal", :jira => ['SW-585','VUF-1715'] do
    it "gets ckey 486903 above fold" do
      resp = solr_resp_ids_titles(title_search_args 'wall street journal')
      expect(resp).to include('486903').in_first(4)
      resp = solr_resp_ids_titles(title_search_args 'the wall street journal')
      expect(resp).to include('486903').in_first(4)
    end

    it 'has good results for "the wall street journal" with the journal facet' do
      expect(solr_resp_doc_ids_only(title_search_args('the wall street journal').merge({'fq' => 'format_main_ssim:Journal/Periodical'}))).to include([
        '400114', # index, sal3, 0099-9660
      ]).in_first(10)
    end

    it 'has good results for "the wall street journal" with the newspaper facet' do
      expect(solr_resp_doc_ids_only(title_search_args('the wall street journal').merge({'fq' => 'format_main_ssim:Newspaper'}))).to include([
        '486903', # also database, microform, 0099-9660
        '6654532', # proquest
        '10041833', # biz, 0193-2241
      ]).in_first(10)
    end

    it 'has good results for "the wall street journal" without a format specified' do
      expect(solr_resp_doc_ids_only(title_search_args('the wall street journal'))).to include([
        '400114', # index, sal3, 0099-9660
        '486903', # also database, microform, 0099-9660
        '6654532', # proquest
        '10041833', # biz, 0193-2241
        '1407594', # purveyor of news to biz america, green
        '1037892', # the story of dow jones ..., green
      ]).in_first(20)
    end
  end

  context "ScienceDirect" do
    it 'includes good results' do
      resp = solr_resp_doc_ids_only(title_search_args 'ScienceDirect')
      expect(resp).to include("7716332").in_first(2) # database
      expect(resp).to include("L207466").in_first(5) # medical/lane
    end


    # Metadata has 'ScienceDirect' as the 245a title, and Science Direct is the 246 variant title
    it 'includes good results even with a space' do
      resp = solr_resp_doc_ids_only(title_search_args 'Science Direct')
      expect(resp).to include("7716332").in_first(3) # database
      expect(resp).to include("L207466").in_first(10) # medical/lane
    end
  end # ScienceDirect

  context "Nature" do
    it "as everything search", :jira => 'VUF-1515' do
      resp = solr_response({'q' => 'nature', 'fl'=>'id,title_display', 'facet'=>false})
      expect(resp).to include({'title_display' => /^Nature/}).in_first(3)
    end

    it "as title search" do
      resp = solr_response(title_search_args('nature').merge({'fl'=>'id,title_display', 'facet'=>false}))
      expect(resp).to include({'title_display' => /^Nature/}).in_first(3)
    end

    it "as title search with format journal" do
      resp = solr_response(title_search_args('nature').merge({'fq' => 'format_main_ssim:"Journal/Periodical"', 'fl'=>'id,title_display', 'facet'=>false}))
      expect(resp.size).to be <= 2200
      expect(resp).to include({'title_display' => /^Nature/}).in_first(5)
      expect(resp).to include({'title_display' => /^Nature; international journal of science/}).in_first(5)
    end

    it 'has good results for "nature" with the journal facet' do
      expect(solr_resp_doc_ids_only(title_search_args('nature').merge({'fq' => 'format_main_ssim:Journal/Periodical'}))).to include([
        'L14', # london 0028-0836, lane/medical
        '3195844', # london 0028-0836, biology
        '466281', # directory of biologicals
        '370787', # physical science, sal
      ]).in_first(10)
    end
  end

  context "Science" do
    it 'has good results for "science" with the journal facet' do
      expect(solr_resp_doc_ids_only(title_search_args('science').merge({'fq' => 'format_main_ssim:Journal/Periodical'}))).to include([
        '394654', # london, green, 0036-8075
        '3195846', # london, biology, 0036-8075
        '433334', # bimonthly, 0193-4511
      ]).in_first(10)
    end
  end
  context "Ethics" do
    it 'has good results for "ethics" with the journal facet' do
      expect(solr_resp_doc_ids_only(title_search_args('ethics').merge({'fq' => 'format_main_ssim:Journal/Periodical'}))).to include([
        '521868', # HT
        '497326', # 0014-1704, green
        # '8205688', # 1677-2954, brazil, online
      ]).in_first(10)
    end
  end

  context "The New York Times", :jira => ['SW-585', 'VUF-1926', 'VUF-1715', 'VUF-833'] do
    it "should get ckey 495710 above fold" do
      resp = solr_resp_ids_titles(title_search_args 'THE new york times')
      expect(resp).to include('495710').in_first(5)
    end
    it "should get ckey 495710 above fold without 'the'", pending: 'fixme' do
      # note:  this only works when 'the' is included, due to title_245a_exact matching in edismax (and our data)
      resp = solr_resp_ids_titles(title_search_args 'new york times')
      expect(resp).to include('495710').in_first(4)
    end

    # note:  it would be megaspiffy if we didn't need "the" in front ... but to match exact search, we do.
    it 'has good results for "The New York Times" with the newspaper facet' do
      expect(solr_resp_doc_ids_only(title_search_args('The New York Times').merge({'fq' => 'format_main_ssim:Newspaper'}))).to include([
        '10042346', # biz, online, 0362-4331
        '495710', # green, terman, 0362-4331
        '486905', # green micro, 0362-4331
        '461597', # hoover, micro, 0362-4331
      ]).in_first(10)
    end

    it 'has good results for "The New York Times" without a format specified' do
      expect(solr_resp_doc_ids_only(title_search_args('The New York Times'))).to include([
        '10042346', # biz, online, 0362-4331
        '495710', # green, terman, 0362-4331
        '486905', # green micro, 0362-4331
        '461597', # hoover, micro, 0362-4331
        '8436523',
        '1509739'
      ]).in_first(10)
    end

    it 'has good results for "New York Times"' do
      expect(solr_resp_doc_ids_only(title_search_args('New York Times'))).to include([
        '9323497', # database
        '422377', # hoover book review (bad cataloging)
        '422487', # hoover Rotogravure Sunday section.
        '422593', # hoover Weekly magazine section. - New York.
      ]).in_first(10)
    end
  end # new york times

  context "Financial Times", :jira => ['SW-585', 'VUF-1926'] do
    it "should get ckey 4100964 above fold" do
      # would prefer higher than 4 ...
      resp = solr_resp_ids_titles(title_search_args 'Financial Times')
      expect(resp).to include('4100964').in_first(4)
      resp = solr_resp_ids_titles(title_search_args 'Financial Times')
      expect(resp).to include('4100964').in_first(4)
    end

    it 'has good results for "Financial Times" with the newspaper facet' do
      expect(solr_resp_doc_ids_only(title_search_args('Financial Times').merge({'fq' => 'format_main_ssim:Newspaper'}))).to include([
        '10040357', # biz, 0884-6782
        '4100964', # green, 0884-6782
        '2874107', # sal newark, uganda
      ]).in_first(10)
    end
  end # financial times
end
