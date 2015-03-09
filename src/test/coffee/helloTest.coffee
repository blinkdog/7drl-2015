# helloTest.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

should = require 'should'

hello = require '../lib/hello'

describe 'hello', ->
  it 'should be testable', ->
    true.should.equal true

  it 'should have a message', ->
    hello.message.should.equal "Hello"

#----------------------------------------------------------------------
# end of helloTest.coffee
