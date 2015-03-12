# mainGame.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

# run this module
exports.run = ->
  alert "Now playing Paradroid!"

# debugging in browser
window.API.mainGame = exports if window?.API?

#----------------------------------------------------------------------
# end of mainGame.coffee
