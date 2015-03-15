# mainGame.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

bsod = require './bsod'
{
  DECK_NAMES,
  DECK_OBJECT,
  DECK_SIZE,
  DISPLAY_SIZE
} = require './constant'
{Player} = require './actor/player'
{
  TILEMAP,
  TILESET
} = require './tiles'
tui = require './tui'

#----------------------------------------------------------------------

display = null
engine = null
scheduler = null

#----------------------------------------------------------------------

handleResize = (event) ->
  # center the display canvas vertically in the window
  canvasHeight = document.body.firstChild.height
  spacerHeight = (innerHeight - canvasHeight) / 2
  document.body.firstChild.style.marginTop = "" + spacerHeight + "px"

initDisplay = ->
  document.body.innerHTML = ''
  display = new ROT.Display
    layout: "tile"
    tileWidth: 8
    tileHeight: 8
    tileSet: TILESET
    tileMap: TILEMAP
    width: DISPLAY_SIZE.width
    height: DISPLAY_SIZE.height
    tileColorize: true
  window.API.mainGame.display = display
  document.body.appendChild display.getContainer()
  window.addEventListener 'resize', handleResize
  handleResize()
  redrawDisplay()

initEngine = ->
  ONE_TIME = false
  REPEAT   = true
  # create the engine and scheduler
  scheduler = new ROT.Scheduler.Speed()
  engine = new ROT.Engine scheduler
  # add the doors to the scheduler
  {ship} = window.game
  for doorKey of ship.doors
    doorActor = ship.doors[doorKey]
    scheduler.add doorActor, REPEAT
  # create the player actor
  playerActor = new Player()
  # add the player to the scheduler
  scheduler.add playerActor, REPEAT

redrawDisplay = ->
  display.clear()
  updateDisplay()

updateDisplay = ->
  tui.render display

exports.lockEngine = ->
  # lock the engine until user input is finished
  engine.lock()

exports.unlockEngine = ->
  # user input is finished, unlock the engine
  updateDisplay()
  engine.unlock()

exports.occupied = (x,y,z) ->
  # if the player is standing there
  {player} = window.game
  if (player.x is x) and (player.y is y) and (player.z is z)
    console.log "Player is at #{x},#{y},#{z}"
    return true
  # nobody there
  return false

exports.walkable = (x,y,z) ->
  {ship} = window.game
  # if there is a wall there
  if (ship.decks[z][x][y] is DECK_OBJECT.WALL)
    return false
  # if the player is standing there
  {player} = window.game
  if (player.x is x) and (player.y is y) and (player.z is z)
    return false
  # if a closed door is there
  for doorKey of ship.doors
    doorActor = ship.doors[doorKey]
    if (doorActor._x is x) and (doorActor._y is y) and (doorActor._z is z) and (doorActor.isOpen() is false)
      return false
  # nobody there
  return true

# run this module
exports.run = ->
  initEngine()
  # respond to keyboard commands
  doBSOD = ->
    window.removeEventListener 'keydown', handleKey
    window.removeEventListener 'resize', handleResize
    bsod.run()
  # if this is MSIE, create a BSOD
  setTimeout (-> doBSOD()), bsod.DELAY if bsod.isMSIE()
  # initialize the display
  initDisplay()
  # start the game
  engine.start()

# debugging in browser
window.API.mainGame = exports if window?.API?

#----------------------------------------------------------------------
# end of mainGame.coffee
