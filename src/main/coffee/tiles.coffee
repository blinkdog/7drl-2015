# tiles.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

tileSetImage = "img/terminal8x8.png"
tileSet = document.createElement "img"
tileSet.src = tileSetImage
tileSet.onload = ->
  console.log "Image Loaded: #{tileSetImage}"
  exports.allLoaded = true

special = (i) ->  [((i%16)*8), (Math.floor(i/16)*8)]

generateTileMap = ->
  map = {}
  # get most of the characters right
  for i in [0...256]
    mapTo = String.fromCharCode i
    x = (i%16)*8
    y = Math.floor(i/16)*8
    map[mapTo] = [x,y]
  # add a few unicode -> CP437 mappings
  map["↕"] = special 0x12
  map["→"] = special 0x1a
  map["←"] = special 0x1b
  map["▒"] = special 0xb1
  map["│"] = special 0xb3
  map["║"] = special 0xba
  map["╗"] = special 0xbb
  map["╝"] = special 0xbc
  map["─"] = special 0xc4
  map["╚"] = special 0xc8
  map["╔"] = special 0xc9
  map["═"] = special 0xcd
  map["Φ"] = special 0xe8
  # return the map to the caller
  return map

tileMap = generateTileMap()

#----------------------------------------------------------------------

# true when all the images have been loaded
exports.allLoaded = false

exports.TILEMAP = tileMap

exports.TILESET = tileSet

# debugging in browser
window.API.tiles = exports if window?.API?

#----------------------------------------------------------------------
# end of tiles.coffee
