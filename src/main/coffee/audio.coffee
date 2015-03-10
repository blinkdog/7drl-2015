# audio.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

SOUNDS = [
  "briefing",
  "game-on"
]

sfx = {}

loadSound = (name) ->
  audioObj = new Audio "sfx/#{name}.ogg"
  audioObj.onloadeddata = -> 
    console.log "Audio Loaded: #{name}"
    sfx[name] = audioObj
  audioObj.load()

if window?.Audio?
  audio = new Audio()
  if audio.canPlayType 'audio/ogg'
    loadSound name for name in SOUNDS

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

# debugging in browser
window.API.audio = exports if window?.API?

#----------------------------------------------------------------------
# end of audio.coffee
