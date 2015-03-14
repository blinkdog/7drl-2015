# gameOn.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

audio = require './audio'
mainGame = require './mainGame'
ship = require './ship'

#----------------------------------------------------------------------

DISPLAY_SIZE =
  width: 40
  height: 8

GAME_START_DELAY = 4250 #ms

{
  DECK_DIFFICULTY,
  DECK_OBJECT,
  DECK_SIZE,
  DROIDS,
  SHIP_NAMES
} = require './constant'

#----------------------------------------------------------------------

display = null

#----------------------------------------------------------------------

addDroids = ->

addMessages = ->
  shipName = SHIP_NAMES[window.game.shipId]
  window.game.messages = ["You board the Robo-Freighter #{shipName}."]

addPlayer = ->
  theShip = window.game.ship
  startingDeckIndex = DECK_DIFFICULTY.START.random()
  startingDeck = theShip.decks[startingDeckIndex]
  [x,y] = ship.findRandomObject startingDeck, DECK_OBJECT.EMPTY
  window.game.player ?=
    droid: DROIDS[0]
    x: -1
    y: -1
    z: -1
  window.game.player.x = x
  window.game.player.y = y
  window.game.player.z = startingDeckIndex

droidType = (id) ->
  return "Device" if id is "001"
  return "Cyborg" if id is "999"
  numId = parseInt id
  return "Robot" if numId < 500
  return "Droid"

handleResize = (event) ->
  # center the display canvas vertically in the window
  canvasHeight = document.body.firstChild.height
  spacerHeight = (innerHeight - canvasHeight) / 2
  document.body.firstChild.style.marginTop = "" + spacerHeight + "px"

initDisplay = ->
  document.body.innerHTML = ''
  display = new ROT.Display
    width: DISPLAY_SIZE.width
    height: DISPLAY_SIZE.height
    fontSize: 30
  document.body.appendChild display.getContainer()
  window.addEventListener 'resize', handleResize
  handleResize()
  updateDisplay()

initGame = ->
  # if we don't have a game object, create one
  window.game ?= {}         
  # if we don't have a starting ship, start at Metahawk
  window.game.shipId ?= 0
  # generate a ship layout
  window.game.ship = ship.create()
  # add messages to the game
  addMessages()
  # add the player to the ship
  addPlayer()
  # add hostile droids to the ship
  addDroids()

startGame = ->
  audio.play 'game-start'
  window.removeEventListener 'resize', handleResize
  mainGame.run()

updateDisplay = ->
  {droid} = window.game.player
  shipName = SHIP_NAMES[window.game.shipId]
  display.clear()
  display.drawText 0, 0, "Unit Type #{droid.id}: #{droid.klass} #{droidType droid.id}"
  display.drawText 0, 2, "This is the unit that you currently control. Prepare to board Robo-Freighter #{shipName} to eliminate all rogue robots."

# run this module
exports.run = ->
  # initialize the game
  initGame()
  # initialize the display
  initDisplay()
  # play the beam-on-to-ship sound effect
  # TODO: Revert; Just for dev/testing!
  #audio.play 'game-on'
  # start the game
  # TODO: Revert; Just for dev/testing!
  #setTimeout startGame, GAME_START_DELAY
  setTimeout startGame, 1
  
# debugging in browser
window.API.gameOn = exports if window?.API?

#----------------------------------------------------------------------
# end of gameOn.coffee
