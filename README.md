# 7drl-2015
My entry for Seven Day Roguelike (7DRL) Challenge 2015

## Postmortem
Failure. Right now, you can walk around the ship and watch robots
move. There isn't enough time left to add enough features to make
this a playable (i.e.: win/lose) game.

Compared to last year, there was a lot more going on at home and
work this year, which reduced usable hours by a lot. I spent too
much time up front importing content and getting the briefing
going, when I should have focused on the game play.

72 hours into the project before I had the ability to generate
deck maps? Eeek.

120 hours into the project before I had the ability to view and
walk around on those deck maps? Eeek!

141 hours into the project before a real turn scheduler was in
place? Eeek!!!

Well, it was certainly a learning experience. I think I learned
more from the failure this year than I did from my "success" last
year. Sometimes, less really is more.

## Development Log
* [Sunday] - 7drl-2015 repository created on GitHub
* 157 - Coding begins
* 153 - First buildable, runnable, distributable
* 149 - Sound effect support, looping briefing sample
* 148 - Briefing content, but not briefing code; too sleepy
* 131 - Briefing scrollable, space bar begins mission
* 131 - Screenshot 1 Uploaded
* 096 - Deck map generation
* 095 - BSOD
* 079 - All(?) sound effects
* 076 - Lifts that ensure all decks can be accessed
* 070 - Main game display with borrowed tileset
* 048 - Deck display, FOV, viewed/not-viewed, no-clip walking
* 027 - Scheduler and engine, doors that open/close, clip walking
* 026 - Added stub use command
* 021 - Lifts now operational; move between decks
* 007 - Ship populated with robots that move and open doors
* 006 - Screenshot 3 Uploaded
* 006 - Final Cleanup Check-In

## Thanks
* Andrew Braybrook for the original Paradroid. All sound effects are borrowed
from the Commodore 64 version of the original game.
* Thank you to Dave Glowacki and David Schultz, for assistance with the deck
accessibility algorithm idea. Piss-poor implementation to be blamed completely
on @blinkdog.
* `img/terminal8x8.png` borrowed from [Necromancer Simulator 2014](https://github.com/maqqr/7drl2014)
then given an alpha channel to make it usable as rot.js tileset
