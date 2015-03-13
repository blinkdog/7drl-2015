# mainGame.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

bsod = require './bsod'
{DECK_NAMES} = require './constant'
{TILEMAP, TILESET} = require './tiles'

DISPLAY_SIZE =
  width: 80
  height: 50

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
  updateDisplay()

updateDisplay = ->
  display.clear()
  # clear to magic pink
  for x in [0...DISPLAY_SIZE.width]
    for y in [0...DISPLAY_SIZE.height]
      display.draw x, y, "#", "#f0f", "#000"
  # clear title bar
  for x in [0...DISPLAY_SIZE.width]
    display.draw x, 0, " "
  # draw title bar
  {player} = window.game
  px = (""+player.x).lpad "0", 2
  py = (""+player.y).lpad "0", 2
  pz = DECK_NAMES[player.z]
  display.drawText 0, 0, "Deck:%s (%s,%s)".format pz, px, py

# run this module
exports.run = ->
  doBSOD = ->
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
