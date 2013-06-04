# encoding : utf-8 
require 'spec_helper'

describe "Tests for synonyms.txt used by Solr SynonymFilterFactory" do

  context "RDA changes for authority headings", :jira => 'SW-845' do
    context '"Dept." will change to "Department"' do
      # department => dept
      it "author search for United States Dept. of State" do
        resp = solr_resp_doc_ids_only(author_search_args('United States Dept. of State'))
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args('United States Dept of State')))
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(author_search_args('United States Department of State')))
        resp.should have_at_least(55000).documents
        # contain this heading in an author field in the spelled out form (i.e. United States Department. of State):
        # 10095720, 10096139
      end
    end
    context '"Koran" will change to "Qurʼan"' do
      # qurʼan, qur'an, quran, qorʼan, qor'an, qoran => koran
      it "everything search" do
        resp = solr_resp_ids_from_query('koran')
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query("qurʼan")) # alif
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query("Qur'an")) # apostrophe
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query("quran"))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query("Qorʼan")) # alif
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query("qor'an")) # apostrophe
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query("Qoran"))
        resp.should have_at_least(3000).documents
      end
      it "title search" do
        resp = solr_resp_doc_ids_only(title_search_args('Koran'))
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args("Qurʼan"))) # alif
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args("qur'an"))) # apostrophe
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args("Quran")))
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args("qorʼan"))) # alif
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args("Qor'an"))) # apostrophe
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args("qoran")))
      end
    end
    context '"O.T." and "N.T." will change to "Old Testament" and "New Testament"', :fixme => true do
      # old testament => o.t.
      # new testament => n.t.
      # 
      # From email of Kay Teel to gryphon-search on 2013-05-03
      # "... in RDA the authorized headings for the books of the Bible no longer have the testament in the heading. 
      # (That is, "Bible. N.T. Matthew" is now just "Bible. Matthew" not "Bible. New Testament. Matthew" 
      #   --> fewer results for "new testament".)
      # 
      # "... We don't have any records (yet) that are just "Bible. New Testament" so I can't tell 
      # if a search would/wouldn't find them. 
      # 
      # "But it looks like "bible n.t." retrieves "bible new testament" and I think that's what we wanted." 
      
      context '"bible n.t." retrieves "bible new testament" ' do
        it "everything search" do
          resp = solr_resp_ids_from_query('bible n.t.')
          resp.should have_at_least(16000).documents
          resp.should include('9490551') # no n.t. in the record
#          resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query("bible new testament"))  # 3486 (7108 in prod)
          resp.should_not have_the_same_number_of_results_as(solr_resp_ids_from_query("bible n. t.")) # space
        end
        it "title search" do
          resp = solr_resp_doc_ids_only(title_search_args('bible n.t.'))
          resp.should have_at_least(2000).documents
          resp.should include('9490551') # no n.t. in the record
#          resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('bible new testament')))
          resp.should_not have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args('bible n. t.'))) # space
        end
        it "subject search" do
          resp = solr_resp_doc_ids_only(subject_search_args('bible n.t.'))
          resp.should have_at_least(15000).documents
          resp.should include('6063878') # no n.t. but  653: a| Bible a| New Testament
