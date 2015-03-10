# gameOn.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

audio = require './audio'

# run this module
exports.run = ->
  # play the beam-on-to-ship sound effect
  audio.play 'game-on'

# debugging in browser
window.API.gameOn = exports if window?.API?

#----------------------------------------------------------------------
# end of gameOn.coffee
