# mainGame.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

bsod = require './bsod'
{
  DECK_NAMES,
  DECK_SIZE,
  DISPLAY_SIZE
} = require './constant'
{
  TILEMAP,
  TILESET
} = require './tiles'
tui = require './tui'

#----------------------------------------------------------------------

display = null

#----------------------------------------------------------------------

handleKey = (event) ->
  {
    VK_DOWN, VK_LEFT, VK_RIGHT, VK_UP
  } = ROT
  {player} = window.game
  switch event.keyCode
    when VK_UP
      player.y = Math.max 0, player.y-1
      updateDisplay()
    when VK_DOWN
      player.y = Math.min DECK_SIZE.height-1, player.y+1
      updateDisplay()
    when VK_LEFT
      player.x = Math.max 0, player.x-1
      updateDisplay()
    when VK_RIGHT
      player.x = Math.min DECK_SIZE.width-1, player.x+1
      updateDisplay()

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
  document.body.appendChild display.getContainer()
  window.addEventListener 'resize', handleResize
  handleResize()
  redrawDisplay()

redrawDisplay = ->
  display.clear()
  updateDisplay()

updateDisplay = ->
  tui.render display

# run this module
exports.run = ->
  # respond to keyboard commands
  window.addEventListener 'keydown', handleKey
  # respond to keyboard commands
  doBSOD = ->
    window.removeEventListener 'keydown', handleKey
    window.removeEventListener 'resize', handleResize
    bsod.run()
  # if this is MSIE, create a BSOD
  setTimeout (-> doBSOD()), bsod.DELAY if bsod.isMSIE()
  # initialize the display
  initDisplay()

# debugging in browser
window.API.mainGame = exports if window?.API?

#----------------------------------------------------------------------
# end of mainGame.coffee
