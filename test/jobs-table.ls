{sinon} = require './test-util'
require! '../src/utils': {format-jobs-table, format-row-obj}
require! ramda: {prop, merge}
require! chalk: {green, inverse, strip-color, bold, dim}

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

  clock = null
  describe 'activity' (,) ->
    before ->
      clock := sinon.use-fake-timers Date.now!

    after ->
      clock.restore!

    describe 'with no data for job' (,) ->
      it 'shows "never"' ->
        eq \never, prop \activity, format-row-obj job-name: \foo

    describe 'without job building' (,) ->
      base-data =
        building          : false
        timestamp         : Date.now! - 120000
        estimatedDuration : 1 # unimportant values
        duration          : 1 # but have to exist in job

      get-activity = (prop \activity) . format-row-obj . merge base-data

      it 'is time ago str' ->
        eq '~1m ago', strip-color get-activity do
          timestamp: Date.now! - 1000 * 60 * 2m

      it 'is bold if last build < 10min' ->
        eq (bold '~4m ago'), get-activity do
          timestamp: Date.now! - 1000 * 60 * 5m

      it 'is dimmed if last build > 1h' ->
        eq (dim '~1h ago'), get-activity do
          timestamp: Date.now! - 1000 * 60 * 60 * 2h

      it 'is normal color if 10min < last build < 1h' ->
        eq '~29m ago', get-activity do
          timestamp: Date.now! - 1000 * 60 * 30m

    describe 'with job building' (,) ->
      base-data =
        building           : true
        duration           : 0
        timestamp          : Date.now! - 20000
        estimated-duration : 10000

      get-activity = (prop \activity) . format-row-obj . merge base-data

      it 'is progress bar' ->
        eq (inverse 'buildin') + 'g (50%)', get-activity do
          timestamp: Date.now! - 5000

      it 'shows max 100%+' ->
        eq 'building (100%+)', strip-color get-activity do
          timestamp: Date.now! - 20000
