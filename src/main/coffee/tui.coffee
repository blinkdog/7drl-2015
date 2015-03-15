# tui.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

{
  DECK_NAMES,
  DECK_OBJECT,
  DECK_SIZE,
  DISPLAY_SIZE,
  NUM_MESSAGES
} = require './constant'
pkg = require '../package'

DECKMAP =
  LOCATION:
    X: DISPLAY_SIZE.width-(DECK_SIZE.width+2)
    Y: 1
  SIZE:
    WIDTH: DECK_SIZE.width
    HEIGHT: DECK_SIZE.height

DECKSELECT =
  LOCATION:
    X: Math.floor (DISPLAY_SIZE.width-(DECK_SIZE.width+2))/2
    Y: Math.floor (DISPLAY_SIZE.height-(DECK_NAMES.length+2))/2
  SIZE:
    WIDTH: DECK_SIZE.width+2
    HEIGHT: DECK_NAMES.length

FOVMAP =
  LOCATION:
    X: 4
    Y: 5
  SIZE:
    WIDTH: 9
    HEIGHT: 9

LEVELMAP =
  LOCATION:
    X: DECKMAP.LOCATION.X - 6
    Y: DECKMAP.LOCATION.Y
  SIZE:
    WIDTH: 3
    HEIGHT: 16

MESSAGELOG =
  LOCATION:
    X: 0
    Y: DISPLAY_SIZE.height-(NUM_MESSAGES+1)
  SIZE:
    WIDTH: DISPLAY_SIZE.width
    HEIGHT: NUM_MESSAGES

DO_MAP_TILE = {}
DO_MAP_TILE[DECK_OBJECT.EMPTY] = "."
DO_MAP_TILE[DECK_OBJECT.WALL] = "▒"
DO_MAP_TILE[DECK_OBJECT.DOOR_H] = "─"
DO_MAP_TILE[DECK_OBJECT.DOOR_V] = "│"
DO_MAP_TILE[DECK_OBJECT.LIFT] = "↕"
DO_MAP_TILE[DECK_OBJECT.CONSOLE] = "Φ"
DO_MAP_TILE[DECK_OBJECT.ENERGIZER] = "%"

#----------------------------------------------------------------------

# clear a boxed area
clearBox = (display, x1, y1, x2, y2) ->
  for x in [x1..x2]
    for y in [y1..y2]
      display.draw x, y, " ", "#fff", "#000"

# clear an entire row
clearRow = (display, row) ->
  for x in [0...DISPLAY_SIZE.width]
    display.draw x, row, " ", "#fff", "#000"

# draw a double-thick box
drawBox = (display, x1, y1, x2, y2, fg, bg) ->
  clearBox display, x1, y1, x2, y2
  for x in [x1..x2]
    display.draw x, y1, "═", fg, bg
    display.draw x, y2, "═", fg, bg
  for y in [y1..y2]
    display.draw x1, y, "║", fg, bg
    display.draw x2, y, "║", fg, bg
  display.draw x1, y1, "╔", fg, bg
  display.draw x2, y1, "╗", fg, bg
  display.draw x1, y2, "╚", fg, bg
  display.draw x2, y2, "╝", fg, bg

#----------------------------------------------------------------------

# clear display to magic pink
magicPink = (display) ->
  for x in [0...DISPLAY_SIZE.width]
    for y in [0...DISPLAY_SIZE.height]
      display.draw x, y, "#", "#f0f", "#000"

# draw the complete title bar
titleBar = (display) ->
  clearRow display, 0
  # display the name of the game
  display.drawText 0, 0, "ParadroidRL v%s".format pkg.version
  # display the player's current location
  {player} = window.game
  px = (""+player.x).lpad "0", 2
  py = (""+player.y).lpad "0", 2
  deckName = DECK_NAMES[player.z]
  pz = (""+(player.z+1)).lpad "0", 2
  location = "Deck %s: %s (%s,%s)".format pz, deckName, px, py
  display.drawText DISPLAY_SIZE.width - location.length, 0, location

# draw the complete status bar
statusBar = (display) ->
  lastRow = DISPLAY_SIZE.height-1
  clearRow display, lastRow
  {player} = window.game
  display.drawText 0, lastRow, "[%s]".format player.droid.id

# draw a map of the deck in a box
deckMap = (display) ->
  # draw the border of the deck map
  x1 = DECKMAP.LOCATION.X
  y1 = DECKMAP.LOCATION.Y
  x2 = DECKMAP.LOCATION.X + DECKMAP.SIZE.WIDTH + 1
  y2 = DECKMAP.LOCATION.Y + DECKMAP.SIZE.HEIGHT + 1
  drawBox display, x1, y1, x2, y2, '#888', '#000'
  # draw the layout of the deck itself
  {player} = window.game
  deck = window.game.ship.decks[player.z]
  view = window.game.ship.views[player.z]
# TODO: Revealing the deck map, or not? Let's try the reveal-as-we-view...
#  for x in [0...DECK_SIZE.width]
#    for y in [0...DECK_SIZE.height]
#      color = if view[x][y] then '#2f0' else '#888'
#      display.draw x1+x+1, y1+y+1, DO_MAP_TILE[deck[x][y]], color, '#000'
  for x in [0...DECK_SIZE.width]
    for y in [0...DECK_SIZE.height]
      if view[x][y]
        ch = DO_MAP_TILE[deck[x][y]]
        ch = '.' if deck[x][y] is DECK_OBJECT.EMPTY
        display.draw x1+x+1, y1+y+1, ch, '#2f0', '#000'
  # add the YOU ARE HERE player icon
  display.draw x1+player.x+1, y1+player.y+1, '@', '#fff', '#000'

