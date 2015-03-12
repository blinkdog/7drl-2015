# ship.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

{
  DECK_NAMES,
  DECK_OBJECT,
  DECK_SIZE
} = require './constant'

Deck = require './deck'

#----------------------------------------------------------------------

addConsoles = (ship) ->

addDroids = (ship) ->

addEnergizers = (ship) ->

addLifts = (ship) ->

addPlayer = (ship) ->

#----------------------------------------------------------------------

exports.create = ->
  # create a ship full of decks
  ship =
    decks: []
  for name in DECK_NAMES
    deck = new Deck DECK_SIZE.width, DECK_SIZE.height
    ship.decks.push deck.create()
  # add lifts
  addLifts ship
  # add consoles
  addConsoles ship
  # add energizers
  addEnergizers ship
  # add droids
  addDroids ship
  # add player
  addPlayer ship
  # return the ship to the caller
  return ship

# debugging in browser
window.API.ship = exports if window?.API?

#----------------------------------------------------------------------
# end of ship.coffee
