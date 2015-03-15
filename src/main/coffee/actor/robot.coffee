# robot.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

mainGame = require '../mainGame'

{
  DECK_OBJECT,
  DECK_SIZE
} = require '../constant'

MAX_DEST_MOVES = 100

TOPOLOGY =
  topology: 4

class Robot
  constructor: (@_droid, @_x, @_y, @_z) ->
    @_speed = Math.floor(parseInt(@_droid.id) / 10)
    @_destination = null
    @_destMoves = -1
    @ch = @_droid.id.substring 0, 1
    @fg = ROT.Color.toHex ROT.Color.randomize([192, 192, 192], [32, 32, 32])

  getSpeed: -> @_speed

  act: ->
    # bail if the robot isn't on the same deck as the player
    return if @_z isnt window.game.player.z
    # if we don't have anywhere to go
    if (@_destination is null) or (@_destMoves < 1)
      @chooseDestination()
    @move()

  chooseDestination: ->
    {ship} = window.game
    @_destination = null
    @_destMoves = MAX_DEST_MOVES
    while @_destination is null
      x = Math.floor DECK_SIZE.width * Math.random()
      y = Math.floor DECK_SIZE.height * Math.random()
      if ship.decks[@_z][x][y] is DECK_OBJECT.EMPTY
        @_destination = [x,y,@_z]

  move: ->
    [nx,ny] = @calcMove()
    @doMove nx, ny
    
  calcMove: ->
    # use up one of our move allowances
    @_destMoves--
    # determine where we can (eventually) legally move
    passableCallback = (x,y) =>
      {ship} = window.game
      return (ship.decks[@_z][x][y] isnt DECK_OBJECT.WALL)
    # prepare path to given coords
    astar = new ROT.Path.AStar @_destination[0], @_destination[1], passableCallback, TOPOLOGY
    # determine how to get to our destination from where we are
    nx = -1
    ny = -1
    astar.compute @_x, @_y, (x,y) =>
      # capture only the next step
      if (nx is -1) and (ny is -1)
        if (x isnt @_x) or (y isnt @_y)
          nx = x
          ny = y
    # if we didn't get any steps, warn
    # TODO: Fix this
#    if (nx is -1) and (ny is -1)
#      console.log "WARNING: Robot #{@_x},#{@_y},#{@_z} unable to determine path."
    # return the next step to the caller
    return [nx, ny]

  doMove: (nx, ny) ->
    # if we didn't get a next step, bail
    return if (nx is -1) and (ny is -1)
    # if the destination is walkable
    if mainGame.walkable nx, ny, @_z
      # walk there
      @_x = nx
      @_y = ny
      return
    # can we make the destination walkable?
    {ship} = window.game
    switch ship.decks[@_z][nx][ny]
      # if a door is blocking the way
      when DECK_OBJECT.DOOR_H, DECK_OBJECT.DOOR_V
        # open the door
        doorKey = "#{nx},#{ny},#{@_z}"
        ship.doors[doorKey].open()
    # otherwise it's another robot or the player
    # don't wait around forever
    @_destMoves -= (10 + Math.floor 10 * Math.random())

# export the actor class
exports.Robot = Robot

# debugging in browser
window.API.actor ?= {} if window?.API?
window.API.actor.robot = exports if window?.API?

#----------------------------------------------------------------------
# end of robot.coffee
