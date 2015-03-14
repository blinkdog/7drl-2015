# ship.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

{
  DECK_NAMES,
  DECK_OBJECT,
  DECK_SIZE
} = require './constant'

{Deck} = require './deck'
{combine} = require './lift'

#----------------------------------------------------------------------

addConsoles = (ship) ->

addEnergizers = (ship) ->

addLifts = (ship) ->
  lifts = []
#  console.log "addLifts"
  while (allDecksHave(ship, DECK_OBJECT.LIFT) is false) or (allDecksAccessible(ship, lifts) is false)
#    console.log "all decks do not have lifts"
    randomDeckIndex = Math.floor(ship.decks.length * Math.random())
#    console.log "starting at deck #{randomDeckIndex}"
    randomDeck = ship.decks[randomDeckIndex]
    liftAt = findRandomObject randomDeck, DECK_OBJECT.EMPTY
#    console.log "choosing spot #{liftAt[0]},#{liftAt[1]} for a lift"
    upDeckIndex = randomDeckIndex
    downDeckIndex = randomDeckIndex
    while (downDeckIndex < ship.decks.length-1) and (Math.random() < 0.5)
      downDeck = ship.decks[downDeckIndex+1]
      if downDeck[liftAt[0]][liftAt[1]] is DECK_OBJECT.EMPTY
        downDeckIndex++
      else
#        console.log "not empty on the downdeck"
        break
#    console.log "downDeckIndex = #{downDeckIndex}"
    while (upDeckIndex > 0) and (Math.random() < 0.5)
      upDeck = ship.decks[upDeckIndex-1]
      if upDeck[liftAt[0]][liftAt[1]] is DECK_OBJECT.EMPTY
        upDeckIndex--
      else
#        console.log "not empty on the updeck"
        break
#    console.log "upDeckIndex = #{upDeckIndex}"
    if (downDeckIndex - upDeckIndex) > 0
      lifts.push [upDeckIndex, downDeckIndex]
      for deckIndex in [upDeckIndex..downDeckIndex]
#        console.log "Added lift at Deck #{deckIndex}: #{liftAt[0]},#{liftAt[1]}"
        ship.decks[deckIndex][liftAt[0]][liftAt[1]] = DECK_OBJECT.LIFT
#  console.log "done adding lifts"
  
allDecksAccessible = (ship, lifts) ->
  if lifts.length is 0
#    console.log "No lifts exist yet"
    return false
  start = lifts[0]
  for lift1 in lifts
    for lift2 in lifts
      result = combine start, lift2
      if result.length is 1
        start = result[0]
  MIN_DECK = 0
  MAX_DECK = ship.decks.length-1
  if (start[0] is MIN_DECK) and (start[1] is MAX_DECK)
#    console.log "All decks are accessible."
    return true
#  console.log "Not all decks are accessible. [#{start[0]},#{start[1]}]"
  return false

allDecksHave = (ship, obj) ->
  for deck in ship.decks
    if countObject(deck, obj) is 0
      return false
  return true

countObject = (deck, obj) ->
  count = 0
  for column in deck
    for row in column
      count++ if row is obj
  return count

findRandomObject = (deck, obj) ->
  possible = []
  for x in [0...DECK_SIZE.width]
    for y in [0...DECK_SIZE.height]
      if deck[x][y] is obj
        possible.push [x,y]
#  console.log "findRandomObject: There are #{possible.length} possibilities."
  return possible.random()

#----------------------------------------------------------------------

exports.create = ->
  # create a ship full of decks
  ship =
    decks: []
    views: []
  for name in DECK_NAMES
    deck = new Deck DECK_SIZE.width, DECK_SIZE.height
    ship.decks.push deck.create()
    ship.views.push ((false for y in [0...DECK_SIZE.height]) for x in [0...DECK_SIZE.width])
  # add lifts
  addLifts ship
  # add consoles
  addConsoles ship
  # add energizers
  addEnergizers ship
  # return the ship to the caller
  return ship

exports.findRandomObject = findRandomObject

# debugging in browser
window.API.ship = exports if window?.API?

#----------------------------------------------------------------------
# end of ship.coffee
