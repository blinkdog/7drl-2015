# paradroid.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

# let's get our resources loading ASAP
audio = require './audio'
tiles = require './tiles'

#briefing = require './briefing'
briefing = require './gameOn'     # TODO: Revert; This is just for dev/test!

checkResources = ->
  if audio.allLoaded and tiles.allLoaded
    console.log "Resources loaded!"
    briefing.run()
  else
    console.log "checkResources in 500ms..."
    setTimeout (-> checkResources()), 500

exports.run = ->
  checkResources()

#----------------------------------------------------------------------
# end of paradroid.coffee
