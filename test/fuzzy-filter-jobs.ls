{nock, proxyquire, async, qs} = require './test-util'
require! bluebird: Promise

fuzzy-filter-jobs = proxyquire '../src/api/fuzzy-filter-jobs',
  './get-all-jobs': ->
    Promise.resolve do
      * 'master_oq-engine',
        'master_oq-eqcatalogue-tool'
        'master_oq-hazardlib'
        'master_oq-nrmllib'
        'master_oq-platform'
        'master_oq-risklib'
        'ydevel_oq-engine_multi-package'
        'zdevel_oq-engine'
        'zdevel_oq-hazardlib'
        'zdevel_oq-nrmllib'
        'zdevel_oq-risklib'

describe 'fuzzy-filter-jobs' (,) ->
  it 'returns Just with matches' async ->*
    jobs = yield fuzzy-filter-jobs 'engine'
    ok jobs.isJust

  it 'returns Nothing without matches' async ->*
    jobs = yield fuzzy-filter-jobs '0000000'
    ok jobs.isNothing

  it 'returns max 10 items' async ->*
    jobs = yield fuzzy-filter-jobs 'oq'
    eq 10, jobs.get!.length

  it 'returns a list of matched items' async ->*
    jobs = yield fuzzy-filter-jobs 'devel'
    deep-eq jobs.get!,
      * 'ydevel_oq-engine_multi-package'
        'zdevel_oq-engine'
        'zdevel_oq-hazardlib'
        'zdevel_oq-nrmllib'
        'zdevel_oq-risklib'