#          resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args('bible new testament')))
          resp.should_not have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args('bible n. t.'))) # space
        end        
      end
    end
    context '"violoncello" will change to "cello" ' do
      # violoncello, violincello => cello
      it "subject search" do
        resp = solr_resp_doc_ids_only(subject_search_args('violoncello'))
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args('cello')))
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(subject_search_args('violincello')))
        resp.should have_at_least(3000).documents
      end
      it "advanced search" do
        author_query = '_query_:"{!dismax pf=$pf_author qf=$qf_author}+Carl +Philipp +Emanuel +Bach"'
        cello_title_query = '_query_:"{!dismax pf=$pf_title qf=$qf_title}+cello"'
        cello_resp = solr_resp_doc_ids_only({'qt'=>'advanced', 'q'=>"#{author_query} AND #{cello_title_query}"})
        vocello_title_query = '_query_:"{!dismax pf=$pf_title qf=$qf_title}+violoncello"'
        vocello_resp = solr_resp_doc_ids_only({'qt'=>'advanced', 'q'=>"#{author_query} AND #{vocello_title_query}"})
        cello_resp.should have_the_same_number_of_results_as vocello_resp
        vicello_title_query = '_query_:"{!dismax pf=$pf_title qf=$qf_title}+violincello"'
        vicello_resp = solr_resp_doc_ids_only({'qt'=>'advanced', 'q'=>"#{author_query} AND #{vicello_title_query}"})
        cello_resp.should have_the_same_number_of_results_as vicello_resp
      end
    end
  end # RDA changes for authority headings
  
  context "programming languages", :jira => 'SW-678' do
    context "C++" do
      it "everything search" do
        resp = solr_response({'q'=>"C++", 'fl'=>'id,title_245a_display', 'facet'=>false})
        resp.should include("title_245a_display" => /C\+\+/).in_each_of_first(20).documents
        resp.should have_at_most(1000).documents
        resp.should_not have_the_same_number_of_results_as(solr_resp_ids_from_query("C"))
      end
      it "professional C++" do
        resp = solr_resp_ids_from_query('professional C++')
        resp.should include(['9612289', '9240287', '7534583', '7819695', '9801531']).in_first(10).results
        resp.should have_at_most(150).documents
        resp.should_not have_the_same_number_of_results_as(solr_resp_ids_from_query("professional C"))
      end
      it "C++ active learning" do
        resp = solr_resp_ids_from_query('C++ active learning')
        resp.should include('8937747').as_first.result
        resp.should have_at_most(50).documents
        resp.should_not have_the_same_number_of_results_as(solr_resp_ids_from_query("C active learning"))
      end
      it "C++ computer program" do
        resp = solr_response({'q'=>"C++ computer program", 'fl'=>'id,title_245a_display', 'facet'=>false})
        resp.should include("title_245a_display" => /C\+\+/).in_each_of_first(20).documents
        resp.should have_at_most(800).documents
        resp.should_not have_the_same_number_of_results_as(solr_resp_ids_from_query("C computer program"))
      end
      it "C programming", :jira => 'VUF-1993' do
        resp = solr_resp_doc_ids_only(subject_search_args('C programming'))
        resp.should have_at_least(1000).results
        resp.should have_at_most(1200).results
        resp.should include("4617632")
      end
    end
    context "C# (also musical key)" do
      it "professional C#" do
        resp = solr_response({'q'=>'professional C#', 'fl'=>'id,title_245a_display', 'facet'=>false})
        resp.should include("title_245a_display" => /C(#|♯)/).in_each_of_first(20).documents
        resp.should have_at_most(250).documents
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query("professional C♯"))
        resp.should_not have_the_same_number_of_results_as(solr_resp_ids_from_query("professional C"))
      end
    end
    context "F# (also musical key)" do
      it "title search" do
        resp = solr_response(title_search_args("F#").merge!({'fl'=>'id,title_245a_display', 'facet'=>false}))
        resp.should include("title_245a_display" => /f(#|♯|\-sharp| sharp)/i).in_each_of_first(20).documents
        resp.should have_at_most(2000).documents
        resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only(title_search_args("F♯")))
        # it is distinct from results for F
        f_resp = solr_response(title_search_args("F").merge!({'fl'=>'id,title_245a_display', 'facet'=>false}))
        f_resp.should include("title_245a_display" => /^"?F\.?"?$/).in_each_of_first(5).documents
        resp.should_not have_the_same_number_of_results_as(f_resp)
      end
    end
    context "j#, j♯ => jsssharp" do
      it "everything search" do
        resp = solr_resp_ids_from_query('J#')
        resp.should have_at_most(20).documents
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query("J♯"))
        resp.should_not have_the_same_number_of_results_as(solr_resp_ids_from_query("J"))
      end
    end
  end # programming languages
  
  context "musical keys", :jira => 'SW-107' do
    context "sharp keys" do
      # a#, a♯, a-sharp => a sharp
      # number sign, musical sharp sign, hyphen, space
      
      it "a#" do
        resp = solr_resp_ids_from_query('a#')
        resp.should have_at_most(1250).documents  # should not include a   as well, only  a sharp
      end
      it "a# - title search" do
        resp = solr_resp_doc_ids_only(title_search_args('a#'))
        resp.should have_at_most(200).documents # should not include a   as well, only  a sharp
      end
      it "c# minor" do
        resp = solr_response({'q' => 'c# minor', 'fl'=>'id,title_display', 'facet'=>false})
        resp.should include("title_display" => /c(#|♯|\-sharp| sharp) minor/i).in_each_of_first(20).documents
        resp.should have_at_most(1500).documents
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('C♯ minor'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('C-sharp minor'))
        # would also match  c ... minor ... sharp
        resp.should have_fewer_results_than(solr_resp_ids_from_query('C sharp minor'))
      end
      it "d#" do
        resp = solr_resp_ids_from_query('d#')
        resp.should include('7941865').as_first  # Etude in D sharp minor
        resp.should have_at_most(175).documents  # should not include d  as well, only  d sharp
      end
      it "e#" do
        resp = solr_resp_ids_from_query('e#')
        resp.should include('273560').as_first  # E# Gott hat Jesum erweckt
        resp.should have_at_most(2250).documents  # should not include e  as well, only  e sharp
      end
      it "f# minor" do
        resp = solr_resp_ids_from_query('f# minor')
        resp.should have_at_least(450).documents
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('f♯ minor'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('F-sharp minor'))
        # would also match  f ... minor ... sharp
        resp.should have_fewer_results_than(solr_resp_ids_from_query('f sharp minor'))
      end
      it "f# major" do
        resp = solr_resp_ids_from_query('F# major')
        resp.should have_at_least(450).documents
        resp.should include('6284').in_first(6).results # Valse oubliee, no. 1, in F-sharp major
        resp.should include('295938').in_first(6).results  # Etude, F# major. [Op. 36, no. 13].
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('F♯ major'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('F-sharp major'))
        # would also match  f ... major ... sharp
        resp.should have_fewer_results_than(solr_resp_ids_from_query('f sharp minor'))
      end

      context "should not reduce precision for reasonable non-musical searches with x#" do
        # see above for programming languages C#, F#
      end

      context "should not reduce perceived precision for reasonable non-musical searches with x sharp (space)" do
        it "a sharp lookout" do
          resp = solr_resp_ids_from_query('a sharp lookout')
          resp.should include('1274880').as_first # A sharp lookout
          resp.should include('1353163').in_first(3)  # includes A sharp lookout in TOC
          resp.should have_at_most(10).documents
        end
        it "a short sharp (qs = 1)" do
          resp = solr_resp_ids_from_query('a short sharp')
          resp.should include('3965729').as_first.document # A short, sharp shock / Kim Stanley Robinson.
          resp.should have_at_most(850).documents
        end
        it "B sharp - title" do
          resp = solr_resp_doc_ids_only(title_search_args('b sharp'))
          resp.should include('8156248').as_first # Geo B. Sharp
          resp.should have_at_most(600).documents
        end
      end
    end # sharp keys

    context "flat keys" do
      # ab, a♭, a-flat => a flat
      # lowercase b, flat sign, hyphen, space
      it "ab major" do
        resp = solr_resp_ids_from_query('ab major')
        resp.should have_at_least(450).documents
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('a♭ major'))
        resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('A-flat major'))
        # would also match  a ... major ... flat
        resp.should have_fewer_results_than(solr_resp_ids_from_query('a flat major'))
      end

      it "advanced search for title with b♭ and with author" do
        author_query = '_query_:"{!dismax pf=$pf_author qf=$qf_author}+Carl +Philipp +Emanuel +Bach"'
        ♭_title_query = '_query_:"{!dismax pf=$pf_title qf=$qf_title}+cello +b♭"'
        ♭_resp = solr_resp_doc_ids_only({'qt'=>'advanced', 'q'=>"#{author_query} AND #{♭_title_query}"})
        ♭_resp.should include('7697437')  # b♭  is in 700r, which is in title_related_search
        b_title_query = '_query_:"{!dismax pf=$pf_title qf=$qf_title}+cello +bb"'
        ♭_resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'qt'=>'advanced', 'q'=>"#{author_query} AND #{b_title_query}"}))
        hyphen_title_query = '_query_:"{!dismax pf=$pf_title qf=$qf_title}+cello +b-flat"'
        ♭_resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'qt'=>'advanced', 'q'=>"#{author_query} AND #{hyphen_title_query}"}))
        # could have b in one 700 title, and flat in another
