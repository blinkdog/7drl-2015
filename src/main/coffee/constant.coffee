# constant.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

exports.DECK_NAMES = [
  "Observation Deck",
  "Bridge",
  "Reactor",
  "Research",
  "Stores",
  "Staterooms",
  "Repairs",
  "Quarters",
  "Robo-Stores",
  "Shuttle Bay",
  "Mid-Cargo",
  "Upper Cargo",
  "Engineering",
  "Maintenance",
  "Airlock",
  "Vehicle Hold" ]

exports.DECK_OBJECT =
  EMPTY: 0
  WALL: 1
  DOOR_H: 2
  DOOR_V: 3

exports.DECK_SIZE =
  width: 38
  height: 16

exports.SHIP_NAMES = [
  "Metahawk",
  "Hewstromo",
  "Graftgold",
  "Blabgorius IV",
  "Red Barchetta",
  "Retta-beast",
  "Itsnotardenuff",
  "Paradroid" ]

# debugging in browser
window.API.constant = exports if window?.API?

#----------------------------------------------------------------------
# end of constant.coffee
