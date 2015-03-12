# bsod.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

exports.DELAY = 30000 #ms = 30 sec

audio = require './audio'

display = null

handleResize = (event) ->
  # center the display canvas vertically in the window
  canvasHeight = document.body.firstChild.height
  spacerHeight = (innerHeight - canvasHeight) / 2
  document.body.firstChild.style.marginTop = "" + spacerHeight + "px"

updateDisplay = ->
  display.clear()
  display.drawText(36, 6, "%b{#bbb}%c{#00f}Windows");
  display.draw(35, 6, " ", "#00f", "#bbb");
  display.draw(43, 6, " ", "#00f", "#bbb");
  display.drawText(3, 8, "%c{#fff}A fatal exception 0E has occurred at 0028:C0011E36 in VXD VMM(01) + 00010E36. The current application will be terminated.", 70);
  display.drawText(3, 11, "%c{#fff}*  Press any key to terminate the current application.");
  display.drawText(3, 12, "%c{#fff}*  Press CTRL+ALT+DEL again to restart your computer. You will");
  display.drawText(6, 13, "%c{#fff}lose any unsaved information in all applications.");
  display.drawText(25, 15, "%c{#fff}Press any key to continue _");

# http://stackoverflow.com/a/20411654
exports.isMSIE = ->
  if navigator?.userAgent?
    return true if navigator.userAgent.indexOf('MSIE') isnt -1
  if navigator?.appVersion?
    return true if navigator.appVersion.indexOf('Trident/') > 0
  return true if window?.msRequestAnimationFrame?
  return false

exports.run = ->
  audio.stopAll()
  document.body.innerHTML = ''
  display = new ROT.Display
    width: 80
    height: 25
    bg: "#00f"
    fontSize: 15
    fontFamily: 'monospace'
  document.body.appendChild display.getContainer()
  window.addEventListener 'resize', handleResize
  handleResize()
  updateDisplay()

# debugging in browser
window.API.bsod = exports if window?.API?

#----------------------------------------------------------------------
# end of bsod.coffee
