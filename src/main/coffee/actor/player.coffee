# player.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

{
  DECK_OBJECT,
  DECK_SIZE
} = require '../constant'
{
  VK_DOWN, VK_LEFT, VK_RIGHT, VK_UP, VK_NUMPAD5,
  VK_NUMPAD2, VK_NUMPAD4, VK_NUMPAD6, VK_NUMPAD8,
  VK_SPACE
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
        window.game.messages.push "You move."
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

  use: ->
    {messages} = window.game
    {player} = window.game
    {ship} = window.game
    {x,y,z} = player
    switch ship.decks[z][x][y]
      when DECK_OBJECT.LIFT
        messages.push "The lift is broken. Even in the future nothing works!"
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
