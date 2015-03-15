# constant.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

# START:  001 (Player)
# EASY:   1xx-3xx
# NORMAL: 4xx-6xx
# HARD:   7xx-9xx
exports.DECK_DIFFICULTY =
  START:  [    2,3,4,                      14   ]
  EASY:   [  1,2,3,4,5,6,    9,10,11,      14,15]
  NORMAL: [0,1,      5,6,  8,9,      12,13,   15]
  HARD:   [  1,          7,    10,11,         15]

exports.DECK_NAMES = [
  "Observation Deck",
  "Bridge",
  "Reactor",
  "Research",
  "Stores",
  "Staterooms",
  "Repairs",
  "Quarters",
  "Robo-Stores",
  "Shuttle Bay",
  "Mid-Cargo",
  "Upper Cargo",
  "Engineering",
  "Maintenance",
  "Airlock",
  "Vehicle Hold" ]

exports.DECK_OBJECT =
  EMPTY: 0
  WALL: 1
  DOOR_H: 2
  DOOR_V: 3
  LIFT: 4
  CONSOLE: 5
  ENERGIZER: 6
  
exports.DECK_SIZE =
  width: 38
  height: 16

exports.DISPLAY_SIZE =
  width: 80
  height: 35

DROID_01 =
  id: "001"
  entry: "01"
  klass: "Influence"
  height: 1.00
  weight: 27
  drive: "none"
  brain: "none"
  armament: "lasers"
  sensors: []
  notes: "Robot activity influence device. This helmet is self-powered and will control any robot for a short time. Lasers are turret mounted."

DROID_02 =
  id: "123"
  entry: "02"
  klass: "Disposal"
  height: 1.37
  weight: 85
  drive: "tracks"
  brain: "none"
  armament: "none"
  sensors: ["spectral", "infra-red"]
  notes: "Simple rubbish disposal robot. Common device in most space craft to maintain a clean ship."

DROID_03 =
  id: "139"
  entry: "03"
  klass: "Disposal"
  height: 1.22
  weight: 61
  drive: "anti-grav"
  brain: "none"
  armament: "none"
  sensors: ["spectral"]
  notes: "Created by Dr. Masternak to clean up large heaps of rubbish. Its large scoop is used to collect rubbish. It is then crushed internally."

DROID_04 =
  id: "247"
  entry: "04"
  klass: "Servant"
  height: 1.56
  weight: 78
  drive: "anti-grav"
  brain: "neutronic"
  armament: "none"
  sensors: ["spectral"]
  notes: "Light duty servant robot. One of the first to use the anti-grav system."

DROID_05 =
  id: "249"
  entry: "05"
  klass: "Servant"
  height: 1.63
  weight: 83
  drive: "tripedal"
  brain: "neutronic"
  armament: "none"
  sensors: ["spectral"]
  notes: "Cheaper version of the anti-grav servant robot."

DROID_06 =
  id: "296"
  entry: "06"
  klass: "Servant"
  height: 1.20
  weight: 47
  drive: "tracks"
  brain: "neutronic"
  armament: "none"
  sensors: ["spectral"]
  notes: "This robot is used mainly for serving drinks. A tray is mounted on the head. Built by Orchard and Marsden Enterprises."

DROID_07 =
  id: "302"
  entry: "07"
  klass: "Messenger"
  height: 1.07
  weight: 23
  drive: "anti-grav"
  brain: "none"
  armament: "none"
  sensors: ["spectral"]
  notes: "Common device for moving small packages. Clamp is mounted on the lower body."

DROID_08 =
  id: "329"
  entry: "08"
  klass: "Messenger"
  height: 1.07
  weight: 31
  drive: "wheels"
  brain: "none"
  armament: "none"
  sensors: ["spectral"]
  notes: "Early type messenger robot. Large wheels impede motion on small craft."

DROID_09 =
  id: "420"
  entry: "09"
  klass: "Maintenance"
  height: 1.41
  weight: 57
  drive: "tracks"
  brain: "neutronic"
  armament: "none"
  sensors: ["spectral"]
  notes: "Slow maintenance robot. Confined to drive maintenance during flight."

DROID_10 =
  id: "476"
  entry: "10"
  klass: "Maintenance"
  height: 1.32
  weight: 42
  drive: "anti-grav"
  brain: "neutronic"
  armament: "lasers"
  sensors: ["spectral", "infra-red"]
  notes: "Ship maintenance robot. Fitted with multiple arms to carry out repairs to the ship efficiently. All craft built after the Jupiter Incident are supplied with a team of these."

DROID_11 =
  id: "493"
  entry: "11"
  klass: "Maintenance"
  height: 1.48
  weight: 51
  drive: "anti-grav"
  brain: "neutronic"
  armament: "none"
  sensors: ["spectral"]
  notes: "Slave maintenance droid. Standard version will carry its own toolbox."

DROID_12 =
  id: "516"
  entry: "12"
  klass: "Crew"
  height: 1.57
  weight: 74
  drive: "bipedal"
  brain: "neutronic"
  armament: "none"
  sensors: ["spectral"]
  notes: "Early crew droid. Able to carry out simple flight checks only. No longer supplied."

