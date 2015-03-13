# lift.coffee
# Copyright 2015 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------

exports.combine = (lift1, lift2) ->
  if (lift2[0] <= lift1[0]) and (lift2[1] >= lift1[0])
    return [[Math.min(lift1[0], lift2[0]), Math.max(lift1[1], lift2[1])]]
  if (lift2[0] <= lift1[1]) and (lift2[1] >= lift1[1])
    return [[Math.min(lift1[0], lift2[0]), Math.max(lift1[1], lift2[1])]]
  if (lift1[0] <= lift2[0]) and (lift1[1] >= lift2[0])
    return [[Math.min(lift1[0], lift2[0]), Math.max(lift1[1], lift2[1])]]
  if (lift1[0] <= lift2[1]) and (lift1[1] >= lift2[1])
    return [[Math.min(lift1[0], lift2[0]), Math.max(lift1[1], lift2[1])]]
  return [lift1, lift2]

# debugging in browser
window.API.lift = exports if window?.API?

#----------------------------------------------------------------------
# end of lift.coffee
