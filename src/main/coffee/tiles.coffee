# tiles.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

tileSetImage = "img/terminal8x8.png"
tileSet = document.createElement "img"
tileSet.src = tileSetImage
tileSet.onload = ->
  console.log "Image Loaded: #{tileSetImage}"
  exports.allLoaded = true

generateTileMap = ->
  map = {}
  for i in [0...256]
    mapTo = String.fromCharCode i
    x = (i%16)*8
    y = Math.floor(i/16)*8
    map[mapTo] = [x,y]
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