DROID_13 =
  id: "571"
  entry: "13"
  klass: "Crew"
  height: 1.76
  weight: 62
  drive: "bipedal"
  brain: "neutronic"
  armament: "none"
  sensors: ["spectral"]
  notes: "Standard crew droid. Supplied with the ship."

DROID_14 =
  id: "598"
  entry: "14"
  klass: "Crew"
  height: 1.72
  weight: 93
  drive: "bipedal"
  brain: "neutronic"
  armament: "none"
  sensors: ["spectral"]
  notes: "A highly sophisticated device. Able to control the Robo-Freighter on its own."

DROID_15 =
  id: "614"
  entry: "15"
  klass: "Sentinel"
  height: 1.93
  weight: 121
  drive: "bipedal"
  brain: "neutronic"
  armament: "laser rifle"
  sensors: ["spectral", "subsonic"]
  notes: "Low security sentinel droid. Used to protect areas of the ship from intruders. A slow but sure device."

DROID_16 =
  id: "615"
  entry: "16"
  klass: "Sentinel"
  height: 1.20
  weight: 29
  drive: "anti-grav"
  brain: "neutronic"
  armament: "lasers"
  sensors: ["spectral", "infra-red"]
  notes: "Sophisticated sentinel droid. Only 2000 built by the Nicholson Company. These are now very rare."

DROID_17 =
  id: "629"
  entry: "17"
  klass: "Sentinel"
  height: 1.09
  weight: 59
  drive: "tracks"
  brain: "neutronic"
  armament: "lasers"
  sensors: ["spectral","subsonic"]
  notes: "Slow sentinal droid. Lasers are built into the turret. These are mounted on a small tank body. May be fitted with an auto-cannon on the Gillen version."

DROID_18 =
  id: "711"
  entry: "18"
  klass: "Battle"
  height: 1.93
  weight: 102
  drive: "bipedal"
  brain: "neutronic"
  armament: "disruptor"
  sensors: ["ultra-sonic", "radar"]
  notes: "Heavy duty battle droid. Disruptor is built into the head. One of the first in service with the military."

DROID_19 =
  id: "742"
  entry: "19"
  klass: "Battle"
  height: 1.87
  weight: 140
  drive: "bipedal"
  brain: "neutronic"
  armament: "disruptor"
  sensors: ["spectral", "radar"]
  notes: "This version is the one mainly used by the military."

DROID_20 =
  id: "751"
  entry: "20"
  klass: "Battle"
  height: 1.93
  weight: 227
  drive: "bipedal"
  brain: "neutronic"
  armament: "lasers"
  sensors: ["spectral"]
  notes: "Very heavy duty battle droid. Only a few have so far entered service. These are the most powerful battle units ever built."

DROID_21 =
  id: "821"
  entry: "21"
  klass: "Security"
  height: 1.00
  weight: 28
  drive: "anti-grav"
  brain: "neutronic"
  armament: "lasers"
  sensors: ["spectral", "radar", "infra-red"]
  notes: "A very reliable anti-grav unit is fitted into this droid. It will patrol the ship and eliminate intruders as soon as detected by powerful sensors."

DROID_22 =
  id: "834"
  entry: "22"
  klass: "Security"
  height: 1.10
  weight: 34
  drive: "anti-grav"
  brain: "neutronic"
  armament: "lasers"
  sensors: ["spectral", "radar"]
  notes: "Early type anti-grav security droid fitted with an over-driven anti-grav unit. This droid is very fast but is not reliable."

DROID_23 =
  id: "883"
  entry: "23"
  klass: "Security"
  height: 1.62
  weight: 79
  drive: "wheels"
  brain: "neutronic"
  armament: "exterminator"
  sensors: ["spectral", "radar"]
  notes: "This droid was designed from archive data. For some unknown reason it instills great fear in Human adversaries."

DROID_24 =
  id: "999"
  entry: "24"
  klass: "Command"
  height: 1.87
  weight: 162
  drive: "anti-grav"
  brain: "primode"
  armament: "lasers"
  sensors: ["infra-red", "radar", "subsonic"]
  notes: "Experimental command cyborg. Fitted with a new type of brain. Mounted on a security droid anti-grav unit for convenience. Warning: The influence device may not control a primode brain for long."

exports.CYBORG = DROID_24

exports.DROIDS = [
  DROID_01, DROID_02, DROID_03, DROID_04, DROID_05, DROID_06, DROID_07, DROID_08,
  DROID_09, DROID_10, DROID_11, DROID_12, DROID_13, DROID_14, DROID_15, DROID_16,
  DROID_17, DROID_18, DROID_19, DROID_20, DROID_21, DROID_22, DROID_23, DROID_24 ]

exports.DROIDS_PER_DECK = 10

exports.NUM_MESSAGES = 10

exports.SHIP_NAMES = [
  "Metahawk",
  "Hewstromo",
  "Graftgold",
  "Blabgorius IV",
  "Red Barchetta",
  "Retta-beast",
  "Itsnotardenuff",
  "Paradroid" ]

# debugging in browser
window.API.constant = exports if window?.API?

#----------------------------------------------------------------------
# end of constant.coffee