#        space_title_query = '_query_:"{!dismax pf=$pf_title qf=$qf_title}+cello +b +flat"'
#        ♭_resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'qt'=>'advanced', 'q'=>"#{author_query} AND #{space_title_query}"}))
        # do a title search and facet on composer
      end
      
      it "title search with composer facet" do
        facet_args = {'fq' => '{!raw f=author_person_facet}Bach, Carl Philipp Emanuel, 1714-1788'}
        resp_♭ = solr_resp_doc_ids_only(title_search_args('cello b♭').merge!(facet_args))
        resp_b = solr_resp_doc_ids_only(title_search_args('cello bb').merge!(facet_args))
        resp_hyphen = solr_resp_doc_ids_only(title_search_args('cello b-flat').merge!(facet_args))
        resp_space = solr_resp_doc_ids_only(title_search_args('cello b flat').merge!(facet_args))
        resp_♭.should have_the_same_number_of_results_as(resp_b)
        resp_♭.should have_the_same_number_of_results_as(resp_hyphen)
        resp_♭.should have_fewer_results_than(resp_space)
        resp_♭.should have_at_least(5).documents
        resp_space.should have_at_least(8).documents
        resp_space.should include('310505') # has cello b♭, but by J.S. Bach, not C.P.E. Bach
      end
      
      it "author-title search (which is a phrase search) b♭" do
        resp_♭ = solr_resp_doc_ids_only(author_title_search_args("Bach, Carl Philipp Emanuel, 1714-1788. Concertos, violoncello, string orchestra, H. 436, B♭ major."))
        resp_b = solr_resp_doc_ids_only(author_title_search_args("Bach, Carl Philipp Emanuel, 1714-1788. Concertos, violoncello, string orchestra, H. 436, Bb major."))
        resp_hyphen = solr_resp_doc_ids_only(author_title_search_args("Bach, Carl Philipp Emanuel, 1714-1788. Concertos, violoncello, string orchestra, H. 436, B-flat major."))
        resp_space = solr_resp_doc_ids_only(author_title_search_args("Bach, Carl Philipp Emanuel, 1714-1788. Concertos, violoncello, string orchestra, H. 436, B flat major."))
        resp_♭.should have_the_same_number_of_results_as(resp_b)
        resp_♭.should have_the_same_number_of_results_as(resp_hyphen)
        resp_♭.should have_the_same_number_of_results_as(resp_space)
        resp_♭.should include('7697437')
        resp_♭.should_not include('310505') # has cello b♭, but by J.S. Bach, not C.P.E. Bach
        resp_♭.should have_at_least(5).documents
      end
      
      context "should not reduce perceived precision for reasonable non-musical searches with xb (lowercase b)" do
        # FIXME:  it's punctuation sensitive!
        it "ab oculis - title search" do
          resp = solr_response(title_search_args('ab oculis').merge!({'fl'=>'id,title_display', 'facet'=>false}))
          resp.should include("title_display" => /ab oculis/i).in_each_of_first(20).documents
          resp.should have_at_most(5).documents
        end
        it "bb. - title search" do
          resp = solr_response({'q' => 'bb.', 'fl'=>'id,title_display', 'facet'=>false})
          resp.should include("title_display" => /b.? ?b.?/i).in_each_of_first(20).documents
          resp.should have_at_least(200).documents
