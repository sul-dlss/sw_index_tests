# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Korean Everything", :korean => true do
  
  lang_limit = {'fq'=>'language:Korean'}

  context "Hangul: social change", :jira => 'VUF-2776' do
    chars_together_in_245 = ['8538284',  # chars in sequence in 245a  (사회　 변동)
                              '6664109',
                              '8531245',
                              '8606605',
                              '7833894',
                              '6634237',
                              '7114770',
                              '6319511',
                              '6912217',
                              '9153921',
                              '8718866',
                              '6864659',
                              '7812292',
                              '8375621',
                              '8375626',
                              '8375629',
                              '8480542',
                              '9960153',
                              '9381290',
                              '7850201',
                              '7756289',
                              '8919867',
                              '8298201',
                              '7518224',
                              '9268135',
                              #'7158313',  # longer 245, longer record so it doesn't rank as high?
                              ]
    bigrams_in_245_not_together = ['10103424',
                                    '8596596',
                                    '8435397',
                                    '8612578',
                                    '8479437',
                                    '6870526',
                                    '6994853',
                                    '6971581',
                                    '8240506',
                                    '7519786',
                                    '6724346',
                                    '6648636',
                                    '6633289',
                                    '7101450', # in 245a, but far apart
                                    ]
    bigrams_in_245b = ['8802538', # in 245b, consecutive
                      '7831769'  # in 245b, not consecutive
                        ]
    bigrams_in_245_wrong_order = ['9759439']
    context "사회변동 (no spaces)" do
      it_behaves_like 'good results for query', 'everything', '사회변동', 50, 60, chars_together_in_245, 30, 'rows'=>50
      it_behaves_like 'best matches first', 'everything', '사회변동', bigrams_in_245_not_together, 50, 'rows'=>50
      it_behaves_like 'best matches first', 'everything', '사회변동', bigrams_in_245b, 50, 'rows'=>50
      it_behaves_like 'best matches first', 'everything', '사회변동', bigrams_in_245_wrong_order, 50, 'rows'=>50
    end
    context "phrase 사회변동 (no spaces)" do
      it_behaves_like 'good results for query', 'everything', '"사회변동"', 25, 45, chars_together_in_245, 28, 'rows'=>40
    end
  end # Hangul: social change, VUF-2776

end