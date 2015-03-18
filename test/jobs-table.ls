{sinon} = require './test-util'
require! '../src/utils': {format-jobs-table, format-row-obj}
require! ramda: {prop}
require! chalk: {green, inverse, strip-color}

JOBS = [
  job-name : \foo-1
  result   : \SUCCESS
  number   : 1
]

describe 'format-jobs-table' (,) ->
  it 'formats a table with jobs' ->
    eq do
      strip-color format-jobs-table JOBS

      """
      ┌───┬───────┬──────────┐
      │ # │ job   │ activity │
      ├───┼───────┼──────────┤
      │ 1 │ foo-1 │ never    │
      └───┴───────┴──────────┘
      """

describe 'format-row-obj' (,) ->
  describe 'build number' (,) ->
    it 'exists' ->
      eq 1, prop \number, format-row-obj number: 1

    it 'formatted as N/A if not defined' ->
      eq 'N/A', prop \number, format-row-obj number: undefined

  describe 'name' (,) ->
    it 'exists' ->
      eq \foo, prop \jobName, format-row-obj job-name: \foo

    it 'is green if build is successful' ->
      eq (green \foo), prop \jobName, format-row-obj do
        job-name : \foo
        result   : \SUCCESS

  var clock
  describe 'activity' (,) ->
    before ->
      clock := sinon.use-fake-timers Date.now!

    after ->
      clock.restore!

    describe 'with no data for job' (,) ->
      it 'shows "never"' ->
        eq \never, prop \activity, format-row-obj job-name: \foo

    describe 'without job building' (,) ->
      it 'is time ago str' ->
        eq '~1m ago', strip-color prop \activity, format-row-obj do
          building          : false
          duration          : 60000
          timestamp         : Date.now! - 120000
          estimatedDuration : 1

    describe 'with job building' (,) ->
      it 'is progress bar' ->
        eq (inverse 'buildin') + 'g (50%)', prop \activity, format-row-obj do
          building           : true
          duration           : 0
          timestamp          : Date.now! - 5000
          estimated-duration : 10000

      it 'shows max 100%+' ->
        eq 'building (100%+)', strip-color prop \activity, format-row-obj do
          building           : true
          duration           : 0
          timestamp          : Date.now! - 20000
          estimated-duration : 10000