#          resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('bb'))
        end
        it "the great eb;" do
          resp = solr_resp_ids_from_query('the great eb;')
          resp.should include('688693').as_first.document
          resp.should have_at_least(180).documents
#          resp.should have_the_same_number_of_results_as(solr_resp_ids_from_query('the great eb'))
        end
        it "e.b. white" do
          resp = solr_response({'q' => 'e.b. white', 'fl'=>'id,title_display', 'facet'=>false})
          resp.should include("title_display" => /e. ?b. white/i).in_each_of_first(20).documents
          resp.should have_at_least(350).documents
        end
        it "eb white", :fixme => true do 
          resp = solr_response({'q' => 'eb white', 'fl'=>'id,title_display', 'facet'=>false})
          resp.should include("title_display" => /e.? ?b.? white/i).in_each_of_first(10).documents
          resp.should have_at_least(10).documents
        end
        it "fb - title search", :fixme => true do
          resp = solr_response(title_search_args('fb').merge!({'fl'=>'id,title_display', 'facet'=>false}))
          resp.should include("title_display" => /f\.?b/i).in_each_of_first(5).documents
          resp.should have_at_least(100).documents # not w synonyms;  ok with f.b.
        end
        it "gb flash - title search" do
          resp = solr_response(title_search_args('gb flash'))
          resp.should include('6974143').as_first.document
          resp.should have_at_most(5).documents
        end
      end
      context "should not reduce perceived precision for reasonable non-musical searches with x flat (space)" do
        it "a flat world - title search" do
          resp = solr_response(title_search_args('a flat world').merge!({'fl'=>'id,title_display', 'facet'=>false}))
          resp.should include("title_display" => /a flat world/).in_each_of_first(5).documents
          resp.should have_at_most(65).documents
        end
        it "a bent flat (qs = 1)" do
          resp = solr_resp_ids_from_query('a bent flat')
          resp.should include('8821540').as_first.document
          resp.should have_at_least(12).documents
        end
        it "3-d flat - book, title search" do
          book_facet_arg = {'fq' => '{!raw f=format}Book'}
          resp = solr_resp_doc_ids_only(title_search_args('3-d flat').merge!(book_facet_arg))
          resp.should include('3143706')  # "Design of 3-D nacelle near flat-plate wing ..."
          resp.should include('8613091')  # " ... 3-D forms from flat curved shapes ..."
        end
      end
    end # flat keys
  end # musical keys

end