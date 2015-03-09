# paradroidTest.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

should = require 'should'

paradroid = require '../lib/paradroid'

describe 'paradroid', ->
  it 'should be testable', ->
    true.should.equal true

  it 'should have a run method', ->
    paradroid.should.have.property 'run'

#----------------------------------------------------------------------
# end of paradroidTest.coffee
