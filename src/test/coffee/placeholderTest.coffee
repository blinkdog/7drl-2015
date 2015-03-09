# placeholderTest.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

should = require 'should'

hello = require '../lib/placeholder'

describe 'placeholder', ->
  it 'should be testable', ->
    true.should.equal true

  it 'should declare a PLACEHOLDER variable', ->
    PLACEHOLDER.should.equal true

#----------------------------------------------------------------------
# end of placeholderTest.coffee