# draw the field-of-view play area in a box
fovMap = (display) ->
  # draw the box around the FOV map
  x1 = FOVMAP.LOCATION.X
  y1 = FOVMAP.LOCATION.Y
  x2 = FOVMAP.LOCATION.X + FOVMAP.SIZE.WIDTH + 1
  y2 = FOVMAP.LOCATION.Y + FOVMAP.SIZE.HEIGHT + 1
  drawBox display, x1, y1, x2, y2, '#888', '#000'
  # create the FOV input callback
  {player, ship} = window.game
  deck = ship.decks[player.z]
  view = ship.views[player.z]
  lightPasses = (x,y) ->
    return false if (x < 0) or (x >= DECK_SIZE.width)
    return false if (y < 0) or (y >= DECK_SIZE.height)
    switch deck[x][y]
      when DECK_OBJECT.EMPTY, DECK_OBJECT.LIFT
        return true
      when DECK_OBJECT.DOOR_H, DECK_OBJECT.DOOR_V
        return ship.doors[x+","+y+","+player.z].isOpen()
    return false
  # compute the FOV
  fov = new ROT.FOV.PreciseShadowcasting lightPasses
  fov.compute player.x, player.y, 4, (x, y, r, visibility) ->
    return if (x < 0) or (x >= DECK_SIZE.width)
    return if (y < 0) or (y >= DECK_SIZE.height)
    view[x][y] = true
    ch = DO_MAP_TILE[deck[x][y]]
    switch deck[x][y]
      when DECK_OBJECT.DOOR_H, DECK_OBJECT.DOOR_V
        ch = ' ' if ship.doors[x+","+y+","+player.z].isOpen()
    dx = x1+5 + (x-player.x)
    dy = y1+5 + (y-player.y)
    if dx > x1 and dx < x2 and dy > y1 and dy < y2
      display.draw dx, dy, ch, '#2f0', '#000'
  # draw all of the droids
  {droids} = window.game
  for droid in droids
    # if the droid is on the same deck
    if droid._z is player.z
      drx = droid._x - player.x
      dry = droid._y - player.y
      dx = x1+5+drx
      dy = y1+5+dry
      if dx > x1 and dx < x2 and dy > y1 and dy < y2
        display.draw dx, dy, droid.ch, droid.fg, '#000'
  # draw the YOU ARE HERE player icon
  display.draw x1+5, y1+5, '@', '#fff', '#000'

# draw the indicator of our current height (deck) in the ship
levelMap = (display) ->
  # draw the border of the level map
  x1 = LEVELMAP.LOCATION.X
  y1 = LEVELMAP.LOCATION.Y
  x2 = LEVELMAP.LOCATION.X + LEVELMAP.SIZE.WIDTH + 1
  y2 = LEVELMAP.LOCATION.Y + LEVELMAP.SIZE.HEIGHT + 1
  drawBox display, x1, y1, x2, y2, '#888', '#000'
  # draw the column of levels; ignore color for now
  {ship} = window.game
  for y in [0...ship.decks.length]
    display.draw x1+2, y1+y+1, '▒', '#888', '#000'
  # draw arrows indicating the current position of the player
  {z} = window.game.player
  display.draw x1+1, y1+z+1, '→', '#888', '#000'
  display.draw x1+3, y1+z+1, '←', '#888', '#000'

# display the latest log messages
messageLog = (display) ->
  # clear out the message log area
  x1 = MESSAGELOG.LOCATION.X
  y1 = MESSAGELOG.LOCATION.Y
  x2 = MESSAGELOG.LOCATION.X + MESSAGELOG.SIZE.WIDTH - 1
  y2 = MESSAGELOG.LOCATION.Y + MESSAGELOG.SIZE.HEIGHT - 1
  clearBox display, x1, y1, x2, y2
  # display any messages we might have
  {messages} = window.game
  dispMessages = messages.slice -NUM_MESSAGES
  for i in [0...dispMessages.length]
    display.drawText 0, MESSAGELOG.LOCATION.Y+i, dispMessages[i]

# draw something to let the user select a (deck) in the ship
deckSelect = (display, currentDeck, minDeck, maxDeck) ->
  # draw the border of the level map
  x1 = DECKSELECT.LOCATION.X
  y1 = DECKSELECT.LOCATION.Y
  x2 = DECKSELECT.LOCATION.X + DECKSELECT.SIZE.WIDTH + 1
  y2 = DECKSELECT.LOCATION.Y + DECKSELECT.SIZE.HEIGHT + 1
  drawBox display, x1, y1, x2, y2, '#888', '#000'
  # draw the column of levels; ignore color for now
  {ship} = window.game
  for y in [0...ship.decks.length]
    color = '#888'
    color = '#ccc' if (y >= minDeck) and (y <= maxDeck)
    color = '#2f0' if y is currentDeck
    for x in [0...DECK_SIZE.width]
      display.draw x1+x+2, y1+y+1, '▒', color, '#000'
  # draw arrows indicating the current position of the player
  z = currentDeck
  display.draw x1+1, y1+z+1, '→', '#f20', '#000'
  display.draw x1+DECK_SIZE.width+2, y1+z+1, '←', '#f20', '#000'

#----------------------------------------------------------------------

# render the text user interface to the ROT.Display
# @param display display on which to render the TUI
exports.render = (display) ->
  magicPink display   # TODO: Remove; Just for dev/test!
  titleBar display
  statusBar display
  fovMap display
  deckMap display
  levelMap display
  messageLog display

exports.renderSelectDeck = (display, currentDeck, minDeck, maxDeck) ->
  deckSelect display, currentDeck, minDeck, maxDeck

# debugging in browser
window.API.tui = exports if window?.API?

#----------------------------------------------------------------------
# end of tui.coffee
