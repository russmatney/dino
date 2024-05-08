Dino Games
==========

Dino was originally intended as a monorepo full of independent games and
test-consumers for the addons/reusable code - a jumpstarter for doing game jams
with the side effect of testing/improving library code.

I was experimenting! Along the way I wasn't sure if it would make sense to
persue a more serious game alongside the others, or if the addons would be
consumable from another repo.

At this point I'm driving Dino toward being a framework, even if just a personal
one. I'm honing in on reusable controllers and systems, and taking on the
challenge of designing a game (or several) that fits these pieces together.

Here's some commentary and links for the games created along the way, in reverse
chronological order. Most of the entities and challenges in this game have been
incorporated into Dino's more generic entity/quest/proc-gen system.

You can find more notes and brainstorms about dino and these games on my blog -
I'll add more links to those docs at some point.

# Void Spike - July 2023
Play the web version here: [russmatney.itch.io/spike](https://russmatney.itch.io/spike)

A submission for the GMTK Game Jam 2023

The idea here was to emphasize the 'delivery' of a crafted something. I was
going for a platformer overcooked, where you collect ingredients from enemies
and eventually toss the cooked meal toward something... discerning. It ended up
pretty rough.

# Shirt - June 2023
Play the web version here: [russmatney.itch.io/shirt](https://russmatney.itch.io/shirt)

A submission for the [Godot Wild Jam #58](https://itch.io/jam/godot-wild-jam-58)

Duaa, when she first heard me talking about 'Tunic': "Why not just name it 'Shirt'?"

Intended to try to implement something like a a top-down zelda clone - this got
a few blobs that chase you, a boomerrang, and a quest to collect some gems and
open a door.

# Mountain - May 2023
A work-in-progress. I toyed with some Ascend/Descend ideas - Tears of the
Kingdom had just launched. I never quite got this one across any finish line.

The idea was to create a simple game in which you traverse a mountain - top to
bottom, then back to top again. I got various tilesets and particle effects
working, plus some other refactors, and i doodled a level. Unfortunately on the
first play through I hated the level design enough to just drop the whole thing
for a while.

# Super Elevator Level - May 2023
Play the downloadable version here: [russmatney.itch.io/super-elevator-level](https://russmatney.itch.io/super-elevator-level)

Or the webversion: [russmatney.itch.io/super-elevator-level-web](https://russmatney.itch.io/super-elevator-level-web)

Submitted to the [Go Godot Jam 4](https://itch.io/jam/go-godot-jam-4)

I've loved Beat Em Ups since I was young, and they are a major draw to game dev
for me - I intend to put together a more serious one by the end of 2024. (Most
likely [this repo](https://github.com/russmatney/beatemup-city), which is private at the time of writing but won't always be...)

# Herd: A sheep bullet hell - May 2023
I worked on this for the Bullet Hell Jam 2023, but didn't end up submitting anything.

Still, I like the idea of herding sheep into a pen - it feels vaguely Pikmin
like, and has been a fun quest to keep around.

# Mvania 19: HatBot - Feb/March 2023
A submission for [Metroidvania Month-long Jam 19](https://itch.io/jam/metroidvania-month-19).

Play the downloadable version here: [russmatney.itch.io/mvania19](https://russmatney.itch.io/mvania19)

Or the webversion: [russmatney.itch.io/mvania19-web](https://russmatney.itch.io/mvania19)

I built up several addons during this build, including Hotel and later Metro to
manage data across scene transitions and manage room-based games in general.
That learning was worth it, but the resulting code is largely unused at this
point in favor of other solutions (e.g. MetSys and Vania/Brick).
# Juicy Snake - Jan 2023
A rough prototype for [Juice Jam 2](https://itch.io/jam/gdb-juice-jam-ii).

Play the deployed version here: [russmatney.itch.io/snake](https://russmatney.itch.io/snake)

This has been completely dropped... might reimplement from scratch at some
point, tho not likely in this repo.

# Tower Jet - Jan 2023
A Jetpack-fueled mess of propulsion in some generated tilemaps.

This was built directly on top of Cozy Gunner, but unfortunately got pretty
distracted when I tried to implement some noise-based procedural level
generation. I'd hoped to create something similar to Spelunky or Down well, but
climbing/jet-packing up instead of digging down. I learned a lot about godot's
tool scripts, tilemaps, and noise tools, but the finished game is quite a mess.
Good luck in there!

I built much of Reptile (a dino addon) while working on this game, but most of
that code has been tossed at this point.

Play the deployed version here: [russmatney.itch.io/tower](https://russmatney.itch.io/tower)


A submission for the [Godot Wild Jam #53](https://itch.io/jam/godot-wild-jam-53)

At this point I still use 'Tower' to refer to this idea in Dino.

# Cozy Gunner - Jan 2023
A juicy gunner.

Play the deployed version here: [russmatney.itch.io/gunner](https://russmatney.itch.io/gunner)

I was digging into 'Juice' in games videos ([here's a playlist](https://youtube.com/playlist?list=PL2gEO25pE6dqsPxgajrZSuqutgzZSjnk5) i made at the time), and created this to start
implementing player controller feedback (screenshake, hitstop, etc).

This is game is mostly just Dino's 'Break the Targets' quest at this point.

# Harvey - Jan 2023
An overcooked-like farming game. Submission for the Ludum Dare 52 (Theme: Harvest).

Play the deployed version here: [russmatney.itch.io/harvey](https://russmatney.itch.io/harvey)

# Ghost House - December 2022
Play the deployed version here: [russmatney.itch.io/ghosts](https://russmatney.itch.io/ghosts)

A small something created for the [Godot Wild Jam #52](https://itch.io/jam/godot-wild-jam-52).

I was happy with the look and feel of this, but there's no win state - just a
few rooms to wander with your stunning flashlight.

# Runner - October/November 2023
Play the deployed version here: [russmatney.itch.io/runner](https://russmatney.itch.io/runner)

A catch-the-leaf inspired running game.

The core of the logic is the Runner.gd script, which handles adding and removing
rooms while the player moves across them until they are all complete.

This idea is also referred to as Leaf Runner and/or The Woods.

# Dungeon Crawler - October/November 2023
Play the deployed version here: [russmatney.itch.io/dungeon-crawler](https://russmatney.itch.io/dungeon-crawler)

This was a chance to implement keys and door logic, and a basic boss state
machine. The map was one giant scene, and the tiles use auto-tiling, which should
make it simple to doodle a few more levels.

Now completely deleted from Dino.

