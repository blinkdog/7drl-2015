# liftTest.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

should = require 'should'

lift = require '../lib/lift'

describe 'lift', ->
  it 'should not combine non-overlaps', ->
    lift.combine([1,2], [3,4]).should.eql [[1,2],[3,4]]

  it 'should not combine non-overlaps', ->
    lift.combine([3,4], [1,2]).should.eql [[3,4],[1,2]]

  it 'should not combine far non-overlaps', ->
    lift.combine([1,2], [30,40]).should.eql [[1,2],[30,40]]

  it 'should not combine far non-overlaps', ->
    lift.combine([30,40], [1,2]).should.eql [[30,40],[1,2]]

  it 'should combine topedge-bottomedge overlaps', ->
    lift.combine([1,2], [2,3]).should.eql [[1,3]]

  it 'should combine bottomedge-topedge overlaps', ->
    lift.combine([2,3], [1,2]).should.eql [[1,3]]

  it 'should combine middle-bottom overlaps', ->
    lift.combine([1,3], [2,5]).should.eql [[1,5]]

  it 'should combine bottom-middle overlaps', ->
    lift.combine([2,5], [1,3]).should.eql [[1,5]]

  it 'should combine middle-top overlaps', ->
    lift.combine([4,6], [2,5]).should.eql [[2,6]]

  it 'should combine top-middle overlaps', ->
    lift.combine([2,5], [4,6]).should.eql [[2,6]]

  it 'should combine identicals', ->
    lift.combine([1,5], [1,5]).should.eql [[1,5]]

  it 'should combine inner-outer overlaps', ->
    lift.combine([3,5], [1,7]).should.eql [[1,7]]

  it 'should combine outer-inner overlaps', ->
    lift.combine([1,7], [3,5]).should.eql [[1,7]]

  it 'should combine type 3s', ->
    lift.combine([1,10], [5,50]).should.eql [[1,50]]

  it 'should combine type 4s', ->
    lift.combine([40,60], [5,50]).should.eql [[5,60]]

  it 'should combine tiny overlaps', ->
    lift.combine([1,5], [5,5]).should.eql [[1,5]]

  it 'should combine tiny overlaps', ->
    lift.combine([1,5], [1,1]).should.eql [[1,5]]

  it 'should combine tiny overlaps', ->
    lift.combine([5,5], [1,5]).should.eql [[1,5]]

  it 'should combine tiny overlaps', ->
    lift.combine([1,1], [1,5]).should.eql [[1,5]]

#----------------------------------------------------------------------
# end of liftTest.coffee
