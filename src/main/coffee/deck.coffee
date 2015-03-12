# deck.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

{
  DECK_OBJECT,
  DECK_SIZE
} = require './constant'

# Deck map generation control constants
MAX_ATTEMPT = 100
MAX_DEPTH = 5
MIN_DEPTH = 2
MIN_THICKNESS = 3
PROB_HORIZ_SPLIT = 0.5
PROB_STOP_SPLIT = 0.01

# ROT.Map.Deck = Randomly generate spaceship deck maps
ROT.Map.Deck = (width, height) ->
  ROT.Map.call this, width, height

ROT.Map.Deck.extend ROT.Map

ROT.Map.Deck::create = (next) ->
  avoid =
    HORIZ: []
    VERT: []
  # generate a solid map
  @_map = @_fillMap DECK_OBJECT.WALL
  # generate a BSP tree for the deck
  tree = @_bsp 1, 1, @_width-2, @_height-2, 0
  # walk the BSP tree to generate the map
  @_walk @_map, tree, 1, 1, @_width-2, @_height-2, avoid
  # send the map information to the callback
  for i in [0...@_width]
    for j in [0...@_height]
      next i, j, @_map[i][j]
  # return the map
  return @_map

ROT.Map.Deck::_betweenInc = (min, max) ->
  min + Math.floor(((max-min)+1) * Math.random())

ROT.Map.Deck::_bsp = (x1, y1, x2, y2, depth) ->
  # if we are too deep
  if depth >= MAX_DEPTH
    return null 
  # if we should no longer split
  if (depth >= MIN_DEPTH) and (Math.random() < PROB_STOP_SPLIT)
    return null
  # if we should split horizontally
  if Math.random() < PROB_HORIZ_SPLIT
    # if there isn't room to split horizontally
    if ((y2-y1)+1) < ((MIN_THICKNESS*2)+1)
      return null
    # figure out where we're going to split
    minSplit = y1 + MIN_THICKNESS
    maxSplit = y2 - MIN_THICKNESS
    splitAt = @_betweenInc minSplit, maxSplit
    # recursively split the subspaces
    top = @_bsp x1, y1, x2, splitAt-1, depth+1
    bottom = @_bsp x1, splitAt+1, x2, y2, depth+1
    return node =
      x1: x1
      y1: y1
      x2: x1
      y2: y1
      split: 'HORIZ'
      splitAt: splitAt
      left: top
      right: bottom
  else
    # if there isn't room to split vertically
    if ((x2-x1)+1) < ((MIN_THICKNESS*2)+1)
      return null
    # figure out where we're going to split
    minSplit = x1 + MIN_THICKNESS
    maxSplit = x2 - MIN_THICKNESS
    splitAt = @_betweenInc minSplit, maxSplit
    # recursively split the subspaces
    left = @_bsp x1, y1, splitAt-1, y2, depth+1
    right = @_bsp splitAt+1, y1, x2, y2, depth+1
    return node =
      x1: x1
      y1: y1
      x2: x1
      y2: y1
      split: 'VERT'
      splitAt: splitAt
      left: left
      right: right

ROT.Map.Deck::_fill = (map, x1, y1, x2, y2, value) ->
  for y in [y1..y2]
    for x in [x1..x2]
      map[x][y] = value
  return map

ROT.Map.Deck::_walk = (map, node, x1, y1, x2, y2, avoid) ->
  # determine the boundaries of the subspaces
  if node.split is 'HORIZ'
    lx1 = x1
    ly1 = y1
    lx2 = x2
    ly2 = node.splitAt-1
    rx1 = x1
    ry1 = node.splitAt+1
    rx2 = x2
    ry2 = y2
  if node.split is 'VERT'
    lx1 = x1
    ly1 = y1
    lx2 = node.splitAt-1
    ly2 = y2
    rx1 = node.splitAt+1
    ry1 = y1
    rx2 = x2
    ry2 = y2
  avoid[node.split].push node.splitAt
  # walk the subspace nodes, fill the subspace leaves
  if node.left?
    @_walk map, node.left, lx1, ly1, lx2, ly2, avoid
  else
    @_fill map, lx1, ly1, lx2, ly2, DECK_OBJECT.EMPTY
  if node.right?
    @_walk map, node.right, rx1, ry1, rx2, ry2, avoid
  else
    @_fill map, rx1, ry1, rx2, ry2, DECK_OBJECT.EMPTY
  # determine how to bridge between the two subspaces
  if node.split is 'HORIZ'
    attempt = 0
    choice = -1
    while choice < 0
      doorAt = @_betweenInc x1+1, x2-1
      if not (doorAt in avoid['VERT'])
        choice = doorAt
      else
        attempt++
      if attempt > MAX_ATTEMPT
        choice = doorAt
    @_map[choice][node.splitAt] = DECK_OBJECT.DOOR_H
  if node.split is 'VERT'
    attempt = 0
    choice = -1
    while choice < 0
      doorAt = @_betweenInc y1+1, y2-1
      if not (doorAt in avoid['HORIZ'])
        choice = doorAt
      else
        attempt++
      if attempt > MAX_ATTEMPT
        choice = doorAt
    @_map[node.splitAt][choice] = DECK_OBJECT.DOOR_V
  return avoid

# export to Node module
exports.Deck = ROT.Map.Deck

# debugging in browser
window.API.deck = exports if window?.API?

#----------------------------------------------------------------------
# end of deck.coffee
