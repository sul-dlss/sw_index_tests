# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'Chinese Unigrams', chinese: true do
  context 'Gone with the Wind', jira: 'VUF-2789' do
    it_behaves_like 'result size and vern short title matches first', 'title', '飘', 160, 200, /(飘|飄)/, 2
    it_behaves_like 'best matches first', 'title', '飘', '6701323', 5 # book
    it_behaves_like 'best matches first', 'title', '飘', '7737681', 5 # video
  end

  context 'home' do
    # TODO: revisit this range after we switch indexes
    it_behaves_like 'result size and vern short title matches first', 'title', '家', 5_000, 23_000, /^家[^[[:alnum:]]]*$/, 20
    it_behaves_like 'best matches first', 'title', '家', '4172748', 15
  end

  context 'Zen', jira: 'VUF-2790' do
    # TODO: Korean metadata passed through the Japanese analysis are boosting some irrelevant results (e.g. 9170471)
    it_behaves_like 'result size and vern short title matches first', 'title', '禪', 600, 950, /(禪|禅)/, 15
    # Japanese analysis is adding additional traditional matches;
    # TODO: should we be mapping traditional -> simplified for Japanese analysis too?
    # it_behaves_like 'both scripts get expected result size', 'title', 'traditional', '禪', 'simplified', '禅', 600, 800
    it_behaves_like 'best matches first', 'title', '禪', '6815304', 10
  end

  context 'bigram + unigram' do
    # also old fiction in chinese_title
    context 'Three kingdoms 三國誌' do
      # 三國 (three - bigram) and  誌 (kingdom unigram)
      # San guo zhi by Chen Shou  (exact 245a)
      chinese_245a = ['6696113', # microform, EAL
                      '9265099', # v. 394  harvard-yenching coll, sal1&2
                      '5630782', # v1-5  EAL Chinese coll
                      '9424180', # v 487  harvard-yenching coll, sal1&2
                      '8656531', # ser2: v14  sal1&2
                      '8656623', # ser2:v106 sal1&2
                      '9407164', # ser2:v53 harvard-yenching coll, sal1&2
                      '6718129', # v254 east asia big sets sal1&2
                      '6435402', # 65 juan  v1-5  harvard-yenching coll, sal1&2
                      '6829978', # 65 juan  v1-4  EAL chinese coll
                      '10102192', # v96-97  sal1&2
                      '8656532', # ser2 v15  sal1&2
                      '8448620' # Zhongguo shi xue ming zhu xuan. EAL chinese coll
                     ]
      korean_245a = ['8303152', # Samgukchi / Na Kwan-jung chiŭm  author Luo, Guanzhong  (245a, first 3 chars of 240a, 700t)
                     '10156316' # Samgukchi by  Yi Mun-yŏl p'yŏngyŏk  (245a, part of 246a, 500a, 700t)
                    ]
      japanese_245a = ['9146942', # has variant 2nd char 囯 56EF
                      ]
      it_behaves_like 'good results for query', 'title', '三國誌', 170, 250, chinese_245a, 25, 'rows' => 25
      # now that we're splitting words, the results are different.
      # it_behaves_like 'good results for query', 'title', '三國 誌', 200, 230, chinese_245a, 25, 'rows' => 25
      it_behaves_like 'result size and vern short title matches first', 'title', '三國誌', 170, 250, /三(國|国|囯)(誌|志)/, 30, 'rows' => 50

      # now that we're splitting words, these characters aren't necessarily adjacent
      # it_behaves_like 'result size and vern short title matches first', 'title', '三国 志', 200, 230, /三(國|国|囯)(誌|志)/, 25, 'rows' => 50

      it_behaves_like 'best matches first', 'title', '三國誌', korean_245a, 20
      # now that we're white-space sensitive, the doc no longer matches.
      # it_behaves_like 'best matches first', 'title', '三國 誌', korean_245a, 20
      it_behaves_like 'best matches first', 'title', '三國誌', japanese_245a, 20
      # now that we're white-space sensitive, the doc no longer matches.
      # it_behaves_like 'best matches first', 'title', '三國 誌', japanese_245a, 20
      # these queries get slightly different results
      # it_behaves_like 'both scripts get expected result size', 'title', 'traditional', '三國誌', 'simplified', '三国志', 170, 250
    end
  end
end
