# mainGame.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

bsod = require './bsod'

# run this module
exports.run = ->
  # if this is MSIE, create a BSOD
  setTimeout (-> bsod.run()), bsod.DELAY if bsod.isMSIE()
  # let's play ParadroidRL
  alert "Now playing Paradroid!"

# debugging in browser
window.API.mainGame = exports if window?.API?

#----------------------------------------------------------------------
# end of mainGame.coffee
