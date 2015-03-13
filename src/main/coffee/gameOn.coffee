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
  DECK_SIZE,
  SHIP_NAMES
} = require './constant'

#----------------------------------------------------------------------

display = null

#----------------------------------------------------------------------

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
  if not window.game?
    window.game =
      droid:
        type: "001"
        klass: "Influence Device"
      ship: null
      shipId: 0
  window.game.ship = ship.create()

startGame = ->
  audio.play 'game-start'
  mainGame.run()

updateDisplay = ->
  {droid} = window.game
  shipName = SHIP_NAMES[window.game.shipId]
  display.clear()
  display.drawText 0, 0, "Unit Type #{droid.type}: #{droid.klass}"
  display.drawText 0, 2, "This is the unit that you currently control. Prepare to board Robo-Freighter #{shipName} to eliminate all rogue robots."

# run this module
exports.run = ->
  # initialize the game
  initGame()
  # initialize the display
  initDisplay()
  # play the beam-on-to-ship sound effect
  audio.play 'game-on'
  # start the game
  setTimeout startGame, GAME_START_DELAY
  
# debugging in browser
window.API.gameOn = exports if window?.API?

#----------------------------------------------------------------------
# end of gameOn.coffee
