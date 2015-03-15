# door.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

CLOSE_TIMER = 3
SPEED = 100

class Door
  constructor: (@_x, @_y, @_z) ->
    @_closeTimer = CLOSE_TIMER
    @_doorKey = "#{@_x},#{@_y},#{@_z}"
    @_open = true
    @_speed = SPEED
  
  getSpeed: -> @_speed
  
  isOpen: -> @_open

  act: ->
    if @_open
      if @_closeTimer > 0
        @_closeTimer--
      else
        @close()

  close: ->
    occ = window.API.mainGame.occupied @_x, @_y, @_z
    console.log "#{@_x},#{@_y},#{@_z}: #{occ}"
    if window.API.mainGame.occupied @_x, @_y, @_z
      @_closeTimer = CLOSE_TIMER
    else
      @_open = false
    
  open: ->
    @_closeTimer = CLOSE_TIMER
    @_open = true

# export the actor class
exports.Door = Door

# debugging in browser
window.API.actor ?= {} if window?.API?
window.API.actor.door = exports if window?.API?

#----------------------------------------------------------------------
# end of door.coffee
