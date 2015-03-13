# briefing.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

audio = require './audio'
gameOn = require './gameOn'

#----------------------------------------------------------------------

BRIEFING = [ "BRIEFING: ParadroidRL",
"",
"Original Paradroid for Commodore 64",
"programmed by Andrew Braybrook.",
"",
"Begin Mission:   Space Bar",
"Scroll Briefing: Arrow Keys or NumPad",
"",
"----------------------------------------",
"",
"Clear the freighters of robots by",
"destroying them or by transferring",
"control to them.",
"",
"Control is by keyboard only.",
"Press '?' key to modify control mapping.",
"",
"o--o--< Default Control Mapping >--o--o",
"",
"?      = Control Mapping",
"A      = Select Weapon / Attack",
"NUMPAD = Movement and Ramming",
"T      = Toggle Transfer Mode",
"TAB    = Select Next Target",
"SPACE  = Use Console or Lift",
"X      = Cheat Console",
"",
"o-------------------------------------o",
"",
"Arrow keys and NumPad will move robot.",
"Press T to toggle transfer mode.",
"",
"Contact with another robot when mode",
"is engaged will initiate transfer.",
"",
"Press A to attack with available weapon.",
"Press TAB to switch between targets.",
"Press A again to fire chosen weapon.",
"",
"----------------------------------------",
"",
"A fleet of Robo-Freighters on",
"its way to the Beta Ceti system",
"reported entering an uncharted field",
"of asteroids. Each ship carries a",
"cargo of battle droids to reinforce",
"the outworld defences.",
"",
"Two distress beacons gave been",
"recovered. Similar messages were",
"stored on each. The ships had been",
"bombarded by a powerful radionic",
"beam from one of the asteroids.",
""
"All of the robots on the ships,",
"including those in storage, became",
"hyper-active. The crews report an",
"attack by droids, isolating them",
"on the bridge. They cannot reach the",
"shuttle and can hold out for only a",
"couple more hours.",
"",
"Since these beacons were located",
"two days ago, we can only fear the",
"worst.",
""
"Some of the fleet was last seen",
"heading for enemy space. In enemy",
"hands the droids can be used against",
"our forces.",
"",
"Docking would be impossible but",
"we can beam aboard a prototype",
"Influence Device.",
"",
"----------------------------------------",
"",
"The 001 Influence Device consists",
"of a helmet, which, when placed",
"over a robot's control unit can halt",
"the normal activities of that robot",
"for a short time. The helmet has",
"its own energy supply and powers",
"the robot itself, at an upgraded",
"capability. The helmet also uses",
"an energy cloak for protection of",
"the host.",
"",
"The helmet is fitted with twin",
"lasers mounted in a turret. These",
"can be focused on any target inside",
"a range of eight metres.",
"",
"Most of the device's resources are",
"channelled towards holding control",
"of the host robot, as it attempts",
"to resume 'normal' option.",
"",
"It is therefore necessary to change",
"the host robot often to prevent the",
"device from burning out. Transfer",
"to a new robot requires the device",
"to drain its host of energy in order",
"to take it over. Failure to archieve",
"transfer results in the device being",
"a free agent once more.",
"",
"----------------------------------------",
"",
"An Influence Device can transmit",
"only certain data, namely its own",
"location and the location of other",
"robots in visual range. This data is",
"merged with known ship layouts at",
"your remote terminal.",
"",
"Additional information about the",
"ship and robots may be obtained by",
"accessing the ship's computer at a",
"console. A small-scale plan of the",
"whole deck is available, as well",
"as a side elevation of the ship.",
"",
"Robots are represented on-screen",
"as a symbol showing a three-digit",
"number. The first digit shown is",
"the important one, the class of the",
"robot. It denotes the strength also.",
"",
"To find out more about any given",
"robot, use the robot enquiry system",
"at a console. Only data about units",
"of a lower class than your current",
"host is available, since it is the",
"host's security clearance which is",
"used to access the console.",
"",
"----------------------------------------",
"",
"Press SPACE BAR to Begin Mission.",
""
"END BRIEFING" ]

{
  VK_UP, VK_NUMPAD8, VK_PAGE_UP,
  VK_DOWN, VK_NUMPAD2, VK_PAGE_DOWN,
  VK_SPACE
} = ROT

DISPLAY_SIZE =
  width: 40
  height: 8

#----------------------------------------------------------------------

briefingScroll = 0
display = null

#----------------------------------------------------------------------

MAX_SCROLL = BRIEFING.length - DISPLAY_SIZE.height

handleKey = (event) ->
  switch event.keyCode
    when VK_UP, VK_NUMPAD8
      briefingScroll = Math.max 0, briefingScroll-1
      updateBriefing()
    when VK_PAGE_UP
      briefingScroll = Math.max 0, briefingScroll-DISPLAY_SIZE.height
      updateBriefing()
    when VK_DOWN, VK_NUMPAD2
      briefingScroll = Math.min MAX_SCROLL, briefingScroll+1
      updateBriefing()
    when VK_PAGE_DOWN
      briefingScroll = Math.min MAX_SCROLL, briefingScroll+DISPLAY_SIZE.height
      updateBriefing()
    when VK_SPACE
      window.removeEventListener 'keydown', handleKey
      window.removeEventListener 'resize', handleResize
      audio.stop 'briefing'
      gameOn.run()

handleResize = (event) ->
  # center the display canvas vertically in the window
  canvasHeight = document.body.firstChild.height
  spacerHeight = (innerHeight - canvasHeight) / 2
  document.body.firstChild.style.marginTop = "" + spacerHeight + "px"

initDisplay = ->
  document.body.innerHTML = ''
  display = new ROT.Display
    width: DISPLAY_SIZE.width
    height: DISPLAY_SIZE.height
    fontSize: 30
  document.body.appendChild display.getContainer()
  window.addEventListener 'resize', handleResize
  handleResize()
  updateBriefing()

updateBriefing = ->
  display.clear()
  for i in [0...DISPLAY_SIZE.height]
    display.drawText 0, i, BRIEFING[briefingScroll + i]

# run this module
exports.run = ->
  # add event handlers for keyboard input
  window.addEventListener 'keydown', handleKey
  # replace body with briefing display
  initDisplay()
  # loop the briefing theme
  audio.loop 'briefing'

# debugging in browser
window.API.briefing = exports if window?.API?

#----------------------------------------------------------------------
# end of briefing.coffee
