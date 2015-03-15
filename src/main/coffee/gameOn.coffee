# gameOn.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

audio = require './audio'
mainGame = require './mainGame'
{Robot} = require './actor/robot'
ship = require './ship'

#----------------------------------------------------------------------

DISPLAY_SIZE =
  width: 40
  height: 8

GAME_START_DELAY = 4250 #ms

{
  CYBORG,
  DECK_DIFFICULTY,
  DECK_NAMES,
  DECK_OBJECT,
  DECK_SIZE,
  DROIDS,
  DROIDS_PER_DECK,
  SHIP_NAMES
} = require './constant'

#----------------------------------------------------------------------

display = null

#----------------------------------------------------------------------

addDroids = ->
  # initialize some things
  {player} = window.game
  theShip = window.game.ship
  droids = []
  window.game.droids = droids
  # for each deck on the ship
  for z in [0...DECK_NAMES.length-1]
    theDeck = theShip.decks[z]
    numDroids = 0
    # generate a number of droids
    while numDroids < DROIDS_PER_DECK
      [x,y] = ship.findRandomObject theDeck, DECK_OBJECT.EMPTY
      # make sure we don't start on top of the player
      if (x isnt player.x) or (y isnt player.y) or (z isnt player.z)
        # create the new droid
        droid = new Robot droidSpec(z), x, y, z
        droids.push droid
        numDroids++
  # generate a 999 command cyborg on the bridge
  bridgeDeckIndex = DECK_NAMES.indexOf "Bridge"
  bridgeDeck = theShip.decks[bridgeDeckIndex]
  [x,y] = ship.findRandomObject bridgeDeck, DECK_OBJECT.EMPTY
  cyborg = new Robot CYBORG, x, y, bridgeDeckIndex
  droids.push cyborg

droidSpec = (z) ->
  droidChoice = null
  while droidChoice is null
    # pick a random droid
    droidChoice = DROIDS.random()
    droidClass = parseInt droidChoice.id.substring 0, 1
    # filter out any inappropriate choices
    switch droidClass
      when 0, 9
        # 001 is the player, we never generate those
        # 999 is the command cyborg, a unique special
        droidChoice = null
      when 1, 2, 3
        if not (z in DECK_DIFFICULTY.EASY)
          droidChoice = null
      when 4, 5, 6
        if not (z in DECK_DIFFICULTY.NORMAL)
          droidChoice = null
      when 7, 8
        if not (z in DECK_DIFFICULTY.HARD)
          droidChoice = null
  return droidChoice

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
  audio.play 'game-on'
  # start the game
  setTimeout startGame, GAME_START_DELAY
  
# debugging in browser
window.API.gameOn = exports if window?.API?

#----------------------------------------------------------------------
# end of gameOn.coffee
