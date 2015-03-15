# player.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

audio = require '../audio'
{
  DECK_OBJECT,
  DECK_NAMES,
  DECK_SIZE
} = require '../constant'
tui = require '../tui'

{
  VK_DOWN, VK_LEFT, VK_RIGHT, VK_UP, VK_NUMPAD5,
  VK_NUMPAD2, VK_NUMPAD4, VK_NUMPAD6, VK_NUMPAD8,
  VK_RETURN, VK_SPACE
} = ROT

SPEED = 100

class Player
  constructor: ->
    @_speed = SPEED

  act: ->
    window.API.mainGame.lockEngine()
    window.addEventListener 'keydown', @handleKey

  getSpeed: -> @_speed

  handleKey: (event) =>
    {player} = window.game
    {ship} = window.game
    command = false
    nx = -1
    ny = -1
    switch event.keyCode
      when VK_UP, VK_NUMPAD8
        nx = player.x
        ny = Math.max 0, player.y-1
        command = true
      when VK_DOWN, VK_NUMPAD2
        nx = player.x
        ny = Math.min DECK_SIZE.height-1, player.y+1
        command = true
      when VK_LEFT, VK_NUMPAD4
        nx = Math.max 0, player.x-1
        ny = player.y
        command = true
      when VK_RIGHT, VK_NUMPAD6
        nx = Math.min DECK_SIZE.width-1, player.x+1
        ny = player.y
        command = true
      when VK_NUMPAD5
        window.game.messages.push "You wait."
        command = true
      when VK_SPACE
        @use()
        command = true
    # if the player tried to move
    if (nx isnt -1) or (ny isnt -1)
      walk = window.API.mainGame.walkable nx, ny, player.z
      if walk
        player.x = nx
        player.y = ny
        # TODO: Should we inform the player every time they move? Probably not.
        #window.game.messages.push "You move."
      else
        # determine why we can't walk
        switch ship.decks[player.z][nx][ny]
          when DECK_OBJECT.WALL
            window.game.messages.push "You collide with the wall."
          when DECK_OBJECT.DOOR_H, DECK_OBJECT.DOOR_V
            {ship} = window.game
            doorKey = "#{nx},#{ny},#{player.z}"
            doorActor = ship.doors[doorKey]
            doorActor.open()
            window.game.messages.push "You open the door."
          else
            window.game.messages.push "You can't walk there. I don't know why."
    # if a command was issued
    if command
      # resume the game
      window.removeEventListener 'keydown', @handleKey
      window.API.mainGame.unlockEngine()

  selectDeck: (oldDeck) ->
    {player} = window.game
    {ship} = window.game
    # don't want the game to resume until the player selects a deck
    window.API.mainGame.lockEngine()
    # figure out where the player can go
    x = player.x
    y = player.y
    currentDeck = player.z
    minDeck = currentDeck
    maxDeck = currentDeck
    while (minDeck > 0) and (ship.decks[minDeck-1][x][y] is DECK_OBJECT.LIFT)
      minDeck--
    while (maxDeck < ship.decks.length-1) and (ship.decks[maxDeck+1][x][y] is DECK_OBJECT.LIFT)
      maxDeck++
    # here's a handler for the deck selection keypresses
    handleDeckKey = (event) =>
      finished = false
      switch event.keyCode
        when VK_UP, VK_NUMPAD8
          if currentDeck > minDeck
            currentDeck--
            audio.play 'lift'
        when VK_DOWN, VK_NUMPAD2
          if currentDeck < maxDeck
            currentDeck++
            audio.play 'lift'
        when VK_RETURN, VK_SPACE
          finished = true
      # update the display to reflect keypress
      tui.renderSelectDeck window.API.mainGame.display, currentDeck, minDeck, maxDeck
      if finished
        if currentDeck isnt oldDeck
          player.z = currentDeck
          {messages} = window.game
          messages.push "You take the lift to Deck %s: %s.".format (""+(currentDeck+1)).lpad('0',2), DECK_NAMES[currentDeck]
        # clear the display to get rid of the deck selection
        window.API.mainGame.display.clear()
        # back to the regular game
        window.removeEventListener 'keydown', handleDeckKey
        window.API.mainGame.unlockEngine()
    # start handling deck selection keypresses
    window.addEventListener 'keydown', handleDeckKey
    # show the player the deck selection screen
    setTimeout (-> tui.renderSelectDeck window.API.mainGame.display, currentDeck, minDeck, maxDeck), 1

  use: ->
    {messages} = window.game
    {player} = window.game
    {ship} = window.game
    {x,y,z} = player
    switch ship.decks[z][x][y]
      when DECK_OBJECT.LIFT
        window.removeEventListener 'keydown', @handleKey
        @selectDeck z
      when DECK_OBJECT.DOOR_H, DECK_OBJECT.DOOR_V
        messages.push "The door will close by itself."
      else
        messages.push "There is nothing here to use."
    
# export the actor class
exports.Player = Player

# debugging in browser
window.API.actor ?= {} if window?.API?
window.API.actor.player = exports if window?.API?

#----------------------------------------------------------------------
# end of player.coffee
