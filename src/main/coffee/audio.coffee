# audio.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

_ = require 'underscore'

SOUNDS = [
  "briefing",
  "game-on",
  "game-start"
]

sfx = {}

maybeAllLoaded = _.after SOUNDS.length, ->
  exports.allLoaded = true

loadSound = (name) ->
  audioObj = new Audio "sfx/#{name}.ogg"
  audioObj.onloadeddata = -> 
    console.log "Audio Loaded: #{name}"
    sfx[name] = audioObj
    maybeAllLoaded()
  audioObj.load()

if window?.Audio?
  audio = new Audio()
  if audio.canPlayType 'audio/ogg'
    loadSound name for name in SOUNDS

# true when all the sounds have been loaded
exports.allLoaded = false

# list of available sounds
exports.list = SOUNDS

# loop a sound effect
# @param name name of the sound effect to be looped
exports.loop = (name) ->
  if sfx[name]?
    sfx[name].loop = true
    sfx[name].play()

# play a sound effect
# @param name name of the sound effect to be played
exports.play = (name) ->
  if sfx[name]?
    sfx[name].play()

# stop a looping sound effect
# @param name name of the sound effect to be stopped
exports.stop = (name) ->
  if sfx[name]?
    sfx[name].loop = false
    sfx[name].pause()

# stop all sound effects
exports.stopAll = ->
  for name in SOUNDS
    if sfx[name]?
      sfx[name].loop = false
      sfx[name].pause()

# debugging in browser
window.API.audio = exports if window?.API?

#----------------------------------------------------------------------
# end of audio.coffee
