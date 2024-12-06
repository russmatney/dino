# CHANGELOG


## Untagged


### 6 Dec 2024

- ([`68e143c0`](https://github.com/russmatney/dino/commit/68e143c0)) feat: rough shirt level recreation

  > Adds a reasonable _CaveTemplate and 3 new maps to shirt


### 26 Nov 2024

- ([`57217389`](https://github.com/russmatney/dino/commit/57217389)) chore: bunch of export preset updates
- ([`b9539b0e`](https://github.com/russmatney/dino/commit/b9539b0e)) hatbot: create spaceship, kingdom, volcano maps and rooms
- ([`4f97d5c7`](https://github.com/russmatney/dino/commit/4f97d5c7)) feat: dino players always init z-index 1

  > In the metsys context, our player node is outside of the room, so
  > sometimes ends up above the room in the scene tree - which can get very
  > confusing when the background is in front of the player.
  > 
  > Probably will work with these as layers - foreground gets.... 2? 5?

- ([`737efe59`](https://github.com/russmatney/dino/commit/737efe59)) bones: add U._disconnect(sig, fn)

  > Nice to have one that doesn't care if the signal is connected.
  > Just: make it so!


### 25 Nov 2024

- ([`01b0cad1`](https://github.com/russmatney/dino/commit/01b0cad1)) wip: zoom in more (hatbot), tryna adjust camera limits on load

  > Unsuccessfully.

- ([`61312714`](https://github.com/russmatney/dino/commit/61312714)) feat: support metro/travel-points in hatbot-metsys rewrite

  > Refactors MetroTravelPoints (Elevators) to emit a travel_requested
  > signal - subscribes to this signal in HatBotGame.
  > 
  > Seems simple enough? And it's workin :dance:


### 23 Nov 2024

- ([`c7878eac`](https://github.com/russmatney/dino/commit/c7878eac)) fix: update itch/steam workflows
- ([`4b4db31d`](https://github.com/russmatney/dino/commit/4b4db31d)) fix: update other addons/bones/reptile paths
- ([`565bc742`](https://github.com/russmatney/dino/commit/565bc742)) fix: update Metal tilemap path
- ([`e77d2dc9`](https://github.com/russmatney/dino/commit/e77d2dc9)) feat: play-scene from metsys room helper

  > Pulling this impl in from Glossolalia.

- ([`e1faebb4`](https://github.com/russmatney/dino/commit/e1faebb4)) feat: tiles, bg, lighting wips for hatbot Zero rooms

  > Roughs out a few rooms via metsys. Really hard to see! has some
  > z-ordering issues and needs better color/tile work.


### 22 Nov 2024

- ([`181c293f`](https://github.com/russmatney/dino/commit/181c293f)) fix: some theme update noisey cruft
- ([`742f33bb`](https://github.com/russmatney/dino/commit/742f33bb)) feat: reload metsys editor maps by selecting game scene

  > Attaches MetSys' main database node to the MetSysPlugin, and references
  > the plugin from the autoload. This lets us call
  > MetSys.plugin.main.force_reload() when switching metsys game contexts.
  > 
  > Now reloading the metsys view just by selecting the main game scene!

- ([`d63647ab`](https://github.com/russmatney/dino/commit/d63647ab)) fix: MetSys reload_map() reloading Map Viewer

  > Small fix to get the Map Viewer to reload (along with the Map Editor)
  > after reloading from disk.

- ([`abfa4257`](https://github.com/russmatney/dino/commit/abfa4257)) chore: drop gd_explorer

  > Love this idea, but i'll have to return to it later

- ([`67241695`](https://github.com/russmatney/dino/commit/67241695)) feat: reset map, disconnect room_changed signals

  > More MetSys context-switching cleanup - we're now able to play
  > vania/hatbot/shirt interchangably!
  > 
  > However, the in-editor map isn't updating yet.

- ([`6d285e0e`](https://github.com/russmatney/dino/commit/6d285e0e)) fix: fix up tilesets to get rid of tileset atlas warnings

  > This was a huge pain - the error is nice but gives not clue as to which
  > tile map/set causes the issue, which sucks when we have, like, 30.

- ([`334972ec`](https://github.com/russmatney/dino/commit/334972ec)) feat: pull metsys context reset into Vania static func

  > This helper isn't perfect yet (not yet working when switching games),
  > but it somewhat resets the editor context, so it's a start.


### 3 Nov 2024

- ([`ec05daff`](https://github.com/russmatney/dino/commit/ec05daff)) chore: more tilemap cruft?!

  > Not sure why things move around so much just b/c i'm moving between
  > machines. Feels like the git story isn't super tight.

- ([`507f195a`](https://github.com/russmatney/dino/commit/507f195a)) fix: set Shirt game_scene to metsys version
- ([`bd8040df`](https://github.com/russmatney/dino/commit/bd8040df)) fix: genre_type was being ignored

  > Adds support for 'genre' as well, b/c why not

- ([`bbaedc08`](https://github.com/russmatney/dino/commit/bbaedc08)) feat: shirt metsys game working (tho not topdown yet)
- ([`343984cd`](https://github.com/russmatney/dino/commit/343984cd)) wip: shirt MetSys impl started, nearly working
- ([`32ab895d`](https://github.com/russmatney/dino/commit/32ab895d)) fix: kill dead dj_turntable reference

  > this now lives in bones/src - maybe it's better off in here? could those
  > be the same thing?

- ([`4b273801`](https://github.com/russmatney/dino/commit/4b273801)) wip: attempt to support MetSys for HatBot AND Vania

  > Not quite working, unless you restart the game completely. Some internal
  > state or other needs clearing/cleanup.

- ([`d889b36a`](https://github.com/russmatney/dino/commit/d889b36a)) fix: don't infer types in metsys

  > I expect metsys is built against a different version of godot?

- ([`0af3121e`](https://github.com/russmatney/dino/commit/0af3121e)) deps: update bones
- ([`f599925d`](https://github.com/russmatney/dino/commit/f599925d)) deps: update dialogue manager
- ([`b2998db1`](https://github.com/russmatney/dino/commit/b2998db1)) deps: update pandora
- ([`4bb2d13c`](https://github.com/russmatney/dino/commit/4bb2d13c)) deps: update metsys

### 29 Oct 2024

- ([`4943c32a`](https://github.com/russmatney/dino/commit/4943c32a)) fix: move everything to tileMapLayers
- ([`68dfe4a3`](https://github.com/russmatney/dino/commit/68dfe4a3)) fix: update vexed fonts reference
- ([`dbfa7b62`](https://github.com/russmatney/dino/commit/dbfa7b62)) refactor: reorg tilemaps and move to tilemap layers

  > Here or otherwise during tonights build, i totally lost the hatbot +
  > spike + demoland tilemaps. I could recreate or fetch them from history
  > at some point, but maybe remaking them is a better exercise?

- ([`16b38ea3`](https://github.com/russmatney/dino/commit/16b38ea3)) deps: bones update (DJ path, navi root scene)
- ([`0a964c7f`](https://github.com/russmatney/dino/commit/0a964c7f)) chore: point at bones fonts
- ([`75d87626`](https://github.com/russmatney/dino/commit/75d87626)) deps: misc dep update cruft
- ([`de0b576a`](https://github.com/russmatney/dino/commit/de0b576a)) wip: messy bones update

  > Bones is dropping it's tilemaps, lights, fonts, and other assets.


### 27 Oct 2024

- ([`162d7160`](https://github.com/russmatney/dino/commit/162d7160)) feat: hatbot navigation restored!

  > via metroTravelPoints implementation, which is a bit clunky.
  > 
  > Also we're spawning on playerSpawnPoints instead of node-pathed
  > elevators.

- ([`80fb5c89`](https://github.com/russmatney/dino/commit/80fb5c89)) feat: bones/Navi default to waiting for currentScene clear
- ([`d1893474`](https://github.com/russmatney/dino/commit/d1893474)) feat: music as tool script to fix in-editor compiler errors
- ([`69fc231e`](https://github.com/russmatney/dino/commit/69fc231e)) feat: support awaiting scene exit before adding new one

  > The phantom camera was compaining about too many hosts, b/c we were
  > adding the new root scene before the previous one was removed. This
  > should prevent other issues, like spawn_player finding and using the
  > previous scene's spawn_point.
  > 
  > We might want this as the default, and to opt-in to skipping this await instead.

- ([`2b9da0d3`](https://github.com/russmatney/dino/commit/2b9da0d3)) wip: some nearly restored metroTravelPoint usage

  > Down to just camera problems, hopefully.
  > 
  > And really i'd like to choose the next travelPoint, not have to assign
  > them manually. maybe via the quick-select menu, which actually takes
  > entities already.

- ([`17276c3e`](https://github.com/russmatney/dino/commit/17276c3e)) fix: 'rooms' don't have this method anymore?
- ([`2472b25e`](https://github.com/russmatney/dino/commit/2472b25e)) fix: no need to crash when there's no action
- ([`36d974b2`](https://github.com/russmatney/dino/commit/36d974b2)) cruft: more resource cruft!
- ([`7e364e93`](https://github.com/russmatney/dino/commit/7e364e93)) feat: set a random scale if there's no action

  > gives this button more power, and lets us explore hatbot a bit.

- ([`c185a889`](https://github.com/russmatney/dino/commit/c185a889)) feat: bones/Navi(nav_to, {on_ready=func(node)})
- ([`5b625d29`](https://github.com/russmatney/dino/commit/5b625d29)) feat: restore hatbot (launch) via arcade mode menu

  > Note that most of the other DinoGames in the arcade seem to crash...
  > 
  > And the player can't squeeze into hatbot's scale

- ([`d4a51056`](https://github.com/russmatney/dino/commit/d4a51056)) chore: quick playerSpawner node

  > i'm learning how to compose a bit better here.
  > definitely some unity influence!


### 26 Oct 2024

- ([`390a863f`](https://github.com/russmatney/dino/commit/390a863f)) wip: restoring and debugging the old arcade
- ([`79d0f33f`](https://github.com/russmatney/dino/commit/79d0f33f)) chore: some nice helper functions

  > Maybe ought to pull these data helpers together

- ([`ee3d44cf`](https://github.com/russmatney/dino/commit/ee3d44cf)) chore: bump godot version in actions
- ([`c0b953fe`](https://github.com/russmatney/dino/commit/c0b953fe)) fix: brickRoom string/nil-pun crash
- ([`78d002ca`](https://github.com/russmatney/dino/commit/78d002ca)) cruft: Shirt scene opened/updated
- ([`82ad1c3c`](https://github.com/russmatney/dino/commit/82ad1c3c)) cruft: misc open/closed scene updates
- ([`9116ba1c`](https://github.com/russmatney/dino/commit/9116ba1c)) fix: resolve quick-select never dismissing

  > check nested children in entityList.

- ([`20e12180`](https://github.com/russmatney/dino/commit/20e12180)) misc: some gym tweaks

  > games broken, but gyms still working!

- ([`430e82b8`](https://github.com/russmatney/dino/commit/430e82b8)) chore: resolve a bunch of warnings

### 25 Oct 2024

- ([`9cf40d22`](https://github.com/russmatney/dino/commit/9cf40d22)) chore: even more core/bones tweaks (reptile, juice/debug)
- ([`222dbc14`](https://github.com/russmatney/dino/commit/222dbc14)) deps: add IconGodotNode
- ([`e8b2252a`](https://github.com/russmatney/dino/commit/e8b2252a)) chore: restore dj/assets/sounds+songs
- ([`d1b9970e`](https://github.com/russmatney/dino/commit/d1b9970e)) chore: more src/core vs addons/bones migration
- ([`48980d9d`](https://github.com/russmatney/dino/commit/48980d9d)) chore: drop addons/core|bones overlap, move remaining addons/core to src/

  > Pulling the non-bonesed part of addons/core into src/core to give dino
  > more power and separate out a cleaner bones usage.

- ([`44a475bd`](https://github.com/russmatney/dino/commit/44a475bd)) deps: drop core/actions

  > In favor of bones/actions.

- ([`a117a28c`](https://github.com/russmatney/dino/commit/a117a28c)) chore: more teeb import cruft
- ([`37a49bcc`](https://github.com/russmatney/dino/commit/37a49bcc)) chore: bones import update
- ([`05c5f52a`](https://github.com/russmatney/dino/commit/05c5f52a)) deps: add bones
- ([`ac7164c6`](https://github.com/russmatney/dino/commit/ac7164c6)) deps: update log.gd
- ([`85ac4597`](https://github.com/russmatney/dino/commit/85ac4597)) deps: update input_helper
- ([`6b78a03d`](https://github.com/russmatney/dino/commit/6b78a03d)) deps: update gdfxr
- ([`2cac6504`](https://github.com/russmatney/dino/commit/2cac6504)) deps: update pandora
- ([`15ee0b6b`](https://github.com/russmatney/dino/commit/15ee0b6b)) deps: update phantom_camera
- ([`21f2e604`](https://github.com/russmatney/dino/commit/21f2e604)) deps: update gdunit
- ([`588a773c`](https://github.com/russmatney/dino/commit/588a773c)) deps: update metSys
- ([`3ea092c2`](https://github.com/russmatney/dino/commit/3ea092c2)) deps: update dialogue_manager
- ([`a420f9f4`](https://github.com/russmatney/dino/commit/a420f9f4)) deps: reimport text effects
- ([`c16f1e22`](https://github.com/russmatney/dino/commit/c16f1e22)) deps: update aseprite wizard

### 12 Oct 2024

- ([`89ba06b9`](https://github.com/russmatney/dino/commit/89ba06b9)) chore: bunch of godot 4.3 import cruft

### 22 Sep 2024

- ([`ee522863`](https://github.com/russmatney/dino/commit/ee522863)) chore: godot 4.3 update

### 20 Jun 2024

- ([`96f826b3`](https://github.com/russmatney/dino/commit/96f826b3)) fix: readme discord link

### 4 Jun 2024

- ([`be932f64`](https://github.com/russmatney/dino/commit/be932f64)) chore: add ko-fi link

### 31 May 2024

- ([`c1096043`](https://github.com/russmatney/dino/commit/c1096043)) changelog: include all tags

  > Moves to including all tags in the changelog.
  > 
  > This duplicates some commits, which is slightly annoying, but it also
  > includes the tags, so seems more correct at least (unknown vs v1.0.0).


## v1.0.0


### 31 May 2024

- ([`56cb30c0`](https://github.com/russmatney/dino/commit/56cb30c0)) fix: full changelog now generating

  > Drops a fallback commit-count value (was set at 500), so we now print
  > the entire commit history in the changelog files


### 30 May 2024

- ([`2ae920fd`](https://github.com/russmatney/dino/commit/2ae920fd)) fix: update test now that the bow is disabled
- ([`8418a404`](https://github.com/russmatney/dino/commit/8418a404)) fix: skip spawn points in mapdef icon grid

  > No need to show _every_ entity.

- ([`0019b703`](https://github.com/russmatney/dino/commit/0019b703)) feat: add a _burnch_ of icons
- ([`c09ebaf1`](https://github.com/russmatney/dino/commit/c09ebaf1)) fix: specify reasonable room shapes for launch modes

  > Updates the mapdefs for classic, tower, and woods to make sure the room
  > shapes are reasonable/traversible.

- ([`0d0210dd`](https://github.com/russmatney/dino/commit/0d0210dd)) feat: no minimap borders between same-room cells

  > Minimap looking much nicer now - will have to toy with some different
  > themes later on.

- ([`4189586f`](https://github.com/russmatney/dino/commit/4189586f)) fix: simplify target collision detection

  > Rather than 'weapons' groups, we rely on the collision layers/masks to
  > simplify the code. targets now get destroyed if the player or any player
  > projectile hits them.

- ([`634406d5`](https://github.com/russmatney/dino/commit/634406d5)) fix: skip_merge applies to sub_map_defs, not just rooms
- ([`d4d7c894`](https://github.com/russmatney/dino/commit/d4d7c894)) chore: disable test for the moment

  > These three rooms sometimes stack vertically, which makes writing the
  > assertions pretty annoying. Once we get a bit more control over room
  > placement, this should be easier to implement in a consistent way.
  > 
  > For now, the simpler previous test has similar coverage.

- ([`a5803e58`](https://github.com/russmatney/dino/commit/a5803e58)) fix: use bullet position to fire bullets

  > didn't realize this wasn't even being used!
  > 
  > A bit problemmatic - standing too close to a wall means you can't fire
  > up :/

- ([`e58dc1c1`](https://github.com/russmatney/dino/commit/e58dc1c1)) feat: basic next wave notif
- ([`51bf55bf`](https://github.com/russmatney/dino/commit/51bf55bf)) feat: powerups allow new weapon selection
- ([`57caa1c5`](https://github.com/russmatney/dino/commit/57caa1c5)) fix: don't wrap the timer when it's over 100
- ([`f33c7abf`](https://github.com/russmatney/dino/commit/f33c7abf)) fix: misc enemy state machine cleanup

  > Enemies sometimes fire just after they've died.... maybe this check will
  > fix it?

- ([`7236ac73`](https://github.com/russmatney/dino/commit/7236ac73)) fix: flip bullet firing position, remove offset

  > This offset might be trying to align the initial position with the held
  > bow, or maybe it predates the collision exception code. it wasn't
  > handling the player facing a different direction, but also it's not
  > necessary, so i'm dropping it for now.

- ([`dec3914b`](https://github.com/russmatney/dino/commit/dec3914b)) refactor: drop extra blob team room, switch to 3 waves
- ([`e3b5ee93`](https://github.com/russmatney/dino/commit/e3b5ee93)) feat: restore hud timer and show time-per-level
- ([`dc830b1f`](https://github.com/russmatney/dino/commit/dc830b1f)) feat: add mapdef icons to vania game transitions

  > A preview/review of the generated level's enemies and entities. Could
  > add drops as well, and maybe the level-complete version should instead
  > be a summary of the notifs/actions taken.


### 29 May 2024

- ([`0e6657e6`](https://github.com/russmatney/dino/commit/0e6657e6)) feat: add checkpoint to load screen (so you can heal up)
- ([`af193baa`](https://github.com/russmatney/dino/commit/af193baa)) fix: drop progress pause menu tab
- ([`8c7f28fb`](https://github.com/russmatney/dino/commit/8c7f28fb)) feat: use 'door' borders between doors

  > Not looking great yet b/c the same-room cells are still showing walls
  > between each other.

- ([`21215019`](https://github.com/russmatney/dino/commit/21215019)) fix: use consistent bg_color for rooms

  > This was returning a random color per function call. Perhaps a better
  > option would be setting a default random color on the mapInput itself,
  > but that runs into trouble with merging/overwriting (keep the manual vs
  > the random one)?

- ([`19ceb97d`](https://github.com/russmatney/dino/commit/19ceb97d)) feat: add sound to leaf collection
- ([`2fb07851`](https://github.com/russmatney/dino/commit/2fb07851)) fix: better spell collision detection

  > before this fix, clever players could ride spells around. Maybe a fun
  > feature for another time.

- ([`c4974f2a`](https://github.com/russmatney/dino/commit/c4974f2a)) fix: bullets can destroy boxes
- ([`b60c7e24`](https://github.com/russmatney/dino/commit/b60c7e24)) fix: orbs (tossed-items) re-collectable via area2d

  > Also fixes the extra orb-aiming red dots that have been littering the
  > player per-orb-toss.

- ([`cf3e90f9`](https://github.com/russmatney/dino/commit/cf3e90f9)) fix: U.call_in fixes

  > not sure what callable.is_valid/is_null is for, but w/e

- ([`3d961224`](https://github.com/russmatney/dino/commit/3d961224)) fix: feed-the-void skips-merge to ensure orb drops
- ([`3a927e13`](https://github.com/russmatney/dino/commit/3a927e13)) fix: reset player data before starting a game mode
- ([`754c10cc`](https://github.com/russmatney/dino/commit/754c10cc)) fix: restore feed-the-void quest

  > This was broken in a few ways - be good to get some per-quest or
  > per-map-def unit tests going.

- ([`c8c24478`](https://github.com/russmatney/dino/commit/c8c24478)) fix: use 'installed' gdunit

  > For some reason the pre-install step in CI is now segfaulting - the
  > tests run and pass afterwards, but the action is marked as failed. Maybe
  > something in the latest gdunit? I know the latest gets downloaded by
  > default, so this is probably a safer option anyway.

- ([`56f9607b`](https://github.com/russmatney/dino/commit/56f9607b)) fix: more resilient test

  > The test assumed the second room would have two neighbors, but in some
  > layouts it might be the first - this refactors to make sure the created
  > doors match.

- ([`62efe13e`](https://github.com/russmatney/dino/commit/62efe13e)) feat: wave system spawn_point variety and quest integration

  > Adds several spawn points for each enemy in a wave, and selects one per
  > enemy when spawning the next wave.
  > 
  > Updates vaniaGame's quest setup to set the number of expected enemies
  > according to the wave count.
  > 
  > Waves ignore bosses for now, which complicates things but seems pretty
  > much right so far.

- ([`ec4b4322`](https://github.com/russmatney/dino/commit/ec4b4322)) wip: towards opt-ing in to spawning enemies via waves

  > Still todo:
  > 
  > - add more and randomly select a spawn point (so the enemy doesn't spawn
  > in the
  > same place every time)
  > - update quest logic to expect more enemies (multiply by wave count)
  > - ensure expected drops on wave-spawned enemies
  > - wait to add more enemies
  > - test wave spawning starting/stopping in room-changing situations

- ([`fb182f07`](https://github.com/russmatney/dino/commit/fb182f07)) feat: mapInput extended with dupe_room_count, skip_merge

  > MapDefs/Inputs can now specify `n` rooms with the same data, and tell
  > some MapInput to skip the merge with the root mapDef's mapInput.
  > 
  > Woods and Tower have been updated to specify a start and end room, with
  > ~8 rooms in between.


### 28 May 2024

- ([`ff993577`](https://github.com/russmatney/dino/commit/ff993577)) test: fix some updated naming n such
- ([`f5230187`](https://github.com/russmatney/dino/commit/f5230187)) test: a more serious doors test b/c fuck doors
- ([`4c2daae3`](https://github.com/russmatney/dino/commit/4c2daae3)) feat: rewrite door logic for consistently placed doors

  > This is a bit cleaner now, but damn it wasn't a mofo pain in the ass.
  > 
  > The generator's 'neighbor_data' bit is now persisted as just 'doors', an
  > array of map_cell pairs on the vaniaRoomDef.

- ([`6abe4387`](https://github.com/russmatney/dino/commit/6abe4387)) wip: towards consistent door calcs
- ([`20d48295`](https://github.com/russmatney/dino/commit/20d48295)) fix: dedupe possible_doors, prevent same-room door calcs

  > In some code paths, the door calc was trying to calc doors within the
  > same room, which was causing a warning. There were also duplicated
  > doors, due to cell ordering. this fix should minimize some door calcs.

- ([`9267b5ea`](https://github.com/russmatney/dino/commit/9267b5ea)) fix: offscreen indicator labels, fix leaf quest

  > Drops a dead robot script, and adds offscreen indicators to bosses.

- ([`193907ec`](https://github.com/russmatney/dino/commit/193907ec)) fix: stop using a deactivated weapon

  > I'm not sure the difference between deactivate and stop_using...
  > probably had some idea in mind. maybe deactivate is like sheathing the
  > sword? stop_using is like releasing the trigger on an auto-firing
  > weapon.

- ([`3360eaf4`](https://github.com/russmatney/dino/commit/3360eaf4)) fix: wall-crawlers no longer falling in more states

  > This prevents their drops from getting stuck below the floor (for
  > ceiling-walkers who fall and add a drop 'above' themselves).

- ([`894bea60`](https://github.com/russmatney/dino/commit/894bea60)) fix: don't skip ceilings in tower game

  > Causing too many issues for now, dropping.

- ([`8dc38fdc`](https://github.com/russmatney/dino/commit/8dc38fdc)) feat: activate/deactivate room lighting/bg features

  > Now that we're rendering multiple levels at a time, these room features
  > are conflicting w/ each other - this prevents the overlap by
  > deactivating other rooms, and activating only the current room's
  > lighting feats.
  > 
  > This also drops an unused HUD component and serializes the tower, woods,
  > and mountain mapdefs as individual files.
  > 
  > There's some oddity in the quest completion still - i was able to
  > complete the tower with an enemy and target remaining - for targets, it
  > might makes sense b/c some target configs present multiple nodes for a
  > single entity - for the enemies, i'm less sure...
  > 
  > Also some trouble with enemies getting stuck in walls - a 'skipped'
  > ceiling is clear, but then when you go through it (as a vertical door)
  > some gets filled in (the floor of the room above it). For now i may have
  > to disable the skipped ceilings on the tower level.

- ([`58656db2`](https://github.com/russmatney/dino/commit/58656db2)) feat: display current seed in HUD

  > This seed isn't yet properly used, but it will be shortly.

- ([`52b07ad5`](https://github.com/russmatney/dino/commit/52b07ad5)) fix: restore target test quest

  > the manual total depends on update_quest eventually being called with
  > the relevant x (target, enemy, leaf, etc).

- ([`6ee4dfd4`](https://github.com/russmatney/dino/commit/6ee4dfd4)) fix: player knockedback state fallback ttl

  > So we don't get stuck if never hit the ground, which can happen if we
  > land on top of another enemy.

- ([`ce4b2e46`](https://github.com/russmatney/dino/commit/ce4b2e46)) fix: don't apply gravity to wall crawlers

  > Wall-crawlers no longer have gravity applied (in idle and run states).
  > this fixes crawlers sticking to the ceiling and wall starting positions,
  > tho they need to be overlapping/_very_ close to the walls for
  > is_on_wall/ceiling/etc to detect the wall - could be better to use a
  > raycast to find the nearest wall and move toward it.

- ([`3bc3f03d`](https://github.com/russmatney/dino/commit/3bc3f03d)) fix: remove dead enemy collisions, add front-ray to blobs

  > Blobs now turn around at platform edges (just adding the front-ray
  > opts-in to this)

- ([`0bc6f408`](https://github.com/russmatney/dino/commit/0bc6f408)) fix: robots hurt to touch unless dead, don't fire at dead players

  > Also adjusts the robot hitbox collisions layers/masks

- ([`23403e36`](https://github.com/russmatney/dino/commit/23403e36)) fix: disable hoodie player for now

  > Disabling until i can redo this character at ~half the height.
  > Right now it doesn't work well/fit with some level layouts.


### 27 May 2024

- ([`9cba4439`](https://github.com/russmatney/dino/commit/9cba4439)) chore: toying with custom folder colors
- ([`8f7402c4`](https://github.com/russmatney/dino/commit/8f7402c4)) refactor: quests system extended

  > A bit of a mess in here, looking forward to cleaning this up more.
  > 
  > For now, removes quest managers from vaniaRoom, adds one to vaniaGame.
  > 
  > The QuestManager now has a flag (manual_mode) for opting-out of automatic
  > quest creation. Quests were extended to check against
  > pandoraEntityIds (previously they'd only check with nodes and groups).
  > This lets VaniaGame pass all the room_defs entities/enemies into each
  > quests' has_required_entities and setup_with_entities funcs. Quests now
  > have a manual_total that is set via setup_with_entities to be sure all
  > the xs are found (not just the rendered ones). In general these 'manual'
  > modes and entity vs node checks are a PITA and should get cleaned up
  > somehow or other.
  > 
  > VaniaGame's room_states logic (which tracked visited and quests_complete
  > per room) has been refactored to use room_defs directly (for visited)
  > and a single quest manager for quest_completion.
  > 
  > This enables a proper 'feed the void' quest! Tho it's easy to fail if
  > you toss the orb over the side :/

- ([`ec308c78`](https://github.com/russmatney/dino/commit/ec308c78)) feat: Util gets flatten and flat_map impls
- ([`39224250`](https://github.com/russmatney/dino/commit/39224250)) refactor: save classic-mode levels (mapdefs) as custom resource files

  > Saves the classic side-scroller submapdefs (levels) as custom
  > resources (.tres files).
  > 
  > This is a nice step - can now quick-load these mapdefs anywhere else,
  > including for quick testing in VaniaGame.tscn

- ([`ed02a8b2`](https://github.com/russmatney/dino/commit/ed02a8b2)) chore: turn music down a bit

### 25 May 2024

- ([`7ee60638`](https://github.com/russmatney/dino/commit/7ee60638)) fix: drop 'room_shape' tests

  > room_shape was dropped, it's an idea but pretty redundant against
  > room_shapes.

- ([`39a3b056`](https://github.com/russmatney/dino/commit/39a3b056)) feat: now loading multiple vania rooms at a time!

  > Some wonky behavior around lighting - vania rooms bring their own bg
  > color and directional2D lights rn, so things start to clash, and
  > shadows/tilemap occlusions seem to get offset strangely....

- ([`e567c32e`](https://github.com/russmatney/dino/commit/e567c32e)) wip: refactoring vaniaGame to manage multiple rendered rooms

  > Nearly working, tho setting offsets isn't quite right yet.

- ([`17603062`](https://github.com/russmatney/dino/commit/17603062)) refactor: better var name `map` -> `current_room` in VaniaGame

  > Also removes a queue_free that frees the previous-room's metsys_room_instance
  > when transitioning. This inst is still removed from the tree, so there
  > should be no change in behavior - looking next into whether that
  > removal is actually requried.

- ([`d9edde5b`](https://github.com/russmatney/dino/commit/d9edde5b)) refactor: vaniaGame extends Node instead of MetSysGame

  > Looking at these types again, i've already overwritten all the
  > MetSysGame and MetSysModule code, so for now i'm dropping the types
  > completely. Mostly spurred by looking into rendering multiple rooms at
  > once.


### 23 May 2024

- ([`947bdb29`](https://github.com/russmatney/dino/commit/947bdb29)) fix: support mouse click on quick select menu

  > Also fixes up pickup logging

- ([`fc92d208`](https://github.com/russmatney/dino/commit/fc92d208)) fix: add lots of missing animations to ssplayers

  > Cutting way down on the warnings and errors! Hopefully we'll flesh these
  > anims out soon - the hario ones were a nice step, reused the run-right
  > stuff.
  > 
  > I think a lower-res hoodie would be a good step too, to get the
  > characters all a bit smaller.

- ([`cce19838`](https://github.com/russmatney/dino/commit/cce19838)) fix: bosses die at max_y

  > Copies pattern from ssplayer, tho i don't love it - die() should
  > probably transit to Dead....

- ([`5dea1d37`](https://github.com/russmatney/dino/commit/5dea1d37)) feat: darken bg tilemap colors
- ([`6ab0cb91`](https://github.com/russmatney/dino/commit/6ab0cb91)) fix: ensure all hatbot animations, face the right

  > This dude has been running around backwards for months, including in the
  > trailer.

- ([`e75c23e0`](https://github.com/russmatney/dino/commit/e75c23e0)) fix: stop using weapon when controls are blocked

  > There's been a long running fire-forever issue, i think this is the
  > cause.

- ([`75bf40a9`](https://github.com/russmatney/dino/commit/75bf40a9)) fix: kill ss_player if they're below 10k (falling forever)
- ([`00bb0863`](https://github.com/russmatney/dino/commit/00bb0863)) fix: set found_match so we don't add extra chunks

  > Also pulls get_rotations into GridDef so we can read chunk metadata in
  > there - we'll probably want to opt-out of some quarter turns for
  > platforms, for example.

- ([`014e70a1`](https://github.com/russmatney/dino/commit/014e70a1)) wip: add_tile_chunks re-attempting with new chunks

  > Levels fairly unplayable like this, but the logic seems to be working.
  > Would be nice to prevent re-attempts with a previously used chunk as
  > well. mostly we probably need some better or more minimal chunk shapes,
  > and hopefully some one-way platform logic.

- ([`e7502203`](https://github.com/russmatney/dino/commit/e7502203)) feat: tile chunk rotations working

  > though the results are not great. Probably want shape metadata to opt
  > in/out of specific rotations - getting lots of vertical platforms this way.

- ([`d1d5f2dd`](https://github.com/russmatney/dino/commit/d1d5f2dd)) refactor: DRY up add_tile_chunks

  > reusing the add_tile_chunks logic for adding background tiles.
  > 
  > This also reintroduces regular tile-chunks, which seem to get in the way
  > a bit - will work through that later (likely making the added tiles destructible.)

- ([`7c68c9a6`](https://github.com/russmatney/dino/commit/7c68c9a6)) chore: more uid churn!
- ([`213934a7`](https://github.com/russmatney/dino/commit/213934a7)) chore: cleaner menu-set logs
- ([`803bdda5`](https://github.com/russmatney/dino/commit/803bdda5)) refactor: style rearrange
- ([`6377733f`](https://github.com/russmatney/dino/commit/6377733f)) chore: defer setting sound/music volume to dodge bus warning

  > The bus warning checks for all buses whenever one has it's volume set.
  > in this case setting the music bus and volume was firing the warning for
  > the sound buses, which are set by the Sounds autoload before any sounds
  > are fired anyway. Deferring the set_*_volume calls lets the buses get
  > setup first. Could also move these to enter_tree or something :shrug:

- ([`97e42419`](https://github.com/russmatney/dino/commit/97e42419)) chore: more uid churn
- ([`4619decd`](https://github.com/russmatney/dino/commit/4619decd)) refactor: replace action hint key with actionInputIcon

  > the ActionInputIcon is reactive to the currently used controller, so
  > this is a fix for exposing proper button hints.

- ([`43c05f5f`](https://github.com/russmatney/dino/commit/43c05f5f)) chore: reduce logs, update some uids
- ([`a982177f`](https://github.com/russmatney/dino/commit/a982177f)) fix: vania editor detects vania_game added before and after

  > Ought to dry this detect-a-node api up with some helper.
  > 
  > I saw a crash here that seemed consistent for a bit - editing a level
  > via the vania editor then proceeding to the next was crashing, but it's
  > not reproducing anymore :/


### 22 May 2024

- ([`96532acb`](https://github.com/russmatney/dino/commit/96532acb)) test: coverage for vaniaGame threaded level gen

  > Initial tests for vaniaGame's threaded level gen, including removing the
  > VaniaGame node from the tree while the thread is running.
  > 
  > Lots of dodging create_tween when not in the tree - maybe ought to wrap
  > that/try for a null-safe/nil-punned tween api. sort of happening in the
  > Anim class static funcs for now.

- ([`9348dfe4`](https://github.com/russmatney/dino/commit/9348dfe4)) feat: basic player selection at the start of each game mode

  > NOTE this does not yet clear the player entity when quitting to main, so
  > there's no re-selection - maybe this should run every time rather than
  > just when there's no player_entity.

- ([`75f3f6d4`](https://github.com/russmatney/dino/commit/75f3f6d4)) feat: basic death handling - jumbotron and respawn
- ([`78bb5ba8`](https://github.com/russmatney/dino/commit/78bb5ba8)) feat: just the gun to start

  > Towards earning powerups.

- ([`19beb592`](https://github.com/russmatney/dino/commit/19beb592)) feat: add bush entities to woods rooms
- ([`9927e7ef`](https://github.com/russmatney/dino/commit/9927e7ef)) fix: prefer to add labels/etc to the current room

  > impling add_child_to_level to cut off notifs and other things being
  > added to the game-mode and sticking accumulating across classic-mode
  > games and vania transitions.

- ([`c92a5aab`](https://github.com/russmatney/dino/commit/c92a5aab)) fix: safer player respawning

  > Dino.current_player_node now returns null if the instance is not valid.
  > 
  > Dino.respawn_active_player now sets the level_node to the previous
  > player's parent unless another level_node is specified.
  > 
  > General safety checks for crashes... ideally this would get better some
  > broader test coverage.

- ([`b8707e02`](https://github.com/russmatney/dino/commit/b8707e02)) fix: get_collider() bodies might not be valid?

  > bunch of extra checks to avoid crashes.

- ([`2d5bb184`](https://github.com/russmatney/dino/commit/2d5bb184)) fix: disable popup pickup notifs

  > Until these are shown once-per-type or skippable,
  > it's just super annoying.


### 21 May 2024

- ([`c6978678`](https://github.com/russmatney/dino/commit/c6978678)) chore: ignore clips/

  > This is where recorded 'movie-mode' gameplay goes

- ([`61b3280f`](https://github.com/russmatney/dino/commit/61b3280f)) ci: refactor steam linux/windows deploy

  > The previous attempt failed on the second deploy b/c the OTP was used in
  > the first one - here we instead extend the deploy script to do both
  > deploys rather than invoke it multiple times.

- ([`a26061d0`](https://github.com/russmatney/dino/commit/a26061d0)) build: macos build settings
- ([`4b6623f3`](https://github.com/russmatney/dino/commit/4b6623f3)) fix: dodge pandora release-build bug

  > This is still a thing.... should have made a PR way back!

- ([`14cd7a8f`](https://github.com/russmatney/dino/commit/14cd7a8f)) ci: disable macos builds

  > well, it was worth a shot.

- ([`3a62a8a3`](https://github.com/russmatney/dino/commit/3a62a8a3)) ci: use --export-release (not --export)
- ([`a903b844`](https://github.com/russmatney/dino/commit/a903b844)) ci: update itch builds to 4.2.2, enable mac build
- ([`64fe0130`](https://github.com/russmatney/dino/commit/64fe0130)) ci: run tests on 4.2.2
- ([`f755239d`](https://github.com/russmatney/dino/commit/f755239d)) ci: attempt to build/deploy windows/macos for steam
- ([`9fce4cf0`](https://github.com/russmatney/dino/commit/9fce4cf0)) feat: credits refactor

  > Pulls in dothop's 'headers' addition to the credits code, pulls it all
  > out of addons and into dino directly.


### 20 May 2024

- ([`dc239e89`](https://github.com/russmatney/dino/commit/dc239e89)) chore: steam build vdfs for windows and macos
- ([`b202cb19`](https://github.com/russmatney/dino/commit/b202cb19)) fix: big controls clean up

  > Rearranges the main controls, decouples some overloaded ones, adds
  > support for input r/l triggers and editing/resetting those controls.
  > 
  > going with a basic control scheme: bottom-action to jump, right-action
  > to 'attack' (i.e. use weapon), left-action to exec whatever action,
  > top-action to quick swap weapon. maybe will expand that into a quick
  > swap for more player things. maybe the action-button could be held to
  > show all available actions? there's a cycle-actions problem right now...

- ([`97a99d30`](https://github.com/russmatney/dino/commit/97a99d30)) fix: input_helper types blocking joypadMotion replacements

  > Using the wrong types breaks things even when the values are correct :/


### 19 May 2024

- ([`8a90fc7b`](https://github.com/russmatney/dino/commit/8a90fc7b)) feat: game complete transition with menu/credits buttons

  > Just a basic popup with text for now.

- ([`80aab4ea`](https://github.com/russmatney/dino/commit/80aab4ea)) feat: level complete overlay and transition

  > Wait for player to kick off the transition, much less jarring.

- ([`6ab5e783`](https://github.com/russmatney/dino/commit/6ab5e783)) feat: setup level-start text

  > plus some more safe nil-punning

- ([`c9d69e60`](https://github.com/russmatney/dino/commit/c9d69e60)) wip: level start overlay with timers and pausing
- ([`1460eca0`](https://github.com/russmatney/dino/commit/1460eca0)) feat: util func for pausing a list of nodes
- ([`786b0d53`](https://github.com/russmatney/dino/commit/786b0d53)) fix: restore focus setting in main menu
- ([`a5b1a23b`](https://github.com/russmatney/dino/commit/a5b1a23b)) fix: quick camera transition, fixup ready-to-play overlay
- ([`69a16a06`](https://github.com/russmatney/dino/commit/69a16a06)) feat: support animating to+from grayscale

  > ScreenBlur now supports anim_blur and anim_gray feats!


### 17 May 2024

- ([`afa56faf`](https://github.com/russmatney/dino/commit/afa56faf)) docs: update changelog

  > Still looks like we're losing changelog whenever we run this - must get
  > some max commits set in my code somewhere.

- ([`f29e04df`](https://github.com/russmatney/dino/commit/f29e04df)) feat: blur transitions pretty much working, toying with grey scale
- ([`e471dfcd`](https://github.com/russmatney/dino/commit/e471dfcd)) wip: toying with screenblur in vania game transitions
- ([`837a6ac6`](https://github.com/russmatney/dino/commit/837a6ac6)) feat: playground anim in/out

  > Not too bad! Something active for the loading playground's nodes.

- ([`ed955992`](https://github.com/russmatney/dino/commit/ed955992)) feat: pull in dothop's Anim class, genericize
- ([`a6c16ecf`](https://github.com/russmatney/dino/commit/a6c16ecf)) feat: basic ready-to-play overlay

  > Now requiring player input in the load playground before starting the loaded
  > vania game - helps slow down the jarring transitions.

- ([`effb4e11`](https://github.com/russmatney/dino/commit/effb4e11)) feat: enable player position on minimap

### 16 May 2024

- ([`4f181e36`](https://github.com/russmatney/dino/commit/4f181e36)) feat: use vania room bg_color for minimap color

  > Be nice to get the doors working too.

- ([`a509b701`](https://github.com/russmatney/dino/commit/a509b701)) fix: ensure_children manually in vania room tests

  > VaniaRoom's ensure_children got cleaned up last night - the tests never
  > add the node to the scene_tree, so ensure_children needs to be called
  > manually.

- ([`84b6c06b`](https://github.com/russmatney/dino/commit/84b6c06b)) feat: sound, controls panels added to pause menu tabs
- ([`80a3f616`](https://github.com/russmatney/dino/commit/80a3f616)) feat: show more action in controls panel
- ([`ad2d8dcb`](https://github.com/russmatney/dino/commit/ad2d8dcb)) feat: tabbed options menu with sound/control opts
- ([`0eb5b1fe`](https://github.com/russmatney/dino/commit/0eb5b1fe)) deps: add kenney input prompt icons
- ([`e1e14559`](https://github.com/russmatney/dino/commit/e1e14559)) wip: rough options panel init

  > pulls in dothop's muteButtonList and controls panel

- ([`5e8c9d3d`](https://github.com/russmatney/dino/commit/5e8c9d3d)) feat: add dino logo basic fade in, particles to main menu
- ([`9edd269f`](https://github.com/russmatney/dino/commit/9edd269f)) light: misc 2d directional light tweaks
- ([`de386a86`](https://github.com/russmatney/dino/commit/de386a86)) tiles: cleaner volcano tile occlusion

### 15 May 2024

- ([`4ee4ea66`](https://github.com/russmatney/dino/commit/4ee4ea66)) feat: custom bg_color per room/map_def

  > Also adds an occlusion layer to the volcano tiles.

- ([`47faac2a`](https://github.com/russmatney/dino/commit/47faac2a)) fix: update test roomShape api, add vania gen test clean up

  > Adds metSys cleanup funcs to the vania generator + vania game unit tests
  > - these were starting to leave metsys data around between tests,
  > hopefully this is the last we see of it.

- ([`808d0f6d`](https://github.com/russmatney/dino/commit/808d0f6d)) fix: restore tests, add 'none' as first room shape type

  > Falsy enum values strike again! What a PITA. This also breaks the room
  > shapes i've already assigned b/c they're all ints that are now off by
  > one. great.

- ([`0955bdcf`](https://github.com/russmatney/dino/commit/0955bdcf)) wip: specify some rooms shapes for Tower
- ([`47f420f2`](https://github.com/russmatney/dino/commit/47f420f2)) feat: introduce RoomShape resource with type enum

  > RoomShapes are now selectable via the ui by label (enum value).

- ([`b53d12d8`](https://github.com/russmatney/dino/commit/b53d12d8)) feat: specify roomEffects via enum type drop down
- ([`74f849e2`](https://github.com/russmatney/dino/commit/74f849e2)) feat: specify drops via MapInput
- ([`b8a0575d`](https://github.com/russmatney/dino/commit/b8a0575d)) feat: vania level_complete tracks quests in all rooms

  > We now support quests across multi-room vania games. When all rooms have
  > quests_complete marked true, the vania game is considered complete.
  > 
  > Note that rooms can still technically be created without quests, which
  > means the level cannot be completed :/

- ([`8290b569`](https://github.com/russmatney/dino/commit/8290b569)) wip: quick classic test sub-map-defs

  > I saw a thread-related crash between loading vania games, I'm not sure
  > how/why - it looked like the thread/scene was exiting before the thread
  > could be waited/cleared.... hopefully adding some interstitials/slowing
  > down the loading will make those crashes impossible.

- ([`d2e0d397`](https://github.com/russmatney/dino/commit/d2e0d397)) fix: classic using sub_map_defs, stateless U.append_array

  > Also disables some game modes.
  > 
  > Curious to see if we run into anything that was depending on
  > U.append_array's side effect. In this case it was unexpectedly
  > accumulating mapInput content when merging with subdef inputs.

- ([`9834ec2e`](https://github.com/russmatney/dino/commit/9834ec2e)) fix: restore thread-based level gen

  > Pre-calcs some neighbor data that was pulled from Metsys - the metsys
  > data uses signals to updates its state, which unfortunately complicates
  > doing that work on a thread (b/c signals/deferreds are awaited on the
  > main thread). There might be some clever locking/semaphore workarounds,
  > but instead we precalc the neighbor data that we were building from
  > metsys - ideally we'd be able to run without it.
  > 
  > Adds some awaits to tests that use MetSys's state to sanity check the
  > data.

- ([`889106ca`](https://github.com/russmatney/dino/commit/889106ca)) wip/fix: wait a frame in vania gen, restore tests

  > the recent 'deferred' fixes in vania gen broke the doors/neighbor code,
  > which depends on metsys being update before the doors are setup. This
  > restores the tests, but unfortunately breaks the 'loading' screen -
  > threads that await are resumed by the main thread :/
  > 
  > Looking into a potential way to keep the work on the same thread, but it
  > might be complex/not-worth it:
  > https://github.com/godotengine/godot/issues/79637#issuecomment-1727999031


### 14 May 2024

- ([`61ffa8c3`](https://github.com/russmatney/dino/commit/61ffa8c3)) fix: toss the game_mode after completing

  > probably better to do this in exit_tree or something - tho, why doesn't
  > this happen automatically? either way we need also do this in other
  > paths (player death, exiting via pause menu).

- ([`7e9a8cb8`](https://github.com/russmatney/dino/commit/7e9a8cb8)) feat: skip borders and corners via MapInput

  > Also defers a few generation calls to avoid thread errors - not sure how
  > critical they are, but things to be fairly stable (in classic mode,
  > anyway).

- ([`8a251304`](https://github.com/russmatney/dino/commit/8a251304)) fix: playable classic mode via vania game

  > Defers adding the new vania game node to the scene - hopefully fixes a
  > sometimes crash occuring in the level transitions.

- ([`529403bd`](https://github.com/russmatney/dino/commit/529403bd)) fix: static vania generator room number

  > ensuring unique packed scene names across multiple vania games.

- ([`41644f63`](https://github.com/russmatney/dino/commit/41644f63)) wip: neighbor_direction, one-room vania quest level_complete signal

  > Neighbor direction can now be specified per room, and vania quests now
  > fire level_complete the first time a room's quests are complete.
  > 
  > Fills out more of the classic Sidescroller map defs, first playthrough
  > had a nasty stack-dump crash :/

- ([`62850a93`](https://github.com/russmatney/dino/commit/62850a93)) wip: 'only_advance' flag on room_input

  > 'only_advance' tells the room placement to filter for neighbors in the
  > positive x or y direction (i.e. run-right or fall down). Feels like
  > we'll want more control tho (e.g. climbing vs falling), so probably
  > going to go with something more expressive, like a preferred neighbor
  > direction.

- ([`975cc696`](https://github.com/russmatney/dino/commit/975cc696)) feat: vania room placement using door_mode

  > room placement can now prefer neighbors with a vertical or horizontal
  > door.

- ([`3bb30f03`](https://github.com/russmatney/dino/commit/3bb30f03)) refactor: slightly cleaner/more reusable door filter
- ([`16f333ea`](https://github.com/russmatney/dino/commit/16f333ea)) feat: basic 'door_mode' as a PITA enum

  > Got burned on this enum in several ways all morning. enums backed by
  > ints are terrible!

- ([`76bf07d9`](https://github.com/russmatney/dino/commit/76bf07d9)) refactor: moving all game modes to vaniaGame

  > mapDef.create_node() now uses vaniaGame regardless of level_script. Adds
  > grid_defs to mapInput, mapDef, and preps mapInput to determine
  > local_cells based on the parsed grid defs.
  > 
  > Maybe we can drop dinoLevel and Brick completely? need to get further
  > along first.


### 13 May 2024

- ([`3d0ada74`](https://github.com/russmatney/dino/commit/3d0ada74)) refactor: move arcade/roulette impls from dinoGames to levelDefs
- ([`12b12176`](https://github.com/russmatney/dino/commit/12b12176)) refactor: pull dino level gen games into levelDefs

  > No more generating DinoLevels from dinoGame entities. The game entities
  > are pretty much deprecated - they're all hard-coded maps. maybe they
  > still work?

- ([`43c76f0a`](https://github.com/russmatney/dino/commit/43c76f0a)) wip: misc mapDef cleanups
- ([`a0fb3fb3`](https://github.com/russmatney/dino/commit/a0fb3fb3)) refactor: more notifs, dinoLevel spawns player

  > The DinoLevel and VaniaGame are now both responsible for spawning the
  > player, so the gameMode doesn't need to care about it.

- ([`98e64dea`](https://github.com/russmatney/dino/commit/98e64dea)) refactor: rename RoomInput -> MapInput

  > This 'input' concept is very useful, but no reason to couple it with
  > rooms - that is done already based on context (i.e. is it an input or
  > room_input). In this case, MapDefs will have a shared Input obj to pull
  > entities from.

- ([`dd5e9473`](https://github.com/russmatney/dino/commit/dd5e9473)) deps: delete + update aseprite wizard

  > my current dep update flow doesn't remove deleted files! yikes! This
  > clears a bunch of dead asepritewizard code

- ([`49b5ffc7`](https://github.com/russmatney/dino/commit/49b5ffc7)) deps: all deps up to date

  > With a few tweaks in places.


### 11 May 2024

- ([`d1b85609`](https://github.com/russmatney/dino/commit/d1b85609)) feat: initial game mode scenes for rest of launch games

  > plus very rough map_def details

- ([`4ab2f9d9`](https://github.com/russmatney/dino/commit/4ab2f9d9)) fix: ignore nil room_defs_path
- ([`47a1664e`](https://github.com/russmatney/dino/commit/47a1664e)) feat: classic mode running on mapDefs

  > Extends MapDef to support an attached levelDef, and adds a single func
  > for creating a game_node with a mapDef (be it a DinoLevel or VaniaGame)
  > - this will allow mapDef details (parameters like room_inputs, enemy
  > count, seed, difficulty, etc) to be incorporated into brick's level gen.
  > 
  > vania maps don't fire level_complete yet - will need some improved quest
  > feats to check quests across unloaded vania rooms (likely via
  > room_defs).

- ([`a25f7e71`](https://github.com/russmatney/dino/commit/a25f7e71)) fix: update some entity labels

  > These are a bit fragile at the moment - plus it'd be really nice to
  > support and + or in these labels (eg. b = Beefstronaut or Monstroar).

- ([`01455558`](https://github.com/russmatney/dino/commit/01455558)) feat: basic level-def based ClassicSideScroller impl
- ([`fc814eef`](https://github.com/russmatney/dino/commit/fc814eef)) fix: pull entities based on grid, not label_to_ent

### 10 May 2024

- ([`09b8d31c`](https://github.com/russmatney/dino/commit/09b8d31c)) feat: add all launch games as DinoGameModes

  > Pandora quirk: setting a resource via text-path currently does nothing -
  > a bug i might have introduced with the drag-n-drop feat.

- ([`c86207a0`](https://github.com/russmatney/dino/commit/c86207a0)) docs: add line about addon licenses
- ([`6b52946e`](https://github.com/russmatney/dino/commit/6b52946e)) docs: add dino history blurb

  > Mostly pulled from the dino garden note.


### 9 May 2024

- ([`323c3dec`](https://github.com/russmatney/dino/commit/323c3dec)) docs: update changelog
- ([`47eed652`](https://github.com/russmatney/dino/commit/47eed652)) wip: main menu relayout, list of launch games

  > These buttons don't nav to anything yet - Just whipping the main menu
  > into shape for now.

- ([`76e19d36`](https://github.com/russmatney/dino/commit/76e19d36)) ui: animatedVBox script, button and button list aseprite files

### 8 May 2024

- ([`851711df`](https://github.com/russmatney/dino/commit/851711df)) docs: readme rewrite/clean up
- ([`249d7328`](https://github.com/russmatney/dino/commit/249d7328)) docs: update games list

  > Probably too ambitious for this month, but today, we're going for it!

- ([`74c1a44d`](https://github.com/russmatney/dino/commit/74c1a44d)) docs: move old to docs/old, add new games.md outline

### 7 May 2024

- ([`08ad819e`](https://github.com/russmatney/dino/commit/08ad819e)) feat: add first villager npcs

  > Nice that these get the npc state machines out of the gate -
  > wander/hop/notice/follow/grab/throw all working.
  > 
  > Need animations and some randomization around colors and sizes.

- ([`e5740405`](https://github.com/russmatney/dino/commit/e5740405)) fix: misc dep update errors
- ([`a48a978f`](https://github.com/russmatney/dino/commit/a48a978f)) deps: move to simonGigant text_effects
- ([`6179aa6a`](https://github.com/russmatney/dino/commit/6179aa6a)) deps: update phantom camera
- ([`643e9791`](https://github.com/russmatney/dino/commit/643e9791)) deps: update gdunit
- ([`76a2a3f7`](https://github.com/russmatney/dino/commit/76a2a3f7)) deps: update input helper/dialogue manager
- ([`130830e1`](https://github.com/russmatney/dino/commit/130830e1)) deps: update metsys
- ([`2879e586`](https://github.com/russmatney/dino/commit/2879e586)) docs: fix sidebar old games link
- ([`5a8fc493`](https://github.com/russmatney/dino/commit/5a8fc493)) docs: old-games link on homepage
- ([`3990de78`](https://github.com/russmatney/dino/commit/3990de78)) docs: update and rename changelog
- ([`8739e515`](https://github.com/russmatney/dino/commit/8739e515)) docs: wip architecture/systems outline
- ([`dc2adaea`](https://github.com/russmatney/dino/commit/dc2adaea)) docs: doc readme copy-pasta

  > Copies most of the dino readme into the docsify site's home page.

- ([`e128be2c`](https://github.com/russmatney/dino/commit/e128be2c)) docs: sidebar, navbar, readme doc links
- ([`202d4176`](https://github.com/russmatney/dino/commit/202d4176)) docs: misc updates

  > Brings the dino games/addons/bb tool docs up to date.


### 6 May 2024

- ([`8233a5c1`](https://github.com/russmatney/dino/commit/8233a5c1)) docs: move .org docs to .md

  > Very rough. rewrite incoming!

- ([`b9d9e0fe`](https://github.com/russmatney/dino/commit/b9d9e0fe)) chore: initial changelog

  > Pulls over changelog.clj from log.gd, fixes a sort order issue, then
  > builds two changelogs - one for github, one for the docs site. hopefully
  > these can be just be merged, but w/e.

- ([`6764faf9`](https://github.com/russmatney/dino/commit/6764faf9)) license: source code now MIT licensed
- ([`5478107f`](https://github.com/russmatney/dino/commit/5478107f)) chore: drop pluggs-related stuff

  > Removing this before the incoming license change

- ([`2c5b06db`](https://github.com/russmatney/dino/commit/2c5b06db)) feat: expose list of static mapDefs on vania main menu
- ([`f7dde67a`](https://github.com/russmatney/dino/commit/f7dde67a)) refactor: pull static mapDefs from vania into MapDef.gd
- ([`1135aece`](https://github.com/russmatney/dino/commit/1135aece)) chore: some clj-kondo hooks
- ([`0231b01f`](https://github.com/russmatney/dino/commit/0231b01f)) feat: vania editor updating entities, enemies, tiles
- ([`70585f83`](https://github.com/russmatney/dino/commit/70585f83)) fix: overwrite GODOT_BIN for test tasks

### 5 May 2024

- ([`3940ebc9`](https://github.com/russmatney/dino/commit/3940ebc9)) feat: add more terrains to kingdom, grass, volcano tilesets
- ([`49676c72`](https://github.com/russmatney/dino/commit/49676c72)) fix: support vania room backgrounds in isolation

  > These weren't working without creating via vania generator, which is a pita to devloop

- ([`62170601`](https://github.com/russmatney/dino/commit/62170601)) fix: drop some sounds, fix room transition bug

  > def.genre_type() is a function now!

- ([`9f2ef8e1`](https://github.com/russmatney/dino/commit/9f2ef8e1)) feat: create DinoTiles as first-class tile entity
- ([`365a8d80`](https://github.com/russmatney/dino/commit/365a8d80)) feat: mix terrains when tilemaps have multiple
- ([`032668df`](https://github.com/russmatney/dino/commit/032668df)) refactor: move tile chunks from roomdef to DinoTileMap
- ([`aeb342da`](https://github.com/russmatney/dino/commit/aeb342da)) refactor: move vania_room_def fields to funcs

  > Rather than copy/dupe data from room inputs, we read from them.

- ([`c97084bb`](https://github.com/russmatney/dino/commit/c97084bb)) wip: rough v1 village

  > Lots of incompatibility between the ssplayer and the td action impls!

- ([`d37c291f`](https://github.com/russmatney/dino/commit/d37c291f)) fix: genre-switch no longer crashing

  > You can get stuck in the wall in a few cases, but otherwise this seems
  > pretty solid.

- ([`8cca8d1f`](https://github.com/russmatney/dino/commit/8cca8d1f)) wip: reproducible genre-transition crash

### 4 May 2024

- ([`29745433`](https://github.com/russmatney/dino/commit/29745433)) refactor: drop RoomInputs constants+simplify api. fixes tests.

  > Now building/merging a single roomInput per room, rather than supporting
  > the dict/array/string conveniences.
  > 
  > (which were, in the end, convenient for no one)


### 3 May 2024

- ([`554bd3ac`](https://github.com/russmatney/dino/commit/554bd3ac)) wip: genre room transitions a bit buggy
- ([`a3a5511a`](https://github.com/russmatney/dino/commit/a3a5511a)) feat: quick action bot add
- ([`783121b4`](https://github.com/russmatney/dino/commit/783121b4)) feat: quick harvey_room() func

  > it'd be nice to have an action bot here, wouldn't it?

- ([`de737834`](https://github.com/russmatney/dino/commit/de737834)) feat: add harvey entities, sheep
- ([`55743244`](https://github.com/russmatney/dino/commit/55743244)) feat: add blob walker/chaser as dinoEnemies

  > first topdown enemies!

- ([`986369d8`](https://github.com/russmatney/dino/commit/986369d8)) misc: lsp warning, dino gym auto-add
- ([`98a89189`](https://github.com/russmatney/dino/commit/98a89189)) feat: supporting topdown entities/rooms in vania

### 2 May 2024

- ([`ffaec735`](https://github.com/russmatney/dino/commit/ffaec735)) wip: fix some (not all) tests
- ([`9f9f2b7c`](https://github.com/russmatney/dino/commit/9f9f2b7c)) wip: deepening MapDef support wherever room_inputs were used
- ([`37b1c410`](https://github.com/russmatney/dino/commit/37b1c410)) wip: rough initial MapDef usage from Vania
- ([`877bdc14`](https://github.com/russmatney/dino/commit/877bdc14)) refactor: rename RoomInputs -> RoomInput
- ([`353e53e2`](https://github.com/russmatney/dino/commit/353e53e2)) deps: disable phantom camera updater
- ([`272ed831`](https://github.com/russmatney/dino/commit/272ed831)) refactor: misc brick/dino level clean up

### 1 May 2024

- ([`d944b648`](https://github.com/russmatney/dino/commit/d944b648)) feat: restored dampened screenshake

  > the rotational screenshake requires toggling 'ignore screenshake' in all
  > relevant camera2Ds - kind of annoying, but w/e.
  > 
  > The rotation is somewhat dampened, i think b/c these adjustments are
  > tweened/dampened by the phantom camera setup.

- ([`6a71734b`](https://github.com/russmatney/dino/commit/6a71734b)) refactor: drop old camPOF/POI/POA scenes/nodes

  > Finally free of the old camera code.

- ([`4e4af198`](https://github.com/russmatney/dino/commit/4e4af198)) wip: pulling screenshake into Juice, dropping old camera code
- ([`11874c4b`](https://github.com/russmatney/dino/commit/11874c4b)) refactor: move freezeframe/hitstop into Juice.gd
- ([`c840dc35`](https://github.com/russmatney/dino/commit/c840dc35)) refactor: update sounds/music per update DJ/Sounds/Music

  > Some changes after pulling in the DJ refactors from DotHop. still need
  > to pull the assets from addons/core/dj in.

- ([`8ef74580`](https://github.com/russmatney/dino/commit/8ef74580)) fix: drop extra canvasLayer from vaniaEditor

  > A sneaky bug - the editor was blocking all mouse input! the pause menu
  > gets added via @tool scripts at editor time, and the new vaniaeditor tab
  > had a canvasLayer hanging around that was blocking everything.

- ([`6e5decc9`](https://github.com/russmatney/dino/commit/6e5decc9)) wip: pull in dothop dj sound refactors
- ([`834ca61d`](https://github.com/russmatney/dino/commit/834ca61d)) feat: add vania editor to pause menu

  > Needs some reworking, but it shouldn't be too bad now that we have all
  > the entities and our handy entityButton

- ([`d43abe96`](https://github.com/russmatney/dino/commit/d43abe96)) fix: quick-select dreaming, pause player/weapon change fixed

### 30 Apr 2024

- ([`ecbac0db`](https://github.com/russmatney/dino/commit/ecbac0db)) fix: support changing weapon via joypad
- ([`d6b7203e`](https://github.com/russmatney/dino/commit/d6b7203e)) fix: update hard-coded path in test
- ([`9c4c5fb2`](https://github.com/russmatney/dino/commit/9c4c5fb2)) refactor: src/games level clean up

  > Moved more assets into src/dino, flattened most level dirs. Probably
  > ready to create level defs for most of these. Pluggs, Super Elevator
  > Level are still odd, and demoland/hatbot/ghost-house would be great to
  > pull tilesets/backgrounds/etc out of (for easy reuse/look-n-feel
  > generation).

- ([`a8245f6f`](https://github.com/russmatney/dino/commit/a8245f6f)) refactor: pull harvey entities into dino/ents

  > Also sets z_indexs for most top down entities, restoring harvey as a
  > generated dino level.

- ([`a04302e7`](https://github.com/russmatney/dino/commit/a04302e7)) refactor: pull harvey player/bots into tdplayer/tdnpc

  > Dupes the harvey interaction logic into the tdplayer/tdnpc scripts -
  > ought to dry these up or otherwise genericize the pattern. next is
  > harvey plots as dino/entities!

- ([`1e1271f1`](https://github.com/russmatney/dino/commit/1e1271f1)) refactor: drop dead shirt hud/menus, move mountain player into players
- ([`9e01034d`](https://github.com/russmatney/dino/commit/9e01034d)) feat: restore herd level generation

  > A tricky bit converting a tilemap to a pen and area 2d here, but things
  > are working again!

- ([`ddbb8e25`](https://github.com/russmatney/dino/commit/ddbb8e25)) feat: restore fetchSheep quest

  > Updates the fetchSheep quest to work with the new quest manager

- ([`8df607df`](https://github.com/russmatney/dino/commit/8df607df)) refactor: TopDownNPC with follow/grab/throw impl

  > Pulls the topdown enemy machine into a td npc one, then adds behavior
  > from herd's sheep impl.

- ([`14c165a2`](https://github.com/russmatney/dino/commit/14c165a2)) refactor: TDPlayer calling, grabbing, throwing sheep

### 29 Apr 2024

- ([`c8bfdbff`](https://github.com/russmatney/dino/commit/c8bfdbff)) wip: drop herd/Wolf, fix herd/Fence
- ([`eb3ded06`](https://github.com/russmatney/dino/commit/eb3ded06)) deps: update gd_explorer
- ([`16474e43`](https://github.com/russmatney/dino/commit/16474e43)) deps: update dialogue manager
- ([`8e529a30`](https://github.com/russmatney/dino/commit/8e529a30)) deps: update gdunit
- ([`b04a791d`](https://github.com/russmatney/dino/commit/b04a791d)) deps: update phantom_camera again
- ([`f2fc1094`](https://github.com/russmatney/dino/commit/f2fc1094)) deps: update sound manager
- ([`d69a3332`](https://github.com/russmatney/dino/commit/d69a3332)) deps: update metsys
- ([`db12c12c`](https://github.com/russmatney/dino/commit/db12c12c)) deps: update AsepriteWizard
- ([`8ee49c78`](https://github.com/russmatney/dino/commit/8ee49c78)) deps: update phantom camera
- ([`01b6c177`](https://github.com/russmatney/dino/commit/01b6c177)) feat: ensure pcam on TDPlayer

  > Plus a quick select menu, tho we don't have weapons to switch between
  > yet.

- ([`7ceeefc1`](https://github.com/russmatney/dino/commit/7ceeefc1)) refactor: td player/enemy state differences

  > Removes conditional logic from player/enemy state machines

- ([`197be809`](https://github.com/russmatney/dino/commit/197be809)) refactor: pull shirt blobs into enemies/blobs

  > Also fixes TDMachine naming between player/enemy

- ([`90780dfa`](https://github.com/russmatney/dino/commit/90780dfa)) refactor: clean up TDPlayer/TDEnemy impls

  > Merges the now dead TDBody code into TDPlayer, cleans up the TDPlayer
  > and TDEnemy impls a bit, drops DinoTDPlayer completely.
  > 
  > Still need to clean up the TDMachines (they are duped right now, but
  > there's no need for the player to know about the enemy impl states like
  > wander/chase).

- ([`d7e6cf5e`](https://github.com/russmatney/dino/commit/d7e6cf5e)) wip: move beehive topdown > dino/players,enemies
- ([`5abed6b4`](https://github.com/russmatney/dino/commit/5abed6b4)) refactor: move states > sidescroller_machine

  > making room for mixing in topdown_machine code!


### 28 Apr 2024

- ([`7cf0eb2c`](https://github.com/russmatney/dino/commit/7cf0eb2c)) feat: add lil-big-hat player

  > from hatbot's initial release


### 27 Apr 2024

- ([`70258e2a`](https://github.com/russmatney/dino/commit/70258e2a)) feat: add drops if the enemy/entity has a 'drops' prop

  > Removes drops set on enemies - we'll add them at generation time via roomInputs

- ([`4b908cd9`](https://github.com/russmatney/dino/commit/4b908cd9)) feat: support first props, two bushes
- ([`671d4c9e`](https://github.com/russmatney/dino/commit/671d4c9e)) feat: initial hanging light entity

  > pulls the hanging light in from ghosts.

- ([`a06c34fe`](https://github.com/russmatney/dino/commit/a06c34fe)) fix: correct moved arrow scene
- ([`60ba2f4e`](https://github.com/russmatney/dino/commit/60ba2f4e)) fix: mvoed file paths

  > Ought to get these GridDefs into a proper resource, it might prevent
  > this kind of annoyance.

- ([`00a4ea9f`](https://github.com/russmatney/dino/commit/00a4ea9f)) feat: restore sword animation

  > been broken for way too long!

- ([`091f0f64`](https://github.com/russmatney/dino/commit/091f0f64)) fix: clean up Orb spike implementation

  > Removes use of ingredient_type/data in favor of the new drop_data stuff
  > - in theory more than just orbs can be used as orb items with a few more
  > fixes here.
  > 
  > Cooking pots and delivery zones now accept all tossed items, but it
  > could be configed/extended via drop data. Cooking pots now produce
  > unconfigured 'sspowerups' as well.

- ([`de6893e2`](https://github.com/russmatney/dino/commit/de6893e2)) refactor: reorg-ing a bit - weapons and pickups subfolders
- ([`2c71ec8d`](https://github.com/russmatney/dino/commit/2c71ec8d)) feat: add gold, fire, leaf particle effects
- ([`68d83a93`](https://github.com/russmatney/dino/commit/68d83a93)) feat: dust particle area as room effect

  > Also supports adding random effects in RandomRoom()

- ([`bf2a5ceb`](https://github.com/russmatney/dino/commit/bf2a5ceb)) refactor: make RoomEffect more reusable

  > The only room affects are particleAreas right now, but there will be
  > others - maybe this is a clean pattern for other things as well (tiles,
  > entities, enemies, etc) - could all be hooks for the vania room gen api.

- ([`afd2f10f`](https://github.com/russmatney/dino/commit/afd2f10f)) fix: vania rooms get unique names via index

  > This will ensure hotel db paths are unique

- ([`eb226b04`](https://github.com/russmatney/dino/commit/eb226b04)) fix: disable light occlusion in background tile layers
- ([`4d9eada5`](https://github.com/russmatney/dino/commit/4d9eada5)) fix: adjust test assertion

  > room defs vs inputs/constraints need a refactor, it's a bit messy at the
  > moment.


### 26 Apr 2024

- ([`e03ec68b`](https://github.com/russmatney/dino/commit/e03ec68b)) feat: pull basic coin/gem impls from shirt

  > Coins and gems are now collectable.... plenty of lil issues to work
  > through, but meh, they're in there.

- ([`2c070d14`](https://github.com/russmatney/dino/commit/2c070d14)) chore: clean up and todos

  > the player can still move, enemies still attack while shopping rn.

- ([`baefdc03`](https://github.com/russmatney/dino/commit/baefdc03)) feat: add leaf god as dino entity

  > Just enough to add the npc to the mix

- ([`e076e93b`](https://github.com/russmatney/dino/commit/e076e93b)) fix: update player status via hotel checkins
- ([`9fc5e9d1`](https://github.com/russmatney/dino/commit/9fc5e9d1)) wip: rough exchange 3 leaves for increased hearts
- ([`74a74f9c`](https://github.com/russmatney/dino/commit/74a74f9c)) wip: leaf god shop pcam and ui

  > adds a new NPC state called Shop that kill's the npc movement and
  > prioritizes a pcam. On the leaf god, hooks onto exchange and exit ui
  > buttons. Exchange not yet implemented!

- ([`5b06b45a`](https://github.com/russmatney/dino/commit/5b06b45a)) refactor: player/enemy/boss/npc base scripts no longer @tool

  > I think running these as tool scripts is required for the configuration
  > warning to work, but it introduces a bunch of annoying situations and
  > conditionals to prevent errors from occuring (e.g. calling functions on
  > non-tool scripts now throw errors in the editor unless those also become
  > tool scripts).
  > 
  > I'm not sure i'm really using the config warnings anyway... maybe they
  > could fire at runtime? Or i could break them into a separate
  > tool-scripty config checker node?

- ([`85abf0d9`](https://github.com/russmatney/dino/commit/85abf0d9)) wip: initial NPC impl (leaf god)

  > Sets up a basic npc state machine (idle + walk) and a first
  > consumer (leaf god). Towards a first working 'shop'.

- ([`14678870`](https://github.com/russmatney/dino/commit/14678870)) feat: action areas self-register

  > Similar to actionDetectors, actionAreas now register themselves when
  > their parent is 'ready'. It looks for an ActionHint on the parent and
  > expects some 'actions' to be defined.
  > 
  > We should probably warn if no actions are defined but the area/detector
  > exists and aren't registered yet.
  > 
  > `register_actions` can still be used to set actions on custom
  > areas (e.g.. the coin door has separate front/back action areas)

- ([`07670b0d`](https://github.com/russmatney/dino/commit/07670b0d)) feat: action detector self-setup

  > Rather than expect the parent to call action_detector.setup, we call it
  > from the action detector's ready (connecting to it's parent's ready
  > signal).
  > 
  > it still looks for 'actions', an action_hint, and now 'can_execute_any'
  > on the parent.

- ([`03aee161`](https://github.com/russmatney/dino/commit/03aee161)) refactor: move jumbotron to src/components

### 25 Apr 2024

- ([`dbc7a4b7`](https://github.com/russmatney/dino/commit/dbc7a4b7)) chore: drop misc Log.pr usage

  > new rule: Log.pr/prn is intended for CURRENT debugging - any that are
  > left in place should be one of Log.info/warn/error, or not at all.

- ([`d9e809f2`](https://github.com/russmatney/dino/commit/d9e809f2)) fix: misc theme fixes

  > Now that we own the default theme and font, a handful of things are
  > wonky. not that they were correct in the first place...

- ([`92ac080f`](https://github.com/russmatney/dino/commit/92ac080f)) feat: tween screen blur, add quest notifs
- ([`999faf57`](https://github.com/russmatney/dino/commit/999faf57)) feat: basic popup notif, set default theme

  > The default theme is where the inspector fetches theme type overwrites.
  > Finally understanding how themes are supposed to work - lots of control
  > styling clean up to do :/

- ([`4ea692f1`](https://github.com/russmatney/dino/commit/4ea692f1)) feat: banner notif impl and per-room firing
- ([`e21a7c1f`](https://github.com/russmatney/dino/commit/e21a7c1f)) wip: basic side notif on pickup

  > Moving between canvas layers and control nodes here, keep flip-flopping
  > on the best impl

- ([`caef4a7f`](https://github.com/russmatney/dino/commit/caef4a7f)) feat: basic side notif animate entry/exit
- ([`ec2dd047`](https://github.com/russmatney/dino/commit/ec2dd047)) wip: side notifs clearing after ttl
- ([`31328abd`](https://github.com/russmatney/dino/commit/31328abd)) wip: side notification queueing via slots
- ([`1f2fcd6b`](https://github.com/russmatney/dino/commit/1f2fcd6b)) refactor: pull notifications into src/components
- ([`09bffb38`](https://github.com/russmatney/dino/commit/09bffb38)) refactor: pull offscreenIndicator into src/components
- ([`9380d56a`](https://github.com/russmatney/dino/commit/9380d56a)) chore: drop noisey logs
- ([`2d5d40f7`](https://github.com/russmatney/dino/commit/2d5d40f7)) fix: remove enemies group from raycast

  > This was causing the killEnemies quest to fail - that apparently expects
  > anything in the 'enemies' group to have a 'died' signal.

- ([`d8a7a989`](https://github.com/russmatney/dino/commit/d8a7a989)) refactor: consolidate src/components

  > starting to get at that component library a bit.


### 24 Apr 2024

- ([`4b4a4614`](https://github.com/russmatney/dino/commit/4b4a4614)) feat: add quest manager to vania room

  > VaniaRooms now have a quest manager, which could be used to close and
  > open doors or otherwise react to quest progress and completion.

- ([`64484abd`](https://github.com/russmatney/dino/commit/64484abd)) refactor: Quests via manager node instead of autoload

  > The Quest manager now checks it's parents children for quests, and
  > subscribes to add_node events on the tree to trigger updates.
  > 
  > This could present an issue with 'totals' moving around, and the
  > approach has some clear performance/ugliness, but the general flow seems
  > like the preferred one. Next, to integrate into vania rooms a bit.

- ([`27f35d7d`](https://github.com/russmatney/dino/commit/27f35d7d)) wip: refactoring Quests

  > Changing the mental model for quests from an autoload to a QuestManager
  > node.
  > 
  > The quest manager subscribes to the tree's node_added/removed events and
  > adds/removes/update Quest children based on added nodes.
  > 
  > Not quite deduping at the moment, plus probably some other issues.

- ([`5bb5add4`](https://github.com/russmatney/dino/commit/5bb5add4)) wip: towards player pickup support

  > A rough impl, only supporting DropData for now. Not sure if we want to
  > be very specific or general about collecting pickups - e.g. can we
  > create quick one-off leaf/coin/etc impls? can they easily opt-in to
  > being collected? or should we just hard-code counts/pickups/powerups on
  > the player body?

- ([`09eaa94f`](https://github.com/russmatney/dino/commit/09eaa94f)) feat: v1 treasure chest via actions and drops

  > Adds an action area and open action that creates drops if any are
  > assigned to the tresure chest.

- ([`2ba30964`](https://github.com/russmatney/dino/commit/2ba30964)) feat: boxes destructible and dropping drops

  > Ought to move these boxes over to a rigid body so we can knock them
  > around a bit

- ([`0bb7dee8`](https://github.com/russmatney/dino/commit/0bb7dee8)) fix: restore arcade/roulette modes

  > Not all game entities work right now, but this at least gets gunner
  > working in an arcade and roulette context. the dino level has a few
  > different consumers right now, but it's mostly self-sufficient for now.
  > 
  > Hopefully these can be used to launch 'mini' games from in-vania arcade
  > machines.

- ([`f2aa00ad`](https://github.com/russmatney/dino/commit/f2aa00ad)) fix: restore classic mode dino level transitions

  > Refactors dino levels and the way class mode manages them to restore
  > player respawning after the first level.
  > 
  > feed-the-void quests are broken rn b/c the orbs weapon is currently in
  > accessible - pickups/inventory/crafting need to be impled to restore
  > that.
  > 
  > quests need a refactor to operate over entities in vania room defs (not
  > just in-tree nodes).


### 23 Apr 2024

- ([`478d36c3`](https://github.com/russmatney/dino/commit/478d36c3)) feat: v1 navigation meshes per-room

  > More or less restores boss behavior. woo!
  > 
  > Only slightly pissed off at gdscript array type errors - just let the
  > data through, no one will get hurt! instead we stop the world b/c an
  > Array isn't an Array[RoomInputs], even though it might be. Super
  > annoying b/c union types aren't supported.

- ([`985d4760`](https://github.com/russmatney/dino/commit/985d4760)) wip: adding navigation regions to vaniaRooms

  > also wips setting a debug_room_def on VaniaRoom.
  > 
  > RoomInputs getting a bit messy...

- ([`9fc5d4a5`](https://github.com/russmatney/dino/commit/9fc5d4a5)) fix: dino bosses calc warp spots using nav agent

  > A basic algorithm - try to nav to a spot in all directions, use the
  > navAgent to get one inside any active nav region.

- ([`03750e45`](https://github.com/russmatney/dino/commit/03750e45)) feat: dino gym auto-adds camera

### 21 Apr 2024

- ([`c22d952f`](https://github.com/russmatney/dino/commit/c22d952f)) wip: support setting PandoraEntities in exported arrays

  > I'm not sure the implications of the object being null/invalid here, but
  > this seems to allow setting pandora entities in arrays directly in the
  > inspector - hopefully won't run into any issues ....?

- ([`5a2401fc`](https://github.com/russmatney/dino/commit/5a2401fc)) wip: toying with setting room inputs in the inspector
- ([`a7e7e4ba`](https://github.com/russmatney/dino/commit/a7e7e4ba)) fix: reduce log warning noise
- ([`f6703c31`](https://github.com/russmatney/dino/commit/f6703c31)) refactor: well typed tilemap_scenes in RoomInputs/Defs
- ([`2796541a`](https://github.com/russmatney/dino/commit/2796541a)) refactor: move RoomInputs to custom resources

  > Adds types, exports vars - closer to creating these in the editor now.

- ([`c185b7fd`](https://github.com/russmatney/dino/commit/c185b7fd)) wip: step toward abstracting roomEffects

  > Creates a RoomEffect custom resource that houses the scene and offers an
  > add effect per-cell method. Sets up a nice space to expand support for
  > different effect types.


### 20 Apr 2024

- ([`d96c2b5b`](https://github.com/russmatney/dino/commit/d96c2b5b)) wip: basic rain/snow effects via RoomInputs

  > Needs an abstraction/resource backing so we're note assuming effects are
  > gpu particles (i.e. how to support general effects, props,
  > backgrounds... maybe invert the dep for entities/enemies/tiles too).

- ([`8673548b`](https://github.com/russmatney/dino/commit/8673548b)) refactor: merge dino/sidescroller into dino/{players/enemies/bosses}

  > Also moves dino/enemies/bosses up to dino/bosses


### 19 Apr 2024

- ([`86828f26`](https://github.com/russmatney/dino/commit/86828f26)) fix: dodge noisey parser warning
- ([`7500ed82`](https://github.com/russmatney/dino/commit/7500ed82)) feat: refactor orb drop/pickup into DropData and Pickup

  > More general Drop handling. Not quite handled on the player side yet,
  > but the little ding when you collect it is some nice feedback.

- ([`964ea830`](https://github.com/russmatney/dino/commit/964ea830)) refactor: drop gloomba/glowmba, rename enemyrobot -> robot

  > Consolidating more on the blob. gloombas had a light, a stun+bump
  > mechanic, and a goofy hop whenever something near them moved. some/most
  > has been pulled into the ssenemy, tho not everything is working yet.

- ([`b630ed61`](https://github.com/russmatney/dino/commit/b630ed61)) refactor: enemy-robot now an SidescrollerEnemy script + machine
- ([`e7bb1f64`](https://github.com/russmatney/dino/commit/e7bb1f64)) chore: drop 'goomba' enemy

  > this was effectively copied into the 'blob', no need for the dupe.
  > 
  > Also moves blob drops/pickups/tossed items into src/dino/pickups


### 18 Apr 2024

- ([`88ae2909`](https://github.com/russmatney/dino/commit/88ae2909)) fix: drop spikes from dino entities

  > Spikes and one-way platforms are going to be 'tile-based' - i think the
  > portal top/bottom will be similar. for now i'm considering these
  > separate from the more object-based 'entities'.

- ([`276e01b0`](https://github.com/russmatney/dino/commit/276e01b0)) refactor: restore room_inputs tests with non-string ents
- ([`14240e93`](https://github.com/russmatney/dino/commit/14240e93)) fix: cover gridParser missing legend val case

  > Not sure this is the right behavior, but it's enforced and we throw a
  > warning to better deal with it next time.

- ([`53c3a2b6`](https://github.com/russmatney/dino/commit/53c3a2b6)) fix: set window title when gdunit runs, set logger termsafe colors

  > Hacky solutions, but it's working so i'm happy.

- ([`886dc6e2`](https://github.com/russmatney/dino/commit/886dc6e2)) refactor: setup parsing grid-defs per entity/enemy

  > Maybe this gets slow.... but i doubt it. If needed we can statically
  > cache it per path in GridDefs.

- ([`2e64d0a0`](https://github.com/russmatney/dino/commit/2e64d0a0)) refactor: move load(string) to entity.get_scene(ent_id)
- ([`0a7ada66`](https://github.com/russmatney/dino/commit/0a7ada66)) fix: add props to enemy states
- ([`c60367a2`](https://github.com/russmatney/dino/commit/c60367a2)) refactor: support PlayerSpawnPoint as DinoEntity

  > Pulls the player spawn point into src/dino/entities
  > 
  > Also fixes some ss player/enemy bump interactions

- ([`48e21f42`](https://github.com/russmatney/dino/commit/48e21f42)) feat: move remaining dino string ents to pandora ents

  > Getting these better represented, and moving away from using strings
  > everywhere. this should be better and open up a simpler path for
  > creating/adding more entities.

- ([`637182bf`](https://github.com/russmatney/dino/commit/637182bf)) fix: don't connect if already connected

  > still annoying this behavior isn't the default :eyeroll:

- ([`eed9968e`](https://github.com/russmatney/dino/commit/eed9968e)) refactor: pull most machine state checks into properties

  > Adds Machine.<property> funcs that proxy to the current State - this
  > lets avoid checking that the state exists whenever calling it, and helps
  > provide a default if transitioning if we want, tho we should probably
  > just call the old state's func.
  > 
  > Refactors more machine.state.name in ['blah'] usage into new
  > properties in the sidescroller boss states.
  > 
  > These properties live directly on the Machine and State implementations
  > right now, which is not ideal - should probably subclass it for the each
  > machine... already running into confusing reusage (player vs enemy
  > can_bump). Going to hold off for now as these properties accumulate.
  > 
  > I'm not loving needing to impl each property per state, but it's
  > probably the right move. maybe it should just be an exported var or something?


### 16 Apr 2024

- ([`33221336`](https://github.com/russmatney/dino/commit/33221336)) fix: only call anim signals on current state

  > Also adds properties to player states and State.gd, and sets a
  > next_state during transitions (in case the exit() func needs it).

- ([`0a814db4`](https://github.com/russmatney/dino/commit/0a814db4)) feat: machine/state connecting to actor.anim signals

  > Adds some first-class functions to the State implementation for handling
  > animation_finished and frame_changed. Several existing states could be
  > cleaned up a bit now that these are provided auto-magically.

- ([`a188408d`](https://github.com/russmatney/dino/commit/a188408d)) fix: add fallback phantom_camera to vaniaGame

  > Looks like we always need at least one phantomCamera in the scene - this
  > was crashing when dropping + recreating the player (when loading the
  > first map from the 'loading' screen).

- ([`d5d38952`](https://github.com/russmatney/dino/commit/d5d38952)) wip: restore SSEnemy scene

  > Plus some other tweaks.


### 15 Apr 2024

- ([`6b2ea48c`](https://github.com/russmatney/dino/commit/6b2ea48c)) refactor: misc ssplayer tweaks during read-thru
- ([`60155b57`](https://github.com/russmatney/dino/commit/60155b57)) refactor: cleaning up old ssPlayer vars

  > dropping player-or-enemy flags

- ([`de2ffcff`](https://github.com/russmatney/dino/commit/de2ffcff)) refactor: attach playerCamera in SSPlayer

  > Players now ensure a dino/players/PlayerCamera, which is a phantom
  > camera. The scene they are added to should have a camera with pcamHost
  > as a child.

- ([`8bc37ef2`](https://github.com/russmatney/dino/commit/8bc37ef2)) feat: vania room dark exterior, adding color rect bg to cells

  > Quick impl for adding a color rect to each local cell's rect. Updates
  > the vaniaRoom background to a very dark black to make 'doors' a bit more
  > clear - tho really we should figure out a nicer 'portal' of sorts.


### 14 Apr 2024

- ([`35ad603b`](https://github.com/russmatney/dino/commit/35ad603b)) fix: misc lsp errors
- ([`a74eae6f`](https://github.com/russmatney/dino/commit/a74eae6f)) chore: sidescroller enemy/boss clean up
- ([`3d2c1629`](https://github.com/russmatney/dino/commit/3d2c1629)) refactor: drop DinoSSPlayer, SSData

  > more SidescrollerPlayer consolidation

- ([`9d0dd537`](https://github.com/russmatney/dino/commit/9d0dd537)) deps: drop gd_explorer for a moment
- ([`b2a7c7ef`](https://github.com/russmatney/dino/commit/b2a7c7ef)) refactor: beehive/sidescroller pulled into dino/sidescroller

  > Groups all the weapons code/assets

- ([`5ea5be29`](https://github.com/russmatney/dino/commit/5ea5be29)) refactor: merge SSBody and SSPlayer
- ([`2c29a78e`](https://github.com/russmatney/dino/commit/2c29a78e)) deps: drop extra file
- ([`f7afd8b6`](https://github.com/russmatney/dino/commit/f7afd8b6)) refactor: machines start themselves

  > Rather than call machine.start in every entity script, machines start
  > themselves when their parent is ready - a bit cleaner and leaning into
  > the abstraction a bit.

- ([`6c44a65d`](https://github.com/russmatney/dino/commit/6c44a65d)) refactor: pull Machine.gd, State.gd out of beehive

  > Moving these into their own lil state machine lib

- ([`6de70ee0`](https://github.com/russmatney/dino/commit/6de70ee0)) refactor: rearrange machine/State.gd
- ([`0f54e3cc`](https://github.com/russmatney/dino/commit/0f54e3cc)) chore:  some quickSelect menu clean up
- ([`6d4ee8c7`](https://github.com/russmatney/dino/commit/6d4ee8c7)) deps: drop gdunit4/test dir
- ([`ce12aa12`](https://github.com/russmatney/dino/commit/ce12aa12)) chore: lsp warnings/errors
- ([`a84ab734`](https://github.com/russmatney/dino/commit/a84ab734)) deps: update to log.gd latest, set pretty colors
- ([`90624b4f`](https://github.com/russmatney/dino/commit/90624b4f)) deps: phantom-camera import churn
- ([`84b13abd`](https://github.com/russmatney/dino/commit/84b13abd)) deps: restore (now unused) metSys load_room func

### 13 Apr 2024

- ([`222d50ec`](https://github.com/russmatney/dino/commit/222d50ec)) chore: run tests in godot 4.2.2
- ([`3187fc8a`](https://github.com/russmatney/dino/commit/3187fc8a)) refactor: pull metsys.game changes into VaniaGame

  > Rather than editing the MetSys source files, we overwrite load_room
  > completely in VaniaGame.

- ([`66ee4cf2`](https://github.com/russmatney/dino/commit/66ee4cf2)) deps: update gdunit
- ([`e55d180e`](https://github.com/russmatney/dino/commit/e55d180e)) deps: update sound_manager
- ([`31e77956`](https://github.com/russmatney/dino/commit/31e77956)) deps: update gd_explorer
- ([`4ad9f207`](https://github.com/russmatney/dino/commit/4ad9f207)) deps: update gd-plug-ui
- ([`fd75620b`](https://github.com/russmatney/dino/commit/fd75620b)) deps: update log.gd

### 11 Apr 2024

- ([`21fa70ff`](https://github.com/russmatney/dino/commit/21fa70ff)) refactor: use exported categories const instead of random ent id
- ([`b3632289`](https://github.com/russmatney/dino/commit/b3632289)) refactor: rename roomType to genreType
- ([`816204a1`](https://github.com/russmatney/dino/commit/816204a1)) ci: don't cancel builds
- ([`12fe4479`](https://github.com/russmatney/dino/commit/12fe4479)) feat: blur bg on quick select menu
- ([`6a65f239`](https://github.com/russmatney/dino/commit/6a65f239)) feat: edit enemies, room_count from vania menu
- ([`9088612f`](https://github.com/russmatney/dino/commit/9088612f)) refactor: update entityButton consumers with simpler constructor

  > EntityButton.newButton now supports a passed entity and on_select
  > callback, so we're not leaking the signal name and set_*_entity
  > everywhere.

- ([`e769bc2c`](https://github.com/russmatney/dino/commit/e769bc2c)) feat: remove types from entity button

  > Removes noisey per-type handling. this button supports most entities, go
  > for it.


### 10 Apr 2024

- ([`888d5912`](https://github.com/russmatney/dino/commit/888d5912)) feat: vania consuming DinoEnemy entities

  > Moving from raw strings to actual entities in the room def.

- ([`5dd0434c`](https://github.com/russmatney/dino/commit/5dd0434c)) wip: dino enemy pandora entities

  > and portrait diaspora

- ([`84598bdb`](https://github.com/russmatney/dino/commit/84598bdb)) feat: initial quick-swap menu for changing weapons

  > Pauses time while selecting, picks the new weapon on release. pretty cool!

- ([`e7e0def0`](https://github.com/russmatney/dino/commit/e7e0def0)) wip: quick select and dino gym fixes
- ([`2dfb53a5`](https://github.com/russmatney/dino/commit/2dfb53a5)) wip: quick select menu rendering weapons!
- ([`43a11c45`](https://github.com/russmatney/dino/commit/43a11c45)) fix: fixups after moving games into dino/games dir

  > Cuts out more dead game entity fields, moving most (but not all) games
  > to a DinoLevel setup. not sure if all these work with roulette, but
  > arcade should support some basic play-one-game for a while usage (e.g.
  > old demoland, hatbot, ghost house maps are sort still supported)

- ([`3f492e77`](https://github.com/russmatney/dino/commit/3f492e77)) wip: dropping dead pandora category and fields
- ([`f27e2545`](https://github.com/russmatney/dino/commit/f27e2545)) refactor: drop most menus, more consolidation
- ([`983e9053`](https://github.com/russmatney/dino/commit/983e9053)) refactor: move pause menu into dino/menus/pause

  > Big plans for this menu!


### 9 Apr 2024

- ([`b903e73d`](https://github.com/russmatney/dino/commit/b903e73d)) chore: support the 'new' dino entities

  > Adds levelscript chunks and roomInput support for the newly refactored
  > dino entities - brief testing shows at least the box/treasureBox and
  > some checkpoints are working.

- ([`d5a9fc22`](https://github.com/russmatney/dino/commit/d5a9fc22)) refactor: consolidate more assets + portraits
- ([`849c0b8f`](https://github.com/russmatney/dino/commit/849c0b8f)) refactor: correct more broken paths

  > misc spike and SEL cleanup

- ([`d60a5ccd`](https://github.com/russmatney/dino/commit/d60a5ccd)) fix: bunch of broken paths after moving everything
- ([`babf347b`](https://github.com/russmatney/dino/commit/babf347b)) refactor: move src/bb_godot to bb/*
- ([`092c52ea`](https://github.com/russmatney/dino/commit/092c52ea)) refactor: consolidate woods, drop clawe
- ([`ed68ad5c`](https://github.com/russmatney/dino/commit/ed68ad5c)) refactor: more consolidation (spike, gunner pickups)

  > Dropping more dead assets/scenes/sprites, this time mostly from gunner,
  > but including 'gunner pickups', which tower used.

- ([`e50b0217`](https://github.com/russmatney/dino/commit/e50b0217)) refactor: hatbot, mountain assets diaspora

  > moving more per-game assets into their new dino places.

- ([`a7cf517b`](https://github.com/russmatney/dino/commit/a7cf517b)) refactor: pull hatbot bosses, entities into dino/entities
- ([`7b4b447b`](https://github.com/russmatney/dino/commit/7b4b447b)) chore: drop/move gunner assets, consolidate ghost block
- ([`bbdc8783`](https://github.com/russmatney/dino/commit/bbdc8783)) chore: drop dead ghosts/player and shaders
- ([`2fa66498`](https://github.com/russmatney/dino/commit/2fa66498)) chore: drop dead export configs
- ([`72c44fc9`](https://github.com/russmatney/dino/commit/72c44fc9)) refactor: pull glowmba into dino/entities
- ([`9821c8d6`](https://github.com/russmatney/dino/commit/9821c8d6)) chore: drop dead shaders
- ([`65858ffd`](https://github.com/russmatney/dino/commit/65858ffd)) refactor: pull enemyRobot into dino/entities
- ([`e944ceb0`](https://github.com/russmatney/dino/commit/e944ceb0)) refactor: pull gunner targets into dino/entities

  > Similar for the break the targets quest

- ([`56dd5cc3`](https://github.com/russmatney/dino/commit/56dd5cc3)) refactor: pull checkpoints into dino/entities/*
- ([`e7c88faa`](https://github.com/russmatney/dino/commit/e7c88faa)) feat: support mountain 'checkpoints' as a vania entity

  > Drops in a LogCheckpoint as a vania entity.

- ([`57daaa2b`](https://github.com/russmatney/dino/commit/57daaa2b)) fix: 'resurrect' player when respawning

  > Dead players are broken right now b/c is_player is never corrected. This
  > fix isn't perfect but works in the vania context.


### 8 Apr 2024

- ([`ff87fc79`](https://github.com/russmatney/dino/commit/ff87fc79)) wip: toying with some background art
- ([`bbc3b78a`](https://github.com/russmatney/dino/commit/bbc3b78a)) pixels: exploring some background and platform patterns
- ([`ceee7ef3`](https://github.com/russmatney/dino/commit/ceee7ef3)) fix: menu focus highlight and button rearrangement
- ([`9a30639c`](https://github.com/russmatney/dino/commit/9a30639c)) feat: vania/classic menus before starting mode

  > Plus a minor ux improvement in the game mode button.


### 7 Apr 2024

- ([`e89d1fe1`](https://github.com/russmatney/dino/commit/e89d1fe1)) fix: prevent tiles from matching on bottom edge
- ([`2e6ec015`](https://github.com/russmatney/dino/commit/2e6ec015)) feat: prevent entities/tiles from spawning outside concave rooms

  > Walk per local_cell instead of getting the whole tilemap's rect.

- ([`fc0fecec`](https://github.com/russmatney/dino/commit/fc0fecec)) feat: enable jetpack by default

  > makes these rooms more traversible

- ([`35c9500b`](https://github.com/russmatney/dino/commit/35c9500b)) wip: misc camera tweaking, plus some initial lighting
- ([`9c6ffb27`](https://github.com/russmatney/dino/commit/9c6ffb27)) wip: toying with cell size, fixing player spawn point

  > the game was using the load-screen's player spawn point, which hadn't
  > left the tree yet :/


### 6 Apr 2024

- ([`c93f0eaa`](https://github.com/russmatney/dino/commit/c93f0eaa)) fix: cam limits per cell
- ([`2530b9fa`](https://github.com/russmatney/dino/commit/2530b9fa)) refactor: pull slowmo into Juice.gd
- ([`27d77fd7`](https://github.com/russmatney/dino/commit/27d77fd7)) chore: disable orphan reports

### 5 Apr 2024

- ([`438995e6`](https://github.com/russmatney/dino/commit/438995e6)) feat: camera - add enemies to follow group

  > Toying with a better camera setup... not sure what will work here.

- ([`39f5af59`](https://github.com/russmatney/dino/commit/39f5af59)) chore: loading notif, gen more rooms
- ([`945f6d0e`](https://github.com/russmatney/dino/commit/945f6d0e)) fix: null check and some autofrees

  > Generating a bunch of orphans, should clean those up at some point.

- ([`e22e10c1`](https://github.com/russmatney/dino/commit/e22e10c1)) refactor: drop Hood autoload, move notifs to Debug
- ([`8605591a`](https://github.com/russmatney/dino/commit/8605591a)) feat: level generation notifs
- ([`ef6ff132`](https://github.com/russmatney/dino/commit/ef6ff132)) feat: vania game playable load screen

  > Moves the proc-gen to a thread and drops a little playground for hopping
  > around in it's place.

- ([`7a596870`](https://github.com/russmatney/dino/commit/7a596870)) feat: select-character in new vania menu

  > Sets up a main menu for vania. for now pulls over the select-character
  > and game logic from the roulette menu, which slots in nicely with the
  > game-mode api. maybe could have a class/node/something for that?

- ([`9a43e16d`](https://github.com/russmatney/dino/commit/9a43e16d)) chore: misc gdunit settings
- ([`10ad6111`](https://github.com/russmatney/dino/commit/10ad6111)) refactor: move dino/modes/vania to dino/vania

  > Getting a feel for organizing all this nonsense

- ([`4dde3ed5`](https://github.com/russmatney/dino/commit/4dde3ed5)) fix: remove some lingering plugin.gd/cfgs
- ([`3b1c92a5`](https://github.com/russmatney/dino/commit/3b1c92a5)) refactor: pull dj/metro/hotel into addons/core/*
- ([`545c607a`](https://github.com/russmatney/dino/commit/545c607a)) fix: use Log.error when it's relevant
- ([`076e293d`](https://github.com/russmatney/dino/commit/076e293d)) ci: update deploy godot versions
- ([`4c27f627`](https://github.com/russmatney/dino/commit/4c27f627)) fix: make sure user map dir exists
- ([`33766b32`](https://github.com/russmatney/dino/commit/33766b32)) chore: add log exposing resourceSaver error
- ([`633f3544`](https://github.com/russmatney/dino/commit/633f3544)) fix: use custom_user_dir

  > Hopeful this is allowed to be written to via github actions

- ([`be3c67bc`](https://github.com/russmatney/dino/commit/be3c67bc)) fix: addons/thanks -> addons/core/thanks
- ([`4cb1037c`](https://github.com/russmatney/dino/commit/4cb1037c)) fix: restore some lost pandora resource paths
- ([`80f47aaf`](https://github.com/russmatney/dino/commit/80f47aaf)) fix: restore some td/ss weapons to fix weapon tests
- ([`e2255c26`](https://github.com/russmatney/dino/commit/e2255c26)) fix: update broken reptile paths
- ([`9ce82ec2`](https://github.com/russmatney/dino/commit/9ce82ec2)) fix: prevent addons from removing their autoloads

  > It seems addons removing their autoloads in _exit_tree might not be the
  > right move - running an initial project scan to get things working (e.g.
  > in CI) and then running godot again (execute tests via gdunit) results
  > in the autoloads being added back in a different order, leading to
  > crashes.

- ([`e45531f8`](https://github.com/russmatney/dino/commit/e45531f8)) fix: update a bunch of broken paths
- ([`67a89df6`](https://github.com/russmatney/dino/commit/67a89df6)) chore: misc resource cruft
- ([`70eb49d5`](https://github.com/russmatney/dino/commit/70eb49d5)) refactor: move beehive/brick/navi/hood into addons/core/*
- ([`83b4ff67`](https://github.com/russmatney/dino/commit/83b4ff67)) refactor: move camera/quest/reptile into addons/core/*
- ([`6ef72f50`](https://github.com/russmatney/dino/commit/6ef72f50)) refactor: move thanks addon to core/thanks
- ([`56b60b6c`](https://github.com/russmatney/dino/commit/56b60b6c)) wip: disable camera input listeners
- ([`05b60296`](https://github.com/russmatney/dino/commit/05b60296)) refactor: delete TrolleyDebugPanel and rest of trolley addon
- ([`5e8e71d3`](https://github.com/russmatney/dino/commit/5e8e71d3)) refactor: move more Trolley into core/actions, Trolls static funcs
- ([`f8a338ab`](https://github.com/russmatney/dino/commit/f8a338ab)) refactor: move most Trolley autoload to static Trolls

  > Pulling in the Trolls trolley rewrite used in dothop

- ([`6cfcf014`](https://github.com/russmatney/dino/commit/6cfcf014)) fix: remove dead (unused) file

### 4 Apr 2024

- ([`f944892d`](https://github.com/russmatney/dino/commit/f944892d)) ci: enable gdunit4 and git with lfs
- ([`106c7bf0`](https://github.com/russmatney/dino/commit/106c7bf0)) ci: try installed gdunit
- ([`a8186333`](https://github.com/russmatney/dino/commit/a8186333)) ci: switch to new gdunit workflow
- ([`a4ce3e26`](https://github.com/russmatney/dino/commit/a4ce3e26)) fix: misc test and impl fixes
- ([`c54cd8b4`](https://github.com/russmatney/dino/commit/c54cd8b4)) feat: toggleable editor, some tile chunks
- ([`1c41da6b`](https://github.com/russmatney/dino/commit/1c41da6b)) feat: switch to phantom camera
- ([`9c83f9a2`](https://github.com/russmatney/dino/commit/9c83f9a2)) deps: misc import cruft
- ([`369ba351`](https://github.com/russmatney/dino/commit/369ba351)) deps: add phantom camera
- ([`6bb73536`](https://github.com/russmatney/dino/commit/6bb73536)) deps: update AsepriteWizard
- ([`6fb33895`](https://github.com/russmatney/dino/commit/6fb33895)) deps: update dialogue_manager
- ([`09f5717a`](https://github.com/russmatney/dino/commit/09f5717a)) deps: update gd-plug-ui
- ([`60e403e6`](https://github.com/russmatney/dino/commit/60e403e6)) deps: update gdunit
- ([`9131f1f6`](https://github.com/russmatney/dino/commit/9131f1f6)) deps: update gd_explorer
- ([`9df0ad41`](https://github.com/russmatney/dino/commit/9df0ad41)) deps: update metsys

  > Careful to avoid some of my local changes.

- ([`e210d5c1`](https://github.com/russmatney/dino/commit/e210d5c1)) feat: better api for RoomInputs T and L shaped rooms
- ([`b6f445b5`](https://github.com/russmatney/dino/commit/b6f445b5)) feat: add lots of concave rooms!

  > Had to 'normalize' the local_cells, b/c the room placer/generator
  > expects it, but now any shape gets normalized, so viable shapes should
  > work regardless of offset.

- ([`0af5ef8d`](https://github.com/russmatney/dino/commit/0af5ef8d)) feat: basic concave tilemap border support

  > plus a test!
  > 
  > fills in the border-corner as well.

- ([`e7fcfe4f`](https://github.com/russmatney/dino/commit/e7fcfe4f)) test: coverage for placing rooms, and fix possible_room search

  > We were leaving off half the results! wut!

- ([`71fdfece`](https://github.com/russmatney/dino/commit/71fdfece)) feat: RoomInputs supporting custom shape
- ([`966512ea`](https://github.com/russmatney/dino/commit/966512ea)) chore: set window title for gdunit cli runner

  > This lets me target the godot instance that runs during testing from i3,
  > to keep that pita buried/elsewhere.

- ([`35b80bef`](https://github.com/russmatney/dino/commit/35b80bef)) fix: drop removed field
- ([`3b75059f`](https://github.com/russmatney/dino/commit/3b75059f)) test: coverage for VaniaGame start, add, remove rooms

  > Getting some nice coverage and uncovering some quirks here, tho mostly
  > it's handling logic when the nodes haven't actually been added to the
  > scene yet. Still, that'll allow for some programmatic nicities later on,
  > plus the coverage helps reach for more testing as things start to get
  > more complicated.

- ([`de2c1ad3`](https://github.com/russmatney/dino/commit/de2c1ad3)) test: coverage for neighbor updates after add/remove room

  > Maybe a bit hairy - this adds room_defs and neighbor_data to the
  > VaniaGenerator's internal state. hopefully things don't get out of
  > sync!! we have to be careful where and how we update room_def data -
  > ideally it has no really state, only raw input data and helper
  > functions.

- ([`323b4c8f`](https://github.com/russmatney/dino/commit/323b4c8f)) wip: test covering gen-time door creation

  > the doors (and walls) are recalced at _ready time right now, but ideally
  > we'd update them at generation time - this requires some
  > neighbor-awareness, and updating/repacking neighbor rooms when a room is
  > added/removed. I'm not sure how costly this is... but we probably should
  > only update affected rooms, not all of them.

- ([`6706aa44`](https://github.com/russmatney/dino/commit/6706aa44)) fix: use U.get_ to return fallback when val is null
- ([`84203b73`](https://github.com/russmatney/dino/commit/84203b73)) test: initial tests for vania_generator

  > Moves the vania_room tests to their own file, and starts in on some
  > proper generator tests - these are cutting nicely so far, especially
  > with the room inputs api from yesterday.


### 3 Apr 2024

- ([`4115adc3`](https://github.com/russmatney/dino/commit/4115adc3)) fix: restore doors

  > Some complications here, mostly around needing to redo walls/doors
  > whenever neighbors change. for now we redo walls/doors in VaniaRoom _ready()

- ([`1db6ce29`](https://github.com/russmatney/dino/commit/1db6ce29)) test: coverage for walls/doors vs neighbors
- ([`10dbf57a`](https://github.com/russmatney/dino/commit/10dbf57a)) fix: restore vania generator tests
- ([`87aaa133`](https://github.com/russmatney/dino/commit/87aaa133)) chore: pull some vaniaRoom logic into vaniaRoomDef
- ([`c01379be`](https://github.com/russmatney/dino/commit/c01379be)) fix: adjust gen room_inputs to match new style

  > Uglier but more flexible - could get into some nice constructors if a
  > code api for this is useful.

- ([`273e3aba`](https://github.com/russmatney/dino/commit/273e3aba)) feat: support constraints as arrays/dicts and with opts

  > This code is crazy, hopefully the unit tests are enough to combat it.

- ([`8bb54c8b`](https://github.com/russmatney/dino/commit/8bb54c8b)) refactor: roomInputs as lists of constraint-constants

  > Updates tests to be sure this new style works as well.

- ([`9d04205d`](https://github.com/russmatney/dino/commit/9d04205d)) feat: basic constraint display and reapplication via editor

  > Constraints are now exposed in the editor, and can be crudded - as they
  > are added/removed, they are reapplied and the room is regenerated.
  > 
  > Note that changing room shape doesn't work right now, and probably
  > introduces undiscovered bugs!

- ([`d2e115b4`](https://github.com/russmatney/dino/commit/d2e115b4)) wip: toying with tracking RoomInputs constraints
- ([`0ec41ded`](https://github.com/russmatney/dino/commit/0ec41ded)) refactor: pull out ensure_tilemaps impl

  > Adds U.ensure_owned_child to utility. is there a better way to do this?

- ([`a223403b`](https://github.com/russmatney/dino/commit/a223403b)) wip: towards more structure in roomDefs
- ([`07235aec`](https://github.com/russmatney/dino/commit/07235aec)) test: coverage for RoomInputs merge + update_def

  > Coverage for the behavior implemented via roomInputs - asserting that
  > overwriting and distinct/dupe-removal occurs as expected for entities,
  > room shapes, and tilemaps.
  > 
  > RoomInputs will grow to include most/all of the data a room needs to
  > be generated, so this should set a stable foundation to work with.


### 2 Apr 2024

- ([`91d0a38b`](https://github.com/russmatney/dino/commit/91d0a38b)) chore: fixup/disable some broken tests
- ([`2c488e60`](https://github.com/russmatney/dino/commit/2c488e60)) refactor: composable RoomInputs, basic tests

  > Introduces RoomInputs, a class full of static functions for
  > combining/merging tile_sets, entities, and room shapes.
  > 
  > RoomInputs do the heavy lifting when defining VaniaRoomDefs to be
  > generated.
  > 
  > The VaniaRoomDef acts as a 'RoomData' object for each VaniaRoom during
  > generation and while the game is running (for getting neighboring room
  > data, for example).
  > 
  > RoomInputs are intended as the data object to be composed together and
  > targetted by level-design apis. some of it's static helpers present one
  > field (like a single tilemap), others present them in
  > combination (entities + room_size). These will grow as we add props,
  > backgrounds, npcs, etc.
  > 
  > This also starts to write some basic test coverage for
  > vaniaRoomDefs/inputs and VaniaGeneration, which has been desperate for
  > it. The basic cases are not much, but should make it easier to reach for
  > when debugging/extending - e.g. supporting concave room shapes is a
  > headache, tests should make it much easier.

- ([`ad61db31`](https://github.com/russmatney/dino/commit/ad61db31)) test: basic vaniaRoomDef test and clean up

  > drops a bunch of unused roomDef fields, and starts toying with some room
  > shapes.

- ([`e8c57a11`](https://github.com/russmatney/dino/commit/e8c57a11)) fix: one-way-platforms a bit wider
- ([`3eabfaa6`](https://github.com/russmatney/dino/commit/3eabfaa6)) chore: pull label_to_entity into roomDef

  > Adds a few other entities, and starts to reorient the roomDef a bit.
  > 
  > Some misc other fixes and cleanup: restore the kingdom tile collisions,
  > fix the util.setup_popup_items call.

- ([`a1566ce6`](https://github.com/russmatney/dino/commit/a1566ce6)) refactor: util.setup_popup_items

  > This pattern looks familiar, doesn't it (it matches clawe's rofi impl).

- ([`60fe2109`](https://github.com/russmatney/dino/commit/60fe2109)) feat: adding/removing ents/tilesets + reload room in-place

  > Can now add and remove entities and change the current tileset via the
  > editor buttons. the room is regenerated in-place to immediately show the
  > effect.
  > 
  > Helpful for debugging! especially when some but not all of the tilesets
  > have their physics disabled :/

- ([`98919efe`](https://github.com/russmatney/dino/commit/98919efe)) fix: set tilemap names, undo zindex change
- ([`ed5d3971`](https://github.com/russmatney/dino/commit/ed5d3971)) chore: misc clean up

  > preventing tilemaps from being created at tool time

- ([`0fd203e0`](https://github.com/russmatney/dino/commit/0fd203e0)) fix: drop hard-coded rooms

  > fortunately it seems these are not necessary! so we can go from an empty
  > map :D

- ([`7a226021`](https://github.com/russmatney/dino/commit/7a226021)) fix: logs, faster regen
- ([`a9ebed8b`](https://github.com/russmatney/dino/commit/a9ebed8b)) refactor: build rooms in prep_scene instead of ready

  > Now the hiccup happens when adding/removing rooms in the editor, not
  > on-ready when moving between rooms. kind of interesting! and time to
  > move that work onto a thread, i think.

- ([`34710bab`](https://github.com/russmatney/dino/commit/34710bab)) refactor: remove room_instance usage from room generation
- ([`073abf0a`](https://github.com/russmatney/dino/commit/073abf0a)) refactor: calc room size without roomInstance

### 31 Mar 2024

- ([`7c69b35f`](https://github.com/russmatney/dino/commit/7c69b35f)) feat: show current tileset in editor
- ([`bfa3e71f`](https://github.com/russmatney/dino/commit/bfa3e71f)) feat: use tilemaps in the background

  > With a Regen Background button added to the editor!

- ([`f4626776`](https://github.com/russmatney/dino/commit/f4626776)) wip: supporting misc tile chunks as background
- ([`98f179c2`](https://github.com/russmatney/dino/commit/98f179c2)) fix: open all doors between neighbors

  > prevents some weird bugs where you get stuck in the wall when walking
  > into a room (b/c a door can get 'closed' right on top of you, especially
  > when falling 'too slow'). Could be solved by the better offset, but what
  > we really want is to not close a door that we've walked through

- ([`d799379f`](https://github.com/russmatney/dino/commit/d799379f)) feat: mix in a few tilesets

  > Now selecting a random tileset per room!

- ([`afd122f0`](https://github.com/russmatney/dino/commit/afd122f0)) wip: some camera toying
- ([`e79a17be`](https://github.com/russmatney/dino/commit/e79a17be)) fix: prefer to remove rooms based on re-cency

  > you can still 'orphan' rooms by moving away from the start, which lets
  > us play a 'try to get back to the start' minigame... kind of
  > interesting.

- ([`7b63c728`](https://github.com/russmatney/dino/commit/7b63c728)) feat: adding/remove rooms with one click

  > this is pretty cool! we're adding and removing rooms via the editor.
  > 
  > Introduces some bugs - it's possible to leave the player stranded b/c
  > the deleted rooms are random. Maybe need some logic to prevent
  > disconnecting rooms/prefer edges - ought to have some helpers with those
  > competencies anyway.

- ([`61480313`](https://github.com/russmatney/dino/commit/61480313)) fix: break the editor labels up a bit
- ([`ead2c6a2`](https://github.com/russmatney/dino/commit/ead2c6a2)) fix: generator use global room num

  > here we increment on the room number to ensure no accidental file name
  > collisions for the packed room scenes - a uuid/nanoid would work here
  > too - in the mean time, this works as long as the generator is 1:1 with
  > vania game.

- ([`56f6c414`](https://github.com/russmatney/dino/commit/56f6c414)) feat: regenerating rooms around the player

  > POC for 'on the fly' room regeneration - a rough version of swapping out
  > all the rooms except the player's current one - in theory we could have
  > have 'permanent' rooms and use generation to more closer to some target
  > cells on the map.

- ([`e19b2a1a`](https://github.com/russmatney/dino/commit/e19b2a1a)) wip: partial regeneration POC

  > Trying to regenerate all the 'other' (not active) rooms


### 29 Mar 2024

- ([`a9ce7e01`](https://github.com/russmatney/dino/commit/a9ce7e01)) misc: some ui and code clean up, some seeding attention
- ([`da2ff642`](https://github.com/russmatney/dino/commit/da2ff642)) feat: editor regenerating VaniaRooms on button press
- ([`422c30ef`](https://github.com/russmatney/dino/commit/422c30ef)) wip: initial vania editor - respawning player via button
- ([`7746c19d`](https://github.com/russmatney/dino/commit/7746c19d)) feat: ensure neighbors (and doors) when placing rooms
- ([`1fb614cb`](https://github.com/russmatney/dino/commit/1fb614cb)) wip: generator placing rooms randomly

  > This basically works! Tho the rooms don't always have a neighbor.


### 28 Mar 2024

- ([`1e901fed`](https://github.com/russmatney/dino/commit/1e901fed)) feat: add tile chunks from entities.txt

  > Should probably pull the chunks into their own text file

- ([`72812a7c`](https://github.com/russmatney/dino/commit/72812a7c)) wip: skip all but inner-most border when looking for fit
- ([`48a84e61`](https://github.com/russmatney/dino/commit/48a84e61)) wip: cut cell size in half, adjust maps

  > starts a rough VaniaRoomDef chainable constructure interface

- ([`d2db4079`](https://github.com/russmatney/dino/commit/d2db4079)) feat: entities adding themselves to rooms, as long as they 'fit'

  > impls a rough add-entities-to-rooms algorithms. This walks the tilemap's
  > coords looking for a match on 'empty' and floor tiles.
  > 
  > It's kind of working!

- ([`22a876ab`](https://github.com/russmatney/dino/commit/22a876ab)) wip: misc helpers and data wiring

  > Next up: finding possible entity positions!

- ([`7805cdba`](https://github.com/russmatney/dino/commit/7805cdba)) feat: attaching parsed entityDefs to vaniaRoomDefs
- ([`858782c8`](https://github.com/russmatney/dino/commit/858782c8)) refactor: more room -> grid renaming cleanup
- ([`ec17e898`](https://github.com/russmatney/dino/commit/ec17e898)) refactor: rename RoomDef(s) -> GridDef(s)

  > Lots of misc keys still use room_def_ as a prefix and rooms in general...

- ([`99bfada1`](https://github.com/russmatney/dino/commit/99bfada1)) refactor: rename RoomParser -> GridParser
- ([`0d503e47`](https://github.com/russmatney/dino/commit/0d503e47)) feat: parsing entities via RoomParser in VaniaGen

  > Brick RoomDefs/RoomParser starting to need a rename - probably GridDefs
  > and GridParser to start.

- ([`2aecf0a7`](https://github.com/russmatney/dino/commit/2aecf0a7)) refactor: pull room_defs from dicts into VaniaRoomDef class
- ([`ffe11f10`](https://github.com/russmatney/dino/commit/ffe11f10)) fix: make sure main_panel_instance exists

  > This doesn't happen every time, but when it does, it prints like 500 logs.

- ([`d35ac9f1`](https://github.com/russmatney/dino/commit/d35ac9f1)) deps: add gd_explorer

  > Much thanks to @SirLich !

- ([`bdbf0817`](https://github.com/russmatney/dino/commit/bdbf0817)) chore: update dialogue manager

### 27 Mar 2024

- ([`7866c856`](https://github.com/russmatney/dino/commit/7866c856)) fix: be sure to clear all of 'bottom' door tiles
- ([`b06ab6d5`](https://github.com/russmatney/dino/commit/b06ab6d5)) feat: clearing doors/paths between neighboring rooms

  > Pretty rough, but more or less working. The doors don't persist at all -
  > we probably want to store them somewhere and reselect the same ones next
  > time we're in the room.

- ([`bd8c9264`](https://github.com/russmatney/dino/commit/bd8c9264)) feat: set metsys room size, automate room wall generation

  > next is.... doors!

- ([`6ae55b77`](https://github.com/russmatney/dino/commit/6ae55b77)) fix: only adjust offset in one direction

  > Also drops a bunch of logs and goes for the prettier log colors

- ([`e566b4a6`](https://github.com/russmatney/dino/commit/e566b4a6)) feat: swapping player (ss/td) across room transitions

  > Kind of crazy, but it's working! We're completely recreating a different
  > player on room transitions, according to the room-data for the new room.

- ([`64506a5b`](https://github.com/russmatney/dino/commit/64506a5b)) refactor: create VaniaRoomTransition, rename GameType -> RoomType

  > Going into this genre-hopper exploration!

- ([`6b700a75`](https://github.com/russmatney/dino/commit/6b700a75)) chore: update log.gd (now handling PackedScenes)
- ([`8ec933cb`](https://github.com/russmatney/dino/commit/8ec933cb)) refactor: room_opts own cell bg/border color, reduce log noise

### 26 Mar 2024

- ([`0ac2d8eb`](https://github.com/russmatney/dino/commit/0ac2d8eb)) feat: poc generating multi-cell metsys rooms

  > Still pretty hard-coded, but we're arriving at something workable!

- ([`09650c96`](https://github.com/russmatney/dino/commit/09650c96)) wip: creating a few more base rooms

  > trying to get multi-cell rooms going

- ([`76e05058`](https://github.com/russmatney/dino/commit/76e05058)) wip: pull generator out of vania game script
- ([`793987c8`](https://github.com/russmatney/dino/commit/793987c8)) wip: ugly, but finally generating rooms in metsys
- ([`df36a458`](https://github.com/russmatney/dino/commit/df36a458)) refactor: remove deferreds from BrickLevelGen

  > I don't want to wait for a tick or 'ready' or whatever nonsense for a
  > level to be generated unless it's truly necessary - this refactors such
  > that DinoLevel.create_new_level() returns a completely generated
  > level_node, and a player can be spawned on it by passing the node to
  > Dino.spawn_player(level_node).
  > 
  > This is setting up a showdown between the generated rooms and the metSys
  > opinion... not sure what will survive.

- ([`ce8556bc`](https://github.com/russmatney/dino/commit/ce8556bc)) wip: weird hacking, adding metsysGame and dinoLevel to vania node
- ([`5bb3befc`](https://github.com/russmatney/dino/commit/5bb3befc)) fix: update type -> game_type in create_new_player calls
- ([`3f5a67b3`](https://github.com/russmatney/dino/commit/3f5a67b3)) deps: update log.gd (colors)
- ([`99aed098`](https://github.com/russmatney/dino/commit/99aed098)) deps: update asepriteWizard, dialogueManager, log.gd

### 25 Mar 2024

- ([`f59c318d`](https://github.com/russmatney/dino/commit/f59c318d)) wip: VaniaGame as a MetSysGame

  > The MetSys integration begins!

- ([`35b99cae`](https://github.com/russmatney/dino/commit/35b99cae)) wip: new game mode 'Vania', improved printables

  > Adds to_printable to a handful of types, and moves several prints to
  > passing objects in directly rather than labels.
  > 
  > Adds a new game mode! Vania - i hope to use this to integrate with
  > MetSys.

- ([`449a95de`](https://github.com/russmatney/dino/commit/449a95de)) docs: readme link to new docs site
- ([`098abce1`](https://github.com/russmatney/dino/commit/098abce1)) docs: init docsify site
- ([`2b1b8df1`](https://github.com/russmatney/dino/commit/2b1b8df1)) fix: set GODOT_BIN if not set

### 24 Mar 2024

- ([`fc073f9e`](https://github.com/russmatney/dino/commit/fc073f9e)) deps: add custom runner
- ([`ce5dc4aa`](https://github.com/russmatney/dino/commit/ce5dc4aa)) deps: add MetSys!
- ([`1566cd88`](https://github.com/russmatney/dino/commit/1566cd88)) deps: dialogue_manager and gd-plug-ui updates

### 22 Mar 2024

- ([`9ef76582`](https://github.com/russmatney/dino/commit/9ef76582)) docs: more readme clarity

### 21 Mar 2024

- ([`1d7b4290`](https://github.com/russmatney/dino/commit/1d7b4290)) chore: update old Log.to_pretty usage
- ([`6cfe7d76`](https://github.com/russmatney/dino/commit/6cfe7d76)) chore: drop old Log.gd impl
- ([`a5a62b62`](https://github.com/russmatney/dino/commit/a5a62b62)) chore: update plugins, add log.gd
- ([`8f6fa9cd`](https://github.com/russmatney/dino/commit/8f6fa9cd)) feat: install gd-plug

### 18 Jan 2024

- ([`6c08fc4a`](https://github.com/russmatney/dino/commit/6c08fc4a)) docs: readme split into games/addons/credits/bb_godot

  > More focused and hopefully approachable now, plus a once-over of all the
  > content.

- ([`b58edb53`](https://github.com/russmatney/dino/commit/b58edb53)) docs: youtube badge and inline vid

### 14 Jan 2024

- ([`7e7b72e3`](https://github.com/russmatney/dino/commit/7e7b72e3)) feat: quick 'boss battle' level def

  > Adds support for 'Boss', 'Monstroar', and 'Beefstronaut', then re-orgs
  > the current classic-mode setup to include a boss battle.
  > 
  > Not too bad! A few bugs around, but nothing we can't work with.

- ([`9af564fe`](https://github.com/russmatney/dino/commit/9af564fe)) chore: drop dothop completely

  > This has been completely ported to github.com/russmatney/dothop
  > 
  > Only bit of note is that we've started a new pattern in
  > ~assets/art/fall/*.aseprite~ - maybe this makes sense? I spent a bunch
  > of time moving art from here and into individual game dirs, now they're
  > headed back to assets...

- ([`cacb59b7`](https://github.com/russmatney/dino/commit/cacb59b7)) chore: add source-available copyright notice

### 11 Jan 2024

- ([`04f2d1f5`](https://github.com/russmatney/dino/commit/04f2d1f5)) fix: misc tweaks and fixes

  > Handling a bad load in Navi, fixing a level def tile size, reordering
  > default weapons.


### 8 Jan 2024

- ([`24e05a1f`](https://github.com/russmatney/dino/commit/24e05a1f)) docs: brief readme update

### 17 Dec 2023

- ([`1c645c55`](https://github.com/russmatney/dino/commit/1c645c55)) feat: very rough but working classic mode

  > Implements a classic mode based roughly on Roulette mode, but generating
  > levels via LevelDefs and DinoLevel's create_level instead of
  > DinoGameEntities. We'll need to expand the 'stages' from simple
  > level_defs to level_defs + opts to mix in (varing tilesets and level
  > layouts). Tho really i expect classic to be ~10 unique levelDefs, so
  > maybe that won't be necessary.
  > 
  > I'm pretty happy with this - we'll be able to dry up all the game
  > components and recreate the 'games' as lower-key levelDefs, which is
  > roughly a levelscript set of rooms + legend paired with a
  > gen_room_opts() function.

- ([`062b6113`](https://github.com/russmatney/dino/commit/062b6113)) feat: dino_level generating levels based on LevelDefs

  > Things are starting to work!

- ([`bcea8131`](https://github.com/russmatney/dino/commit/bcea8131)) wip,misc: introduce levelDefs for housing dino level definitions

  > LevelDefs are pandora entities wrapping a levelscript (plaintext
  > room/chunk defs plus some input options, like a tileset, a generation
  > script, etc).
  > 
  > These will likely grow more feature-ful, and maybe the theming (tiles,
  > etc) will one day break out of here.
  > 
  > This also rearranges some of the src/dino/* code, like moving DinoLevel
  > into src/dino/levels, and weapons-related code into src/dino/weapons

- ([`efda2c53`](https://github.com/russmatney/dino/commit/efda2c53)) feat: add leaves to the wildcard level

  > Forgot to add the leaf to the legend here, but things are pretty much
  > working for mixing sidescroller levels.

- ([`acb6ef29`](https://github.com/russmatney/dino/commit/acb6ef29)) feat: dynamically add relevant quests to dino level

  > Adds a has_required_entities -> bool func to the quest class and
  > implements it for a handful of quests. This lets us dynamically add
  > quests to levels based on included entities.

- ([`80371e92`](https://github.com/russmatney/dino/commit/80371e92)) fix: couple orb weapon bugs
- ([`ef30ed4b`](https://github.com/russmatney/dino/commit/ef30ed4b)) feat: drop Player (P) autoload, use Dino + PlayerSet

  > Relying on Navi in the PlayerSet for a node with access to the tree, so
  > we can find the spawn_point when spawning.
  > 
  > I abandoned some extra logic and 'spawning' flags that were in place to
  > prevent extra players from being spawned - i don't think we need them,
  > and they should really be more of a smell than anything.

- ([`e892f459`](https://github.com/russmatney/dino/commit/e892f459)) wip: more Dino and Player refactors

  > Moving logic from a single player on the P autoload to a PlayerSet
  > structure attached to Dino and going through Dino for state changes.

- ([`1fa282aa`](https://github.com/russmatney/dino/commit/1fa282aa)) wip: imagining a PlayerSet, cleaning up player/game type
- ([`1e44d728`](https://github.com/russmatney/dino/commit/1e44d728)) feat: Dino.is_debug_mode(), fallback sidescroller player
- ([`c952fda6`](https://github.com/russmatney/dino/commit/c952fda6)) refactor: moving Player.all_entities to DinoPlayerEntity static func
- ([`4b2cc9db`](https://github.com/russmatney/dino/commit/4b2cc9db)) refactor: drop Game.gd, move to Dino.gd

  > Dino and DinoData are stateful and static helpers for dino going
  > forward. Next it'll probably eat back some Player autoload logic.

- ([`d2a833b7`](https://github.com/russmatney/dino/commit/d2a833b7)) refactor: more Game.gd diaspora

  > Moving some helpers to static funcs on entities, others are simplified
  > using entity instance helpers (like mode.launch, mode.nav_to_menu).

- ([`099badb5`](https://github.com/russmatney/dino/commit/099badb5)) wip: fleshing out new DinoMode setup

  > Moving away from DinoGameEntity and the current Game.gd model.
  > 
  > Hoping a 'Debug' game mode supports all the testing/dino-gym concerns.

- ([`4fa659bf`](https://github.com/russmatney/dino/commit/4fa659bf)) misc: set dinoPauseMenu as default menu

  > Also rearranges navi somewhat - vars and readys on top.

- ([`c1d4be8e`](https://github.com/russmatney/dino/commit/c1d4be8e)) feat: pull label_to_entity into DinoLevelGenData helper

  > A static class where we'll start to accumulate all the entities.

- ([`bbd044cf`](https://github.com/russmatney/dino/commit/bbd044cf)) wip: first pass at a spike + target level

  > Doesn't run yet because it doesn't know what kind of player to spawn -
  > need to refactor away from depending on dino-game for player type.
  > Perhaps we can move to letting dino level handle it.
  > 
  > DinoGame as a requirement is a bit overloaded - we'll want to gather
  > whatever those deps are on the fly, and eventually we'll want to change
  > player type on a per-room basis, not per level.


### 16 Dec 2023

- ([`6c2caad2`](https://github.com/russmatney/dino/commit/6c2caad2)) feat: weapon logic DRY up first pass

  > Creates a WeaponSet object to maintain a list of weapons on each beehive
  > body class. The body classes pass a handful of functions through.
  > 
  > Possibly some of these funcs could be invoked directly on the
  > weapon_set to cut down on some surface area.


### 14 Dec 2023

- ([`e05f7037`](https://github.com/russmatney/dino/commit/e05f7037)) fix: prevent BEU crashes for exposed weapon funcs
- ([`be3a4b38`](https://github.com/russmatney/dino/commit/be3a4b38)) wip: rough initial progress tab on pause

  > Progress tab showing a list of game records and some data from each one.
  > 
  > Pretty messy, but the beginning of a structure. Probably better to
  > create and update game records from dino-level (rather than whatever
  > game mode).
  > 
  > This also starts towards some reading/writing of game records, which
  > should be useful for handling 'progression' or 'unlock-the-things'
  > features.

- ([`33fe33ca`](https://github.com/russmatney/dino/commit/33fe33ca)) chore: add trolley/dj debug views to pause debug tab

  > These are still pretty rough, but it's something.

- ([`29d5f52d`](https://github.com/russmatney/dino/commit/29d5f52d)) wip: potential direction for some weapons helpers

  > But it feels like we should bury the weapons state in a node or
  > object... it'd cut down on the exposed api (no need to pass the
  > 'weapons' state around...), but it's quite anti-functional.
  > 
  > A different direction might be passing the player into a
  > weapons system call instead of asking the player for weapons data.

- ([`be8fb4ed`](https://github.com/russmatney/dino/commit/be8fb4ed)) feat: test change and cycle weapon logic
- ([`99f2c170`](https://github.com/russmatney/dino/commit/99f2c170)) feat: add topdown weapon coverage, extends dinoweaponsdata

  > nice to get some tests down, you know?

- ([`93b69f51`](https://github.com/russmatney/dino/commit/93b69f51)) feat: initial test coverage for ssplayer add_weapon(ent_id)

  > Getting some coverage in place over DinoPlayer weapon crud before drying
  > it up. Right now there's duplicate logic in SSBody and TDBody, but the
  > code is (nearly) the same.
  > 
  > Only tweak here was a null-check in a weapon's activate(), which crashes
  > in the test because the actor is set at 'ready()' time. Maybe it
  > should/could be set before then? enter_tree()? maybe that makes sense?


### 13 Dec 2023

- ([`b593a104`](https://github.com/russmatney/dino/commit/b593a104)) feat: change character and weapon on pause menu
- ([`1c74e097`](https://github.com/russmatney/dino/commit/1c74e097)) feat: pause menu showing current weapon + player

  > DRYs up the gameButton and playerButton into an EntityButton that
  > supports game, player, and weapon.

- ([`bb469260`](https://github.com/russmatney/dino/commit/bb469260)) fix: adjust all/basic/mode dino_game lists

  > Allows the expected menus to be registered when running the roulette
  > main menu directly.

- ([`d6663d72`](https://github.com/russmatney/dino/commit/d6663d72)) wip: player + weapon pause tab initial layout + wiring
- ([`bdb10ff3`](https://github.com/russmatney/dino/commit/bdb10ff3)) feat: hud showing active vs inactive weapons

  > Implements an icon-based weapon stack in the HUD. Next up: button hints
  > for how to use things!


### 12 Dec 2023

- ([`c32de6e9`](https://github.com/russmatney/dino/commit/c32de6e9)) feat: td weapons (boomerang) using pandora entities

  > Found a weird bug where loading shirt hits the player once.... pretty annoying.

- ([`9292b242`](https://github.com/russmatney/dino/commit/9292b242)) feat: icons for all ss weapons, showing current weapon in HUD
- ([`62346243`](https://github.com/russmatney/dino/commit/62346243)) feat: sidescroller weapons refactored into weapon entities

  > topdown/beatemup are probably quite broken right now.

- ([`fed2a2de`](https://github.com/russmatney/dino/commit/fed2a2de)) feat: add weapon pandora entities
- ([`8847346b`](https://github.com/russmatney/dino/commit/8847346b)) wip: basic weapon entity setup
- ([`4feb0a88`](https://github.com/russmatney/dino/commit/4feb0a88)) refactor: pull game entity, game/player autoloads from addons/core into src/dino

  > These (and likely other things) really belong in src/dino.

- ([`e8ab2a7c`](https://github.com/russmatney/dino/commit/e8ab2a7c)) chore: drop more noisey logs
- ([`5d64ea6c`](https://github.com/russmatney/dino/commit/5d64ea6c)) feat: dino pause menu tabs with some focus handling

  > Dino pause menu now features 3 tabs, for quest status, level regen, and
  > basic options. There's a focus bug after toggling mute/unmute - the
  > focus gets lost. I'm not sure the best way to handle focus yet, so far
  > it's been adhoc... maybe that's just menu-hacking life.

- ([`367c0bb0`](https://github.com/russmatney/dino/commit/367c0bb0)) refactor: drop ensure_ready, wip tabbed pause menu
- ([`1f2d18c2`](https://github.com/russmatney/dino/commit/1f2d18c2)) refactor: DRY up Roulette Pause Menu into DinoPauseMenu

  > Also extends DinoLevel and Game to support setting menus and a fallback
  > player when running in isolation via the BrickRegenMenu options.

- ([`b465e599`](https://github.com/russmatney/dino/commit/b465e599)) feat: add dino hud timer, with time tracked by dino level

  > DinoLevel owns this timer so that we're not using the HUD to source
  > performance stats/details.

- ([`a7161df5`](https://github.com/russmatney/dino/commit/a7161df5)) chore: drop mute warning logs, misc notif cleanup/bug fixes
- ([`d4dec7af`](https://github.com/russmatney/dino/commit/d4dec7af)) feat: small tween when a notif is updated (vs created)
- ([`e5be99a2`](https://github.com/russmatney/dino/commit/e5be99a2)) feat: notifications use text as fallback for id

  > Now same-notifs just update the in-place notification. Could use an
  > effect to make it more clear! Maybe a little grow-shrink tween?

- ([`cef85cb6`](https://github.com/russmatney/dino/commit/cef85cb6)) feat: display current weapon in HUD

  > Just text for now, icons are coming along with a pandora weapons
  > refactor.

- ([`81a8047b`](https://github.com/russmatney/dino/commit/81a8047b)) woo!: add ellie as new patreon to readme and credits

### 11 Dec 2023

- ([`9146fbe7`](https://github.com/russmatney/dino/commit/9146fbe7)) fix: handle null level_opts in dino HUD
- ([`a27f0edb`](https://github.com/russmatney/dino/commit/a27f0edb)) chore: drop logs, references to Hood.hud

  > Probably going to drop Hood.ensure_hud next, and then we'll be almost
  > rid of the Hood autoload - it's main value is the Hood.notification
  > signal, which could probably live on DinoLevel anyway.

- ([`c1042f91`](https://github.com/russmatney/dino/commit/c1042f91)) feat: notifs support id to update in-place

  > Adds notifications to the DinoHUD, and extends the notifs to update
  > in-place if the passed notification matches a previous notif's id.
  > 
  > Extends Quest to support an `on_quest_update` func, which
  > BreakTheTargets implements to send the notification.

- ([`97669063`](https://github.com/russmatney/dino/commit/97669063)) feat: basic level-opts component shows seed and room count
- ([`39ee9db9`](https://github.com/russmatney/dino/commit/39ee9db9)) wip: basic DinoHUD showing player status

  > A base for the HUD that updates whenever the player is spawned, pulling
  > the icon_texture from the player's pandora entity.
  > 
  > Does not yet react to player health changes, etc.

- ([`316e6a09`](https://github.com/russmatney/dino/commit/316e6a09)) feat: add mute music/sound buttons to main/pause menus
- ([`1ff7faf1`](https://github.com/russmatney/dino/commit/1ff7faf1)) chore: disable pluggs for now

  > Honing in on a dino launch means cutting scope. we'll be back for pluggs
  > sometime!

- ([`ef0484e8`](https://github.com/russmatney/dino/commit/ef0484e8)) docs: shrink asset warning somewhat

  > No need for this to be the main message in the readme.


### 30 Nov 2023

- ([`7ba75c1e`](https://github.com/russmatney/dino/commit/7ba75c1e)) misc: some clean up, drop gunner test for now

  > For some reason Input.get_vector() isn't recognizing that move_right is
  > pressed in this test, so the aim_vector never gets set and the weapon
  > never hits the target :/
  > 
  > Disabling assertion for now.

- ([`1409546f`](https://github.com/russmatney/dino/commit/1409546f)) fix: SpikeData running at editor time

  > Supports BlobPickup running in the editor


### 29 Nov 2023

- ([`fed4fbf1`](https://github.com/russmatney/dino/commit/fed4fbf1)) chore: drop some dead player dirs

  > The games are shrinking nicely.

- ([`321a6e03`](https://github.com/russmatney/dino/commit/321a6e03)) fix: only need 1 gray orb to create a pink one

  > There's a disappearing orb problem that makes spike unwinnable right now
  > - for now, only need 1 (instead of 3) to create pink ones, which fixes
  > playthroughs.

- ([`2bb98598`](https://github.com/russmatney/dino/commit/2bb98598)) fix: ensure fences/low-walls, spikes on player collision masks
- ([`bccb5eab`](https://github.com/russmatney/dino/commit/bccb5eab)) fix: ensure td player has boomerang
- ([`d476eed0`](https://github.com/russmatney/dino/commit/d476eed0)) fix: boomerangs hit targets and gunner-enemies now
- ([`541b131f`](https://github.com/russmatney/dino/commit/541b131f)) feat: connect players, level to died() signals
- ([`3c237789`](https://github.com/russmatney/dino/commit/3c237789)) feat: ensure 'weapons' group on weapons, targets break when weapons enter

  > should support boomerangs, swords, etc.

- ([`3424100d`](https://github.com/russmatney/dino/commit/3424100d)) feat: prefer DinoGameEntity player_scene if one is set

  > Not quite sure the right thing to express here. 'player_type' isn't
  > really the right name, it's more of a game/level detail than a player
  > one.

- ([`e14ee7f4`](https://github.com/russmatney/dino/commit/e14ee7f4)) fix: don't free the last scene until opts.setup(new_scene) is called

  > It'd be great to write a test for this, wouldn't it.


### 28 Nov 2023

- ([`5d46faf4`](https://github.com/russmatney/dino/commit/5d46faf4)) fix: ensure double jump on dino ss player
- ([`addae954`](https://github.com/russmatney/dino/commit/addae954)) feat: ss/td/beu for hairo/hatbot/hoodie/romeo

  > Adds player scenes for each type to each hero.
  > 
  > Quick copy-pasta job that also sets basic art animations, tho most of
  > these are just a single-frame idle animation for now.

- ([`caa5fcb6`](https://github.com/russmatney/dino/commit/caa5fcb6)) feat: aseprite script for adding missing tags

  > Also colorizes the tags with a quick color wheel, which helps see
  > through a mess of them. It's the little things!

- ([`c25574cf`](https://github.com/russmatney/dino/commit/c25574cf)) pixels: icons/portraits for hairo, hatbot, hoodie, and romeo

  > Now working in PlayerButtons, soon to support the unified HUD.

- ([`6620195e`](https://github.com/russmatney/dino/commit/6620195e)) feat: choose-your-character in roulette mode
- ([`da9e9b80`](https://github.com/russmatney/dino/commit/da9e9b80)) chore: more moved file updates

  > Apparently these scenes get 'updated' in the engine's memory but not
  > written to disk without a manual save. tho maybe running the game would
  > trigger a save as well?

- ([`9213acaf`](https://github.com/russmatney/dino/commit/9213acaf)) wip/refactor: create dino/modes, move menus to dino/menus

  > Begins to introduce PlayerButton.

- ([`b2bd747e`](https://github.com/russmatney/dino/commit/b2bd747e)) feat: playing as playerEntity in roulette games

  > Also configs collision layers/masks in td/ss/beu player ready funcs.

- ([`0b16417c`](https://github.com/russmatney/dino/commit/0b16417c)) feat: player autoload supporting set_player_entity()

  > Not called anywhere yet, but should work?

- ([`0a64220c`](https://github.com/russmatney/dino/commit/0a64220c)) wip/feat: DinoPlayerEntity and src/dino/players

  > Pulls players from several games into new scenes in
  > src/dino/players/{hario,hatbot,hoodie,romeo} - these all use shared
  > scripts that inherit from topdown/beatemup/sidescroller beehive players.
  > 
  > Creates a new pandora entity called DinoPlayerEntity, in support of a
  > coming choose-your-character screen, which will select a player used
  > across dino levels.


### 22 Nov 2023

- ([`a4fa2b08`](https://github.com/russmatney/dino/commit/a4fa2b08)) chore: set movie_writer file, bump godot verison
- ([`f09236b6`](https://github.com/russmatney/dino/commit/f09236b6)) test: basic gunner level complete working

  > An integration test that generates a single gunner room and target, and
  > ensures level_complete is emitted when the target is hit.


### 21 Nov 2023

- ([`63fbb834`](https://github.com/russmatney/dino/commit/63fbb834)) wip: not-yet-working gunner level-complete test

  > Attempts an integration test that expects the gunner level to be
  > complete, including a basic rooms overwrite and simulated player inputs.
  > 
  > Possibly breaks other things b/c dino level has been modified in a few
  > ways (eg creating the player before the jumbotron)

- ([`f94e92f0`](https://github.com/russmatney/dino/commit/f94e92f0)) fix: pass opts through Game.launch/restart to Navi.nav_to
- ([`e813e4bc`](https://github.com/russmatney/dino/commit/e813e4bc)) fix: filter out 1-3 tabs from room parser chunks

  > Should really do something more resilient here, like a whitespace regex.
  > Curse my own laziness!

- ([`f8fbf96c`](https://github.com/russmatney/dino/commit/f8fbf96c)) chore: drop dinoGameEntity singleton property

### 15 Nov 2023

- ([`3712da07`](https://github.com/russmatney/dino/commit/3712da07)) fix: update to deploy debug build

  > The release build is ham-strung by pandora release exports not including
  > any data - still need to fix that. Deploying debug builds works for now
  > b/c the issue is related to reading a compressed data file (which is
  > never created).

- ([`3444cca4`](https://github.com/russmatney/dino/commit/3444cca4)) feat: game icon update!
- ([`89bc78f8`](https://github.com/russmatney/dino/commit/89bc78f8)) wip: drop/fix some global QuestManager usage

  > Towards dropping the QuestManager autoload, but punting for now.

- ([`9fde1be1`](https://github.com/russmatney/dino/commit/9fde1be1)) feat: basic SuperElevatorLevel DinoGame impl

  > Does not add a Quest setup to SEL, only refactors enough to use
  > DinoLevel's interstitials and level_complete signal. Can now play
  > through roulette with all the (enabled) games!

- ([`38c0ea89`](https://github.com/russmatney/dino/commit/38c0ea89)) wip: disable dothop

  > Slightly heart-breaking, but dothop is not going to work with
  > arcade/roulette yet - will restore it or rip it into a different game at
  > some point.

- ([`2a7a85eb`](https://github.com/russmatney/dino/commit/2a7a85eb)) feat: herd as DinoLevel, cleaner FetchSheepQuest impl

  > Some other fixes/details here: split out a Util.find_level_root() for
  > searching for quest nodes, and updating arcade to toss and recreate the
  > level_node rather than just regenerate it. This is cleaner and helps
  > keep things encapsulated in their branch of the scene_tree.

- ([`3ad35bb6`](https://github.com/russmatney/dino/commit/3ad35bb6)) feat: harveyLevel extending DinoLevel, using quests

  > Now ready to be used in roulette and arcade!


### 14 Nov 2023

- ([`171c4abd`](https://github.com/russmatney/dino/commit/171c4abd)) feat: Quest impl DRY up

  > Moves repeated logic from several recent Quest impls into the Quest base
  > class. We'll see if we need to deviate from this at all...

- ([`c2193469`](https://github.com/russmatney/dino/commit/c2193469)) fix: better Quest naming

  > ActiveQuest -> QuestData
  > Quest -> QuestManager
  > QuestNode -> Quest
  > 
  > Towards dropping the quest autoload in favor of a QuestManager static
  > class that provides a node to a level via QuestManager.setup_quests()

- ([`6ccfa04f`](https://github.com/russmatney/dino/commit/6ccfa04f)) fix: use player as leaf node for adding cord

  > If the tossedPlug hasn't been added to the tree yet, this crashes.

- ([`013bb39b`](https://github.com/russmatney/dino/commit/013bb39b)) feat: deselect all button on roulette menu
- ([`bc97a687`](https://github.com/russmatney/dino/commit/bc97a687)) fix: Game.get_player -> P.get_player

  > Plus removes the @tool from the DinoGym, where it's quite unnecessary.

- ([`11352f47`](https://github.com/russmatney/dino/commit/11352f47)) fix: add children to level, not current_scene

  > Impls a util for walking parents until one impls add_child_to_level.
  > After much rumination about call-down/signal-up, this is where i
  > landed.... calling-up with duck typing. I don't want to force any
  > would-be parent node to connect up signals across arbitrary children,
  > or require any node that wants to add_child to be part of some
  > child-adders group.... this feels fine for now, and gets away without
  > tracking the current-level, which is nice if we ever want to run
  > more than one level at a time.

- ([`75d83f99`](https://github.com/russmatney/dino/commit/75d83f99)) refactor: move container nodes from Node2D to just Node
- ([`aa9f932d`](https://github.com/russmatney/dino/commit/aa9f932d)) misc: game/navi cleanup
- ([`346aa90b`](https://github.com/russmatney/dino/commit/346aa90b)) fix: set spawn_coords when spawning_player
- ([`f982a34a`](https://github.com/russmatney/dino/commit/f982a34a)) fix: overwrite roulette current_game when launching

  > Otherwise the 'debug' set game ent will be launched first.

- ([`6bb0ef66`](https://github.com/russmatney/dino/commit/6bb0ef66)) wip: minimizing Game.gd, break out player bits into Player.gd

  > Trying to see if the Game autoload can be dropped - feeling like
  > is_managed could maybe go away, and not sure if there's a better way to
  > handle player_scene crashing for simple Player.respawn_player() calls...


### 13 Nov 2023

- ([`061de3e1`](https://github.com/russmatney/dino/commit/061de3e1)) feat: spike as DinoLevel

  > Can now play spike in Arcade and Roulette mode.
  > 
  > Pulls an isolated Quest out of Spike's DeliveryZone, adds it to
  > SpikeZone _ready() and SpikeLevel _init() (which is now a DinoLevel)

- ([`4dbc616a`](https://github.com/russmatney/dino/commit/4dbc616a)) refactor: drop DinoGame class, rewrite away from game.current_game

  > Refactors Game.gd to impl most of the DinoGame functions.
  > 
  > Drops the current_game var, opting to instead determine the current_game
  > whenever needed. this was mostly just supporting figuring out the
  > player_scene, which now has a caching mechanism instead.

- ([`1de14945`](https://github.com/russmatney/dino/commit/1de14945)) fix: restore playable dothop game

  > Now without a game_singleton!

- ([`c16a95a7`](https://github.com/russmatney/dino/commit/c16a95a7)) fix: free jumbotron after it is closed

  > I wonder how this hasn't been causing some other problems.

- ([`7858b7ee`](https://github.com/russmatney/dino/commit/7858b7ee)) refactor: dropping more game singletons: hatbot, mountain, demoland, ghosts, dothop

  > Also some work toward fixing some dothop bugs.

- ([`80cffc97`](https://github.com/russmatney/dino/commit/80cffc97)) chore: drop ghost camera, remove unused util fn

  > godot 4 introduced `reparent`, so we don't need this helper anymore.

- ([`8981d815`](https://github.com/russmatney/dino/commit/8981d815)) feat: game button fade to half when not selected

  > It'd be cool to animate/stop-animating, and move to gray scale when not
  > selected. Quick and working for now, like everything else.

- ([`c7c3a821`](https://github.com/russmatney/dino/commit/c7c3a821)) feat: arcade, roulette menus support selecting games

  > Refactors the arcade and roulette menus to display games as buttons,
  > allowing the player to select a game to take to the arcade, and toggle
  > games on/off for roulette. Needs some ui work, which is coming next.

- ([`63459ca3`](https://github.com/russmatney/dino/commit/63459ca3)) feat: Navi passing opts along with nav_to, hiding menus via groups

  > Much simpler to use groups than to register and track all the menus individually!

- ([`c6e33ccb`](https://github.com/russmatney/dino/commit/c6e33ccb)) refactor: move dino menus to dino/menus, wip game-mode button
- ([`1f97a777`](https://github.com/russmatney/dino/commit/1f97a777)) chore: add dialogue_, sound_manager, input_helper

  > Going to intergrate these helpers by nathanhoad.

- ([`f6ee24dd`](https://github.com/russmatney/dino/commit/f6ee24dd)) chore: update aseprite wizard
- ([`6defdfa6`](https://github.com/russmatney/dino/commit/6defdfa6)) chore: update pandora
- ([`bae1aea8`](https://github.com/russmatney/dino/commit/bae1aea8)) chore: bump to 4.2.beta6, fix new lsp warnings

### 11 Nov 2023

- ([`c56bc6f6`](https://github.com/russmatney/dino/commit/c56bc6f6)) feat: pluggs dinolevel setup
- ([`11a71ad5`](https://github.com/russmatney/dino/commit/11a71ad5)) misc: tweak some woods levels
- ([`e7620bce`](https://github.com/russmatney/dino/commit/e7620bce)) feat: refactor woods into a Quest-based Dino level
- ([`d7aacd08`](https://github.com/russmatney/dino/commit/d7aacd08)) feat: pin current scene by clicking 'pin' twice

  > Extending to a next/prev with the scene nav history wouldn't be too big
  > a leap here.

- ([`0a57ae6c`](https://github.com/russmatney/dino/commit/0a57ae6c)) refactor: drop SS autoload in favor of SSData static class
- ([`81269a2a`](https://github.com/russmatney/dino/commit/81269a2a)) refactor: move puzz from autoload to static class
- ([`d85b8c1e`](https://github.com/russmatney/dino/commit/d85b8c1e)) refactor: drop snake game
- ([`4e617ce1`](https://github.com/russmatney/dino/commit/4e617ce1)) refactor: drop runner, move assets to woods
- ([`8cab5fff`](https://github.com/russmatney/dino/commit/8cab5fff)) refactor: delete DungeonCrawler

  > Moves the assets into Shirt, and one basic coin implementation that
  > apparently HatBot uses.

- ([`4d5386e3`](https://github.com/russmatney/dino/commit/4d5386e3)) chore: drop Respawner concept and autoload
- ([`d898d6f2`](https://github.com/russmatney/dino/commit/d898d6f2)) chore: drop unused Clawe.gd
- ([`67354b3e`](https://github.com/russmatney/dino/commit/67354b3e)) fix: restore proper pretty printing

  > Really ought to have unit tests on this, especially now that it's solidifying.

- ([`cf59c8b1`](https://github.com/russmatney/dino/commit/cf59c8b1)) refactor: Util -> U static funcs, drop util autoload

  > Also fixes the Log impl to reference it's own static funcs.

- ([`fb059c79`](https://github.com/russmatney/dino/commit/fb059c79)) refactor: move Debug pretty-printer to static Log class

  > static funcs are much nicer than state- and load-order dependent autoloads.
  > 
  > Plus Log is a much better name for this.


### 10 Nov 2023

- ([`3221029e`](https://github.com/russmatney/dino/commit/3221029e)) fix: don't await a jumbotron in tree_exiting

  > Finally can play through rounds of roulette without crashes! Woo!

- ([`aa5aa785`](https://github.com/russmatney/dino/commit/aa5aa785)) refactor: fix breakTheTargets, nearly working roulette rounds
- ([`8b233c13`](https://github.com/russmatney/dino/commit/8b233c13)) fix: drop DRYed up XLevel scripts, reseed after round complete

  > Still marking gunner complete immediately on the second round,
  > i think b/c the tower targets are being captured and exiting immediately
  > by gunner's target test.

- ([`43997394`](https://github.com/russmatney/dino/commit/43997394)) refactor: jumbo_notif via Jumbotron static

  > Pulls jumbotron out of Quest autoload, removes state.
  > 
  > The big shift is the return signal - we make sure to wait until the
  > previous jumbotron has exited (not just kicking off an async fade out
  > process).


### 9 Nov 2023

- ([`67e97bff`](https://github.com/russmatney/dino/commit/67e97bff)) feat: more jumbotrons, quicker tower levels, DinoLevel DRY up
- ([`d2ceabc3`](https://github.com/russmatney/dino/commit/d2ceabc3)) fix: free old game nodes, one-shot connect to quests-complete

  > Making some good cases for some new classes here, but I just hate to be
  > stuck in one, you know?
  > 
  > But yeah, should probably write a script exposing opts for
  > Arcade/Roulette and dry up the shared quest-regen-level bits. If only
  > these could be composed... i guess that's what a class is? ugh.

- ([`6af77b50`](https://github.com/russmatney/dino/commit/6af77b50)) feat: Roulette working with questy gunner/shirt

  > Short one gem-counting bug in shirt.

- ([`578e609b`](https://github.com/russmatney/dino/commit/578e609b)) feat: support pause in Jumbotron

  > defaults to true, but is opt-out if you'd like.

- ([`1e2990f0`](https://github.com/russmatney/dino/commit/1e2990f0)) feat: jumbotron as a basic level-intro

  > Should probably optionally pause execution while this is up.

- ([`c3aa7124`](https://github.com/russmatney/dino/commit/c3aa7124)) fix: dodge some annoying errors
- ([`283a79ca`](https://github.com/russmatney/dino/commit/283a79ca)) refactor: Gunner BreakTheTargets refactored into QuestNode

  > Game.gd caching a player_scene so we don't need to care so much
  > about the 'current_game' - tho we could also check the
  > current-game-entity for much cheaper.

- ([`e6e5697c`](https://github.com/russmatney/dino/commit/e6e5697c)) fix: no more SSPlayer default hud

  > This was overwriting Gunner's hud.

- ([`11db1470`](https://github.com/russmatney/dino/commit/11db1470)) wip: really not sure if levels or game-modes should connect to Quests
- ([`b73d9b4c`](https://github.com/russmatney/dino/commit/b73d9b4c)) fix: drop some bad ideas from Game.gd

  > If anything relies on this, it shouldn't.

- ([`b4457b16`](https://github.com/russmatney/dino/commit/b4457b16)) refactor: BrickLevelGen nodes ensure containers on ready

  > Moving some logic around, towards a better ready vs regeneration cycle.
  > 
  > - BrickLevelGen ensure_containers() in _ready
  > - BrickLevelGen only set owners in editor
  > - BrickLevelGen call 'regenerate' if no rooms (and after a delay)
  > 
  > This probably isn't right, but unfortunately achieves the right behavior
  > so far.

- ([`52053d3c`](https://github.com/russmatney/dino/commit/52053d3c)) chore: small clean ups

  > warning message too big, queue_free is probably better, no need for this
  > ready fn (especially now that brickLevelGen will use it's ready to clear
  > containers).

- ([`f69174f8`](https://github.com/russmatney/dino/commit/f69174f8)) wip: silence a bunch of already-connected errors

  > Maybe these should be one-offs, or maybe we shouldn't try to reconnect
  > them so much... not really sure.

- ([`597f4529`](https://github.com/russmatney/dino/commit/597f4529)) refactor: Quest -> Q, QuestNode as class Quest

  > Writes two simple quests for Shirt: CollectGems and KillEnemies.
  > Refactors ShirtLevel to signal completion in terms of Quest nodes.
  > 
  > Not sure the best way to encode these, and lots of ux fixes needed.

- ([`c843b439`](https://github.com/russmatney/dino/commit/c843b439)) feat: minor Quest jumbotron impl cleanup
- ([`dbb81dbd`](https://github.com/russmatney/dino/commit/dbb81dbd)) fix: better image alt text
- ([`2b17a513`](https://github.com/russmatney/dino/commit/2b17a513)) fix: discord badge style, itch/steam badge colors
- ([`1a599ab8`](https://github.com/russmatney/dino/commit/1a599ab8)) doc: add flat shields.io links to readme
- ([`f7ff884d`](https://github.com/russmatney/dino/commit/f7ff884d)) doc: testing multi-line org html inling
- ([`3e110088`](https://github.com/russmatney/dino/commit/3e110088)) test: drop game singleton assertion

  > Dino games no longer guarantee singletons!

- ([`04335d4e`](https://github.com/russmatney/dino/commit/04335d4e)) doc: attempt to fix readme action links

### 8 Nov 2023

- ([`9620388d`](https://github.com/russmatney/dino/commit/9620388d)) fix: prevent crash when launching roulette
- ([`1855b2cc`](https://github.com/russmatney/dino/commit/1855b2cc)) wip: basic arcade mode, noisey log and camera fixes
- ([`f3a28ad1`](https://github.com/russmatney/dino/commit/f3a28ad1)) fix: pause menus on layer 10, process_mode 'always'

  > Figured out a long-time issue where clickign on the pause menu wasn't
  > doing anything. Finally diagnosed that it was the player HUD blocking
  > it... but that's not right, is it? It's the canvas_layer! We don't need
  > to re-order the scene_tree, we need to bump up the layer of the pause
  > menus so they get that always-in-front treatment.

- ([`e51856c2`](https://github.com/russmatney/dino/commit/e51856c2)) fix: free dead huds

  > Frees HUDs before creating new ones. woops!

- ([`64f40ad4`](https://github.com/russmatney/dino/commit/64f40ad4)) feat: change seed, room_count, regenerating level via brickRegenMenu

  > Regenerating while paused working! Just have to manually disable the
  > HUDs that are blocking the input while paused, those wiley bastards.

- ([`d9ef9681`](https://github.com/russmatney/dino/commit/d9ef9681)) wip: towards a brickRegenMenu on the roulette pause screen
- ([`9f6ecac3`](https://github.com/russmatney/dino/commit/9f6ecac3)) addon: adds custom-scene-launcher and ports it to godot 4

  > Imports: https://gitlab.com/godot-addons/custom-scene-launcher and
  > manually updates most of it for godot 4. It sort of works - not sure
  > what the pin button is supposed to be doing. Will probably strip it down
  > at some point - not sure why it's reading/writing from a config at all,
  > for example.
  > 
  > Either way, a bit of a boon for now, as we can manually select a scene
  > and play it regardless of which scene is focused.


### 7 Nov 2023

- ([`29c6c79d`](https://github.com/russmatney/dino/commit/29c6c79d)) wip: level complete for shirt, tower, woods
- ([`fcd99066`](https://github.com/russmatney/dino/commit/fcd99066)) feat: quick level_complete signal work for pluggs
- ([`acc26cc8`](https://github.com/russmatney/dino/commit/acc26cc8)) feat: roulette passing from gunner to pluggs!

  > First case of roulette passing from one game to the next! Bunch of
  > cleanup and solidifying to happen, but great to see it working.

- ([`2aeaf95e`](https://github.com/russmatney/dino/commit/2aeaf95e)) fix: can't use `is` if it's invalid, it turns out
- ([`f7c86165`](https://github.com/russmatney/dino/commit/f7c86165)) feat: Roulette launching the first game

  > Writing right around the game.current_game state here - I wonder how this
  > is going to go!

- ([`e53d393f`](https://github.com/russmatney/dino/commit/e53d393f)) feat: boilerplate for a new game-mode: Arcade

  > Could probably dry this up more, but it's also nice to have fresh
  > workspaces for improving some custom menus'n'such.
  > 
  > I'm hopeful that having two game-modes to hack on will help me
  > think through a somewhat generic structure for managing these games.

- ([`791df5b8`](https://github.com/russmatney/dino/commit/791df5b8)) feat: make use of is_game_mode() flag

  > Adds the game_ent func, an sorts by it in dino menu.

- ([`8c18272e`](https://github.com/russmatney/dino/commit/8c18272e)) feat: first game_mode, drop a bunch of game singletons

  > Introduces a new concept, dino game modes. This is a sub-category of
  > DinoGameEntities right now.
  > 
  > Drops a bunch of unused game_singletons, and refactors Game.gd to create
  > a DinoGame on the fly when a singleton isn't specified. DinoGames still
  > use 'singleton'-like behavior via the Game.gd autoload.
  > 
  > Perhaps the Game.gd autoload should also go away or otherwise lose it's
  > state? Right now it'd be problemmatic to run two games at once. So far
  > it seems like the encounter/level refactor we're in will change the way
  > this works.

- ([`a0f49050`](https://github.com/russmatney/dino/commit/a0f49050)) misc: noisey logs, woods regen
- ([`75b5e7c0`](https://github.com/russmatney/dino/commit/75b5e7c0)) feat: drop super elevator level singleton and usage
- ([`b4f5ddfa`](https://github.com/russmatney/dino/commit/b4f5ddfa)) fix: calc room rect properly

  > Resolves a bug when adding border tiles - room rects were being calced
  > with tmap.get_used_rect(), which doesn't always cover the whole room.
  > Instead we build a rect for the room ourselves - note these are coord
  > Rect2i in tilemap space, not local Vector2 floats.

- ([`2e7fbe26`](https://github.com/russmatney/dino/commit/2e7fbe26)) fix: better behaving border_depth applied to TheWoods

  > Corrects some errors - this is actually simpler than I thought.

- ([`497774f3`](https://github.com/russmatney/dino/commit/497774f3)) feat: cleaner border extension impl, includes corners

  > Rather than calc these in a loop, we establish the level corners and
  > border corners, then fill in 4 rects based on those.
  > 
  > Still leaves gaps between the used_rect() rect and inner tile rooms. I
  > wonder if there's a clean way to fill those...

- ([`b3cf73da`](https://github.com/russmatney/dino/commit/b3cf73da)) feat: brick supporting basic extended borders

  > Still need to fill in internal gaps and corners, but this works for
  > one-room levels.

- ([`d3c011f2`](https://github.com/russmatney/dino/commit/d3c011f2)) chore: misc level default regens.
- ([`865a7d25`](https://github.com/russmatney/dino/commit/865a7d25)) feat: basic super elevator level gen via brick

  > Working pretty well, tho the tilesets are the cave theme for now. will
  > need to improve the art to be more elevator-y.


### 3 Nov 2023

- ([`ed2c3dc4`](https://github.com/russmatney/dino/commit/ed2c3dc4)) chore: disable a few games

  > disables mountain, ghost house, and dungeon crawler.
  > 
  > Not much to do with these at the moment - will return when things are
  > more clear/farther along, maybe to create some villages/npcs.

- ([`a8b4f5c9`](https://github.com/russmatney/dino/commit/a8b4f5c9)) feat: load level-gen games via first-level entity param

  > Adds a new property to the DinoGameEntity: 'first_level'. If set, the
  > default DinoGame.start() impl will load it via Nav.nav_to(). start() can
  > be overwritten, but the trend right now is towards completely dropping
  > the game singletons, and putting game specific logic into these
  > first_level scenes.
  > 
  > This updates dino to make all the existing level-gen implementations
  > playable! Check out VoidSpike, Shirt, TowerJet, Gunner, Harvey, Herd,
  > Pluggs, and TheWoods for new Brick/levelscript generated levels.
  > Hopefully soon these will have a 'treadmill' (for basic regenerating
  > when the win condition is reached) and options configurable via the
  > pause menu.

- ([`1a11de83`](https://github.com/russmatney/dino/commit/1a11de83)) test: disable too-broad tests and orphan reporting

  > Dropping these for the moment to get another build deployed.

- ([`a61278ed`](https://github.com/russmatney/dino/commit/a61278ed)) feat: get most tests passing again
- ([`8d77ad19`](https://github.com/russmatney/dino/commit/8d77ad19)) feat: spike levelgen impl working, including top/bottom portal

  > Kind of a hack, but these are the escape hatches i want to support.
  > 
  > Could refactor towards a simpler api, something that automagically
  > reparents/rearranges cross-dep entities like this. But, realizing that
  > this feature could be impled via the roombox makes me wonder if it's
  > better to keep things simple - i.e. find some other way to express it.
  > we'll see how it goes as we add more use-cases - a simple 'setup' called
  > on the final generated output might be a better/simpler place to do some
  > of this work, tho right now we're benefiting from letting the rooms do
  > the positioning work.

- ([`6ea28d5a`](https://github.com/russmatney/dino/commit/6ea28d5a)) wip: tilemap -> entity and a more complex case in spike

  > A wip towards supporting a few more options, in this case getting an
  > area2d from a tilemap and an entity, then moving them both under an
  > arbitrary instance.

- ([`f61f9f1d`](https://github.com/russmatney/dino/commit/f61f9f1d)) feat: generating a basic void spike level via BrickLevelGen

  > Extends the one-way platform to be resizable (and preserve that width
  > via an @export).
  > 
  > Some other adjustments to make this work, including dropping the
  > Metro-spike impl. Maybe Metro could be stripped down to support
  > fast-travel (nav/menus) and mini-maps? That'd fit it's name better.


### 2 Nov 2023

- ([`0764257e`](https://github.com/russmatney/dino/commit/0764257e)) fix: drop this tool script debugging code
- ([`a1617cdf`](https://github.com/russmatney/dino/commit/a1617cdf)) misc: some latest level gens for gunner, harvey, tower
- ([`ffcb5c62`](https://github.com/russmatney/dino/commit/ffcb5c62)) feat: herd generating levels via BrickLevelGen

  > A bit more involved - had to develop a quick method for generating the
  > FetchSheepQuest and it's required area2d on the fly - this does so by
  > setting a group on the generated 'Pen' tilemap and using that to derive
  > an area2d, and adding the quest after the fact in HerdLevel.gd

- ([`92eea209`](https://github.com/russmatney/dino/commit/92eea209)) feat: support similar 'setup' style on brickLevel tilemaps

  > In this case, adding a tilemap to a group.

- ([`84913710`](https://github.com/russmatney/dino/commit/84913710)) feat: naive tilemap -> area2d helper

  > This will need to get much more nuanced, but it covers a useful enough
  > case (basic rectangles) to be impled for now.

- ([`ccf8564b`](https://github.com/russmatney/dino/commit/ccf8564b)) fix: enemy robots taking hits again

  > No longer invincible!

- ([`13d960d2`](https://github.com/russmatney/dino/commit/13d960d2)) feat: levelGen generating tower jet levels

  > Pretty cool! This is finally becoming what i wanted this game to be,
  > short of a heck-ton of polish.

- ([`a3108fd6`](https://github.com/russmatney/dino/commit/a3108fd6)) feat: support show-color-rect

  > This is quite useful for debugging - being able to see the rect each
  > room is responsible for.

- ([`5aaa5a68`](https://github.com/russmatney/dino/commit/5aaa5a68)) wip: cam_window_rect() not crashing

  > The offscreen-indicators use this, and it doesn't appear to be working
  > anymore. No longer crashing the game tho, so that's good.

- ([`df10edfd`](https://github.com/russmatney/dino/commit/df10edfd)) feat: basic gunner level gen and rooms

  > Gunner still crashing, but it's fun to be doodling more levels this way.

- ([`d6911b9d`](https://github.com/russmatney/dino/commit/d6911b9d)) feat: add some harvey levels, adjust box layouts

  > For these grid-based levels, rather than push every entity down to the
  > bottom of it's coord, we expect to align 0,0 on an entity with the
  > grid's coord (top-left). Further adjustments can happy per entity in a
  > passed setup(ent) helper. The baked-in helper made sense in a platformer
  > context, but not a top-down one.
  > 
  > Another adjustment is making seedboxes accessible from all sides, which
  > makes more top-down sense, and avoids the rotation complexity that the
  > delivery boxes took on.

- ([`9969420d`](https://github.com/russmatney/dino/commit/9969420d)) fix: resize seed/delivery boxes, set harvey player scene

  > Very pleased to find that entity 'setup' was already implemented! I
  > threw it in when writing that function out (but then forgot), and then
  > opted into the same api when drafting harvey's levelgen this morning.
  > Worked perfectly!

- ([`c6d531a0`](https://github.com/russmatney/dino/commit/c6d531a0)) feat: basic harvey level gen

  > Pretty quick to get this started! Bunch of clean up/sizing/etc to work out.


### 1 Nov 2023

- ([`80d47d85`](https://github.com/russmatney/dino/commit/80d47d85)) feat: support gems in shirtlevelgen

  > Also removes shirt's 'metro' treatment, b/c it was breaking the plain
  > shirt level. Ought to reformulate the metro approach - what are we
  > getting for it? (minimap/pause-map, pausing/hiding levels, room-corner
  > cameras... anything else?)

- ([`93557ba5`](https://github.com/russmatney/dino/commit/93557ba5)) feat: shirt consuming slimmer BrickLevelGen style

  > Removes the bit of shirtLevel that was transferring nodes to the scene -
  > BrickLevelGen handles this for us now, creating parent nodes if none
  > exist.
  > 
  > I hit a bad-address issue when coming back around to make this change,
  > but it was resolved after an editor restart.

- ([`9d3f993a`](https://github.com/russmatney/dino/commit/9d3f993a)) feat: pluggs consuming BrickLevelGen

  > BrickLevelGen now creates missing nodes for the parent, which is even
  > nicer. Drops pluggs's initial levelGen impl, expresses pluggs-y things
  > in PluggsLevelGen and PluggsLevel, which are happily separated.

- ([`5b18073a`](https://github.com/russmatney/dino/commit/5b18073a)) feat: drop woods WorldGen - now supported by BrickLevelGen

  > This earlier implementation is now expressed via BrickLevelGen,
  > WoodsLevelGen, and WoodsLevel.
  > 
  > Updates some tests per the BrickRoom multi-tilemap extension.

- ([`a9d867d8`](https://github.com/russmatney/dino/commit/a9d867d8)) feat: woods levels generating via BrickLevelGen

  > Not 100% about subclassing BrickLevelGen every time, but maybe it makes
  > alot of sense?
  > 
  > Starting to implement level logic, in this case just finding the last
  > room and connecting to it's signal.
  > 
  > Introduces roomboxes on Rooms, which requires even more assignment of
  > node children owners to keep (for the required collisionShape2Ds).
  > 
  > Extends BrickLevelGen to accept nodes for entities/rooms/tilemaps, to
  > DRY up the node handoff from gen to level. Could even create and add
  > these on the fly to the gen's parent or owner.

- ([`a1eb9ffc`](https://github.com/russmatney/dino/commit/a1eb9ffc)) feat: basic entities coverage for BrickLevelGen
- ([`77c69f5c`](https://github.com/russmatney/dino/commit/77c69f5c)) feat: basic tilemap test coverage for BrickLevelGen

  > adds the metal16 tiles as a fallback for unspecified label_to_tilemaps.
  > 
  > Merges the opts passed to BrickLevelGen.generate_level into each
  > room_opt, to support things like label_to_entity/label_to_tilemap being
  > passed one time.

- ([`36e01f9a`](https://github.com/russmatney/dino/commit/36e01f9a)) refactor: move much of BrickLevelGen to static funcs

  > Reaching for tests pushed me to want to just test the generate_level
  > func, rather than creating a node to test this on.

- ([`92474139`](https://github.com/russmatney/dino/commit/92474139)) feat: generating floor tiles under pits, entities

  > Coming together pretty well here!

- ([`7275258a`](https://github.com/russmatney/dino/commit/7275258a)) refactor: BrickRoom + LevelGen supporting multiple tilemaps

  > Moves from a passed tilemap_scene to a label_to_tilemap dict - this is a
  > map from the legend/label of the room_defs to an options dict for each
  > tilemap, supporting just `scene` and `add_borders` for now. To come:
  > extend-edges or some better named feat.

- ([`e1b115dd`](https://github.com/russmatney/dino/commit/e1b115dd)) refactor: move border tilemaps helpers to Reptile
- ([`7b40f039`](https://github.com/russmatney/dino/commit/7b40f039)) refactor: move Reptile from autoload to static class

  > Reptile was already stateless, no need for the autoload now that we have
  > static class funcs.

- ([`782e4048`](https://github.com/russmatney/dino/commit/782e4048)) chore: drop shirt/gen/LevelGen, emit seed, misc clean up

### 31 Oct 2023

- ([`38a10e17`](https://github.com/russmatney/dino/commit/38a10e17)) wip: debugging entity positioning issue

  > Entities are ending up at 0,0. not sure why yet, but i suspect it's
  > because the rooms and entities aren't added to the gen scene anymore, so
  > somehow the positions are being set and later propagated.

- ([`61c889ad`](https://github.com/russmatney/dino/commit/61c889ad)) refactor: break shirt-details into shirtlevelgen

  > BrickLevelGen more or less generic now! Could use a testing setup.

- ([`879494df`](https://github.com/russmatney/dino/commit/879494df)) refactor: cleaning up BrickLevelGen impl

  > Cutting out intermediary nodes, removing run-timey features that will
  > now live in the parent node.

- ([`24732259`](https://github.com/russmatney/dino/commit/24732259)) wip: ShirtLevelGen as ShirtLevel child, promoting nodes

  > Rough working impl of a level generator as a child node to a
  > level-script/encounter parent node.

- ([`9e67648e`](https://github.com/russmatney/dino/commit/9e67648e)) wip: towards a DRY BrickLevelGen impl

  > Not sure yet if this should be inherited or just static funcs, like
  > BrickRoom.

- ([`8b1fd4c4`](https://github.com/russmatney/dino/commit/8b1fd4c4)) refactor: move BrickRoom impl back to static funcs

  > The create_room shift to room.gen() was to allow modifications via
  > inheritance and subclass function overwrites - instead BrickRooms should
  > be pretty much throw-away/transient - pass in opts and generate the
  > tilemaps and entities, then promote them to the level nodes and maybe
  > finally drop some area2ds for convenience.

- ([`c55ebe10`](https://github.com/russmatney/dino/commit/c55ebe10)) feat: much cleaner border add

  > Uncomplicates the matching-wall-deletion approach, instead opting only
  > include border tiles that don't overlap an room's rect. A bit tricky
  > working with tilemap scaling here, but it works now... ought to get this
  > covered by tests.


### 30 Oct 2023

- ([`99056af6`](https://github.com/russmatney/dino/commit/99056af6)) fix: correct filter_rooms opts pass in woods test
- ([`9fac480d`](https://github.com/russmatney/dino/commit/9fac480d)) refactor: drop PluggsRoom completely

  > No need to inherit BrickRoom, instead we'll call out to it statically
  > and promote it's parts as needed.

- ([`737d9e43`](https://github.com/russmatney/dino/commit/737d9e43)) refactor: drop WoodsRoom completely

  > Moving away from inheriting BrickRoom, and using it as a completely
  > static class - modifications to it's internals should be passed in as
  > functions via BrickRoomOpts

- ([`604d947a`](https://github.com/russmatney/dino/commit/604d947a)) misc: run some level gen, add a big open room
- ([`6a18249b`](https://github.com/russmatney/dino/commit/6a18249b)) fix: insidious alignment bug after . = Empty change

  > Glad to find a test to reproduce this, it was very confusing.
  > 
  > Moving from '.' always setting null in the shape to setting whatever the
  > legend says it is (Floor, in this case) probably created a few other
  > bugs as well.

- ([`4f36ec3f`](https://github.com/russmatney/dino/commit/4f36ec3f)) fix: pretty printer cut-off b/c arrays/etc are not 'valid'

  > Had to get more specific with this safety check.

- ([`a9f80a9f`](https://github.com/russmatney/dino/commit/a9f80a9f)) chore: test and misc fixes

  > Chasing a bug - unfortunately this test repro passed. along the way i
  > realized my pretty printer's colors aren't working, wonder when that
  > broke.

- ([`56260f39`](https://github.com/russmatney/dino/commit/56260f39)) feat: add borders per-room, drop conflicting borders

  > An attempt at bordering on a per-room level. Not perfect, but working
  > pretty well. Could use some clean up - about to pull these levelGen bits
  > into some DRY and tested brick abstraction.

- ([`da1f6d08`](https://github.com/russmatney/dino/commit/da1f6d08)) refactor: remove hard-coded '.' -> null in parser

  > Instead, we support returning '.' as whatever the legend says it is, or
  > null if there is nothing matching in the legend. Note that other
  > characters without match in the legend will be passed through, so still
  > a bit of hard-coding for '.' in that case.

- ([`bb2f75e7`](https://github.com/russmatney/dino/commit/bb2f75e7)) wip: wrap_tilemap impl adds a tiled border

  > A simple used_rect() -> border tile implementation. Leaves gaps where
  > there are no rooms, but maybe we can just fill those in?

- ([`76eb5c31`](https://github.com/russmatney/dino/commit/76eb5c31)) fix: shirt gen - skip 'first' room after first
- ([`55ffde2c`](https://github.com/russmatney/dino/commit/55ffde2c)) feat: promoting entities to the rooms node

  > Getting ever closer to the scene tree structure we should have -
  > should probably be putting these on an entities node rather than the
  > rooms one, but i'm not sure of the implications yet.

- ([`2d8d2322`](https://github.com/russmatney/dino/commit/2d8d2322)) fix: drop room_base_dim variable

  > This was dropped from the algorithm in favor of tile_size.

- ([`65e6283e`](https://github.com/russmatney/dino/commit/65e6283e)) fix: don't set tree root as current_scene

  > Finally learned how to read this error - I was setting the root as the
  > current_scene, which is a no-no. For now returns to the previous
  > algorithm, setting the root's last child as the current_scene, which
  > should generally be right? Hopefully this removes another error failing
  > the start-every-game test.

- ([`663d48b7`](https://github.com/russmatney/dino/commit/663d48b7)) misc: flip the default on playerspawnpoints

  > Plus a generated shirt level in our newest LevelGen

- ([`446059bb`](https://github.com/russmatney/dino/commit/446059bb)) feat: now adding player + enemies

  > Not too bad! Didn't even need to subclass BrickRoom here, which I'm
  > thinking is a bad pattern. Not sure if BrickRoom should even have an
  > instance... vs just creating and passing along node2ds or some
  > non-specific thing. It's really about the tiles and entities - the tiles
  > are being promoted to the level, and the entities probably should be as
  > well.

- ([`0844f37b`](https://github.com/russmatney/dino/commit/0844f37b)) wip: doodling some connected top-down rooms

  > Boilerplate for a new LevelGen - slated next for the Bricks testing and
  > DRY up, but towards generating some shirt-levels first.


### 29 Oct 2023

- ([`e37d6210`](https://github.com/russmatney/dino/commit/e37d6210)) feat: test coverage for adding an aligned room in any direction

  > Quick impl - not too dry, but decently tested.

- ([`5c5d4e53`](https://github.com/russmatney/dino/commit/5c5d4e53)) feat: create BrickRoomOpts, swaps in for opts Dictionary

  > Perhaps this is more maintainable. I'm reluctant but i'll try it.

- ([`b4257956`](https://github.com/russmatney/dino/commit/b4257956)) chore: misc woods/pluggs room regens
- ([`a576d324`](https://github.com/russmatney/dino/commit/a576d324)) feat: adding room above last room

  > Basic version of adding a room above the last one. Probably not quite
  > the right api yet - this supports passing a side to add the next room
  > too, but we might want to search the room options for one that fit the
  > last room's open sides, and start getting into rotating the rooms.

- ([`7dbe5d78`](https://github.com/russmatney/dino/commit/7dbe5d78)) fix: restore woods_room tests

  > Updates some positions/sizes in test assertions after
  > woods<>pluggs<>brick refactor.
  > 
  > The woods implementation changed from using base_dim_size and room-type
  > based positioning to matching last/next floor tiles up (and using
  > opts.tile_size, which defaults to 16).

- ([`f4761c93`](https://github.com/russmatney/dino/commit/f4761c93)) feat: restore tiles on wall woods rooms

  > The next-room algo now supports aligning last/next room floor tiles, so
  > we can have ceilings again.

- ([`dc6e5e12`](https://github.com/russmatney/dino/commit/dc6e5e12)) feat: next_room_position smarter offset handling

  > Now aligning rooms with closed tops as well.
  > 
  > This concept should be applicable to topdown rooms as well, once we get
  > to placing rooms against more than just one wall.

- ([`b5c016d5`](https://github.com/russmatney/dino/commit/b5c016d5)) fix: apparently fix camera issue?

  > I don't think I actually fixed this, but the tests are passing now.

- ([`918d8e26`](https://github.com/russmatney/dino/commit/918d8e26)) chore: noisey invalid uid nonsense

  > These seem to happen as i move between machines, but i might just be
  > suspicious of that.

- ([`3bf79e1d`](https://github.com/russmatney/dino/commit/3bf79e1d)) wip: rename ensure_camera -> request_camera, testing boilerplate

### 28 Oct 2023

- ([`b73a3612`](https://github.com/russmatney/dino/commit/b73a3612)) wip: adjust fall rooms to fix woods worldgen

  > Instead we should improve the algorithm to find the 'middle' of the wall
  > - in this case it's getting stuck at the top of the room, which should
  > never happen.

- ([`4df82ae6`](https://github.com/russmatney/dino/commit/4df82ae6)) fix: tidys some pretty printer/misc details
- ([`660f3333`](https://github.com/russmatney/dino/commit/660f3333)) fix: select a random room for the middle-ones

  > This got dropped when moving WoodsRoom to inherit BrickRoom.

- ([`75a442ee`](https://github.com/russmatney/dino/commit/75a442ee)) fix: correct inverted flags/skip_flags

  > ... should probably have a test that catches this?

- ([`83f9ef3a`](https://github.com/russmatney/dino/commit/83f9ef3a)) wip: porting woods level gen to use BrickRoom

  > Tests nearly back, but for the dimensional changes.

- ([`fd0b0ac7`](https://github.com/russmatney/dino/commit/fd0b0ac7)) feat: debug.to_pretty duck-typing

  > Extends new types to use the pretty printer.

- ([`43344cb8`](https://github.com/russmatney/dino/commit/43344cb8)) feat: introduce BrickRoom, which takes on generic PluggsRoom code

  > Extracts the per-game/encounter stuff, like label->entity and tilemap
  > scene. Some trouble with static vs dynamic constructors - should
  > probably figure out what's going on with that.

- ([`87c0b78a`](https://github.com/russmatney/dino/commit/87c0b78a)) refactor: move some PluggsRoom helpers to RoomDef
- ([`d5b0cb88`](https://github.com/russmatney/dino/commit/d5b0cb88)) fix: fix flaky test

  > Hopefully this actually fixed and not just random now

- ([`1760c32d`](https://github.com/russmatney/dino/commit/1760c32d)) refactor: pluggs,woodsRoom building via RoomDefs and RoomDef

  > Refactors and restores pluggs_room_ and woods_room_tests, now in terms
  > of two classes.
  > 
  > Still lots of `.shape` being exposed, but this will be easier to
  > abstract into one of these classes now.

- ([`78f5436b`](https://github.com/russmatney/dino/commit/78f5436b)) feat: RoomParser.parse() returning RoomDefs

  > Moving to some classes and more structure for this data. Expecting a
  > bunch of helpers to become RoomDefs/RoomDef methods, and probably to add
  > some structure to the 'opts' - i'd love a reasonable constructor syntax
  > for these objects... will probably write a from_opts(Dictionary) api for
  > things.

- ([`f2517a48`](https://github.com/russmatney/dino/commit/f2517a48)) wip: starting in on BrickRoom, RoomDef impl + tests
- ([`50f47c68`](https://github.com/russmatney/dino/commit/50f47c68)) assets: adds some doodles to the splash image
- ([`312f0bb5`](https://github.com/russmatney/dino/commit/312f0bb5)) addon: brick -> provider of level-based proc-gen

  > Introduces a new addon called 'brick'. Really just looking for a place
  > to put this RoomDef and RoomParser, as well as trying to get a stronger
  > metaphor under the Encounter and LevelGen concepts. Maybe this could end
  > up eating Metro, or providing MetroRoom-like features.


### 27 Oct 2023

- ([`4695f847`](https://github.com/russmatney/dino/commit/4695f847)) refactor: rewrite gut tests as gdunit tests
- ([`35948bd1`](https://github.com/russmatney/dino/commit/35948bd1)) fix: restore woods room tests, port pluggs room tests
- ([`20124ede`](https://github.com/russmatney/dino/commit/20124ede)) chore: drop more gut stuff
- ([`a235811f`](https://github.com/russmatney/dino/commit/a235811f)) ci: tests officially failing (successfully!)
- ([`b0b141e5`](https://github.com/russmatney/dino/commit/b0b141e5)) fix: force 0 exit code on project load/scan
- ([`297edaf8`](https://github.com/russmatney/dino/commit/297edaf8)) refactor: move to running gdunit tests in CI
- ([`b39df1ba`](https://github.com/russmatney/dino/commit/b39df1ba)) feat: rewrite bb test, remove old commands
- ([`e6745fda`](https://github.com/russmatney/dino/commit/e6745fda)) chore: drop addons/gut

  > Also drops some gut config files, and some old inkgd stuff

- ([`2b26063c`](https://github.com/russmatney/dino/commit/2b26063c)) chore: simplify test structure

  > moves the tests from unit/integration and addon/src dirs into just test/.


### 26 Oct 2023

- ([`df70a0fe`](https://github.com/russmatney/dino/commit/df70a0fe)) feat: finish rewrite woods_room_test in gdunit

  > Happily, these fail when the code running in the test has a runtime
  > error. yay test suite! Now to rewrite the rest and drop gut.

- ([`d578e6a1`](https://github.com/russmatney/dino/commit/d578e6a1)) dep: add gdunit4, wip port of woods_room_test

  > Confirms that tests fail when a script error occurs. woo!

- ([`6175261d`](https://github.com/russmatney/dino/commit/6175261d)) fix: some tests fixed, about to move to gdunit

  > Just found gut doesn't fail tests when gdscript throws errors, which is
  > too dang bad. More digging reveals it's a hot topic, an gdscript doesn't
  > really have exceptions. So that's interesting.

- ([`cbdd9e4e`](https://github.com/russmatney/dino/commit/cbdd9e4e)) feat: explicit seed handling in pluggs level gen
- ([`19288929`](https://github.com/russmatney/dino/commit/19288929)) refactor: use navi wrapper instead of accessing navi.current_scene

  > The navi.current_scene usage is a bit fragile, so we prefer to call
  > funcs instead of depend on this var (which may not be set.)

- ([`dbe4a965`](https://github.com/russmatney/dino/commit/dbe4a965)) feat: plug into arcade machine to reboot the world

  > A level-gen treadmill - can now connect to arcade machines to re-run the
  > level gen (or bubble up other events).
  > 
  > Not too sure on this double signal emit (machine to room, room to level
  > gen). Maybe this should be the message bus pattern?
  > 
  > Also fixes a bug in navi when no current_scene is set. Should be fine?
  > Required for deving, ever since the current_scene doesn't get auto-set
  > anymore.
  > 
  > Adds a basic HUD to pluggs.

- ([`5c805d3f`](https://github.com/russmatney/dino/commit/5c805d3f)) feat: level gen using flags/skip_flags to pick rooms

  > Seems simple, maybe it'll scale?
  > 
  > Also adds player spawn points to 'p' tiles.

- ([`08ef8d72`](https://github.com/russmatney/dino/commit/08ef8d72)) feat: add dino boot splash
- ([`e21780e1`](https://github.com/russmatney/dino/commit/e21780e1)) fix: remove overlapping joypad action

  > Removes 'restart' on Y, which was overlapping with 'action', making
  > pluggs unplayable via controller in the regen room.


### 25 Oct 2023

- ([`9d23b6cb`](https://github.com/russmatney/dino/commit/9d23b6cb)) feat: add light occluders to metal tiles
- ([`eca0743a`](https://github.com/russmatney/dino/commit/eca0743a)) feat: point to levelGen for playable pluggs scene
- ([`1773d0df`](https://github.com/russmatney/dino/commit/1773d0df)) feat: larger and smoother lights

  > Adds a big dithered light to the arcade machine, and a larger and
  > smoother light to the usuals.

- ([`d369e48f`](https://github.com/russmatney/dino/commit/d369e48f)) feat: level gen adding arcade machines
- ([`aaca2c45`](https://github.com/russmatney/dino/commit/aaca2c45)) feat: basic ArcadeMachine turning on/off via socket

  > Pretty simple!

- ([`f8ddb5e9`](https://github.com/russmatney/dino/commit/f8ddb5e9)) feat: arcade machine art
- ([`33f6910a`](https://github.com/russmatney/dino/commit/33f6910a)) fix: update godot version number in itch deploys
- ([`d4f94e6c`](https://github.com/russmatney/dino/commit/d4f94e6c)) ci: deploy to steam/itch from 'edge' and 'prod' branches

  > Will come back to deploying only some tags at some point - hoping this
  > lets me keep working on main with some more git-based deploy control.

- ([`b66488b4`](https://github.com/russmatney/dino/commit/b66488b4)) chore: delete rest of the TODOs

  > Drops the rest of the codebase's TODOs. Here's to making them more useful!

- ([`4bcb0dee`](https://github.com/russmatney/dino/commit/4bcb0dee)) chore: deleting TODOs

  > A clean up task - calling TODO bankruptcy, removing most/all. They are
  > generally quite old and asking for things that could be added, but we
  > can make TODOs useful as well and have feature-wishlists elsewhere.

- ([`ab633e0e`](https://github.com/russmatney/dino/commit/ab633e0e)) feat: expand watch command to whole directory

  > After much wrestling with watching all the asset/ dirs, watching just
  > the root and filtering on extension ends up being much simpler and
  > actually working. Plus it's probably more flexible for some other watch
  > tasks, (maybe generating ids/entities on levelscript file changes?)

- ([`58106ed1`](https://github.com/russmatney/dino/commit/58106ed1)) feat: add quit-game button to pause menus

  > I suppose we could dry up these options, especially since they're mostly
  > point-free at this point.
  > 
  > We may want to hide this button on some platforms, maybe web? Not sure
  > what'll happen. Letting it go for now.

- ([`b31d9c65`](https://github.com/russmatney/dino/commit/b31d9c65)) fix: correct readme badge urls

### 24 Oct 2023

- ([`a91d88f3`](https://github.com/russmatney/dino/commit/a91d88f3)) feat: adding Lights to pluggs room gen

  > Impls add_entity for PluggsRoom.
  > 
  > Also introduces a RoomDef class, which should be incorporated into the
  > inevitable refactor.

- ([`a73f955c`](https://github.com/russmatney/dino/commit/a73f955c)) feat: alignment between rooms working

  > Plus a bunch more room defs.

- ([`0aa63a7c`](https://github.com/russmatney/dino/commit/0aa63a7c)) wip: towards aligning on last y pos
- ([`b685663f`](https://github.com/russmatney/dino/commit/b685663f)) fix: don't crash if room_defs ends with empty lines

  > Updates the puzz parser to drop blank lines before passing chunks to the
  > section parser.


### 23 Oct 2023

- ([`4a941629`](https://github.com/russmatney/dino/commit/4a941629)) feat: add credits and quit buttons to main menu
- ([`73473d65`](https://github.com/russmatney/dino/commit/73473d65)) feat: scroll controls during credits

  > Much nicer to wiz around these credits - could use some sticky headers
  > and things too.

- ([`d663604d`](https://github.com/russmatney/dino/commit/d663604d)) wip: some pandora tweaks to fix a release build

  > Not at all final changes to pandora, just something to get things
  > working. The compressed pandora export is failing with an unrecognized
  > ERR_FILE_UNRECOGNIZED (15), so this moves pandora to reading/writing the
  > non-compressed in debug and release, rather than just debug.

- ([`ce50cf81`](https://github.com/russmatney/dino/commit/ce50cf81)) tool: bb export command

### 18 Oct 2023

- ([`eba8601b`](https://github.com/russmatney/dino/commit/eba8601b)) wip: blerg ci still not configured correctly

### 16 Oct 2023

- ([`fbaedb85`](https://github.com/russmatney/dino/commit/fbaedb85)) feat: readme linking to steam page

## v0.0.0-3


### 18 Oct 2023

- ([`8b17adb2`](https://github.com/russmatney/dino/commit/8b17adb2)) feat: update pluggs 'main' scene

  > Should probably incorporate this kind of data into the pandora entity as
  > well.

- ([`2193a92d`](https://github.com/russmatney/dino/commit/2193a92d)) feat: plugs 'unplugging' at a max length

  > it's kind of doing it!

- ([`7d514726`](https://github.com/russmatney/dino/commit/7d514726)) feat: drawing cord between socket and pluggs

  > And updating while pluggs moves around.

- ([`6517c296`](https://github.com/russmatney/dino/commit/6517c296)) feat: cord color changes based on length thresholds
- ([`f45b1b0e`](https://github.com/russmatney/dino/commit/f45b1b0e)) feat: lights lit by plugged sockets

  > Something starting to happen here.

- ([`12f0636a`](https://github.com/russmatney/dino/commit/12f0636a)) fix: woods room crash, disable some main-scene editor plugins

## v0.0.0-2


### 18 Oct 2023

- ([`528fa97a`](https://github.com/russmatney/dino/commit/528fa97a)) feat: test for something-focused in main menu

  > Also drops the process/lazy game entries add, b/c it should not be
  > needed.

- ([`af5e931c`](https://github.com/russmatney/dino/commit/af5e931c)) fix: only run if the branch is tagged?
- ([`89e5b1c9`](https://github.com/russmatney/dino/commit/89e5b1c9)) fix: specify bash in run command

  > Apparently a shell syntax error returns a success message.

- ([`889580c3`](https://github.com/russmatney/dino/commit/889580c3)) ci: reuse GODOT_VERSION variable

  > Still hardcoded on a few image versions...

- ([`fe69b246`](https://github.com/russmatney/dino/commit/fe69b246)) ci: unfortunately this manual check seems necessary

  > I'm a bit annoyed I can't break up my test and deploy pipeline without
  > workarounds - feels like github actions should support connecting
  > workflows without needing to create a github app or adding a personal
  > token and using the github ci (and coupling the workflows).
  > 
  > Eh, i guess CI is always just workarounds.


## v0.0.0-1


### 18 Oct 2023

- ([`6e7a8e21`](https://github.com/russmatney/dino/commit/6e7a8e21)) ci: another deploy attempt

## v0.0.0-0


## posterity.year-one


### 10 Nov 2023

- ([`3221029e`](https://github.com/russmatney/dino/commit/3221029e)) fix: don't await a jumbotron in tree_exiting

  > Finally can play through rounds of roulette without crashes! Woo!

- ([`aa5aa785`](https://github.com/russmatney/dino/commit/aa5aa785)) refactor: fix breakTheTargets, nearly working roulette rounds
- ([`8b233c13`](https://github.com/russmatney/dino/commit/8b233c13)) fix: drop DRYed up XLevel scripts, reseed after round complete

  > Still marking gunner complete immediately on the second round,
  > i think b/c the tower targets are being captured and exiting immediately
  > by gunner's target test.

- ([`43997394`](https://github.com/russmatney/dino/commit/43997394)) refactor: jumbo_notif via Jumbotron static

  > Pulls jumbotron out of Quest autoload, removes state.
  > 
  > The big shift is the return signal - we make sure to wait until the
  > previous jumbotron has exited (not just kicking off an async fade out
  > process).


### 9 Nov 2023

- ([`67e97bff`](https://github.com/russmatney/dino/commit/67e97bff)) feat: more jumbotrons, quicker tower levels, DinoLevel DRY up
- ([`d2ceabc3`](https://github.com/russmatney/dino/commit/d2ceabc3)) fix: free old game nodes, one-shot connect to quests-complete

  > Making some good cases for some new classes here, but I just hate to be
  > stuck in one, you know?
  > 
  > But yeah, should probably write a script exposing opts for
  > Arcade/Roulette and dry up the shared quest-regen-level bits. If only
  > these could be composed... i guess that's what a class is? ugh.

- ([`6af77b50`](https://github.com/russmatney/dino/commit/6af77b50)) feat: Roulette working with questy gunner/shirt

  > Short one gem-counting bug in shirt.

- ([`578e609b`](https://github.com/russmatney/dino/commit/578e609b)) feat: support pause in Jumbotron

  > defaults to true, but is opt-out if you'd like.

- ([`1e2990f0`](https://github.com/russmatney/dino/commit/1e2990f0)) feat: jumbotron as a basic level-intro

  > Should probably optionally pause execution while this is up.

- ([`c3aa7124`](https://github.com/russmatney/dino/commit/c3aa7124)) fix: dodge some annoying errors
- ([`283a79ca`](https://github.com/russmatney/dino/commit/283a79ca)) refactor: Gunner BreakTheTargets refactored into QuestNode

  > Game.gd caching a player_scene so we don't need to care so much
  > about the 'current_game' - tho we could also check the
  > current-game-entity for much cheaper.

- ([`e6e5697c`](https://github.com/russmatney/dino/commit/e6e5697c)) fix: no more SSPlayer default hud

  > This was overwriting Gunner's hud.

- ([`11db1470`](https://github.com/russmatney/dino/commit/11db1470)) wip: really not sure if levels or game-modes should connect to Quests
- ([`b73d9b4c`](https://github.com/russmatney/dino/commit/b73d9b4c)) fix: drop some bad ideas from Game.gd

  > If anything relies on this, it shouldn't.

- ([`b4457b16`](https://github.com/russmatney/dino/commit/b4457b16)) refactor: BrickLevelGen nodes ensure containers on ready

  > Moving some logic around, towards a better ready vs regeneration cycle.
  > 
  > - BrickLevelGen ensure_containers() in _ready
  > - BrickLevelGen only set owners in editor
  > - BrickLevelGen call 'regenerate' if no rooms (and after a delay)
  > 
  > This probably isn't right, but unfortunately achieves the right behavior
  > so far.

- ([`52053d3c`](https://github.com/russmatney/dino/commit/52053d3c)) chore: small clean ups

  > warning message too big, queue_free is probably better, no need for this
  > ready fn (especially now that brickLevelGen will use it's ready to clear
  > containers).

- ([`f69174f8`](https://github.com/russmatney/dino/commit/f69174f8)) wip: silence a bunch of already-connected errors

  > Maybe these should be one-offs, or maybe we shouldn't try to reconnect
  > them so much... not really sure.

- ([`597f4529`](https://github.com/russmatney/dino/commit/597f4529)) refactor: Quest -> Q, QuestNode as class Quest

  > Writes two simple quests for Shirt: CollectGems and KillEnemies.
  > Refactors ShirtLevel to signal completion in terms of Quest nodes.
  > 
  > Not sure the best way to encode these, and lots of ux fixes needed.

- ([`c843b439`](https://github.com/russmatney/dino/commit/c843b439)) feat: minor Quest jumbotron impl cleanup
- ([`dbb81dbd`](https://github.com/russmatney/dino/commit/dbb81dbd)) fix: better image alt text
- ([`2b17a513`](https://github.com/russmatney/dino/commit/2b17a513)) fix: discord badge style, itch/steam badge colors
- ([`1a599ab8`](https://github.com/russmatney/dino/commit/1a599ab8)) doc: add flat shields.io links to readme
- ([`f7ff884d`](https://github.com/russmatney/dino/commit/f7ff884d)) doc: testing multi-line org html inling
- ([`3e110088`](https://github.com/russmatney/dino/commit/3e110088)) test: drop game singleton assertion

  > Dino games no longer guarantee singletons!

- ([`04335d4e`](https://github.com/russmatney/dino/commit/04335d4e)) doc: attempt to fix readme action links

### 8 Nov 2023

- ([`9620388d`](https://github.com/russmatney/dino/commit/9620388d)) fix: prevent crash when launching roulette
- ([`1855b2cc`](https://github.com/russmatney/dino/commit/1855b2cc)) wip: basic arcade mode, noisey log and camera fixes
- ([`f3a28ad1`](https://github.com/russmatney/dino/commit/f3a28ad1)) fix: pause menus on layer 10, process_mode 'always'

  > Figured out a long-time issue where clickign on the pause menu wasn't
  > doing anything. Finally diagnosed that it was the player HUD blocking
  > it... but that's not right, is it? It's the canvas_layer! We don't need
  > to re-order the scene_tree, we need to bump up the layer of the pause
  > menus so they get that always-in-front treatment.

- ([`e51856c2`](https://github.com/russmatney/dino/commit/e51856c2)) fix: free dead huds

  > Frees HUDs before creating new ones. woops!

- ([`64f40ad4`](https://github.com/russmatney/dino/commit/64f40ad4)) feat: change seed, room_count, regenerating level via brickRegenMenu

  > Regenerating while paused working! Just have to manually disable the
  > HUDs that are blocking the input while paused, those wiley bastards.

- ([`d9ef9681`](https://github.com/russmatney/dino/commit/d9ef9681)) wip: towards a brickRegenMenu on the roulette pause screen
- ([`9f6ecac3`](https://github.com/russmatney/dino/commit/9f6ecac3)) addon: adds custom-scene-launcher and ports it to godot 4

  > Imports: https://gitlab.com/godot-addons/custom-scene-launcher and
  > manually updates most of it for godot 4. It sort of works - not sure
  > what the pin button is supposed to be doing. Will probably strip it down
  > at some point - not sure why it's reading/writing from a config at all,
  > for example.
  > 
  > Either way, a bit of a boon for now, as we can manually select a scene
  > and play it regardless of which scene is focused.


### 7 Nov 2023

- ([`29c6c79d`](https://github.com/russmatney/dino/commit/29c6c79d)) wip: level complete for shirt, tower, woods
- ([`fcd99066`](https://github.com/russmatney/dino/commit/fcd99066)) feat: quick level_complete signal work for pluggs
- ([`acc26cc8`](https://github.com/russmatney/dino/commit/acc26cc8)) feat: roulette passing from gunner to pluggs!

  > First case of roulette passing from one game to the next! Bunch of
  > cleanup and solidifying to happen, but great to see it working.

- ([`2aeaf95e`](https://github.com/russmatney/dino/commit/2aeaf95e)) fix: can't use `is` if it's invalid, it turns out
- ([`f7c86165`](https://github.com/russmatney/dino/commit/f7c86165)) feat: Roulette launching the first game

  > Writing right around the game.current_game state here - I wonder how this
  > is going to go!

- ([`e53d393f`](https://github.com/russmatney/dino/commit/e53d393f)) feat: boilerplate for a new game-mode: Arcade

  > Could probably dry this up more, but it's also nice to have fresh
  > workspaces for improving some custom menus'n'such.
  > 
  > I'm hopeful that having two game-modes to hack on will help me
  > think through a somewhat generic structure for managing these games.

- ([`791df5b8`](https://github.com/russmatney/dino/commit/791df5b8)) feat: make use of is_game_mode() flag

  > Adds the game_ent func, an sorts by it in dino menu.

- ([`8c18272e`](https://github.com/russmatney/dino/commit/8c18272e)) feat: first game_mode, drop a bunch of game singletons

  > Introduces a new concept, dino game modes. This is a sub-category of
  > DinoGameEntities right now.
  > 
  > Drops a bunch of unused game_singletons, and refactors Game.gd to create
  > a DinoGame on the fly when a singleton isn't specified. DinoGames still
  > use 'singleton'-like behavior via the Game.gd autoload.
  > 
  > Perhaps the Game.gd autoload should also go away or otherwise lose it's
  > state? Right now it'd be problemmatic to run two games at once. So far
  > it seems like the encounter/level refactor we're in will change the way
  > this works.

- ([`a0f49050`](https://github.com/russmatney/dino/commit/a0f49050)) misc: noisey logs, woods regen
- ([`75b5e7c0`](https://github.com/russmatney/dino/commit/75b5e7c0)) feat: drop super elevator level singleton and usage
- ([`b4f5ddfa`](https://github.com/russmatney/dino/commit/b4f5ddfa)) fix: calc room rect properly

  > Resolves a bug when adding border tiles - room rects were being calced
  > with tmap.get_used_rect(), which doesn't always cover the whole room.
  > Instead we build a rect for the room ourselves - note these are coord
  > Rect2i in tilemap space, not local Vector2 floats.

- ([`2e7fbe26`](https://github.com/russmatney/dino/commit/2e7fbe26)) fix: better behaving border_depth applied to TheWoods

  > Corrects some errors - this is actually simpler than I thought.

- ([`497774f3`](https://github.com/russmatney/dino/commit/497774f3)) feat: cleaner border extension impl, includes corners

  > Rather than calc these in a loop, we establish the level corners and
  > border corners, then fill in 4 rects based on those.
  > 
  > Still leaves gaps between the used_rect() rect and inner tile rooms. I
  > wonder if there's a clean way to fill those...

- ([`b3cf73da`](https://github.com/russmatney/dino/commit/b3cf73da)) feat: brick supporting basic extended borders

  > Still need to fill in internal gaps and corners, but this works for
  > one-room levels.

- ([`d3c011f2`](https://github.com/russmatney/dino/commit/d3c011f2)) chore: misc level default regens.
- ([`865a7d25`](https://github.com/russmatney/dino/commit/865a7d25)) feat: basic super elevator level gen via brick

  > Working pretty well, tho the tilesets are the cave theme for now. will
  > need to improve the art to be more elevator-y.


### 3 Nov 2023

- ([`ed2c3dc4`](https://github.com/russmatney/dino/commit/ed2c3dc4)) chore: disable a few games

  > disables mountain, ghost house, and dungeon crawler.
  > 
  > Not much to do with these at the moment - will return when things are
  > more clear/farther along, maybe to create some villages/npcs.

- ([`a8b4f5c9`](https://github.com/russmatney/dino/commit/a8b4f5c9)) feat: load level-gen games via first-level entity param

  > Adds a new property to the DinoGameEntity: 'first_level'. If set, the
  > default DinoGame.start() impl will load it via Nav.nav_to(). start() can
  > be overwritten, but the trend right now is towards completely dropping
  > the game singletons, and putting game specific logic into these
  > first_level scenes.
  > 
  > This updates dino to make all the existing level-gen implementations
  > playable! Check out VoidSpike, Shirt, TowerJet, Gunner, Harvey, Herd,
  > Pluggs, and TheWoods for new Brick/levelscript generated levels.
  > Hopefully soon these will have a 'treadmill' (for basic regenerating
  > when the win condition is reached) and options configurable via the
  > pause menu.

- ([`1a11de83`](https://github.com/russmatney/dino/commit/1a11de83)) test: disable too-broad tests and orphan reporting

  > Dropping these for the moment to get another build deployed.

- ([`a61278ed`](https://github.com/russmatney/dino/commit/a61278ed)) feat: get most tests passing again
- ([`8d77ad19`](https://github.com/russmatney/dino/commit/8d77ad19)) feat: spike levelgen impl working, including top/bottom portal

  > Kind of a hack, but these are the escape hatches i want to support.
  > 
  > Could refactor towards a simpler api, something that automagically
  > reparents/rearranges cross-dep entities like this. But, realizing that
  > this feature could be impled via the roombox makes me wonder if it's
  > better to keep things simple - i.e. find some other way to express it.
  > we'll see how it goes as we add more use-cases - a simple 'setup' called
  > on the final generated output might be a better/simpler place to do some
  > of this work, tho right now we're benefiting from letting the rooms do
  > the positioning work.

- ([`6ea28d5a`](https://github.com/russmatney/dino/commit/6ea28d5a)) wip: tilemap -> entity and a more complex case in spike

  > A wip towards supporting a few more options, in this case getting an
  > area2d from a tilemap and an entity, then moving them both under an
  > arbitrary instance.

- ([`f61f9f1d`](https://github.com/russmatney/dino/commit/f61f9f1d)) feat: generating a basic void spike level via BrickLevelGen

  > Extends the one-way platform to be resizable (and preserve that width
  > via an @export).
  > 
  > Some other adjustments to make this work, including dropping the
  > Metro-spike impl. Maybe Metro could be stripped down to support
  > fast-travel (nav/menus) and mini-maps? That'd fit it's name better.


### 2 Nov 2023

- ([`0764257e`](https://github.com/russmatney/dino/commit/0764257e)) fix: drop this tool script debugging code
- ([`a1617cdf`](https://github.com/russmatney/dino/commit/a1617cdf)) misc: some latest level gens for gunner, harvey, tower
- ([`ffcb5c62`](https://github.com/russmatney/dino/commit/ffcb5c62)) feat: herd generating levels via BrickLevelGen

  > A bit more involved - had to develop a quick method for generating the
  > FetchSheepQuest and it's required area2d on the fly - this does so by
  > setting a group on the generated 'Pen' tilemap and using that to derive
  > an area2d, and adding the quest after the fact in HerdLevel.gd

- ([`92eea209`](https://github.com/russmatney/dino/commit/92eea209)) feat: support similar 'setup' style on brickLevel tilemaps

  > In this case, adding a tilemap to a group.

- ([`84913710`](https://github.com/russmatney/dino/commit/84913710)) feat: naive tilemap -> area2d helper

  > This will need to get much more nuanced, but it covers a useful enough
  > case (basic rectangles) to be impled for now.

- ([`ccf8564b`](https://github.com/russmatney/dino/commit/ccf8564b)) fix: enemy robots taking hits again

  > No longer invincible!

- ([`13d960d2`](https://github.com/russmatney/dino/commit/13d960d2)) feat: levelGen generating tower jet levels

  > Pretty cool! This is finally becoming what i wanted this game to be,
  > short of a heck-ton of polish.

- ([`a3108fd6`](https://github.com/russmatney/dino/commit/a3108fd6)) feat: support show-color-rect

  > This is quite useful for debugging - being able to see the rect each
  > room is responsible for.

- ([`5aaa5a68`](https://github.com/russmatney/dino/commit/5aaa5a68)) wip: cam_window_rect() not crashing

  > The offscreen-indicators use this, and it doesn't appear to be working
  > anymore. No longer crashing the game tho, so that's good.

- ([`df10edfd`](https://github.com/russmatney/dino/commit/df10edfd)) feat: basic gunner level gen and rooms

  > Gunner still crashing, but it's fun to be doodling more levels this way.

- ([`d6911b9d`](https://github.com/russmatney/dino/commit/d6911b9d)) feat: add some harvey levels, adjust box layouts

  > For these grid-based levels, rather than push every entity down to the
  > bottom of it's coord, we expect to align 0,0 on an entity with the
  > grid's coord (top-left). Further adjustments can happy per entity in a
  > passed setup(ent) helper. The baked-in helper made sense in a platformer
  > context, but not a top-down one.
  > 
  > Another adjustment is making seedboxes accessible from all sides, which
  > makes more top-down sense, and avoids the rotation complexity that the
  > delivery boxes took on.

- ([`9969420d`](https://github.com/russmatney/dino/commit/9969420d)) fix: resize seed/delivery boxes, set harvey player scene

  > Very pleased to find that entity 'setup' was already implemented! I
  > threw it in when writing that function out (but then forgot), and then
  > opted into the same api when drafting harvey's levelgen this morning.
  > Worked perfectly!

- ([`c6d531a0`](https://github.com/russmatney/dino/commit/c6d531a0)) feat: basic harvey level gen

  > Pretty quick to get this started! Bunch of clean up/sizing/etc to work out.


### 1 Nov 2023

- ([`80d47d85`](https://github.com/russmatney/dino/commit/80d47d85)) feat: support gems in shirtlevelgen

  > Also removes shirt's 'metro' treatment, b/c it was breaking the plain
  > shirt level. Ought to reformulate the metro approach - what are we
  > getting for it? (minimap/pause-map, pausing/hiding levels, room-corner
  > cameras... anything else?)

- ([`93557ba5`](https://github.com/russmatney/dino/commit/93557ba5)) feat: shirt consuming slimmer BrickLevelGen style

  > Removes the bit of shirtLevel that was transferring nodes to the scene -
  > BrickLevelGen handles this for us now, creating parent nodes if none
  > exist.
  > 
  > I hit a bad-address issue when coming back around to make this change,
  > but it was resolved after an editor restart.

- ([`9d3f993a`](https://github.com/russmatney/dino/commit/9d3f993a)) feat: pluggs consuming BrickLevelGen

  > BrickLevelGen now creates missing nodes for the parent, which is even
  > nicer. Drops pluggs's initial levelGen impl, expresses pluggs-y things
  > in PluggsLevelGen and PluggsLevel, which are happily separated.

- ([`5b18073a`](https://github.com/russmatney/dino/commit/5b18073a)) feat: drop woods WorldGen - now supported by BrickLevelGen

  > This earlier implementation is now expressed via BrickLevelGen,
  > WoodsLevelGen, and WoodsLevel.
  > 
  > Updates some tests per the BrickRoom multi-tilemap extension.

- ([`a9d867d8`](https://github.com/russmatney/dino/commit/a9d867d8)) feat: woods levels generating via BrickLevelGen

  > Not 100% about subclassing BrickLevelGen every time, but maybe it makes
  > alot of sense?
  > 
  > Starting to implement level logic, in this case just finding the last
  > room and connecting to it's signal.
  > 
  > Introduces roomboxes on Rooms, which requires even more assignment of
  > node children owners to keep (for the required collisionShape2Ds).
  > 
  > Extends BrickLevelGen to accept nodes for entities/rooms/tilemaps, to
  > DRY up the node handoff from gen to level. Could even create and add
  > these on the fly to the gen's parent or owner.

- ([`a1eb9ffc`](https://github.com/russmatney/dino/commit/a1eb9ffc)) feat: basic entities coverage for BrickLevelGen
- ([`77c69f5c`](https://github.com/russmatney/dino/commit/77c69f5c)) feat: basic tilemap test coverage for BrickLevelGen

  > adds the metal16 tiles as a fallback for unspecified label_to_tilemaps.
  > 
  > Merges the opts passed to BrickLevelGen.generate_level into each
  > room_opt, to support things like label_to_entity/label_to_tilemap being
  > passed one time.

- ([`36e01f9a`](https://github.com/russmatney/dino/commit/36e01f9a)) refactor: move much of BrickLevelGen to static funcs

  > Reaching for tests pushed me to want to just test the generate_level
  > func, rather than creating a node to test this on.

- ([`92474139`](https://github.com/russmatney/dino/commit/92474139)) feat: generating floor tiles under pits, entities

  > Coming together pretty well here!

- ([`7275258a`](https://github.com/russmatney/dino/commit/7275258a)) refactor: BrickRoom + LevelGen supporting multiple tilemaps

  > Moves from a passed tilemap_scene to a label_to_tilemap dict - this is a
  > map from the legend/label of the room_defs to an options dict for each
  > tilemap, supporting just `scene` and `add_borders` for now. To come:
  > extend-edges or some better named feat.

- ([`e1b115dd`](https://github.com/russmatney/dino/commit/e1b115dd)) refactor: move border tilemaps helpers to Reptile
- ([`7b40f039`](https://github.com/russmatney/dino/commit/7b40f039)) refactor: move Reptile from autoload to static class

  > Reptile was already stateless, no need for the autoload now that we have
  > static class funcs.

- ([`782e4048`](https://github.com/russmatney/dino/commit/782e4048)) chore: drop shirt/gen/LevelGen, emit seed, misc clean up

### 31 Oct 2023

- ([`38a10e17`](https://github.com/russmatney/dino/commit/38a10e17)) wip: debugging entity positioning issue

  > Entities are ending up at 0,0. not sure why yet, but i suspect it's
  > because the rooms and entities aren't added to the gen scene anymore, so
  > somehow the positions are being set and later propagated.

- ([`61c889ad`](https://github.com/russmatney/dino/commit/61c889ad)) refactor: break shirt-details into shirtlevelgen

  > BrickLevelGen more or less generic now! Could use a testing setup.

- ([`879494df`](https://github.com/russmatney/dino/commit/879494df)) refactor: cleaning up BrickLevelGen impl

  > Cutting out intermediary nodes, removing run-timey features that will
  > now live in the parent node.

- ([`24732259`](https://github.com/russmatney/dino/commit/24732259)) wip: ShirtLevelGen as ShirtLevel child, promoting nodes

  > Rough working impl of a level generator as a child node to a
  > level-script/encounter parent node.

- ([`9e67648e`](https://github.com/russmatney/dino/commit/9e67648e)) wip: towards a DRY BrickLevelGen impl

  > Not sure yet if this should be inherited or just static funcs, like
  > BrickRoom.

- ([`8b1fd4c4`](https://github.com/russmatney/dino/commit/8b1fd4c4)) refactor: move BrickRoom impl back to static funcs

  > The create_room shift to room.gen() was to allow modifications via
  > inheritance and subclass function overwrites - instead BrickRooms should
  > be pretty much throw-away/transient - pass in opts and generate the
  > tilemaps and entities, then promote them to the level nodes and maybe
  > finally drop some area2ds for convenience.

- ([`c55ebe10`](https://github.com/russmatney/dino/commit/c55ebe10)) feat: much cleaner border add

  > Uncomplicates the matching-wall-deletion approach, instead opting only
  > include border tiles that don't overlap an room's rect. A bit tricky
  > working with tilemap scaling here, but it works now... ought to get this
  > covered by tests.


### 30 Oct 2023

- ([`99056af6`](https://github.com/russmatney/dino/commit/99056af6)) fix: correct filter_rooms opts pass in woods test
- ([`9fac480d`](https://github.com/russmatney/dino/commit/9fac480d)) refactor: drop PluggsRoom completely

  > No need to inherit BrickRoom, instead we'll call out to it statically
  > and promote it's parts as needed.

- ([`737d9e43`](https://github.com/russmatney/dino/commit/737d9e43)) refactor: drop WoodsRoom completely

  > Moving away from inheriting BrickRoom, and using it as a completely
  > static class - modifications to it's internals should be passed in as
  > functions via BrickRoomOpts

- ([`604d947a`](https://github.com/russmatney/dino/commit/604d947a)) misc: run some level gen, add a big open room
- ([`6a18249b`](https://github.com/russmatney/dino/commit/6a18249b)) fix: insidious alignment bug after . = Empty change

  > Glad to find a test to reproduce this, it was very confusing.
  > 
  > Moving from '.' always setting null in the shape to setting whatever the
  > legend says it is (Floor, in this case) probably created a few other
  > bugs as well.

- ([`4f36ec3f`](https://github.com/russmatney/dino/commit/4f36ec3f)) fix: pretty printer cut-off b/c arrays/etc are not 'valid'

  > Had to get more specific with this safety check.

- ([`a9f80a9f`](https://github.com/russmatney/dino/commit/a9f80a9f)) chore: test and misc fixes

  > Chasing a bug - unfortunately this test repro passed. along the way i
  > realized my pretty printer's colors aren't working, wonder when that
  > broke.

- ([`56260f39`](https://github.com/russmatney/dino/commit/56260f39)) feat: add borders per-room, drop conflicting borders

  > An attempt at bordering on a per-room level. Not perfect, but working
  > pretty well. Could use some clean up - about to pull these levelGen bits
  > into some DRY and tested brick abstraction.

- ([`da1f6d08`](https://github.com/russmatney/dino/commit/da1f6d08)) refactor: remove hard-coded '.' -> null in parser

  > Instead, we support returning '.' as whatever the legend says it is, or
  > null if there is nothing matching in the legend. Note that other
  > characters without match in the legend will be passed through, so still
  > a bit of hard-coding for '.' in that case.

- ([`bb2f75e7`](https://github.com/russmatney/dino/commit/bb2f75e7)) wip: wrap_tilemap impl adds a tiled border

  > A simple used_rect() -> border tile implementation. Leaves gaps where
  > there are no rooms, but maybe we can just fill those in?

- ([`76eb5c31`](https://github.com/russmatney/dino/commit/76eb5c31)) fix: shirt gen - skip 'first' room after first
- ([`55ffde2c`](https://github.com/russmatney/dino/commit/55ffde2c)) feat: promoting entities to the rooms node

  > Getting ever closer to the scene tree structure we should have -
  > should probably be putting these on an entities node rather than the
  > rooms one, but i'm not sure of the implications yet.

- ([`2d8d2322`](https://github.com/russmatney/dino/commit/2d8d2322)) fix: drop room_base_dim variable

  > This was dropped from the algorithm in favor of tile_size.

- ([`65e6283e`](https://github.com/russmatney/dino/commit/65e6283e)) fix: don't set tree root as current_scene

  > Finally learned how to read this error - I was setting the root as the
  > current_scene, which is a no-no. For now returns to the previous
  > algorithm, setting the root's last child as the current_scene, which
  > should generally be right? Hopefully this removes another error failing
  > the start-every-game test.

- ([`663d48b7`](https://github.com/russmatney/dino/commit/663d48b7)) misc: flip the default on playerspawnpoints

  > Plus a generated shirt level in our newest LevelGen

- ([`446059bb`](https://github.com/russmatney/dino/commit/446059bb)) feat: now adding player + enemies

  > Not too bad! Didn't even need to subclass BrickRoom here, which I'm
  > thinking is a bad pattern. Not sure if BrickRoom should even have an
  > instance... vs just creating and passing along node2ds or some
  > non-specific thing. It's really about the tiles and entities - the tiles
  > are being promoted to the level, and the entities probably should be as
  > well.

- ([`0844f37b`](https://github.com/russmatney/dino/commit/0844f37b)) wip: doodling some connected top-down rooms

  > Boilerplate for a new LevelGen - slated next for the Bricks testing and
  > DRY up, but towards generating some shirt-levels first.


### 29 Oct 2023

- ([`e37d6210`](https://github.com/russmatney/dino/commit/e37d6210)) feat: test coverage for adding an aligned room in any direction

  > Quick impl - not too dry, but decently tested.

- ([`5c5d4e53`](https://github.com/russmatney/dino/commit/5c5d4e53)) feat: create BrickRoomOpts, swaps in for opts Dictionary

  > Perhaps this is more maintainable. I'm reluctant but i'll try it.

- ([`b4257956`](https://github.com/russmatney/dino/commit/b4257956)) chore: misc woods/pluggs room regens
- ([`a576d324`](https://github.com/russmatney/dino/commit/a576d324)) feat: adding room above last room

  > Basic version of adding a room above the last one. Probably not quite
  > the right api yet - this supports passing a side to add the next room
  > too, but we might want to search the room options for one that fit the
  > last room's open sides, and start getting into rotating the rooms.

- ([`7dbe5d78`](https://github.com/russmatney/dino/commit/7dbe5d78)) fix: restore woods_room tests

  > Updates some positions/sizes in test assertions after
  > woods<>pluggs<>brick refactor.
  > 
  > The woods implementation changed from using base_dim_size and room-type
  > based positioning to matching last/next floor tiles up (and using
  > opts.tile_size, which defaults to 16).

- ([`f4761c93`](https://github.com/russmatney/dino/commit/f4761c93)) feat: restore tiles on wall woods rooms

  > The next-room algo now supports aligning last/next room floor tiles, so
  > we can have ceilings again.

- ([`dc6e5e12`](https://github.com/russmatney/dino/commit/dc6e5e12)) feat: next_room_position smarter offset handling

  > Now aligning rooms with closed tops as well.
  > 
  > This concept should be applicable to topdown rooms as well, once we get
  > to placing rooms against more than just one wall.

- ([`b5c016d5`](https://github.com/russmatney/dino/commit/b5c016d5)) fix: apparently fix camera issue?

  > I don't think I actually fixed this, but the tests are passing now.

- ([`918d8e26`](https://github.com/russmatney/dino/commit/918d8e26)) chore: noisey invalid uid nonsense

  > These seem to happen as i move between machines, but i might just be
  > suspicious of that.

- ([`3bf79e1d`](https://github.com/russmatney/dino/commit/3bf79e1d)) wip: rename ensure_camera -> request_camera, testing boilerplate

### 28 Oct 2023

- ([`b73a3612`](https://github.com/russmatney/dino/commit/b73a3612)) wip: adjust fall rooms to fix woods worldgen

  > Instead we should improve the algorithm to find the 'middle' of the wall
  > - in this case it's getting stuck at the top of the room, which should
  > never happen.

- ([`4df82ae6`](https://github.com/russmatney/dino/commit/4df82ae6)) fix: tidys some pretty printer/misc details
- ([`660f3333`](https://github.com/russmatney/dino/commit/660f3333)) fix: select a random room for the middle-ones

  > This got dropped when moving WoodsRoom to inherit BrickRoom.

- ([`75a442ee`](https://github.com/russmatney/dino/commit/75a442ee)) fix: correct inverted flags/skip_flags

  > ... should probably have a test that catches this?

- ([`83f9ef3a`](https://github.com/russmatney/dino/commit/83f9ef3a)) wip: porting woods level gen to use BrickRoom

  > Tests nearly back, but for the dimensional changes.

- ([`fd0b0ac7`](https://github.com/russmatney/dino/commit/fd0b0ac7)) feat: debug.to_pretty duck-typing

  > Extends new types to use the pretty printer.

- ([`43344cb8`](https://github.com/russmatney/dino/commit/43344cb8)) feat: introduce BrickRoom, which takes on generic PluggsRoom code

  > Extracts the per-game/encounter stuff, like label->entity and tilemap
  > scene. Some trouble with static vs dynamic constructors - should
  > probably figure out what's going on with that.

- ([`87c0b78a`](https://github.com/russmatney/dino/commit/87c0b78a)) refactor: move some PluggsRoom helpers to RoomDef
- ([`d5b0cb88`](https://github.com/russmatney/dino/commit/d5b0cb88)) fix: fix flaky test

  > Hopefully this actually fixed and not just random now

- ([`1760c32d`](https://github.com/russmatney/dino/commit/1760c32d)) refactor: pluggs,woodsRoom building via RoomDefs and RoomDef

  > Refactors and restores pluggs_room_ and woods_room_tests, now in terms
  > of two classes.
  > 
  > Still lots of `.shape` being exposed, but this will be easier to
  > abstract into one of these classes now.

- ([`78f5436b`](https://github.com/russmatney/dino/commit/78f5436b)) feat: RoomParser.parse() returning RoomDefs

  > Moving to some classes and more structure for this data. Expecting a
  > bunch of helpers to become RoomDefs/RoomDef methods, and probably to add
  > some structure to the 'opts' - i'd love a reasonable constructor syntax
  > for these objects... will probably write a from_opts(Dictionary) api for
  > things.

- ([`f2517a48`](https://github.com/russmatney/dino/commit/f2517a48)) wip: starting in on BrickRoom, RoomDef impl + tests
- ([`50f47c68`](https://github.com/russmatney/dino/commit/50f47c68)) assets: adds some doodles to the splash image
- ([`312f0bb5`](https://github.com/russmatney/dino/commit/312f0bb5)) addon: brick -> provider of level-based proc-gen

  > Introduces a new addon called 'brick'. Really just looking for a place
  > to put this RoomDef and RoomParser, as well as trying to get a stronger
  > metaphor under the Encounter and LevelGen concepts. Maybe this could end
  > up eating Metro, or providing MetroRoom-like features.


### 27 Oct 2023

- ([`4695f847`](https://github.com/russmatney/dino/commit/4695f847)) refactor: rewrite gut tests as gdunit tests
- ([`35948bd1`](https://github.com/russmatney/dino/commit/35948bd1)) fix: restore woods room tests, port pluggs room tests
- ([`20124ede`](https://github.com/russmatney/dino/commit/20124ede)) chore: drop more gut stuff
- ([`a235811f`](https://github.com/russmatney/dino/commit/a235811f)) ci: tests officially failing (successfully!)
- ([`b0b141e5`](https://github.com/russmatney/dino/commit/b0b141e5)) fix: force 0 exit code on project load/scan
- ([`297edaf8`](https://github.com/russmatney/dino/commit/297edaf8)) refactor: move to running gdunit tests in CI
- ([`b39df1ba`](https://github.com/russmatney/dino/commit/b39df1ba)) feat: rewrite bb test, remove old commands
- ([`e6745fda`](https://github.com/russmatney/dino/commit/e6745fda)) chore: drop addons/gut

  > Also drops some gut config files, and some old inkgd stuff

- ([`2b26063c`](https://github.com/russmatney/dino/commit/2b26063c)) chore: simplify test structure

  > moves the tests from unit/integration and addon/src dirs into just test/.


### 26 Oct 2023

- ([`df70a0fe`](https://github.com/russmatney/dino/commit/df70a0fe)) feat: finish rewrite woods_room_test in gdunit

  > Happily, these fail when the code running in the test has a runtime
  > error. yay test suite! Now to rewrite the rest and drop gut.

- ([`d578e6a1`](https://github.com/russmatney/dino/commit/d578e6a1)) dep: add gdunit4, wip port of woods_room_test

  > Confirms that tests fail when a script error occurs. woo!

- ([`6175261d`](https://github.com/russmatney/dino/commit/6175261d)) fix: some tests fixed, about to move to gdunit

  > Just found gut doesn't fail tests when gdscript throws errors, which is
  > too dang bad. More digging reveals it's a hot topic, an gdscript doesn't
  > really have exceptions. So that's interesting.

- ([`cbdd9e4e`](https://github.com/russmatney/dino/commit/cbdd9e4e)) feat: explicit seed handling in pluggs level gen
- ([`19288929`](https://github.com/russmatney/dino/commit/19288929)) refactor: use navi wrapper instead of accessing navi.current_scene

  > The navi.current_scene usage is a bit fragile, so we prefer to call
  > funcs instead of depend on this var (which may not be set.)

- ([`dbe4a965`](https://github.com/russmatney/dino/commit/dbe4a965)) feat: plug into arcade machine to reboot the world

  > A level-gen treadmill - can now connect to arcade machines to re-run the
  > level gen (or bubble up other events).
  > 
  > Not too sure on this double signal emit (machine to room, room to level
  > gen). Maybe this should be the message bus pattern?
  > 
  > Also fixes a bug in navi when no current_scene is set. Should be fine?
  > Required for deving, ever since the current_scene doesn't get auto-set
  > anymore.
  > 
  > Adds a basic HUD to pluggs.

- ([`5c805d3f`](https://github.com/russmatney/dino/commit/5c805d3f)) feat: level gen using flags/skip_flags to pick rooms

  > Seems simple, maybe it'll scale?
  > 
  > Also adds player spawn points to 'p' tiles.

- ([`08ef8d72`](https://github.com/russmatney/dino/commit/08ef8d72)) feat: add dino boot splash
- ([`e21780e1`](https://github.com/russmatney/dino/commit/e21780e1)) fix: remove overlapping joypad action

  > Removes 'restart' on Y, which was overlapping with 'action', making
  > pluggs unplayable via controller in the regen room.


### 25 Oct 2023

- ([`9d23b6cb`](https://github.com/russmatney/dino/commit/9d23b6cb)) feat: add light occluders to metal tiles
- ([`eca0743a`](https://github.com/russmatney/dino/commit/eca0743a)) feat: point to levelGen for playable pluggs scene
- ([`1773d0df`](https://github.com/russmatney/dino/commit/1773d0df)) feat: larger and smoother lights

  > Adds a big dithered light to the arcade machine, and a larger and
  > smoother light to the usuals.

- ([`d369e48f`](https://github.com/russmatney/dino/commit/d369e48f)) feat: level gen adding arcade machines
- ([`aaca2c45`](https://github.com/russmatney/dino/commit/aaca2c45)) feat: basic ArcadeMachine turning on/off via socket

  > Pretty simple!

- ([`f8ddb5e9`](https://github.com/russmatney/dino/commit/f8ddb5e9)) feat: arcade machine art
- ([`33f6910a`](https://github.com/russmatney/dino/commit/33f6910a)) fix: update godot version number in itch deploys
- ([`d4f94e6c`](https://github.com/russmatney/dino/commit/d4f94e6c)) ci: deploy to steam/itch from 'edge' and 'prod' branches

  > Will come back to deploying only some tags at some point - hoping this
  > lets me keep working on main with some more git-based deploy control.

- ([`b66488b4`](https://github.com/russmatney/dino/commit/b66488b4)) chore: delete rest of the TODOs

  > Drops the rest of the codebase's TODOs. Here's to making them more useful!

- ([`4bcb0dee`](https://github.com/russmatney/dino/commit/4bcb0dee)) chore: deleting TODOs

  > A clean up task - calling TODO bankruptcy, removing most/all. They are
  > generally quite old and asking for things that could be added, but we
  > can make TODOs useful as well and have feature-wishlists elsewhere.

- ([`ab633e0e`](https://github.com/russmatney/dino/commit/ab633e0e)) feat: expand watch command to whole directory

  > After much wrestling with watching all the asset/ dirs, watching just
  > the root and filtering on extension ends up being much simpler and
  > actually working. Plus it's probably more flexible for some other watch
  > tasks, (maybe generating ids/entities on levelscript file changes?)

- ([`58106ed1`](https://github.com/russmatney/dino/commit/58106ed1)) feat: add quit-game button to pause menus

  > I suppose we could dry up these options, especially since they're mostly
  > point-free at this point.
  > 
  > We may want to hide this button on some platforms, maybe web? Not sure
  > what'll happen. Letting it go for now.

- ([`b31d9c65`](https://github.com/russmatney/dino/commit/b31d9c65)) fix: correct readme badge urls

### 24 Oct 2023

- ([`a91d88f3`](https://github.com/russmatney/dino/commit/a91d88f3)) feat: adding Lights to pluggs room gen

  > Impls add_entity for PluggsRoom.
  > 
  > Also introduces a RoomDef class, which should be incorporated into the
  > inevitable refactor.

- ([`a73f955c`](https://github.com/russmatney/dino/commit/a73f955c)) feat: alignment between rooms working

  > Plus a bunch more room defs.

- ([`0aa63a7c`](https://github.com/russmatney/dino/commit/0aa63a7c)) wip: towards aligning on last y pos
- ([`b685663f`](https://github.com/russmatney/dino/commit/b685663f)) fix: don't crash if room_defs ends with empty lines

  > Updates the puzz parser to drop blank lines before passing chunks to the
  > section parser.


### 23 Oct 2023

- ([`4a941629`](https://github.com/russmatney/dino/commit/4a941629)) feat: add credits and quit buttons to main menu
- ([`73473d65`](https://github.com/russmatney/dino/commit/73473d65)) feat: scroll controls during credits

  > Much nicer to wiz around these credits - could use some sticky headers
  > and things too.

- ([`d663604d`](https://github.com/russmatney/dino/commit/d663604d)) wip: some pandora tweaks to fix a release build

  > Not at all final changes to pandora, just something to get things
  > working. The compressed pandora export is failing with an unrecognized
  > ERR_FILE_UNRECOGNIZED (15), so this moves pandora to reading/writing the
  > non-compressed in debug and release, rather than just debug.

- ([`ce50cf81`](https://github.com/russmatney/dino/commit/ce50cf81)) tool: bb export command

### 18 Oct 2023

- ([`eba8601b`](https://github.com/russmatney/dino/commit/eba8601b)) wip: blerg ci still not configured correctly
- ([`8b17adb2`](https://github.com/russmatney/dino/commit/8b17adb2)) feat: update pluggs 'main' scene

  > Should probably incorporate this kind of data into the pandora entity as
  > well.

- ([`2193a92d`](https://github.com/russmatney/dino/commit/2193a92d)) feat: plugs 'unplugging' at a max length

  > it's kind of doing it!

- ([`7d514726`](https://github.com/russmatney/dino/commit/7d514726)) feat: drawing cord between socket and pluggs

  > And updating while pluggs moves around.

- ([`6517c296`](https://github.com/russmatney/dino/commit/6517c296)) feat: cord color changes based on length thresholds
- ([`f45b1b0e`](https://github.com/russmatney/dino/commit/f45b1b0e)) feat: lights lit by plugged sockets

  > Something starting to happen here.

- ([`12f0636a`](https://github.com/russmatney/dino/commit/12f0636a)) fix: woods room crash, disable some main-scene editor plugins
- ([`528fa97a`](https://github.com/russmatney/dino/commit/528fa97a)) feat: test for something-focused in main menu

  > Also drops the process/lazy game entries add, b/c it should not be
  > needed.

- ([`af5e931c`](https://github.com/russmatney/dino/commit/af5e931c)) fix: only run if the branch is tagged?
- ([`89e5b1c9`](https://github.com/russmatney/dino/commit/89e5b1c9)) fix: specify bash in run command

  > Apparently a shell syntax error returns a success message.

- ([`889580c3`](https://github.com/russmatney/dino/commit/889580c3)) ci: reuse GODOT_VERSION variable

  > Still hardcoded on a few image versions...

- ([`fe69b246`](https://github.com/russmatney/dino/commit/fe69b246)) ci: unfortunately this manual check seems necessary

  > I'm a bit annoyed I can't break up my test and deploy pipeline without
  > workarounds - feels like github actions should support connecting
  > workflows without needing to create a github app or adding a personal
  > token and using the github ci (and coupling the workflows).
  > 
  > Eh, i guess CI is always just workarounds.

- ([`6e7a8e21`](https://github.com/russmatney/dino/commit/6e7a8e21)) ci: another deploy attempt
- ([`e8b965a6`](https://github.com/russmatney/dino/commit/e8b965a6)) ci: force 0 exit on import task

  > Haven't gotten to the bottom of godot's crash-on-exit in dino yet, but
  > for now this _should_ be ok?

- ([`f2fc9602`](https://github.com/russmatney/dino/commit/f2fc9602)) fix: only run steam deploy when a tag matches the regex

  > Apparently tags is not a supportered workflow_run feature, but tags is
  > just a shorthand for branches with refs/tags/ prefix?


### 17 Oct 2023

- ([`fca90962`](https://github.com/russmatney/dino/commit/fca90962)) fix: force 0 exit after godot import
- ([`584cab48`](https://github.com/russmatney/dino/commit/584cab48)) chore: misc noise, trying to debug the import crash

  > Might just be a crash on exit after a 'successful' import...?

- ([`6b889f05`](https://github.com/russmatney/dino/commit/6b889f05)) feat: require git tag to run deploys

  > I might soften up on this regex a bit, but i think we'll want versions
  > sooner than later, and I definitely don't want to deploy every time the
  > tests pass.... not while the steam deploy sends me an automated email
  > every time, anyway.

- ([`533388c6`](https://github.com/russmatney/dino/commit/533388c6)) poc: login works a second time without pwd
- ([`a0938ced`](https://github.com/russmatney/dino/commit/a0938ced)) fix: different steamcmd login method
- ([`eb39bfb0`](https://github.com/russmatney/dino/commit/eb39bfb0)) fix: time_offset steam totp voodoo ?
- ([`72d0080e`](https://github.com/russmatney/dino/commit/72d0080e)) refactor: create local github action for steam_deploy.sh
- ([`949daf97`](https://github.com/russmatney/dino/commit/949daf97)) fix: disable godot build

  > just trying to see if this steam auth could work

- ([`ff61d04c`](https://github.com/russmatney/dino/commit/ff61d04c)) ci: deploy via steam?
- ([`929ddd18`](https://github.com/russmatney/dino/commit/929ddd18)) wip: towards steam deploys via ci

  > The included python script does not work - will need to find other some
  > 2fa workaround.


### 16 Oct 2023

- ([`fbaedb85`](https://github.com/russmatney/dino/commit/fbaedb85)) feat: readme linking to steam page

### 15 Oct 2023

- ([`fb559960`](https://github.com/russmatney/dino/commit/fb559960)) fix: pass correct option
- ([`dd62b56a`](https://github.com/russmatney/dino/commit/dd62b56a)) more levels
- ([`94cd2aad`](https://github.com/russmatney/dino/commit/94cd2aad)) feat: basic levelGen creating sequential PluggsRooms

  > Copy-pastas the worldGen from woods into a levelGen script and editor
  > node for generating and testing pluggs levels. Not too bad!

- ([`d6f6f994`](https://github.com/russmatney/dino/commit/d6f6f994)) feat: basic tilemap creation based on parsed room def

  > Will need to revisit the scaling shortly - how big should these rooms
  > be?

- ([`4945c3d3`](https://github.com/russmatney/dino/commit/4945c3d3)) feat: basic create_room with colorRect impl + tests

  > So far, coming out much cleaner than the WoodsRoom dive.

- ([`71ddf386`](https://github.com/russmatney/dino/commit/71ddf386)) feat: PluggsRoom gen_room_def impl and tests

  > Pulls the RoomParser and some of the WoodsRoom code into a shared Puzz
  > parser with test, then writes a basic func and unit test for a Pluggs
  > gen_room_def func.


### 14 Oct 2023

- ([`14d66b0b`](https://github.com/russmatney/dino/commit/14d66b0b)) feat: sockets that tossed plugs 'attach' to
- ([`ea92c0b2`](https://github.com/russmatney/dino/commit/ea92c0b2)) refactor: pull plug, cord into plug dir
- ([`7497de4a`](https://github.com/russmatney/dino/commit/7497de4a)) feat: random toss length, kill velocity when max reached

### 13 Oct 2023

- ([`2b8cdb58`](https://github.com/russmatney/dino/commit/2b8cdb58)) feat: drop from bucket, fade out cords/plugs
- ([`4c13bc1a`](https://github.com/russmatney/dino/commit/4c13bc1a)) fix: drop missing type?

  > Feels like a load order problem... anyway, knowing the class_name
  > doesn't matter much.

- ([`c9af42bf`](https://github.com/russmatney/dino/commit/c9af42bf)) misc: mac tres uid updates?

  > Not sure why switching machines requires a bunch of uids to be
  > regenerated.... are these things non-deterministic?

- ([`8367e50a`](https://github.com/russmatney/dino/commit/8367e50a)) feat: basic cord drawing and len calc
- ([`a4447962`](https://github.com/russmatney/dino/commit/a4447962)) feat: pluggs tossing basic plugs
- ([`47ce3336`](https://github.com/russmatney/dino/commit/47ce3336)) feat: pluggs jump/fall animations
- ([`832e2ab1`](https://github.com/russmatney/dino/commit/832e2ab1)) fix: move some things off of Navi.current_scene

  > Navi.current_scene does not get set for the first scene anymore. This
  > should probably be restored, but now that I know more about the
  > sceneTree.current_scene api, it feels fine to use it directly,
  > especially if it means fewer cross addon dependencies.

- ([`55b2e0f6`](https://github.com/russmatney/dino/commit/55b2e0f6)) feat: pluggs favoring bucket state

  > Rather than defaulting to standing, we move to the bucket pretty quickly
  > when idle, requiring the player to press 'up' to stand and start
  > 'running'.

- ([`61e94862`](https://github.com/russmatney/dino/commit/61e94862)) misc: fix some script errors, misc import updates

  > Hopefully these aespritewizard fixes aren't actually necessary...

- ([`55091fcc`](https://github.com/russmatney/dino/commit/55091fcc)) wip: basic EditorResourcePicker working for noop aseprite imports

  > Adds an EditorResourcePicker and specifies PackedDataContainer, which
  > is the type used by the new noop Aseprite Importer.
  > 
  > Connects the Picker's changed signal to a function that pulls the
  > resource's path and pushes it through the existing pipeline via
  > _set_source(path) and _save_config().
  > 
  > Unfortunately the picker does not show the selected resource - I'm not
  > sure why - maybe it's the resource, maybe the picker doesn't support any
  > display on its own? For now, leaves the 'button' showing the path in
  > place so it's clear what file was selected.

- ([`3f48f7c1`](https://github.com/russmatney/dino/commit/3f48f7c1)) deps: update AsepriteWizard to noop importer branch

  > Plus reimport all aseprite files


### 12 Oct 2023

- ([`bfa659e2`](https://github.com/russmatney/dino/commit/bfa659e2)) fix: free first_scene if it's the configged main_scene

  > Also, don't set current_scene at startup - may need to revisit this, but
  > it seems work fine for now. Likely we'll want a splash or loading screen
  > as the proper first scene at some point.

- ([`45d2aec3`](https://github.com/russmatney/dino/commit/45d2aec3)) chore: bunch more steam branding images
- ([`d0bfe1c1`](https://github.com/russmatney/dino/commit/d0bfe1c1)) chore: empty brand asset templates for dino

  > Including initial header and small capsule images


### 11 Oct 2023

- ([`d6281154`](https://github.com/russmatney/dino/commit/d6281154)) fix: don't drop the last autoload when changing scenes

  > navi was dumping the current_scene when navigating, which in some
  > cases (like testing) ends up being the last autoload, which causes weird
  > errors when a random autoload has been freed.
  > 
  > This isn't a great fix, just not-freeing whatever the first scene is...
  > probably will have other implications...
  > 
  > well, good luck out there lil codes!

- ([`4d24d0ac`](https://github.com/russmatney/dino/commit/4d24d0ac)) refactor: remove herd autoload

  > Bit of duplication on level retry logic'n'such here. Probably a static
  > method on the HerdLevel makes more sense.

- ([`1aa902c0`](https://github.com/russmatney/dino/commit/1aa902c0)) fix: misc test failures

  > Starting to find more bugs as these tests grow - managing several games
  > swapping in and out...

- ([`66b875dd`](https://github.com/russmatney/dino/commit/66b875dd)) refactor: drop snake autoload

  > Snake doesn't currently advance to the next level .... but that's not
  > the only thing that's wrong with it.

- ([`19185144`](https://github.com/russmatney/dino/commit/19185144)) refactor: remove spike autoload

  > Removes spike as an autoload, moving most of it's usage to a SpikeData
  > object.

- ([`fd6385da`](https://github.com/russmatney/dino/commit/fd6385da)) refactor: remove ghosts autoload

  > Ran into a confusing bug when the player was getting spawned on the menu
  > scene - small tweak to the should_spawn_player fixed it, but dang if
  > that's not annoying. Could use a test.

- ([`ea8487d6`](https://github.com/russmatney/dino/commit/ea8487d6)) refactor: remove harvey autoload

  > Harvey's autoload logic was mostly level logic, so we move things into a
  > new HarveyLevel.gd, which should be roughly generic.

- ([`3438450b`](https://github.com/russmatney/dino/commit/3438450b)) refactor: remove dothop autoload

  > Moves dothop data/constants to a DHData class, moves build_puzzle_node
  > to a static func on DotHopPuzzle.
  > 
  > Removes restart_game(game) var - games are set as current via
  > Game.launch(game_entity) (or by calling ensure_current_game() after a
  > game-owned-scene has loaded, to support dev).

- ([`1669c373`](https://github.com/russmatney/dino/commit/1669c373)) feat: dinogame cleanup and all-games-start test

  > Adds a test that starts every game - useful as a broad test to be sure
  > there are no fatal crashes at launch time.
  > 
  > Also cleans up the Game.gd implementation, introducing a new cleanup
  > function to be called when a new game is registered - the old game needs
  > to clean up some menus and other things. I'd like to completely free the
  > current_game node, but this ends up breaking without more handling for
  > autoloads/singletons. more to come!

- ([`743a7440`](https://github.com/russmatney/dino/commit/743a7440)) chore: assets diaspora

  > games and addons now have their own assets dirs, rather than a big
  > shared assets/sprites dir in dino. This should make it simpler to
  > selectively bundle games.
  > 
  > Note there are still plenty of cross-game dependencies at the moment!


### 10 Oct 2023

- ([`a7a5484a`](https://github.com/russmatney/dino/commit/a7a5484a)) feat: pluggs jump/fall states

  > Pulls logic from ssbody/player to impl a flexible jump in pluggs' state
  > machine.

- ([`ca113821`](https://github.com/russmatney/dino/commit/ca113821)) misc: rearranging pluggs state machine, cleaning up code
- ([`33c6023a`](https://github.com/russmatney/dino/commit/33c6023a)) feat: pluggs game icon, refactored animation asset

  > Updates the asset and code to use asepriteWizard for the pluggs anims.

- ([`8c2c3a9d`](https://github.com/russmatney/dino/commit/8c2c3a9d)) feat: pluggs main/pause menus, dino game+entity impl

  > Pluggs can now be launched from the dino main menu. huzzah!


### 9 Oct 2023

- ([`190ae3cf`](https://github.com/russmatney/dino/commit/190ae3cf)) refactor: restore some elevators in demoland

  > A new metro-travel-point system, via pandora entities. Cleaner (no more
  > custom travel point registry and custom destination code). Removes the
  > need to load zones with elevators at editor/tool-script time. Now we
  > just assign a destination travel-point entity. The overhead is moved to
  > creating and managing the pandora entities, which should have other
  > benefits. (simple custom destination name, etc).
  > 
  > The rest of the metro-based games are currently broken! Nice to remove
  > some game.register() code.

- ([`62676800`](https://github.com/russmatney/dino/commit/62676800)) refactor: Hotel now only works with nodes

  > No more packed_scene or scene_file_path -> data nonsense. Just nodes.
  > 
  > Travel/Elevators will be refactored to reference pandora entities.

- ([`cb6f1b1c`](https://github.com/russmatney/dino/commit/cb6f1b1c)) fix: minimap crash

  > Metro travel is currently broken b/c of hotel changes.

- ([`00e54f25`](https://github.com/russmatney/dino/commit/00e54f25)) chore: remove more noisy logs

  > Maybe we care about these? Hotel needs a delete + rewrite, but it's tied
  > to a bunch of things rn. hmmm...

- ([`b755add0`](https://github.com/russmatney/dino/commit/b755add0)) fix: book hotel nodes without scene_file_paths
- ([`ef5d0138`](https://github.com/russmatney/dino/commit/ef5d0138)) chore: bunch of imports/misc tscn churn
- ([`4124a375`](https://github.com/russmatney/dino/commit/4124a375)) chore: update to pandora latest
- ([`e98642f4`](https://github.com/russmatney/dino/commit/e98642f4)) chore: more queue_free()

  > Towards cutting down on leaked instances and orphans.

- ([`09ed59b9`](https://github.com/russmatney/dino/commit/09ed59b9)) chore: drop noisy logs
- ([`26a823a7`](https://github.com/russmatney/dino/commit/26a823a7)) fix: ensure_hud was keeping any existing hud

  > Updates ensure_hud to compare resource paths to be sure the new one gets
  > used.
  > 
  > Fixes hanging tests.
  > 
  > Also removes a few more orphans.

- ([`def7031a`](https://github.com/russmatney/dino/commit/def7031a)) chore: drop bulletUpHell

  > I'm not really using this, so am dropping it for now.

- ([`64a2fa5e`](https://github.com/russmatney/dino/commit/64a2fa5e)) ci: set timeout on test runner

  > The tests failed 6 hours after starting yesterday. The tests are indeed
  > hanging, but 6 hours is not something I'd like to default to. This sets
  > a shorter time limit on the test run so it gets killed after 10 minutes.


### 8 Oct 2023

- ([`8d919d90`](https://github.com/russmatney/dino/commit/8d919d90)) wip: work around to try to get the menu working

  > Not sure if this is necessary or if there's some kind of race case. More
  > likely this is a production vs debug build problem.

- ([`001ed5d4`](https://github.com/russmatney/dino/commit/001ed5d4)) wip: rough restart level upon reaching end
- ([`b78ad280`](https://github.com/russmatney/dino/commit/b78ad280)) feat: end rooms detecting player entrance
- ([`aac9df7a`](https://github.com/russmatney/dino/commit/aac9df7a)) feat: basic woods main/pause menus, start() impl

  > Just runs the worldgen scene for now, which can be regened on the fly
  > via shift-r

- ([`5481991c`](https://github.com/russmatney/dino/commit/5481991c)) feat: leaves basically collectible
- ([`f2c09c27`](https://github.com/russmatney/dino/commit/f2c09c27)) feat: basic hud/anim for player
- ([`bc3f26b5`](https://github.com/russmatney/dino/commit/bc3f26b5)) feat: basic woods player, clean up a bunch of startup logs

  > Fewer logs for misc things starting up. Basic player inheriting from
  > SSPlayer n such.

- ([`1bf00aeb`](https://github.com/russmatney/dino/commit/1bf00aeb)) refactor: remove some game autoloads

  > Trying to move to an as-needed load approach, rather than autoloading
  > per-game. moving game data to pandora entities takes care of most
  > issues, but there are a few use-cases left: autoloads for useful
  > enums/data gen, autoloads for next_level/load-area()-like functionality, and a few
  > stateful things like huds that should go through something like hotel.

- ([`04be77b5`](https://github.com/russmatney/dino/commit/04be77b5)) chore: move player_scene to dinogameentity

  > Removes player_scene code from game autoloads.
  > 
  > Also fixes a bug when current_game fails to get updated after playing
  > one.

- ([`031abd04`](https://github.com/russmatney/dino/commit/031abd04)) chore: drop all menu registry

  > This is all handled via dinoGameEntities and game.gd now - no need for
  > manual menu registry.

- ([`7f9011ef`](https://github.com/russmatney/dino/commit/7f9011ef)) chore: drop manages_scene from dinogame

  > Also removes HatBot and Shirt autoloads! Now for the rest of yuhs.

- ([`e53fb949`](https://github.com/russmatney/dino/commit/e53fb949)) wip: more game vs dinoGame vs dinoGameEntity work

  > Removes the need for dinoGames to register via Game.games, using
  > dinoGameEntities for support. Starts to remove the need for games as
  > autoloads, with HatBot and Shirt as the first examples. Pulls
  > manages_scene into dinoGameEntity via a prefix property.

- ([`68960120`](https://github.com/russmatney/dino/commit/68960120)) feat: leaf entities spawning in position

  > not super clean, but at least working.


### 7 Oct 2023

- ([`d188f868`](https://github.com/russmatney/dino/commit/d188f868)) wip: trying and failing to get leaves rendering

  > Probably something annoying... anyway, this api is not clear - need to
  > review and refactor all of this

- ([`f325ef13`](https://github.com/russmatney/dino/commit/f325ef13)) wip: not done, but maybe a thing of beauty?

  > possibly spawning leaves, but untested. Adds scripts for spawn points,
  > introduces a woodsEntity class, and impls a leafEntity mostly based on
  > dothop's leaf impl. Also a once-over of the the current room designs.

- ([`0a53d746`](https://github.com/russmatney/dino/commit/0a53d746)) chore: hide room color rects by default
- ([`ebb9bce6`](https://github.com/russmatney/dino/commit/ebb9bce6)) feat: darker woods tiles, add color rect background and directional light
- ([`88762d9c`](https://github.com/russmatney/dino/commit/88762d9c)) feat: worldgen promoting/merging room tilemaps

  > Now creating a single tilemap, so the terrains are continuous.


### 6 Oct 2023

- ([`daf1d958`](https://github.com/russmatney/dino/commit/daf1d958)) wip: closer but not quite merging tilemaps correctly
- ([`aabc3ca1`](https://github.com/russmatney/dino/commit/aabc3ca1)) wip: merging/promoting room tilemaps (not working!)
- ([`7a3b7bed`](https://github.com/russmatney/dino/commit/7a3b7bed)) chore: quick filler tiles surrounding generated levels

  > Next up, to promote and 'merge' the rooms' tilemaps to remove the seams
  > between rooms.


### 5 Oct 2023

- ([`d9b986f0`](https://github.com/russmatney/dino/commit/d9b986f0)) feat: create player spawn point in start rooms
- ([`dc241010`](https://github.com/russmatney/dino/commit/dc241010)) feat: pass tilemap, room_defs into create_room

  > Now with swappable tilemaps and room def files!

- ([`888ea30b`](https://github.com/russmatney/dino/commit/888ea30b)) chore: free nodes in tests, add hook to print orphans

  > Cleaned up a bunch of orphans, now gut seems to spam this error:
  > 
  > ERROR: Parameter 'PhysicsServer2D::get_singleton()' is null.
  >    at: ~Shape2D (scene/resources/shape_2d.cpp:127)
  > 
  > 200 times at the end of test runs. blerg.

- ([`660451ae`](https://github.com/russmatney/dino/commit/660451ae)) feat: cleaner create_room api - drop next_room_opts

  > Rather than expect consumers to call next_room_opts with the last_room,
  > we support passing last_room into create_room, which cleans up the
  > worldGen impl.

- ([`de4de3a5`](https://github.com/russmatney/dino/commit/de4de3a5)) chore: more ext_resource uid updates

  > Changing resources is a pita

- ([`c127eeb9`](https://github.com/russmatney/dino/commit/c127eeb9)) fix: proved that stat works as a quick test for export success

  > And disables the not-working mac build for now.

- ([`a30cda7e`](https://github.com/russmatney/dino/commit/a30cda7e)) feat: CI running export/deploy only after tests pass
- ([`c782b8ae`](https://github.com/russmatney/dino/commit/c782b8ae)) chore: update font imports and misc refs
- ([`80b50e5a`](https://github.com/russmatney/dino/commit/80b50e5a)) fix: font attribution wording

  > These fonts are not free to distribute after a one time purchase!

- ([`2e4b641f`](https://github.com/russmatney/dino/commit/2e4b641f)) feat: include and attribute V3X3D fonts

  > These vexed fonts are availabe for purchase here:
  > - https://v3x3d.itch.io/arcade-cabinet
  > - https://v3x3d.itch.io/enter-input


### 4 Oct 2023

- ([`f6083e89`](https://github.com/russmatney/dino/commit/f6083e89)) test: next_room_opts unit tests

  > Will likely move this into create_room as well to simplify the api, but
  > here's some unit tests for now anyway.

- ([`c7fc8fb5`](https://github.com/russmatney/dino/commit/c7fc8fb5)) feat: basic create_room test coverage

  > Asserts on start, end, square, long room types created with tilemap
  > used_cells() based on room_def shapes from a .txt file.

- ([`1af8e6f7`](https://github.com/russmatney/dino/commit/1af8e6f7)) fix: include pandora data in dino exports

### 3 Oct 2023

- ([`8c2d115f`](https://github.com/russmatney/dino/commit/8c2d115f)) chore: disable deploys

  > These are mostly working now, but we don't want to run them every time,
  > and we want more protection against deploying empty/failed exports.

- ([`33afc5a9`](https://github.com/russmatney/dino/commit/33afc5a9)) fix: drop --if-changed in CI

  > Seems to be only relevant if the same machine is redeploying.

- ([`7a5ebd47`](https://github.com/russmatney/dino/commit/7a5ebd47)) fix: templates -> `export_templates`
- ([`33689daa`](https://github.com/russmatney/dino/commit/33689daa)) wip: force 0 exit code

  > Hopefully only temporarily

- ([`77cd2341`](https://github.com/russmatney/dino/commit/77cd2341)) fix: force initial asset godot import before export
- ([`5927e02b`](https://github.com/russmatney/dino/commit/5927e02b)) wip: list built artifacts

  > Current setup is deploying empty games! :sad:

- ([`35b49c2b`](https://github.com/russmatney/dino/commit/35b49c2b)) fix: drop upload artifact, set butler api key
- ([`5a4dc1d4`](https://github.com/russmatney/dino/commit/5a4dc1d4)) fix: ignore errors during export for now
- ([`44605447`](https://github.com/russmatney/dino/commit/44605447)) fix: attempt to fix missing export templates bug
- ([`2f7aabac`](https://github.com/russmatney/dino/commit/2f7aabac)) fix: misc export and deploy workflow fixes
- ([`653944fa`](https://github.com/russmatney/dino/commit/653944fa)) wip: build and deploy dino to itch, first attempt

  > Based largely on https://github.com/abarichello/godot-ci

- ([`3a9d8908`](https://github.com/russmatney/dino/commit/3a9d8908)) chore: org raw html in github readme syntax?
- ([`786846f7`](https://github.com/russmatney/dino/commit/786846f7)) chore: quick gut tests status badge
- ([`337e7a84`](https://github.com/russmatney/dino/commit/337e7a84)) feat: tests running in CI!

  > Adjusts some broken tests with the correct (tho hard-coded) values.
  > 
  > Removing the gut prefix '' overwrite made this take hours... my bad!

- ([`c6d56291`](https://github.com/russmatney/dino/commit/c6d56291)) fix: break initial godot import out of cached step
- ([`0ed5bdf0`](https://github.com/russmatney/dino/commit/0ed5bdf0)) fix: revert some falsy config settings

  > Just found out the default gut test prefix is some gibberish, so setting
  > it to '' is actually required. blerg.

- ([`115f385c`](https://github.com/russmatney/dino/commit/115f385c)) fix: force exit code zero

  > OS.exit_code is now just a var passed to SceneTree.quit():
  > 
  > https://docs.godotengine.org/en/4.0/classes/class_scenetree.html#class-scenetree-method-quit

- ([`41944fcf`](https://github.com/russmatney/dino/commit/41944fcf)) chore: adding script for godot's initial import

  > This is apparently required to run gut tests in CI, and also is deemed
  > to small a work-around to include in gut itself. https://github.com/bitwes/Gut/issues/301
  > 
  > I must be doing something wrong!

- ([`524e7e45`](https://github.com/russmatney/dino/commit/524e7e45)) fix: update downloaded godot path
- ([`44529522`](https://github.com/russmatney/dino/commit/44529522)) feat: specify godot dev env for godot version var
- ([`31e03d09`](https://github.com/russmatney/dino/commit/31e03d09)) chore: rewrite github action

  > Not sure why godot-tester moved to node, but now subprocesses don't log
  > anymore, so we don't get any test output. Also, it depends on parsing an
  > xml results file, which is never written to when imports/tests fail for
  > misc other reasons, making it un-debugable. Pulling and rewriting the
  > godot-html-export action to run gut tests - could probably just install
  > bababshka and run my bb tasks instead...
  > 
  > Also, i think the tests are failing to run b/c of missing assets - but
  > i'd like to see that output in CI somehow first

- ([`6463853b`](https://github.com/russmatney/dino/commit/6463853b)) wip: gut tests running in CI
- ([`aff5b46f`](https://github.com/russmatney/dino/commit/aff5b46f)) fix: drop some falsy .gutconfig empty strings

  > Maybe this is throwing off the godot-tester action?

- ([`2d0c842d`](https://github.com/russmatney/dino/commit/2d0c842d)) fix: include (apparently required) output-file 'option'
- ([`4668f35d`](https://github.com/russmatney/dino/commit/4668f35d)) build: initial GUT test github action

### 28 Sep 2023

- ([`1e1a0cd8`](https://github.com/russmatney/dino/commit/1e1a0cd8)) feat: add a few level shapes
- ([`7d7db9e2`](https://github.com/russmatney/dino/commit/7d7db9e2)) feat: generating tilemaps using shapes from rooms.txt

  > Includes a side-scrolling player and a button to generate a new one!
  > Towards a v1 for a level testing tool!

- ([`06d728b0`](https://github.com/russmatney/dino/commit/06d728b0)) feat: supporting START and END room types
- ([`8f8d2d73`](https://github.com/russmatney/dino/commit/8f8d2d73)) feat: rough room parsing and room_def assignment

  > Note this does not yet differentiate start/end rooms

- ([`cfab930c`](https://github.com/russmatney/dino/commit/cfab930c)) feat: creating WoodsRooms instead of ColorRects
- ([`b6a4c4e5`](https://github.com/russmatney/dino/commit/b6a4c4e5)) feat: initial RoomParser impl

  > Getting started with this level script thing.


### 27 Sep 2023

- ([`73569afa`](https://github.com/russmatney/dino/commit/73569afa)) wip: woods initial room design

  > A rough idea of base room designs for woods' levelscript impl.

- ([`05eba84d`](https://github.com/russmatney/dino/commit/05eba84d)) fix: drop dead dino_game_entity class overwrite

  > Also updates an outdated template, which will likely get trimmed as more
  > details move into pandora game entities.


### 24 Sep 2023

- ([`3f2205dc`](https://github.com/russmatney/dino/commit/3f2205dc)) feat: wasd for ui-up/down/lef/right input actions

### 23 Sep 2023

- ([`7b42e685`](https://github.com/russmatney/dino/commit/7b42e685)) feat: rough initial woods room gen algorithm

  > Creating square, long, climb, and fall room types, and aligning their
  > positions. Starts and ends with a square room.

- ([`8f5514cb`](https://github.com/russmatney/dino/commit/8f5514cb)) feat: register singleton when no game autoload is found

  > Towards fewer autoloads and smaller dino-partial exports.
  > 
  > Also begins 'the woods', short for a lost-woods inspired runner.


### 20 Sep 2023

- ([`33c737e1`](https://github.com/russmatney/dino/commit/33c737e1)) feat: main menu supported by entities, and games playable

  > Some loop and lookup hacks to get game singletons and entities to attach
  > to eachother - hopefully will find some nicer way to do this soon.

- ([`6710926e`](https://github.com/russmatney/dino/commit/6710926e)) fix: nil-punning in navi.set_*_menu funcs, dinogame data

  > Adds metadata for the rest of the dinoGameEntities


### 19 Sep 2023

- ([`396940a1`](https://github.com/russmatney/dino/commit/396940a1)) wip: dothop 3 2 level wips
- ([`feffee0a`](https://github.com/russmatney/dino/commit/feffee0a)) wip: dinogameEntities populating main menu

  > A bunch of things are broken - more pandora refactor to come!

- ([`4f5d0987`](https://github.com/russmatney/dino/commit/4f5d0987)) wip: starting in on DinoGameEntity
- ([`e4d18d25`](https://github.com/russmatney/dino/commit/e4d18d25)) feat: dothop puzzle sets implemented

  > PuzzleSets now point to a txt file, and support a default theme. All
  > levels are now accessible!

- ([`3c05bd74`](https://github.com/russmatney/dino/commit/3c05bd74)) wip: creating dothop puzzle set via pandora

  > BREAKING! all game.start() funcs need to handle opts!

- ([`c3ff8154`](https://github.com/russmatney/dino/commit/c3ff8154)) chore: update to pandora latest

### 15 Sep 2023

- ([`23af981b`](https://github.com/russmatney/dino/commit/23af981b)) wip: 8 more levels for dothop three
- ([`3d3dfd5e`](https://github.com/russmatney/dino/commit/3d3dfd5e)) feat: 12 more levels via dothop-two
- ([`fd6e91e1`](https://github.com/russmatney/dino/commit/fd6e91e1)) chore: misc re-import noise
- ([`afb8e8b0`](https://github.com/russmatney/dino/commit/afb8e8b0)) revert: unwind aseprite wizard import-no-import attempt

  > Also discovers a bit of a bug - project settings set to 'false' come out
  > truthy - enabling + disabling the automatic imports leave it enabled!

- ([`efb819e4`](https://github.com/russmatney/dino/commit/efb819e4)) fix: replace malformed gut source_code_pro.fnt

  > Hit this today after deleting and reimporting my .godot/imported/* dir.
  > 
  > https://github.com/bitwes/Gut/issues/479

- ([`c33fb17c`](https://github.com/russmatney/dino/commit/c33fb17c)) chore: update to gut latest
- ([`f28561fa`](https://github.com/russmatney/dino/commit/f28561fa)) wip: aseprite wizard import plugin without import attempt

  > Trying to get aseprite files to show in the fileSystem without
  > automatically importing them... debugging now whether they are still
  > being imported or if godot recreates .import files for things in
  > .godot/imported/*


### 14 Sep 2023

- ([`21fd6ee3`](https://github.com/russmatney/dino/commit/21fd6ee3)) feat: fall theme background
- ([`969ff8ca`](https://github.com/russmatney/dino/commit/969ff8ca)) feat: fall theme running! such happy dancing leaves...

  > Needs a background too tho.

- ([`edc98016`](https://github.com/russmatney/dino/commit/edc98016)) wip: fall theme initial assets - no player yet!

  > Creates a bunch of animatedSprite2Ds for various leaf colors on a Leaf
  > scene, and creates the new pandora theme to support it.

- ([`e7ab71e1`](https://github.com/russmatney/dino/commit/e7ab71e1)) feat: drag-and-drop aseprite files onto animatedSprite2Ds

  > A modification of the AsepriteWizard plugin - should probably be applied
  > to similar button usage for other animated nodes. Should also validate
  > the dropped filetype extensions.
  > 
  > Note that aseprite files won't show up in the FileSystem dock unless you
  > update Editor Settings > Dock > FileSystem > TextFile Extensions.
  > Perhaps some more work in AsepriteWizard could also save this extra step
  > - like implementing an import plugin for aseprite files directly.


### 13 Sep 2023

- ([`73357571`](https://github.com/russmatney/dino/commit/73357571)) fix: adjust font sizes on the dot hop hud
- ([`fa1ae428`](https://github.com/russmatney/dino/commit/fa1ae428)) feat: initial art for space theme: asteroid, player, space bg

  > eh, it's something at least.

- ([`0e28a0e1`](https://github.com/russmatney/dino/commit/0e28a0e1)) fix: correct position when directional inputs are spammed

  > gotta be careful with relative positioning and tweens - the player was
  > wandering way off from the coords.

- ([`f16cc0aa`](https://github.com/russmatney/dino/commit/f16cc0aa)) feat: animated_exit for player/dots in dots theme

  > Opt-in and impl-able per theme.

- ([`a14acf9f`](https://github.com/russmatney/dino/commit/a14acf9f)) feat: show jumbotron and wait for input between levels

  > Quick and dirty 'win' treatment per puzzle, plus some jumbotron
  > refactors so emitting the returned signal cleans up the jumbotron for
  > us. Nice little pattern there.

- ([`0bc5d5c0`](https://github.com/russmatney/dino/commit/0bc5d5c0)) feat: animate dots entry
- ([`90428c83`](https://github.com/russmatney/dino/commit/90428c83)) fix: undo across dotted cells fix and test case

  > Nice to have coverage for these, and in not many lines of code!

- ([`a6d3be84`](https://github.com/russmatney/dino/commit/a6d3be84)) feat: add joypad button to undo input map
- ([`dece1b25`](https://github.com/russmatney/dino/commit/dece1b25)) feat: animated undo feedback in hud

  > The HUD now animates the undo label whenever it is pressed. The controls
  > fade/show logic is a bit hairy... leaving it as-is for now.

- ([`f24f5851`](https://github.com/russmatney/dino/commit/f24f5851)) fix: more manual null handling, like always

  > I miss nil-punning pretty much all the time.

- ([`59315e23`](https://github.com/russmatney/dino/commit/59315e23)) feat: add controller 'restart' action support

  > Also removes the respawn action, and moves restart from shift-r to just
  > r.

- ([`7c29cc26`](https://github.com/russmatney/dino/commit/7c29cc26)) feat: hold restart to reset the puzzle

  > Timing is a little weird b/c shift also start slow-mo. will have to
  > fix/adjust that before tweaking much further.

- ([`419c0203`](https://github.com/russmatney/dino/commit/419c0203)) fix: support setting level_message, dot metric
- ([`2f985869`](https://github.com/russmatney/dino/commit/2f985869)) feat: HUD ui comps wired up

  > Fade/show controls based on input activity.
  > 
  > level num/message, dots remaining wired up but untested.


### 12 Sep 2023

- ([`b78d99ce`](https://github.com/russmatney/dino/commit/b78d99ce)) fix: update exports

  > Probably breaks the mvania build... gotta re-opt-in to the hotel ui
  > folder now.

- ([`2a718888`](https://github.com/russmatney/dino/commit/2a718888)) chore: unblock some tests

  > these waits aren't perfect - there's no real test isolation here.

- ([`683be2e3`](https://github.com/russmatney/dino/commit/683be2e3)) feat: working dothop hud unit tests

  > tho some of these workarounds make me wonder if there's a gap in the
  > gdscript testing ecosystem, it ends up not being much code, and should
  > more or less work fine. Figuring out some patterns here!

- ([`01085fc5`](https://github.com/russmatney/dino/commit/01085fc5)) wip: dothop hud tests nearly in place

  > At this point, just the hud needing to grab the initial state in
  > _ready...

- ([`3602b906`](https://github.com/russmatney/dino/commit/3602b906)) wip: Hotel.gd initial tests, some refactor/clean up
- ([`7af41b51`](https://github.com/russmatney/dino/commit/7af41b51)) fix: only use supported colors in pretty printer

  > Fixes a long-annoying bug in a pretty nice way. Reading the print_rich
  > doc-string, it turns out supported colors are converted to ansi codes
  > when output to stdout, which means the test and stdout in the
  > terminal/emacs buffer are now MUCH more readable (not full of noisy
  > color labels and reasonably colored). The color choices are limited, but
  > we could make it more readable with some bgcolor/fgcolor usage.

- ([`472722c6`](https://github.com/russmatney/dino/commit/472722c6)) wip: basic dothop HUD components

### 11 Sep 2023

- ([`dc1fd370`](https://github.com/russmatney/dino/commit/dc1fd370)) feat: rough dots animations
- ([`0ddd7abd`](https://github.com/russmatney/dino/commit/0ddd7abd)) wip: towards initial dots theme art
- ([`a41d6fc4`](https://github.com/russmatney/dino/commit/a41d6fc4)) wip: rough animated dots player movement

  > Some tweens for animated movement. Also adjusts the existing dots/player
  > scenes to very roughly be centered around the origin (instead of only
  > the positive x/y quadrant).

- ([`6cd49e3a`](https://github.com/russmatney/dino/commit/6cd49e3a)) feat: dots player impl includes screenshake
- ([`279658f1`](https://github.com/russmatney/dino/commit/279658f1)) fix: fix bad function name, restore tests
- ([`a1be7149`](https://github.com/russmatney/dino/commit/a1be7149)) feat: dothop basic player movement api
- ([`f342ce8e`](https://github.com/russmatney/dino/commit/f342ce8e)) feat: dothop camera anchor, centered per level
- ([`35762ceb`](https://github.com/russmatney/dino/commit/35762ceb)) fix: create timer on puzzle node, not tree root

  > Creating this on the tree root meant it hung around after the puzzle was
  > destroyed (when advancing to the next level), leading to errors thrown
  > when the callback attempted to run on an invalid puzzle node

- ([`1fd2ab0a`](https://github.com/russmatney/dino/commit/1fd2ab0a)) fix: timer supporting 'holding' movement in a direction

  > As well as preventing moving backwards from immediately flying in the
  > other direction. Maybe could use more tweaking on the timers, but this
  > felt ok from my desk-controller playthroughs.

- ([`f5ce7ff8`](https://github.com/russmatney/dino/commit/f5ce7ff8)) fix: support a grid/discrete move_vector, fix joystick input

  > The cells_in_dir func was looping forever, and non-discrete inputs were
  > doing who knows what to the move() function. This creates a new trolley
  > helper for ensuring the move_vector returned is useful to a 'grid', so
  > it must be either zero, left, right, up, or down.

- ([`d7106d4d`](https://github.com/russmatney/dino/commit/d7106d4d)) fix: naming and cache invalidation

### 10 Sep 2023

- ([`4d43f4cb`](https://github.com/russmatney/dino/commit/4d43f4cb)) wip: towards working joy stick in dot hop

### 8 Sep 2023

- ([`12b038cd`](https://github.com/russmatney/dino/commit/12b038cd)) fix: misc bugs, and export fixes

  > - don't binary-convert .txt files
  > - include more resources in export (pandora, dothop.txt)
  > 
  > Seems to be a few bugs as well - controller usage doesn't always work,
  > but it at least seems reproducible on the machine.

- ([`bdec1621`](https://github.com/russmatney/dino/commit/bdec1621)) wip: basic dothop main/pause menus, and theme switching!

  > Adds a quick 'space' theme and creates initial main/pause menus for
  > dothop, including buttons and wiring for changing the game's theme
  > in-place.

- ([`5783dcb3`](https://github.com/russmatney/dino/commit/5783dcb3)) feat: dothop themes via pandora config working

  > Plain for now. Once we get the game supporting theme-swapping, we can
  > really dive in here.

- ([`f7a009d2`](https://github.com/russmatney/dino/commit/f7a009d2)) chore: update pandora
- ([`beb90ed3`](https://github.com/russmatney/dino/commit/beb90ed3)) refactor: rewrite DotHop.gd, introduce DotHopGame, rename level->puzzle

  > More DotHop clean up, starting to tie in pandora.

- ([`54281fc6`](https://github.com/russmatney/dino/commit/54281fc6)) refactor: establish DotHopDot and DopHopPlayer classes

  > Trying to work towards swappable themes here, hopefully via pandora.

- ([`c8e37ba6`](https://github.com/russmatney/dino/commit/c8e37ba6)) refactor: rename flowerEater -> dotHop

  > Dot/Dotted/Goal instead of Flower/FlowerEaten/Target. Slightly more
  > abstract/less specific, and the naming feels much cleaner. Could still
  > make a 'flowerEater' game on top of this, but I think the readability is
  > worth it.


### 7 Sep 2023

- ([`fbb80cdb`](https://github.com/russmatney/dino/commit/fbb80cdb)) feat: 'dots' level overwriting game nodes

  > Towards some customizable art on top of the flower-eater game play.

- ([`c6cbaf6b`](https://github.com/russmatney/dino/commit/c6cbaf6b)) refactor: general level script refactor/clean up
- ([`2e09069f`](https://github.com/russmatney/dino/commit/2e09069f)) fix: reduce some noisey logs
- ([`b32df520`](https://github.com/russmatney/dino/commit/b32df520)) fix: don't parse the final message as a shape

  > Updates the puzzlescript parser to prevent it from treating the final
  > message line as a level shape. Could be cleaner, but, it's working and
  > not crashing.

- ([`efa34b64`](https://github.com/russmatney/dino/commit/efa34b64)) fix: found+fixed but couldn't reproduce another bug

  > Hopefully this captures it! Maybe some way to record + write the moves
  > is a good idea for when folks find bugs/get stuck.

- ([`d2caeef9`](https://github.com/russmatney/dino/commit/d2caeef9)) fix: moving the player finds undo in history

  > Even if that history has a bunch of same-space moves! With a couple
  > tests making sure the harder puzzles actually work.

- ([`ee5f3375`](https://github.com/russmatney/dino/commit/ee5f3375)) fix: undo-in-place bug, plus test and some clean up

  > Maybe too specific, or maybe just the way we want to test things.
  > 
  > Note these tests only test the state updates, not the actual node
  > updates - we can include some spies or maybe switch to signals for that
  > later on.

- ([`1d407380`](https://github.com/russmatney/dino/commit/1d407380)) refactor: initial unit tests for flowereater

  > Covers a happy-path and undo on level one.


### 6 Sep 2023

- ([`7a74cc7c`](https://github.com/russmatney/dino/commit/7a74cc7c)) wip: attempt to support 2 player movement and undos
- ([`1724f153`](https://github.com/russmatney/dino/commit/1724f153)) wip: prevent movement when anyone is stuck

  > Found a few issues with this move-to-undo feature - it makes at least
  > one of the two player levels impossible. Need to refine the
  > allowed-to-move rules a bit to prefer movement ahead of undos.

- ([`ab3a2b8e`](https://github.com/russmatney/dino/commit/ab3a2b8e)) fix: resolve some undo-bugs

  > Attention to when the history is updated leaks into some of the helpers
  > - perhaps there's some cleaner structure for this, like a proper
  > state-history.

- ([`2ace5525`](https://github.com/russmatney/dino/commit/2ace5525)) wip: controlling multiple players with undo nearly working
- ([`1a777072`](https://github.com/russmatney/dino/commit/1a777072)) feat: primitive level advancement

  > Playing through, on the level-generator anyway.

- ([`b5f0b05d`](https://github.com/russmatney/dino/commit/b5f0b05d)) feat: support undo

  > Can now undo moves by moving in reverse, plus handling for getting
  > 'stuck' when entering the target early. (you must undo in this
  > situation).

- ([`f6b0b608`](https://github.com/russmatney/dino/commit/f6b0b608)) refactor: clean up puzzle implementation

  > much nicer with some helpers, still a bit messy state-wise.


### 5 Sep 2023

- ([`ff7adb68`](https://github.com/russmatney/dino/commit/ff7adb68)) feat: level1 generating and nearly playable

  > Tho not quite - no win-check in-place yet.

- ([`b4943449`](https://github.com/russmatney/dino/commit/b4943449)) wip: init flowerEater game, pull puzzlescript file

  > Started level gen, with some orange squares on the nil spaces.


### 4 Sep 2023

- ([`6fac33d0`](https://github.com/russmatney/dino/commit/6fac33d0)) wip: pandora for dino games, sel bodies
- ([`38f6e34d`](https://github.com/russmatney/dino/commit/38f6e34d)) chore: update pandora
- ([`accba458`](https://github.com/russmatney/dino/commit/accba458)) exports: osx spike build
- ([`222942b5`](https://github.com/russmatney/dino/commit/222942b5)) the pandora dino-game refactor begins!
- ([`1c90d29b`](https://github.com/russmatney/dino/commit/1c90d29b)) feat: steam build.vdf for dino on linux
- ([`ad5406c2`](https://github.com/russmatney/dino/commit/ad5406c2)) feat: ignore build/build-output

  > Not sure if steam-id should be a secret or not... but maybe?

- ([`1730b73d`](https://github.com/russmatney/dino/commit/1730b73d)) export: latest linux build

  > Also corrects some broken thoughts at the top of the repo

- ([`37ffe77b`](https://github.com/russmatney/dino/commit/37ffe77b)) misc: bunch of dino cruft that acced during BEU City's build out

  > Updates the BEU template aseprite file, probably just some cosmetic
  > stuff, this isn't used for anything directly.
  > 
  > Silences some hotel warnings - we'll hopefully abandon/rewrite this code
  > anyway, ideally moving everything completely into pandora apis, which
  > shoudl give some sep-of-concerns.
  > 
  > The updated 'default nulls' are probably due to a godot version update.
  > 
  > And the super elevator goon naming and custom shader material probably
  > doing a color swap. I think this was a live-demo while talking to greg
  > or cameron.


### 1 Sep 2023

- ([`9ca7afdf`](https://github.com/russmatney/dino/commit/9ca7afdf)) feat: metro reload_current_zone helper

  > Supports arbitrary select-character invocation in BEU city


### 31 Aug 2023

- ([`2f61bbcd`](https://github.com/russmatney/dino/commit/2f61bbcd)) addons: enable pandora plugin
- ([`ea722e53`](https://github.com/russmatney/dino/commit/ea722e53)) fix: support loading a metro zone as PackedScene

  > Also disables a noisy warning.


### 29 Aug 2023

- ([`a7ac2746`](https://github.com/russmatney/dino/commit/a7ac2746)) feat: rough pause/unpause contained entities

  > Now moving to pausing entities overlapping each room, rather than just a
  > room's children. Some TODOs that might reveal bugs in here - paused
  > attackers might hold onto attack-slots, rendering players invincible :/

- ([`2035d888`](https://github.com/russmatney/dino/commit/2035d888)) feat: reparent children to the zone when unpaused.

  > This simplifies a bunch of enemies leaving-their-room issues, by just
  > letting them go.

- ([`a16e4aaf`](https://github.com/russmatney/dino/commit/a16e4aaf)) fix: update respawn to tween global_position

  > global_position is maintained when `reparent()`ing nodes - otherwise
  > enemies were spawning relative to 0,0 rather than staying in their
  > rooms (when being reparented after _ready()).

- ([`710d16c6`](https://github.com/russmatney/dino/commit/710d16c6)) fix: update_zone() and room_box rewrite for more flexible room movement

  > A less strict update_zone impl.
  > 
  > - no longer pause/unpause everything when the player is not contained by a room
  > 
  > room_boxes now moved to the zone-level.
  > 
  > - paused rooms don't have to be 'unpaused' to detect entering
  > players, which lets us avoid annoying 'pause' work-arounds.
  > - room_boxes are now deleted and recreated every time the zone is
  > loaded, which is easier to deal with than trying to get them in the
  > right state in the editor/game based on various previous states.
  > 
  > We also now support leaving the last `n` rooms unpaused, which makes
  > most situations work, but still has a few issues: running away from
  > an enemy until they are eventually 'paused' (b/c their room was paused),
  > then re-entering the room the enemy is in does not 'unpause' that enemy.
  > Maybe need to handle enemies at the zone level as well - should only
  > pause entities contained by the room when it is paused, and should
  > probably move most mobile entities up to the zone level once they're
  > 'ready'.

- ([`2d37d5fa`](https://github.com/russmatney/dino/commit/2d37d5fa)) fix: wait to update-world until player is ready

  > Metro.update_world() was running before the player was ready, which
  > meant the player's global_position was (0, 0) when the room.contains?
  > checks ran.

- ([`42ba0f23`](https://github.com/russmatney/dino/commit/42ba0f23)) fix: BEUBodies z-index, to stay on top of adjacent rooms
- ([`83ec838b`](https://github.com/russmatney/dino/commit/83ec838b)) fix: reduce metro current room pause/unpausing

  > Prevent pausing the current room when we 'exit' but are not yet in
  > another room. This allows wandering the 'open' map a bit without
  > completely breaking gameplay. It also reduces lots of pause/unpause
  > noise.


### 28 Aug 2023

- ([`6613b520`](https://github.com/russmatney/dino/commit/6613b520)) chore: nil-pun Util.free_children()

### 22 Aug 2023

- ([`ec09410e`](https://github.com/russmatney/dino/commit/ec09410e)) fix: unfade in beu machine respawn

  > The death animation fades the character sprite, so if we respawn we're
  > still faded - this resets the fade.


### 19 Aug 2023

- ([`9ca7a199`](https://github.com/russmatney/dino/commit/9ca7a199)) addon: install pandora

  > cp -r ~/bitbrain/pandora/addons/pandora addons/.


### 18 Aug 2023

- ([`7a3f3f45`](https://github.com/russmatney/dino/commit/7a3f3f45)) chore: misc hotel debugging. bugs to track down!

  > should probably write some unit tests....

- ([`38be21b7`](https://github.com/russmatney/dino/commit/38be21b7)) feat: add 'dying' signal

  > b/c i want to emit drops before they're dead - fun to see enemies watch
  > you pillage their plunder.

- ([`00652442`](https://github.com/russmatney/dino/commit/00652442)) feat: pass 'body' into destructible.take_hit(opts)

  > This lets us calculate the direction of the hit, for destructible
  > animations. Maybe could do this ahead of time, perhaps with the 'facing'
  > of the actor.

- ([`16d9a516`](https://github.com/russmatney/dino/commit/16d9a516)) feat: support punching/kicking/jump-kicking destructibles

  > Refactors BEUBody's take_damage into take_hit/take_damage like ssbody,
  > and moves both to handle options objs instead of rigid parameters.
  > 
  > The group-check for 'destructibles' could have been
  > 'has_method('take_hit')', but this unfortunately applies to all
  > BEUbodies as well.

- ([`db63423b`](https://github.com/russmatney/dino/commit/db63423b)) feat: add recover_health to BEUBody

  > copy-pasted from SSBody


### 17 Aug 2023

- ([`588f170d`](https://github.com/russmatney/dino/commit/588f170d)) fix: clear existing symlinks when installing addons

### 15 Aug 2023

- ([`d50bf73e`](https://github.com/russmatney/dino/commit/d50bf73e)) feat: flag to opt-out of default BEUPlayer camera
- ([`6c955972`](https://github.com/russmatney/dino/commit/6c955972)) chore: couple basic aseprite assets for beehive
- ([`d2ea8807`](https://github.com/russmatney/dino/commit/d2ea8807)) fix: support setting only game as current
- ([`f58a0ae0`](https://github.com/russmatney/dino/commit/f58a0ae0)) refactor: move reused assets into core/assets

  > And others into beehive, hood. Cleans up gameicons. Starting to get
  > more opinionated about dino game structure.

- ([`08659c3a`](https://github.com/russmatney/dino/commit/08659c3a)) refactor: move PlayerSpawnPoint into addons/core

### 14 Aug 2023

- ([`370a964c`](https://github.com/russmatney/dino/commit/370a964c)) refactor: move fallback dino game icon to core addons
- ([`0f834076`](https://github.com/russmatney/dino/commit/0f834076)) refactor: pull DJZ sounds into dj/assets/sounds/* dir

  > DJ addon now providing these sounds to consumers. Alternatively, we
  > could write a DinoSounds that lives in src/ and not expose any sounds.

- ([`3c37c37c`](https://github.com/russmatney/dino/commit/3c37c37c)) chore: bunch of import noise
- ([`2a2f93aa`](https://github.com/russmatney/dino/commit/2a2f93aa)) feat: move DinoGame, Game to core, invert deps on game autoloads

  > Also moves some deps/logic from Debug.gd to Trolley.gd, to make Debug.gd
  > easier to autoload (it's the first autoload, so should not have deps
  > like Cam/Trolley/Hood). Trolley would ideally also not depend on
  > Cam/Hood.
  > 
  > Moving DinoGame to an addon to make it accessible to BeatEmUpCity, which
  > a first consumer of the dino addon suite.


### 22 Jul 2023

- ([`4df26baa`](https://github.com/russmatney/dino/commit/4df26baa)) clawe: current-pomodoro/break, latest durations/breaks pretty printed

  > Some 'data' showing up on the clawe dashboard. pretty-printed raw dicts
  > for now, but it's starting to work a bit

- ([`fd83460d`](https://github.com/russmatney/dino/commit/fd83460d)) misc: better debug pretty printing log, reenable color
- ([`ff7c1898`](https://github.com/russmatney/dino/commit/ff7c1898)) clawe: pomodoros - latest breaks, lengths, and current set

  > Data is just about ready, next is some visuals.

- ([`245f92d6`](https://github.com/russmatney/dino/commit/245f92d6)) wip: clawe dashboard ui foundation and logging json from local api

  > printing raw pomodoro data. starting to get somewhere!


### 18 Jul 2023

- ([`0d330ee3`](https://github.com/russmatney/dino/commit/0d330ee3)) feat: parse puzzlescript rules
- ([`ec3af140`](https://github.com/russmatney/dino/commit/ec3af140)) feat: parse puzzlescript sounds, collisionlayers, winconds, levels
- ([`20aace69`](https://github.com/russmatney/dino/commit/20aace69)) feat: parsing puzzlescript legends
- ([`df8eb18a`](https://github.com/russmatney/dino/commit/df8eb18a)) feat: parsing puzzlescript objects + test

### 17 Jul 2023

- ([`8815ce07`](https://github.com/russmatney/dino/commit/8815ce07)) chore: updated clj-kondo import hooks
- ([`1292da4a`](https://github.com/russmatney/dino/commit/1292da4a)) wip: init Puzz, begin puzzlescript parser, disable pretty-print colors

  > Adds an option to disable pretty-print colors - next step is to toggle
  > it based on `--headless`. The colors showing up in stdout logs makes it
  > difficult to read, which is counter productive.
  > 
  > inits a new dino addon, called Puzz - i intend to parse and support
  > puzzlescript files as input, hopefully creating godot nodes via an
  > import plugin. hooray for low-overhead prototyping!

- ([`cd525b24`](https://github.com/russmatney/dino/commit/cd525b24)) feat: add GUT back

  > Run tests via `bb test`


### 11 Jul 2023

- ([`a60e7029`](https://github.com/russmatney/dino/commit/a60e7029)) fix: make sure core is run ahead of other plugins

  > B/c they might depend on the 'Debug' autoload.


### 10 Jul 2023

- ([`02397eb2`](https://github.com/russmatney/dino/commit/02397eb2)) feat: itchio title-sized icons

  > quick and dirty.


### 9 Jul 2023

- ([`d8215d29`](https://github.com/russmatney/dino/commit/d8215d29)) fix: update spike title on main menu
- ([`b3b65a88`](https://github.com/russmatney/dino/commit/b3b65a88)) feat: mention spike in readme
- ([`8b72d369`](https://github.com/russmatney/dino/commit/8b72d369)) final two levels, disable level duplicate
- ([`d1776e22`](https://github.com/russmatney/dino/commit/d1776e22)) feat: flat land two, occlusion layers on snow tiles
- ([`7c398e58`](https://github.com/russmatney/dino/commit/7c398e58)) feat: basic first level with action hints
- ([`2f233f33`](https://github.com/russmatney/dino/commit/2f233f33)) fix: better cooking labels
- ([`63260cc6`](https://github.com/russmatney/dino/commit/63260cc6)) feat: new level: FlatLandOne
- ([`828d7a70`](https://github.com/russmatney/dino/commit/828d7a70)) fix: remove quest status background color
- ([`392e06ee`](https://github.com/russmatney/dino/commit/392e06ee)) fix: hide state label on player ssbodies in managed games
- ([`a12f4565`](https://github.com/russmatney/dino/commit/a12f4565)) fix: remove unused initial anim
- ([`28e08b50`](https://github.com/russmatney/dino/commit/28e08b50)) feat: quick lights and canvas modulate on everything
- ([`2a75b2c2`](https://github.com/russmatney/dino/commit/2a75b2c2)) feat: full/wrong orders are spiked back
- ([`ab6661eb`](https://github.com/russmatney/dino/commit/ab6661eb)) fix: overwrite enemy check_out to bring enemies back to life

  > otherwise everything is dead on the second playthrough

- ([`41cd00c4`](https://github.com/russmatney/dino/commit/41cd00c4)) feat: display delivery zone void wants
- ([`5678bd27`](https://github.com/russmatney/dino/commit/5678bd27)) fix: quest list duplication
- ([`efa367f1`](https://github.com/russmatney/dino/commit/efa367f1)) feat: support respawning after death
- ([`f0cbcf75`](https://github.com/russmatney/dino/commit/f0cbcf75)) feat: weapons use display_name, fix aiming after activate/switch
- ([`5a7ce9ae`](https://github.com/russmatney/dino/commit/5a7ce9ae)) feat: set proper entity status portraits
- ([`9c66b7bf`](https://github.com/russmatney/dino/commit/9c66b7bf)) fix: simple weapon cycle input

  > Overwriting jetpack for now, but that can move to some other jump-like
  > input anyway.

- ([`152fd1fb`](https://github.com/russmatney/dino/commit/152fd1fb)) feat: support custom quest status header

### 8 Jul 2023

- ([`dfac31bb`](https://github.com/russmatney/dino/commit/dfac31bb)) feat: move to next level when quests complete (i.e. deliveries made)

  > Plus a basic win handler.

- ([`eff26b74`](https://github.com/russmatney/dino/commit/eff26b74)) fix: machine bug - trying to transit before it was started

  > Solved two ways - we should not register with hotel until after the
  > machine has started. This transit in check_out might be rare, or might
  > be a very important use-case.

- ([`669e3d72`](https://github.com/russmatney/dino/commit/669e3d72)) feat: update hud and pause screen to use quest status component
- ([`b2d145e4`](https://github.com/russmatney/dino/commit/b2d145e4)) feat: impl quest for deliveryzones
- ([`5ca793eb`](https://github.com/russmatney/dino/commit/5ca793eb)) fix: quests by label _and_ node.

  > Could probably be just be by node... not sure if i have any nodes
  > managing multiple quests, but it seems unlikely at this point.

- ([`f9c6d5c2`](https://github.com/russmatney/dino/commit/f9c6d5c2)) feat: pantry two, infinite faller, portaledges impl
- ([`1868faca`](https://github.com/russmatney/dino/commit/1868faca)) feat: a closet-like level

  > Fun to hit a few dudes in a row from below with the boomerang.

- ([`d412b1f0`](https://github.com/russmatney/dino/commit/d412b1f0)) feat: cooking pot POF and ignore when full
- ([`59cce3da`](https://github.com/russmatney/dino/commit/59cce3da)) feat: one way platform
- ([`f3aee4e6`](https://github.com/russmatney/dino/commit/f3aee4e6)) feat: cooking produces the 'red' blob

  > Also fixes a few `if ingredient_type:` issues when ingredient_type is an
  > enum, which actually means an int, which means it's sometimes `0`, which
  > means `if ingredient_type:` will be false for things with the first enum
  > value.

- ([`7aaa3223`](https://github.com/russmatney/dino/commit/7aaa3223)) feat: pass ingredient_type from drop to delivery, supported by ing_data

  > Creates a Spike.IngredientData class and Spike.Ingredient enum for
  > referencing the data for an ingredient type, then consumes the
  > ingredient type and data in BlobPickup, Blob, OrbitItem, TossedItem,
  > etc.
  > 
  > Starts to work with rules for can_cook and can_be_delivered on
  > ingredients.

- ([`d7b34ccb`](https://github.com/russmatney/dino/commit/d7b34ccb)) feat: rough cooking + delivery in first zone
- ([`4ae26687`](https://github.com/russmatney/dino/commit/4ae26687)) feat: basic delivery impl
- ([`d655e8f2`](https://github.com/russmatney/dino/commit/d655e8f2)) feat: spiking food impl

  > Currently applies everywhere... maybe that's fine?

- ([`5f1f0d07`](https://github.com/russmatney/dino/commit/5f1f0d07)) feat: cooking pot progress bar

  > Progress bar came together pretty quick! I think i know godot way better
  > than i used to...

- ([`5dd66855`](https://github.com/russmatney/dino/commit/5dd66855)) feat: cooking ingredients, 3 required to produce something

  > For now just produces another blob pickup.

- ([`95dda96b`](https://github.com/russmatney/dino/commit/95dda96b)) feat: add web, linux, windows exports for spike
- ([`f484c677`](https://github.com/russmatney/dino/commit/f484c677)) feat: add spike icon and update control instructions

### 7 Jul 2023

- ([`203ed5ae`](https://github.com/russmatney/dino/commit/203ed5ae)) fix: rebuild aim line png
- ([`e4a761f6`](https://github.com/russmatney/dino/commit/e4a761f6)) feat: tossing and retrieving orbiting items
- ([`de859e0d`](https://github.com/russmatney/dino/commit/de859e0d)) wip: rough item orbiting and tossing

  > Not quite right, but nearly working.

- ([`341242a4`](https://github.com/russmatney/dino/commit/341242a4)) fix: don't flip every weapon

  > Fixes a bug where turning after/while firing the boomerang can cause it
  > to flip to the other side.

- ([`ae9d7b43`](https://github.com/russmatney/dino/commit/ae9d7b43)) feat: boomerang can gather pickups

  > Not DRY yet, but working.

- ([`03316c12`](https://github.com/russmatney/dino/commit/03316c12)) feat: sidescroller boomerang

  > Complete copy-paste from tdweapons/boomerang, and it just works. pretty sweet!

- ([`46992f03`](https://github.com/russmatney/dino/commit/46992f03)) feat: basic blob pickup anim and art
- ([`c5e54183`](https://github.com/russmatney/dino/commit/c5e54183)) feat: basic blob drops + pickup

  > Using a coin for now, gotta move this to an 'ingredient' or ice cream
  > scoop soon.

- ([`47bfb8f1`](https://github.com/russmatney/dino/commit/47bfb8f1)) fix: don't reset ssenemy positions to null
- ([`df4bead3`](https://github.com/russmatney/dino/commit/df4bead3)) feat: basic spike goomba, add directional spikes
- ([`e87df34e`](https://github.com/russmatney/dino/commit/e87df34e)) feat: player art via soft-soft hoodie
- ([`537387fb`](https://github.com/russmatney/dino/commit/537387fb)) fix: player group and collision layer

  > Really ought to do this automagically in the ssplayer.gd

- ([`cefd381b`](https://github.com/russmatney/dino/commit/cefd381b)) feat: initial spike zone

  > Most of the pre-work is done! Ready to dive into game design.

- ([`b9d20d85`](https://github.com/russmatney/dino/commit/b9d20d85)) feat: initial spike hud with minimap, status, notifs
- ([`c8e7d1bb`](https://github.com/russmatney/dino/commit/c8e7d1bb)) feat: spike main menu, pause menu

  > Pulled from The Mountain

- ([`0c5d52a1`](https://github.com/russmatney/dino/commit/0c5d52a1)) feat: init Spike

  > Let's go!!! Player via SideScrollerPlayer, an initial gym, and reusing
  > The Mountain player art.


### 6 Jul 2023

- ([`3b7c25b8`](https://github.com/russmatney/dino/commit/3b7c25b8)) feat: revamp dino's main menu to use icon buttons

  > Some fun getting into textureButtons and a custom startGameButton
  > component that wraps it (including focus support!).

- ([`6af16189`](https://github.com/russmatney/dino/commit/6af16189)) feat: restart game autoloads plugin helper

  > A useful button in the UI for reloading all game autoloads in one click.
  > This is helpful when editing game data that you'd like reflected in the
  > editor immediately, like setting icon_texture on each game singleton.

- ([`19feb087`](https://github.com/russmatney/dino/commit/19feb087)) pixels: bunch of game/addon icons
- ([`c9eb2485`](https://github.com/russmatney/dino/commit/c9eb2485)) docs: add dino icons banner image

  > Not sure if github org will parse the image properly here, but we can hope.


### 18 Jun 2023

- ([`12945e39`](https://github.com/russmatney/dino/commit/12945e39)) feat: add lights to portals

  > Portals are much nicer with these backlights. copied from hatbot's
  > elevators.

- ([`9cdd10d2`](https://github.com/russmatney/dino/commit/9cdd10d2)) fix: misc credits, menus, controls-text tweaks
- ([`24f0ee43`](https://github.com/russmatney/dino/commit/24f0ee43)) feat: add lospec 500 to credits
- ([`602eed49`](https://github.com/russmatney/dino/commit/602eed49)) fix: proper player/enemy status portraits
- ([`c26fe129`](https://github.com/russmatney/dino/commit/c26fe129)) feat: show shrine gem count in hud
- ([`7eb69407`](https://github.com/russmatney/dino/commit/7eb69407)) feat: show message when not enough shrine gems
- ([`ce555906`](https://github.com/russmatney/dino/commit/ce555906)) feat: better shrine gem art asset, some action_hint fixes
- ([`fc075eb4`](https://github.com/russmatney/dino/commit/fc075eb4)) fix: handle knockback/dying/dead without animations

  > So that these blobs work without needing proper art.

- ([`efd3f409`](https://github.com/russmatney/dino/commit/efd3f409)) feat: boomerang mechanic, topdown weapons impl

  > Pulls the ssweapon into a tdweapon (which is the same code? maybe could
  > be dried up?).
  > 
  > Impls a fun little boomerang with a dynamic return-to-actor. Not too
  > bad!

- ([`97bfa4b1`](https://github.com/russmatney/dino/commit/97bfa4b1)) feat: forgiving padding on pit tile areas

  > Plus some player collision adjustments.


### 17 Jun 2023

- ([`2b9a810d`](https://github.com/russmatney/dino/commit/2b9a810d)) feat: add enemies, main/pause menu, export

  > First build running on itch!

- ([`6e2d5de9`](https://github.com/russmatney/dino/commit/6e2d5de9)) feat: pickup shrine gems, open door

  > Sort of a game loop, i guess.

- ([`6d99acb7`](https://github.com/russmatney/dino/commit/6d99acb7)) feat: extend door to check shrine gem count
- ([`eee27e2d`](https://github.com/russmatney/dino/commit/eee27e2d)) feat: basic door art and impl
- ([`985216c6`](https://github.com/russmatney/dino/commit/985216c6)) wip: some not-quite-right invincible-after-hit handling
- ([`7a198c11`](https://github.com/russmatney/dino/commit/7a198c11)) feat: rough knocked_back, dying, dead anims and states
- ([`e34374a3`](https://github.com/russmatney/dino/commit/e34374a3)) feat: topdown player jump/fall anims
- ([`16575e2a`](https://github.com/russmatney/dino/commit/16575e2a)) feat: dry up metroTravelPoint, add portals between caveOne and shrines

  > Pulls the hatbot elevator impl into a metroTravelPoint, and moves
  > 'elevator' naming to 'travel_point'. Hopefully doesn't break
  > hatbot/demoland travel points.

- ([`2dfd34e1`](https://github.com/russmatney/dino/commit/2dfd34e1)) wip: shrine entrances, growing caveone zone
- ([`4969a565`](https://github.com/russmatney/dino/commit/4969a565)) feat: notice and chase states, enemy chasing player

  > A decent pause between noticing and starting the chase, which is a
  > chance for a fun ui thing, like the exclamation mark in botw.

- ([`befe41c7`](https://github.com/russmatney/dino/commit/befe41c7)) wip: blobChaser color swap and notice box
- ([`5bc5c15f`](https://github.com/russmatney/dino/commit/5bc5c15f)) tweak: misc wandering numbers
- ([`67938a9f`](https://github.com/russmatney/dino/commit/67938a9f)) fix: hurtbox refers to hurting the box's owner

  > Plus flipping when wandering doesn't get stuck on walls.
  > 
  > Adds notice_box collection support, but nothing using it yet.

- ([`3406606d`](https://github.com/russmatney/dino/commit/3406606d)) feat: introduce BlobWalker, a wandering topdown enemy
- ([`c35bb220`](https://github.com/russmatney/dino/commit/c35bb220)) feat: jumping over pits

  > The pit-detection is not very forgiving, but this more or less works.
  > 
  > The PitDetector lives in shirt for now, but should probably move to
  > beehive/topdown. I'm keeping it in shirt b/c the impl feels too specific
  > - more likely we'll want to support a more generic implementation (not
  > something pit-specific, but something for spikes and other traps).

- ([`39dce259`](https://github.com/russmatney/dino/commit/39dce259)) fix: cave one pit tweaks

  > Not all pit shapes work yet - this makes the existing pitDetector areas
  > work.


### 16 Jun 2023

- ([`f2fc9b2d`](https://github.com/russmatney/dino/commit/f2fc9b2d)) wip: first shirt zone
- ([`e8cbd536`](https://github.com/russmatney/dino/commit/e8cbd536)) feat: another pit fall detection impl

  > Settling on this for now. Not perfect, but a v1.

- ([`5b5dd980`](https://github.com/russmatney/dino/commit/5b5dd980)) wip: closer to proper pit area.encloses impl
- ([`52c1273b`](https://github.com/russmatney/dino/commit/52c1273b)) refactor: reusable cells_to_polygon

  > Not a perfect algorithm yet - getting the order right will take some
  > more work. This should work as impled for most non-convex shapes.

- ([`a4ec8b26`](https://github.com/russmatney/dino/commit/a4ec8b26)) refactor: reusable Reptile.cell_clusters()

  > Pulls the cell clustering logic into a reusable Reptile func.

- ([`509d25bc`](https://github.com/russmatney/dino/commit/509d25bc)) feat: shirt player+hud, reusable HUD class

  > Creates a working Shirt PlayerGym.


### 15 Jun 2023

- ([`86b0ea02`](https://github.com/russmatney/dino/commit/86b0ea02)) feat: _very_ basic pit tiles working!
- ([`1aa80aae`](https://github.com/russmatney/dino/commit/1aa80aae)) wip: nearly correct area2D polygons based on tilemaps

  > Not quite getting some of these convex shapes right, but basic shapes
  > are working great!

- ([`21be6b6d`](https://github.com/russmatney/dino/commit/21be6b6d)) fix: fast use_cell clustering?

  > Not sure why, but this is fast now? Maybe was a fluke the first time?
  > Will keep an eye out.

- ([`a23cf20e`](https://github.com/russmatney/dino/commit/a23cf20e)) wip: very slow tile grouping impl
- ([`03559732`](https://github.com/russmatney/dino/commit/03559732)) wip: pit floor tiles and an initial topdown fall state
- ([`cec8b658`](https://github.com/russmatney/dino/commit/cec8b658)) feat: cave floor/wall tile sets
- ([`19bbc6e8`](https://github.com/russmatney/dino/commit/19bbc6e8)) feat: basic topdown cave terrains
- ([`a8f68722`](https://github.com/russmatney/dino/commit/a8f68722)) feat: jump over low-walls/fences
- ([`ed35cda8`](https://github.com/russmatney/dino/commit/ed35cda8)) feat: add topdown player jump
- ([`fd6d0ca3`](https://github.com/russmatney/dino/commit/fd6d0ca3)) feat: working topdown idle/run anim updates

### 13 Jun 2023

- ([`b52141fb`](https://github.com/russmatney/dino/commit/b52141fb)) feat: topdown player controller basic walking
- ([`eab16032`](https://github.com/russmatney/dino/commit/eab16032)) wip: tdbody.gd, tdplayer.gd basic impls

  > No states yet, but here's a bunch of basics pulled over from ssbody and
  > ssplayer.
  > 
  > Topdown is a bunch more animations! up, down, side...

- ([`8b5e6fdc`](https://github.com/russmatney/dino/commit/8b5e6fdc)) wip: init shirt and beehive/topdown

### 5 Jun 2023

- ([`0124b13f`](https://github.com/russmatney/dino/commit/0124b13f)) feat: refactor hatbot enemy machine into sidescroller_enemy

  > These were already sharing a state machine, and now they share a base
  > SSEnemy.gd as well.

- ([`f33eb998`](https://github.com/russmatney/dino/commit/f33eb998)) chore: move bullet, warp spot, position hint into ss_boss

  > Moving more reusable pieces out of hatbot's boss impl and into the
  > shared beehive ss-boss directory.

- ([`fe136a08`](https://github.com/russmatney/dino/commit/fe136a08)) feat: shared SSBoss machine and script

  > Hatbot's bosses are now much DRYer, with some configurable options for
  > can_fire and can_swoop - tho you can't yet do both (swoop wins if set.)

- ([`be01670f`](https://github.com/russmatney/dino/commit/be01670f)) wip: towards share ssBoss impl
- ([`c1f241d3`](https://github.com/russmatney/dino/commit/c1f241d3)) feat: add hatbot BossGym and clean up boss impl

  > Adds more flexible swoop and warping boss state handling, and some more
  > warnings/handling for hatbot/hotel scene registery (handling scenes that
  > crash on load with error logs instead of code crashes).


### 1 Jun 2023

- ([`317bc40b`](https://github.com/russmatney/dino/commit/317bc40b)) feat: pull hatbot powerup into SS/powerups

  > Also shows powerups on metro maps.

- ([`eea9c5bb`](https://github.com/russmatney/dino/commit/eea9c5bb)) feat: basic muting of sound and music in dj debug ui
- ([`c45e1ae3`](https://github.com/russmatney/dino/commit/c45e1ae3)) fix: refactor herd menus to work with Navi.hide_menus
- ([`5b5886d2`](https://github.com/russmatney/dino/commit/5b5886d2)) feat: navi tracking and hiding menus, fixes harvey
- ([`ade92d42`](https://github.com/russmatney/dino/commit/ade92d42)) fix: refactor harvey game logic out of hud, into Harvey.gd
- ([`7fb0ae26`](https://github.com/russmatney/dino/commit/7fb0ae26)) feat: merge harvey sounds into DJZ
- ([`c190be7d`](https://github.com/russmatney/dino/commit/c190be7d)) fix: hotelUI rebuild preserves and rebooks all scene_file_paths
- ([`4a9de604`](https://github.com/russmatney/dino/commit/4a9de604)) feat: basic spike tiles and mechanic impl

  > it hurts! Tho not yet in idle, so you get a chance to jump out of there.

- ([`bc3873d7`](https://github.com/russmatney/dino/commit/bc3873d7)) wip: take_hit/damage DRY up

  > Unifying the hit/damage apis so the weapons work across games. Not yet
  > there for hatbot enemies, but those are going to get a DRY up
  > themselves, so no need to dupe that work just yet.


### 31 May 2023

- ([`e384e5d8`](https://github.com/russmatney/dino/commit/e384e5d8)) feat: weapon notif on activate
- ([`e732f775`](https://github.com/russmatney/dino/commit/e732f775)) feat: cycling weapons via `
- ([`14c292bc`](https://github.com/russmatney/dino/commit/14c292bc)) feat: gun/bullet ssweapon impl, duped bow/arrow impl

  > Still need to distinguish gun from bow, and add support for weapon
  > cycling.

- ([`2d6265a2`](https://github.com/russmatney/dino/commit/2d6265a2)) refactor: rename bullet -> arrow

### 30 May 2023

- ([`21bf903b`](https://github.com/russmatney/dino/commit/21bf903b)) fix: tower pause menu suddenly readable again
- ([`9ba251bc`](https://github.com/russmatney/dino/commit/9ba251bc)) feat: flashlight as a reusable ss weapon
- ([`da24baf8`](https://github.com/russmatney/dino/commit/da24baf8)) feat: basic flashlight ssweapon impl working
- ([`8686f68e`](https://github.com/russmatney/dino/commit/8686f68e)) feat: refactor sword into SSWeapon api
- ([`33a97da9`](https://github.com/russmatney/dino/commit/33a97da9)) wip: ss weapon impl outline

### 29 May 2023

- ([`22433c4e`](https://github.com/russmatney/dino/commit/22433c4e)) wip: toying with world env glow

### 28 May 2023

- ([`da8ffc0a`](https://github.com/russmatney/dino/commit/da8ffc0a)) feat: quick dash sidescroller powerup
- ([`0d604e83`](https://github.com/russmatney/dino/commit/0d604e83)) feat: mountain tile clean up, rain particles

### 27 May 2023

- ([`49f566dd`](https://github.com/russmatney/dino/commit/49f566dd)) wip: move flashlight into ss/weapons
- ([`0a721988`](https://github.com/russmatney/dino/commit/0a721988)) wip: begin ghosts using SSPlayer refactor
- ([`8cc9aae4`](https://github.com/russmatney/dino/commit/8cc9aae4)) feat: pull bullet/sword into beehive

  > Also add sword/bullet_position when adding the related powerup.

- ([`204fed4d`](https://github.com/russmatney/dino/commit/204fed4d)) refactor: ascend/descend as SS.Powerups on SSPlayer
- ([`02f6d706`](https://github.com/russmatney/dino/commit/02f6d706)) chore: drop aoe tile handling for tower/gunner
- ([`69d986cd`](https://github.com/russmatney/dino/commit/69d986cd)) feat: move forced_movement_target to SSPlayer
- ([`0e573852`](https://github.com/russmatney/dino/commit/0e573852)) feat: more hatbot/ssplayer dry up, introduce SS.Powerup enum
- ([`f844213c`](https://github.com/russmatney/dino/commit/f844213c)) chore: move coins from hatbot to ssplayer

  > Also moves more hatbot deps facing logic to ssbody.

- ([`a25065fa`](https://github.com/russmatney/dino/commit/a25065fa)) fix: nil-pun notif, misc other clean up
- ([`b998fd66`](https://github.com/russmatney/dino/commit/b998fd66)) feat: DRY up optional node setting

  > Nice little util here.

- ([`6da32af8`](https://github.com/russmatney/dino/commit/6da32af8)) feat: bullets, effects, actions api on SSBody/Player

  > More side-scroller player DRY up

- ([`f9101e3a`](https://github.com/russmatney/dino/commit/f9101e3a)) feat: nil-pun update_h_flip helpers
- ([`4cfecc48`](https://github.com/russmatney/dino/commit/4cfecc48)) fix: move sel hud dep to sel player script

  > This was intended as a drop-in beu hud, but it isn't yet. there are errors
  > showing for BEUPlayer, maybe this dep is a reason?


### 26 May 2023

- ([`ee71c9b7`](https://github.com/russmatney/dino/commit/ee71c9b7)) chore: delete dead gunner/tower player states
- ([`42a69ba1`](https://github.com/russmatney/dino/commit/42a69ba1)) wip: pull jetpack impl into ssmachine
- ([`2652d9ac`](https://github.com/russmatney/dino/commit/2652d9ac)) wip: refactor gunner player into SSPlayer
- ([`43ad6f1d`](https://github.com/russmatney/dino/commit/43ad6f1d)) fix: remove old monster reference, update demoland
- ([`b94a526a`](https://github.com/russmatney/dino/commit/b94a526a)) chore: drop hatbot monster scene,script,machine

  > Now built on the side-scroller body and machine.

- ([`121747c7`](https://github.com/russmatney/dino/commit/121747c7)) fix: handle optional climb ray casts
- ([`79e05e04`](https://github.com/russmatney/dino/commit/79e05e04)) feat: ssbody impling double jump
- ([`8748340e`](https://github.com/russmatney/dino/commit/8748340e)) feat: ssbody impling climb

  > Pulls the climb impl into the ssmachine. requires high/low/near-ground
  > raycasts with specific node names!

- ([`9750fbef`](https://github.com/russmatney/dino/commit/9750fbef)) feat: update hatbot player take_hit calls to ssbody style

  > Now taking hits with the ssbody! Nearly completely playable - hopefully
  > just the powerups left.

- ([`b79eba51`](https://github.com/russmatney/dino/commit/b79eba51)) feat: refactor hatbot candle into metro checkpoint

  > Also updated to work with Side-scroller bodies


### 25 May 2023

- ([`5ab6914a`](https://github.com/russmatney/dino/commit/5ab6914a)) fix: moving between rooms with new hatbot controller

  > Always it's the collision mask. ought to set that automagically along
  > with the group.
  > 
  > Also fixes a bug in the player's get_rect, tho maybe it should just
  > return the rect and let consumers modify the position. hmmm.

- ([`2c8777a3`](https://github.com/russmatney/dino/commit/2c8777a3)) wip: merging hatbot monster into SSPlayer
- ([`91b307c7`](https://github.com/russmatney/dino/commit/91b307c7)) chore: rename Trolley.move_dir -> Trolley.move_vector
- ([`bbcf27e4`](https://github.com/russmatney/dino/commit/bbcf27e4)) feat: Harvey and Snake as DinoGames

  > Also moves some 'games' over to 'gyms'

- ([`bd87f829`](https://github.com/russmatney/dino/commit/bd87f829)) feat: remove old player spawn points

  > Ghosts and DungeonCrawler now use the dino player-spawn-point.

- ([`0ac2837a`](https://github.com/russmatney/dino/commit/0ac2837a)) fix: defer maybe_spawn_player on new current-scene listener

  > This gives the current scene a chance to load a player before the Game
  > attempts to

- ([`84b945de`](https://github.com/russmatney/dino/commit/84b945de)) wip: tower and gunner as DinoGames

  > Refactor Tower.gd and Gunner.gd into DinoGame inheritors.
  > 
  > Plus a bunch of game menu clean up.


### 24 May 2023

- ([`d024e9cc`](https://github.com/russmatney/dino/commit/d024e9cc)) feat: ghosts registering menus
- ([`11090933`](https://github.com/russmatney/dino/commit/11090933)) wip: DinoGame registering usual navi menus by default

  > Plus adding the mountain pause menu to some other metro games. Dungeon
  > crawler seems to be quite broken!

- ([`d044fe9b`](https://github.com/russmatney/dino/commit/d044fe9b)) fix: correct roomboxes 0,0 positions

  > Rect merge here was maintaining a 0,0 position, this overwrites it with
  > the first non Vector2.ZERO tilemap rect.

- ([`8661910d`](https://github.com/russmatney/dino/commit/8661910d)) feat: some mvania build updates?

  > Wish these wide one-line list diff were readable.

- ([`3cf8c63b`](https://github.com/russmatney/dino/commit/3cf8c63b)) feat: support movement with normal arrow keys
- ([`8c3d26a7`](https://github.com/russmatney/dino/commit/8c3d26a7)) fix: support menu.show() focus cases

  > Ideally this would get solved in a built-in way, not a
  > don't-forget-to-call-Navi.find_focus(menu) after menu.show() way.
  > 
  > Maybe menus always get navi-registered and shown through a navi helper?
  > 
  > Otherwise, how to detect that there's nothing in focus after a
  > menu.show() happens?
  > 
  > I'd really like hitting tab/up/down/some ui button to notice that
  > nothing is in focus when trying to find a neighbor, and then give an
  > opportunity to focus on the current scene - tho in this case, we'd also
  > need to know that there's a menu overlay shown on top of it. Is there a
  > way to know what scene/menu is currently on-top? Maybe navi needs to
  > manage all the menus and the current scene. that might resolve the
  > pause-while-on-dino-menu oddity.

- ([`f7f19eec`](https://github.com/russmatney/dino/commit/f7f19eec)) feat: add 'Dino Menu' option to relevant menus

  > This won't show up in exported games, unless it's the 'dino' build, but
  > it should always show up in the editor-based builds. Feature tags make
  > this fairly simple!
  > 
  > Also extends Navi.find_focus to accept a passed scene, which helps
  > support the fallback focus-first-button approach for
  > non-set_focus-implementing pause/win/gameover overwrite scenes.
  > 
  > Probably still a menu or two left to fix this on - maybe harvey's
  > timeout screen... i'd really like a shared fix for that, not handling it
  > in every case individually.

- ([`a2f95bfb`](https://github.com/russmatney/dino/commit/a2f95bfb)) feat: focus seems to be working

  > Any scene used with Navi.nav_to can impl `set_focus` to handle setting a
  > particular focus after navigation.
  > 
  > A fallback implementation attempts to find a focus if set_focus is not a
  > method on the current scene.
  > 
  > This _might_ compete with grab_focus() in a scene, which could be called
  > by a control node - maybe we want to defer this and check for a focused
  > node via viewport.gui_get_focus_owner first.
  > 
  > Either way, it's nice to be able to play through a few games with just
  > the controller now!


### 23 May 2023

- ([`c040f3a7`](https://github.com/russmatney/dino/commit/c040f3a7)) chore: more focus infra setup

  > This feels bad. why can't these scenes grab focus for me? Maybe I'll
  > call set_focus or do a fallback in Navi.nav_to...
  > 
  > Still, feels like TAB or some get-next-focus (ui_up/ui_down) should move
  > to the next focusable on-screen control, so there's a fallback for
  > handling weird cases instead of having to hard-code every single focus
  > change. Maybe I'm doing it wrong.

- ([`0a30fe4e`](https://github.com/russmatney/dino/commit/0a30fe4e)) wip: more focus debugging
- ([`b417f178`](https://github.com/russmatney/dino/commit/b417f178)) wip: towards handling focused node in menus

  > keyboard/controller menu controls sort of working, but still a bunch of
  > ways it breaks (e.g. pausing).

- ([`c9ea02f6`](https://github.com/russmatney/dino/commit/c9ea02f6)) feat: add 'focused' guard to trolley input wrappers

  > Still need to wrap the rest of the Input usage. Can godot's internal
  > usage just do this for us? Right now d-pad inputs move the editor's
  > focus around, even when focused on the running game.

- ([`9e11460c`](https://github.com/russmatney/dino/commit/9e11460c)) feat: printing joypad input actions in trolley debug panel
- ([`890f76f4`](https://github.com/russmatney/dino/commit/890f76f4)) feat: add joypad controls to input map
- ([`06a2bb24`](https://github.com/russmatney/dino/commit/06a2bb24)) feat: displaying connected controllers in trolley debug
- ([`01e59a0a`](https://github.com/russmatney/dino/commit/01e59a0a)) feat: cleaner Trolley.move_vector, scroll container for inputs
- ([`8a46e7c4`](https://github.com/russmatney/dino/commit/8a46e7c4)) feat: Trolley debug displaying action + key for input events
- ([`2f486c01`](https://github.com/russmatney/dino/commit/2f486c01)) feat: trolley debug panel listing input events
- ([`5a3b3525`](https://github.com/russmatney/dino/commit/5a3b3525)) feat: basic Trolley debug panel as main editor and debug tab

### 22 May 2023

- ([`43dc1db9`](https://github.com/russmatney/dino/commit/43dc1db9)) fix: move from FileAccess.file_exists to ResourceLoader.exists

  > In exported games, the file may not exist because things get remapped
  > over to resources - ResourceLoader.exists is the proper prod-level check
  > for all these use-cases.


### 20 May 2023

- ([`24ad65a5`](https://github.com/russmatney/dino/commit/24ad65a5)) feat: sort of reasonable ish blur shader

  > but not really. The particles are still square, and this needs to be
  > attached to the camera, not added to the world.
  > 
  > but, some learning and exposure to particles/textures/mipmaps/shaders.

- ([`fa62bfa4`](https://github.com/russmatney/dino/commit/fa62bfa4)) wip: towards a blurry particle shader
- ([`7e1b57f3`](https://github.com/russmatney/dino/commit/7e1b57f3)) fix: shorter rest period
- ([`6c25d26a`](https://github.com/russmatney/dino/commit/6c25d26a)) feat: snow particle emitter
- ([`58711713`](https://github.com/russmatney/dino/commit/58711713)) feat: nicer minimap background and margins
- ([`72182ee0`](https://github.com/russmatney/dino/commit/72182ee0)) fix: correct checkpoint positions on map and minimap

  > The logic is right, but the minimap wasn't being resized/redrawn, so
  > the ch.positions weren't getting corrected. Here was ensure the
  > positions are right when first creating them as well.

- ([`eb8bd4c2`](https://github.com/russmatney/dino/commit/eb8bd4c2)) feat: minimap reusing new metroMap components
- ([`71cc1d23`](https://github.com/russmatney/dino/commit/71cc1d23)) chore: more uid churn
- ([`a2151916`](https://github.com/russmatney/dino/commit/a2151916)) refactor: move room border drawing to MetroMapRoom

  > Better and simpler to keep this locally

- ([`6b709b8d`](https://github.com/russmatney/dino/commit/6b709b8d)) fix: set has_player explicitly in enter/exit

  > Rather than calc based on player position, we trust the enter/exit
  > events on the roombox to be correct.
  > 
  > Fixes a bug where the exiting player was still
  > 'contained' (intersecting) the exited room.

- ([`745c6de0`](https://github.com/russmatney/dino/commit/745c6de0)) feat: show checkpoints on map, color change on visited
- ([`fa2940cc`](https://github.com/russmatney/dino/commit/fa2940cc)) feat: quick only-visited map rooms

  > Filters the map build to only include visited rooms.

- ([`caab47e4`](https://github.com/russmatney/dino/commit/caab47e4)) feat: snow, cave, log checkpoints
- ([`917df8dc`](https://github.com/russmatney/dino/commit/917df8dc)) feat: create log-checkpoint art and component
- ([`f08c49ae`](https://github.com/russmatney/dino/commit/f08c49ae)) fix: patrol clean up

  > Some lingering code from the 2d nav exploration

- ([`74f6a8fb`](https://github.com/russmatney/dino/commit/74f6a8fb)) feat: basic checkpoints

  > restore health, respawn here after death.
  > 
  > Needs some more handling (like hiding the action_hint when the player is
  > resting), and they're invisible right now, but should be decent for
  > drop-in checkpoints for SSPlayers going forward.


### 18 May 2023

- ([`f53d0bc0`](https://github.com/russmatney/dino/commit/f53d0bc0)) feat: add metro map to debug overlay's toggles

  > This isn't super visible yet, but it works ok enough, and might be
  > useful for debugging at some point.

- ([`4d1edca8`](https://github.com/russmatney/dino/commit/4d1edca8)) feat: clean up and connect to control.resized

  > Looking pretty good! Well, very basic, but it's working resizing well,
  > so i'm happy so far.

- ([`1e219f97`](https://github.com/russmatney/dino/commit/1e219f97)) feat: navi pause_toggled signal

  > Didn't end up needing this, but here it is.

- ([`a271c56f`](https://github.com/russmatney/dino/commit/a271c56f)) feat: basic resizable MetroMap component

  > Not too shabby! Key was to scale everything according to the parent
  > size, then it works out nicely

- ([`ba17f70a`](https://github.com/russmatney/dino/commit/ba17f70a)) wip: really rough map on pause screen

  > Think I gotta write a separate map component that isn't a node2d to make
  > laying this out/managing a ui map more reasonable.
  > 
  > I _think_ the minimap is a node2d to make camera/panning easier? not sure.

- ([`58a37aff`](https://github.com/russmatney/dino/commit/58a37aff)) feat: break out and reuse MinimapContainer

  > Towards a drop-in metro-based minimap!

- ([`3f3059c4`](https://github.com/russmatney/dino/commit/3f3059c4)) fix: has_player calc using same room.contains_player()

  > DRYs up a room-contains-player calc. We could maybe use the roombox for
  > this instead... i think the logic ends up being the same. Just note that
  > rooms may be paused when we want to run this, which could affect the
  > roombox signals, tho not necessarily the roombox's geometry/collision
  > calcs.

- ([`6354d4cd`](https://github.com/russmatney/dino/commit/6354d4cd)) chore: drop noisy logs
- ([`02d992b3`](https://github.com/russmatney/dino/commit/02d992b3)) refactor: move minimap from hatbot to metro
- ([`8845de39`](https://github.com/russmatney/dino/commit/8845de39)) feat: HUD copy-pasta from super-elevator-level

  > An argument could be made that this should just be the default HUD from
  > Hood... but it'll always get customized eventually.

- ([`224a36e7`](https://github.com/russmatney/dino/commit/224a36e7)) feat: basic mountain pause menu
- ([`7cf59d24`](https://github.com/russmatney/dino/commit/7cf59d24)) feat: mountain main menu
- ([`f386b4a6`](https://github.com/russmatney/dino/commit/f386b4a6)) chore: remove noisy log, misc uid updates

  > These uids will not sit still.

- ([`238a42bd`](https://github.com/russmatney/dino/commit/238a42bd)) feat: impl Descend

  > Little bit trickier - i think I'm glad i duped the code, as it's
  > slightly different logic in ascend vs descend. Can break out some
  > helpers later on. Feels like it'd be good to get all of a raycasts'
  > colliders, not just the first one.

- ([`43cbd282`](https://github.com/russmatney/dino/commit/43cbd282)) feat: basic ascend is working!!

  > This wasn't so bad after all - a raycast and another state in the
  > sidescroller state machine.


### 17 May 2023

- ([`caf1e860`](https://github.com/russmatney/dino/commit/caf1e860)) wip: ascend/descend boilerplate
- ([`e95a7d8d`](https://github.com/russmatney/dino/commit/e95a7d8d)) feat: add actions api to player

  > Extends the actions API to support actions passed in from the player
  > itself. The ActionDetector script ought to be broken out into an Actions
  > autoload that can register an actor and remove some of this
  > connecting/boilerplate.
  > could even return signals to .emit() on for execing and recalcing
  > current_action.

- ([`69def51b`](https://github.com/russmatney/dino/commit/69def51b)) feat: simpleBlur shader
- ([`f255a723`](https://github.com/russmatney/dino/commit/f255a723)) feat: improved parallax - y-scale-0!
- ([`57a39da0`](https://github.com/russmatney/dino/commit/57a39da0)) wip: rough shot at some parallax backgrounds
- ([`c0fbc877`](https://github.com/russmatney/dino/commit/c0fbc877)) fix: don't pause all metro rooms when the player isn't in ANY

  > starting outside a metroRoom was causing _no_ rooms to ever be found,
  > because they were all paused, which led to none of their room_entered
  > signals firing. This fixes that and another bug, where the player global
  > position was used when it might not have fully entered the room yet. now
  > we support a get_rect on the player and a rect.intersects() chec.
  > 
  > Also adds a directional light and some light-occluding tiles

- ([`b04fcc40`](https://github.com/russmatney/dino/commit/b04fcc40)) feat: prefer dev-only markers in get_spawn_coords
- ([`d2d4331d`](https://github.com/russmatney/dino/commit/d2d4331d)) feat: support multiple tilemaps

  > well this was very close to already implemented.

- ([`2e46baec`](https://github.com/russmatney/dino/commit/2e46baec)) wip: rough set of rooms for the mountain
- ([`b0caf5ee`](https://github.com/russmatney/dino/commit/b0caf5ee)) misc: mountain cleanup, first room
- ([`0bfb4264`](https://github.com/russmatney/dino/commit/0bfb4264)) fix: prevent multiple ensure_camera calls from colliding

  > The add_child call is deferred, so here we add a flag to make sure we
  > don't try to spawn another before the first exists.

- ([`c3b0e276`](https://github.com/russmatney/dino/commit/c3b0e276)) fix: don't crash when no nav_agent found
- ([`3e72fb6e`](https://github.com/russmatney/dino/commit/3e72fb6e)) docs: readme top section update

### 16 May 2023

- ([`cbd71a40`](https://github.com/russmatney/dino/commit/cbd71a40)) wip: navigation attempt on sidescroller enemies
- ([`c6a01ac4`](https://github.com/russmatney/dino/commit/c6a01ac4)) wip: towards a patrol state/behavior
- ([`fdbaac40`](https://github.com/russmatney/dino/commit/fdbaac40)) feat: basic wander behavior for npcs/enemies
- ([`ae21acea`](https://github.com/russmatney/dino/commit/ae21acea)) fix: prevent state funcs from being called early

  > Uses a machine-level `transitioning` var to signal that the state
  > helpers (physics_process) should not be called until after enter(), and
  > similarly should not be called after exit().

- ([`6336af48`](https://github.com/russmatney/dino/commit/6336af48)) feat: knockedBack, dying, dead states
- ([`65d0e58e`](https://github.com/russmatney/dino/commit/65d0e58e)) chore: misc animations, config warnings

  > It seems like classes can't inherit config warnings? hopefully just a
  > local issue.

- ([`28d9bf2b`](https://github.com/russmatney/dino/commit/28d9bf2b)) feat: sidescroller jump state based on height+time

  > Much thanks to sjvnnings for this impl
  > 
  > tut vid: https://www.youtube.com/watch?v=IOe1aGY6hXA
  > gist: https://gist.github.com/sjvnnings/5f02d2f2fc417f3804e967daa73cccfd

- ([`2a3793de`](https://github.com/russmatney/dino/commit/2a3793de)) feat: somewhat reasonable variable jump state

  > Not feeling perfect yet, but I want to stop to look into defining jump
  > in terms of height, not speed.

- ([`79a777c7`](https://github.com/russmatney/dino/commit/79a777c7)) wip: initial idle, run, jump, fall impls

  > Jump is variable, but very floaty :/

- ([`73771033`](https://github.com/russmatney/dino/commit/73771033)) feat: pretty print now printing nullables

  > Had to jump through some hoops to support the variadic versions of
  > these, but we're now printing `(0, 0)` instead of filtering them.

- ([`212f36f4`](https://github.com/russmatney/dino/commit/212f36f4)) wip: SSPlayer, Enemy, NPC, SidescrollerGym setup

  > Extends the Game.gd to support DinoGyms, tho not explicitly. (maybe a
  > fallback Gym game is worth it?). Game.maybe_spawn_player now supports a
  > passed player_scene, which for now is a PackedScene.

- ([`8d76fe19`](https://github.com/russmatney/dino/commit/8d76fe19)) wip: initial (empty) states for SSMachine
- ([`7624f4fa`](https://github.com/russmatney/dino/commit/7624f4fa)) feat: initial sidescroller body script

  > Good structure and starting point, based on the BEUBody script.


### 15 May 2023

- ([`9f64ffcf`](https://github.com/russmatney/dino/commit/9f64ffcf)) fix: pretty printer - don't clear bracketted strs
- ([`e553dba1`](https://github.com/russmatney/dino/commit/e553dba1)) feat: mountain infrastructure

  > Creating a new game for the Godot Wild Jam 57: The Mountain.
  > 
  > Includes placeholders for the main menu, hud, player, and first zone,
  > plus a (maybe complete?) implementation of the DinoGame.
  > 
  > This will be a metroidvania-ish, supported by Metro Zones and Rooms.

- ([`5a344520`](https://github.com/russmatney/dino/commit/5a344520)) chore: DinoGame.gd template

  > Make it easier to create new games.

- ([`53d5cfaf`](https://github.com/russmatney/dino/commit/53d5cfaf)) feat: add super elevator level to readme

### 14 May 2023

- ([`d89bf2f3`](https://github.com/russmatney/dino/commit/d89bf2f3)) fix: hide win/death menus when navigating to main menus
- ([`16a6c170`](https://github.com/russmatney/dino/commit/16a6c170)) build: add macos superelevatorlevel export
- ([`f8601f03`](https://github.com/russmatney/dino/commit/f8601f03)) fix: support multiple attackers again

  > The properties can get overwritten when base class exports get
  > added/removed. what a PITA.

- ([`130b41a0`](https://github.com/russmatney/dino/commit/130b41a0)) fix: reverse spawn positions between goons/bosses

  > Could do something more sophisticated here, but w/e.

- ([`45975fd2`](https://github.com/russmatney/dino/commit/45975fd2)) chore: reduce screenshake
- ([`c701954a`](https://github.com/russmatney/dino/commit/c701954a)) feat: status portraits for player, goon, boss
- ([`84938c80`](https://github.com/russmatney/dino/commit/84938c80)) fix: use display_name to show better enemy names
- ([`10eb64a6`](https://github.com/russmatney/dino/commit/10eb64a6)) feat: nav to main menu via Game.gd

  > Supports game-local 'main-menu' usage from navi win, pause, and death
  > menus.

- ([`1ead4616`](https://github.com/russmatney/dino/commit/1ead4616)) feat: quick player palette swap options
- ([`3eaadb05`](https://github.com/russmatney/dino/commit/3eaadb05)) feat: palette swaps on boss character
- ([`ed2c1635`](https://github.com/russmatney/dino/commit/ed2c1635)) feat: support palette swaps via color-swap shader
- ([`a9c36dee`](https://github.com/russmatney/dino/commit/a9c36dee)) feat: quick 'boss' character anims, added to waves
- ([`1c1767c3`](https://github.com/russmatney/dino/commit/1c1767c3)) feat: SEL player death/respawn via Game.gd

  > Moves from an implicit `player.max_health` Hotel restore usage to a
  > passed `setup_fn` callback, updates other consumers.

- ([`6822fc4e`](https://github.com/russmatney/dino/commit/6822fc4e)) fix: lots of is_instance_valid in BEU states

  > This is ugly as hell, and still doesn't really seem to catch everything.
  > It looks like dictionaries that refer to freed instances can't be
  > accessed with 'get' as well, which makes things terrible. probably
  > that's a bug or something i'm doing wrong... this Util.get_ helper
  > didn't quite catch it either.
  > 
  > Any who, the player seems to be respawnable without crashes now.

- ([`025613ef`](https://github.com/russmatney/dino/commit/025613ef)) fix: limit player facing dir updates to walk/jump

  > The real bug was flipping sides while grabbing, which looked odd.

- ([`fe9c6c3e`](https://github.com/russmatney/dino/commit/fe9c6c3e)) refactor: rename player_spawned to player_ready signal in Game.gd

### 13 May 2023

- ([`8c82a1dc`](https://github.com/russmatney/dino/commit/8c82a1dc)) sel: add walls to background
- ([`879fb658`](https://github.com/russmatney/dino/commit/879fb658)) fix: adjust/add lights per SEL stage
- ([`3ae498ac`](https://github.com/russmatney/dino/commit/3ae498ac)) feat: add shadows under characters
- ([`dd922b6d`](https://github.com/russmatney/dino/commit/dd922b6d)) feat: add quick backgrounds to SEL levels

  > Mostly dithering for now... looks better than the wood tiles!


### 12 May 2023

- ([`15691af4`](https://github.com/russmatney/dino/commit/15691af4)) tweak: increase allowed simultaneous attackers
- ([`2232a7f2`](https://github.com/russmatney/dino/commit/2232a7f2)) feat: support passing itch game id to butler-push
- ([`427a3311`](https://github.com/russmatney/dino/commit/427a3311)) chore: add windows build for superelevatorlevel

  > Hopefully it works!

- ([`2427dda5`](https://github.com/russmatney/dino/commit/2427dda5)) feat: superelevatorlevel web and linux builds
- ([`c57b1168`](https://github.com/russmatney/dino/commit/c57b1168)) misc: add link to play DemoLand
- ([`c61b6a4a`](https://github.com/russmatney/dino/commit/c61b6a4a)) feat: add controls text to title screen
- ([`7e0b8b48`](https://github.com/russmatney/dino/commit/7e0b8b48)) feat: basic SEL main menu
- ([`c4900823`](https://github.com/russmatney/dino/commit/c4900823)) feat: initial Boss's Office final level
- ([`ffd2bd98`](https://github.com/russmatney/dino/commit/ffd2bd98)) feat: tweak floor_count, add elevating sound
- ([`75b1149f`](https://github.com/russmatney/dino/commit/75b1149f)) feat: animate between Elevator waves
- ([`7a2dea35`](https://github.com/russmatney/dino/commit/7a2dea35)) feat: super elevator level infers level_idx
- ([`e31bfaf1`](https://github.com/russmatney/dino/commit/e31bfaf1)) fix: better random spawn positions

  > Makes sure enemies tend to not fall on the same point.

- ([`e13784b3`](https://github.com/russmatney/dino/commit/e13784b3)) fix: only warn once on enemy status list overflow
- ([`fe3a0351`](https://github.com/russmatney/dino/commit/fe3a0351)) feat: basic waves/game loop, basic elevator level

  > Can now play a ground floor, then an elevator level with a few waves of
  > enemies.
  > 
  > Introduces a generic spawn_point with a spawn_points group for quickly
  > grabbing spawn positions.

- ([`890d7030`](https://github.com/russmatney/dino/commit/890d7030)) wip: initial ground floor layout and script

  > Just a maybe spawn player dev mode for now.

- ([`85640019`](https://github.com/russmatney/dino/commit/85640019)) fix: misc crashes and fixes

  > Remove collisions with destructibles for now - they crash in a few
  > places b/c most collisions rn expect only BEUBodies to be colliding.
  > 
  > Makes sure the attacker doesn't get hit by the 'thrown/dying' state of
  > the body being attacked.
  > 
  > Prevents dead bodies from colliding or being hit again. Could bring this
  > back when it's less destructive.

- ([`3f63339a`](https://github.com/russmatney/dino/commit/3f63339a)) feat: refactor Die into Dying/Dead, introduce BEUGym

  > A special BEUGym that connects to BEUBody.dead signals to respawn,
  > rather than respawning after every death. Probably doesn't work for the
  > player yet.
  > 
  > Breaks dying apart to fix a bug where folks were just-dying in the
  > middle of a combo.

- ([`6988cea2`](https://github.com/russmatney/dino/commit/6988cea2)) fix: add some faster enemy attack times
- ([`a9ce429d`](https://github.com/russmatney/dino/commit/a9ce429d)) feat: tweak collision shapes for more punches

  > Speeds up player punching and prevents players from swinging and missing
  > so much. If a punchbox is big (like for a goon), they may approach and
  > stop before getting inside the player's punch box, which leads to
  > confusing gameplay. Perhaps the approach shouldn't stop immediately upon
  > the punchbox being filled - taking another step might solve this better.

- ([`40a30cf1`](https://github.com/russmatney/dino/commit/40a30cf1)) refactor: move BEU machine and player into beehive/beatemup

  > Moving toward including ready-made controllers and AI in beehive.
  > 
  > I intend to work with this beatemup controller in multiple games going
  > forward, so opting to move this across the game/addon boundary early to
  > start feeling it out. This makes room for SuperElevatorLevel-specific
  > things to happen with a proper warning/resistance to muddying the
  > game-agnostic addon code.


### 11 May 2023

- ([`ed85a588`](https://github.com/russmatney/dino/commit/ed85a588)) feat: deactivate/activate camPOF in respawn
- ([`16522575`](https://github.com/russmatney/dino/commit/16522575)) feat: add full set of goon animations
- ([`015af39c`](https://github.com/russmatney/dino/commit/015af39c)) feat: config warnings for expected animations

  > Extends the Util._config_warning to support
  > expected_animations={<NodeName>: ['some', 'required', 'animation']}.
  > 
  > This should provide some sanity to subclasses of BEUBody, as there are
  > quite a few required for things to work.

- ([`65382f9a`](https://github.com/russmatney/dino/commit/65382f9a)) feat: add rest of playerOne animations

  > Also adds the playerOne animations to the goon for now.
  > 
  > Looking pretty good!

- ([`518f3bde`](https://github.com/russmatney/dino/commit/518f3bde)) feat: add walk animation and play it in a few states
- ([`742d91c8`](https://github.com/russmatney/dino/commit/742d91c8)) feat: BEU Kick state refactored to use animation

  > Adds the first kick animation to player one, and expands and moves the
  > passive_frames helper to the BEU body. Hopefully this works for a
  > majority of cases, but users can overwrite for specific animations per
  > fighter if there's a need for more specific handling.

- ([`55ee1699`](https://github.com/russmatney/dino/commit/55ee1699)) fix: check_in actor, not state
- ([`6f784b4b`](https://github.com/russmatney/dino/commit/6f784b4b)) feat: punch refactored to work with animation frames

  > Most of the states will probably move in this direction - rather than
  > timers everywhere, we connect to animation events.
  > 
  > Makes a hopefully reasonable assumption about animation frames. I
  > suppose I'm expecting 5+ animation frames per action... woof that's a
  > lot of art. Fortunately the aseprite wizard should keep the overhead
  > down somewhat.

- ([`82c5eebe`](https://github.com/russmatney/dino/commit/82c5eebe)) addon: add AsepriteWizard for aseprite import magic

  > So far, excellent plugin!

- ([`827604b5`](https://github.com/russmatney/dino/commit/827604b5)) feat: PlayerOne, first animations imported
- ([`f3086710`](https://github.com/russmatney/dino/commit/f3086710)) feat: add anim to BEUBody, move punch/kick to states
- ([`f981e91f`](https://github.com/russmatney/dino/commit/f981e91f)) refactor: slight grab state cleanup
- ([`82c345bb`](https://github.com/russmatney/dino/commit/82c345bb)) feat: thrown bodies hit things in their path

  > Until the first bounce. Right now, the collision mask grows to hit
  > everything (players and enemies alike).


### 10 May 2023

- ([`56b55fa5`](https://github.com/russmatney/dino/commit/56b55fa5)) feat: track kos, lives_lost, is_dead in hotel
- ([`08143170`](https://github.com/russmatney/dino/commit/08143170)) feat: die state, respawn with updated health after death
- ([`9a9e487f`](https://github.com/russmatney/dino/commit/9a9e487f)) feat: respawn (fall-in) as default BEUMachine state

  > Definitely a fun one!
  > 
  > Also bumps up the screenshake across the board.

- ([`491bcd21`](https://github.com/russmatney/dino/commit/491bcd21)) feat: add punch/kick sounds

  > DJTurnTable + gdfxr would be a nice integration - towards managing all
  > these sounds.

- ([`a04a372b`](https://github.com/russmatney/dino/commit/a04a372b)) feat: add sounds, screenshake to misc states

  > Could debate where to put these for a long time! Until the animations
  > get added, we don't know the complexity of the timing for sounds...
  > 
  > There's also the question of how to handle different sounds for
  > different players, and then of the names of the sounds themselves - they
  > are quickly drifting. I'd hope it would be easy to interact with the
  > sounds between the DJ TurnTable and gdfxr. Ideally the existing sounds
  > could easily be edited, cloned, renamed, and still included in DJZ.

- ([`2fdf1ec5`](https://github.com/russmatney/dino/commit/2fdf1ec5)) fix: provide escape to Grabbed state

  > Feels like every state should have a default timeout. Maybe that's
  > something Machine could provide.
  > 
  > Maybe it could even handle a dict with enum keys full of opt-in timers.
  > Excited to dry up the state codes in sel/machine/*.
  > 
  > Feels like this is leading to a data-driven state machine api! Assigning
  > to known keys on the State, like `timers`. Then, we hand `delta` to
  > timers inside beehive, so the consumer doesn't have to - could just add
  > a function for reacting to individual timers running out.

- ([`ee5fbba5`](https://github.com/russmatney/dino/commit/ee5fbba5)) fix: pass texture through enemy_status_list

  > Moves to ttl as null means never delete_in, so you now opt-in to
  > deleting statuses instead of opting-out.
  > 
  > Bit of a mess passing these dicts along - i think the hotel entries are
  > edit-in-place, which is maybe a feature? Some entities were getting ttls
  > added b/c they were used as data-maps, not refs.

- ([`43216276`](https://github.com/russmatney/dino/commit/43216276)) fix: quick hack to avoid bidi in pretty printer

  > Structured text (BiDi) was colliding with the pretty printer's
  > structured text. There might be another 'safe' wrapper we could use
  > instead, but w/e this is fine.

- ([`1d5c438a`](https://github.com/russmatney/dino/commit/1d5c438a)) feat: pretty-print indentention on nested arrays/dicts

  > Much more readable for large nested dicts. Only applicable for
  > Debug.prn (print with newlines), not Debug.pr.

- ([`0566c58c`](https://github.com/russmatney/dino/commit/0566c58c)) fix: don't set child instance_name

  > Booking in enter_tree does not seem able to grab the entry's own
  > instance_name. Will dig further. This _might_ break instance_name for
  > everything... really need to get hotel unit-tested for things like this.

- ([`5e05f8cd`](https://github.com/russmatney/dino/commit/5e05f8cd)) misc: scene tweaks... noise!
- ([`08e8ff06`](https://github.com/russmatney/dino/commit/08e8ff06)) feat: basic HUD showing player and goon health
- ([`2cbff9ae`](https://github.com/russmatney/dino/commit/2cbff9ae)) fix: don't delete entity status with ttl == 0

  > The entityStatus component is setup to queue_free after some ttl - you
  > can opt out by setting ttl = 0. This removes a bug that tried to kill
  > the status component when the enemy ran out of health. Hatbot might need
  > to manually clear boss statuses now...

- ([`430b9bb6`](https://github.com/russmatney/dino/commit/430b9bb6)) feat: HeartContainer adds more HeartIcons

  > If the player has more than 6 health, the heartContainer will add more
  > hearts to show that.

- ([`9b9aba5c`](https://github.com/russmatney/dino/commit/9b9aba5c)) feat: reusable EntityStatusList

  > factored out of Hatbot.

- ([`dce4fdfe`](https://github.com/russmatney/dino/commit/dce4fdfe)) refactor: rename enemyStatus -> entityStatus
- ([`cbb4d23d`](https://github.com/russmatney/dino/commit/cbb4d23d)) feat: health/damage from punched/kicked/thrown states

  > Adds hotel 'health' tracking to BEUBody, and impls a basic health/damage
  > system based on punch/kick/throw power, weight, and defense.

- ([`9f7cb344`](https://github.com/russmatney/dino/commit/9f7cb344)) feat: shrink grab box sizes

  > Not sure yet how this feels - adding sounds and art should help evaluate
  > it better, but i think making them smaller/closer to the center of the
  > body is a good step for now.

- ([`3fc0da80`](https://github.com/russmatney/dino/commit/3fc0da80)) fix: don't clear target body in attack, approach

  > These do get cleared, but not every on every exit.
  > 
  > I suspect these kinds of patterns point toward nested FSMs, but
  > hopefully we don't need to get into those just yet.

- ([`5447fcde`](https://github.com/russmatney/dino/commit/5447fcde)) feat: give goons a circle for detecting attackers

  > Also adjusts some punch speed opts

- ([`0dc414b5`](https://github.com/russmatney/dino/commit/0dc414b5)) fix: this was wrong, and messes with the player control

  > Only set the next_state if it's passed!

- ([`bf46b9a1`](https://github.com/russmatney/dino/commit/bf46b9a1)) fix: remove facing update from shared BEUBody

  > This really only applies to the player, as we'll want enemies to face
  > the player and walk backwards when rope-a-doping.

- ([`467bd60f`](https://github.com/russmatney/dino/commit/467bd60f)) chore: slower enemy walk speed.

  > We'll actually want this for every goon, not set by hand...

- ([`777476a2`](https://github.com/russmatney/dino/commit/777476a2)) feat: add a bounce to the throw animation

  > Also removes 'thrown' from the thrown_by's attackers.

- ([`73ded614`](https://github.com/russmatney/dino/commit/73ded614)) fix: set target once, not every process loop

  > A good example of a state process loop no-no: resetting the target
  > destination every call instead of moving towards it for the whole state.

- ([`49668129`](https://github.com/russmatney/dino/commit/49668129)) wip: enemy ai via Notice, Circle, Approach, Attack states

### 9 May 2023

- ([`c4684c35`](https://github.com/russmatney/dino/commit/c4684c35)) wip: rudimentary goon ai
- ([`5c5da143`](https://github.com/russmatney/dino/commit/5c5da143)) fix: use move_vector in wander to support enemy facing_vector update
- ([`31728688`](https://github.com/russmatney/dino/commit/31728688)) feat: beu enemy wander state
- ([`6b56292d`](https://github.com/russmatney/dino/commit/6b56292d)) feat: pull shared logic into BEUBody

  > Attempting to share code for beat em up players and enemies. Each still
  > needs to create and assign hitboxes and animation nodes, but the code
  > may be mostly write-once.

- ([`34cf7c17`](https://github.com/russmatney/dino/commit/34cf7c17)) feat: add kick to punch combo

  > Also requires hits to progress through the combo.

- ([`c8d9b937`](https://github.com/russmatney/dino/commit/c8d9b937)) feat: jump kicks, kicked state, exit grabbed fix
- ([`53c5d966`](https://github.com/russmatney/dino/commit/53c5d966)) feat: initial grab, throw, grabbed, thrown states

  > Tossing goons around!

- ([`c42abbd1`](https://github.com/russmatney/dino/commit/c42abbd1)) feat: punch, punched, basic combo
- ([`ff0bcabb`](https://github.com/russmatney/dino/commit/ff0bcabb)) feat: basic jump state impled
- ([`14858d2c`](https://github.com/russmatney/dino/commit/14858d2c)) docs: mention quest, herd
- ([`a531c07f`](https://github.com/russmatney/dino/commit/a531c07f)) init: Super Elevator Level, shared state machine, player + enemy

### 8 May 2023

- ([`ab6223fe`](https://github.com/russmatney/dino/commit/ab6223fe)) fix: restore overwritten exports

  > Apparently godot needs a restart after fetching new/changes to exports.

- ([`99c9b6d3`](https://github.com/russmatney/dino/commit/99c9b6d3)) wip: dino-macos build
- ([`211f911a`](https://github.com/russmatney/dino/commit/211f911a)) feat: dino linux, windows builds
- ([`69491b14`](https://github.com/russmatney/dino/commit/69491b14)) fix: bb tasks need :extra- prefix for :deps

### 6 May 2023

- ([`4f7fd541`](https://github.com/russmatney/dino/commit/4f7fd541)) feat: some tut levels and then a...rearrangement
- ([`155c32ef`](https://github.com/russmatney/dino/commit/155c32ef)) feat: arrow showing player current facing dir

  > Helpful to know before throwing.
  > 
  > Alternatively, some art?

- ([`74394a29`](https://github.com/russmatney/dino/commit/74394a29)) wip: sheep 'hop' impled

  > maybe this is working? seems the robots leap too far sometimes? not sure
  > what that's about.

- ([`36b89cdc`](https://github.com/russmatney/dino/commit/36b89cdc)) feat: add green box to sheep pen collision shape

  > Could pull a util out of this for re-use at some point.
  > 
  > Would also be nice to add color to arbitrary collision shapes.


### 5 May 2023

- ([`3842ca89`](https://github.com/russmatney/dino/commit/3842ca89)) feat: sounds for a bunch of lil things
- ([`487e07bd`](https://github.com/russmatney/dino/commit/487e07bd)) feat: dj turntable reload, stop button

  > So we can stop songs we accidentally start.

- ([`d9ed6c76`](https://github.com/russmatney/dino/commit/d9ed6c76)) feat: add DJ TurnTable to debug overlay and editor main scene

  > Quick little infra to get the DJZ sounds playable in the editor and
  > in-game.

- ([`77ed8de2`](https://github.com/russmatney/dino/commit/77ed8de2)) feat: initial DJ sounds UI

  > Had to move all the sounds onto a named enum so that the keys could be
  > listed with enum.keys().

- ([`67454856`](https://github.com/russmatney/dino/commit/67454856)) refactor: pull EnemyStatus out of hatbot, into Hood
- ([`5145fa8c`](https://github.com/russmatney/dino/commit/5145fa8c)) feat: show sheep + health in HUD
- ([`f4a810b1`](https://github.com/russmatney/dino/commit/f4a810b1)) fix: much larger quest font
- ([`e9e7fa71`](https://github.com/russmatney/dino/commit/e9e7fa71)) fix: restore credits view

  > This has been broken, probably since godot 3->4 switch.

- ([`6c1778da`](https://github.com/russmatney/dino/commit/6c1778da)) feat: use next-level-menu for win, show sheep saved
- ([`1471c1ca`](https://github.com/russmatney/dino/commit/1471c1ca)) feat: Navi.add_menu passes back existing menu

  > Rather than creating a new one.

- ([`0e42c821`](https://github.com/russmatney/dino/commit/0e42c821)) feat: button_list supporting rebuild and hide_fn
- ([`c7fbf56e`](https://github.com/russmatney/dino/commit/c7fbf56e)) feat: tracking sheep.is_dead in hotel
- ([`0774eb59`](https://github.com/russmatney/dino/commit/0774eb59)) fix: set scene_file_path when scene passed

  > Finally figure this one out - the var is a different name on a scene vs
  > a resource.

- ([`3f40bbfb`](https://github.com/russmatney/dino/commit/3f40bbfb)) feat: prevent grab when moving, calc current_ax more often

  > A bit concerned about calcing current_action all the time, but maybe
  > it's fine for some games

- ([`b8d06d68`](https://github.com/russmatney/dino/commit/b8d06d68)) fix: hide menu even when retrying a level
- ([`57230ab3`](https://github.com/russmatney/dino/commit/57230ab3)) fix: action hint z-index, bring text on-top
- ([`eb0c00e1`](https://github.com/russmatney/dino/commit/eb0c00e1)) fix: prevent 'calling' a sheep while it is 'thrown'
- ([`c54c98b3`](https://github.com/russmatney/dino/commit/c54c98b3)) feat: impl action cycling

  > Can now use tab/shift-tab to cycle through available actions

- ([`6646c670`](https://github.com/russmatney/dino/commit/6646c670)) chore: drop noisey logs
- ([`e0cd6190`](https://github.com/russmatney/dino/commit/e0cd6190)) feat: add optional label to offscreen indicator
- ([`cf2ee199`](https://github.com/russmatney/dino/commit/cf2ee199)) feat: offscreen indicator animation
- ([`da02d325`](https://github.com/russmatney/dino/commit/da02d325)) fix: initial hud player state
- ([`4e5381de`](https://github.com/russmatney/dino/commit/4e5381de)) fix: use proper offscreen indicator sprite
- ([`2f5a3acc`](https://github.com/russmatney/dino/commit/2f5a3acc)) feat: all-sheep-dead restart-level jumbotron
- ([`b1ca7c92`](https://github.com/russmatney/dino/commit/b1ca7c92)) feat: move fence to unique collision layer

  > No more jumping/throwing sheep over any old wall - now we have an
  > explicit layer for 'jumpable' fences.

- ([`3ba7dcaa`](https://github.com/russmatney/dino/commit/3ba7dcaa)) feat: restart level via jumbotron, prevent hits after death

  > Also restores player and sheep health when loading a level.

- ([`1ac7fdbe`](https://github.com/russmatney/dino/commit/1ac7fdbe)) feat: explicit DinoGame.should_spawn_player(scene)

  > So we don't spawn the player in Herd menus.

- ([`f8b49565`](https://github.com/russmatney/dino/commit/f8b49565)) refactor: cleaner jumbotron impl

  > Rather than return a signal and leak the impl, we support a passed
  > one-shot callback when the jumbotron is closed. Also removes the
  > multi-param support, which isn't used anywhere.

- ([`2ff90b73`](https://github.com/russmatney/dino/commit/2ff90b73)) fix: make sure cam instance is valid

### 4 May 2023

- ([`05a2017d`](https://github.com/russmatney/dino/commit/05a2017d)) feat: herd next level menu impl

  > Plus some commented-out Game.gd ideas.
  > 
  > Game is now playable all the way to a win screen!

- ([`37d2c93c`](https://github.com/russmatney/dino/commit/37d2c93c)) feat: herd main menu, manages_scene passing scene

  > No more scene_file_path passing, no consumers for it.

- ([`3fd49da0`](https://github.com/russmatney/dino/commit/3fd49da0)) fix: wolf line-of-sight raycast was not working at all

  > Also adds a quick level 2.
  > 
  > This probably updates more aggressively than is necessary - should
  > instead keep a list via _process or _physics_process.
  > 
  > Not super happy with the fire then clear just to find_target again, it's
  > kind of weird and goes across state files.

- ([`2c6c0251`](https://github.com/russmatney/dino/commit/2c6c0251)) feat: level one.

  > Pretty boring.

- ([`1b4215cb`](https://github.com/russmatney/dino/commit/1b4215cb)) refactor: pull SheepPen into scene

  > Perhaps this should be attached to the quest node by default, or a
  > sibling of it.... either way, this saves the trouble of manually setting
  > the area2d's collision layer every time.

- ([`369de243`](https://github.com/russmatney/dino/commit/369de243)) feat: add quest status to HUD
- ([`afc77e7e`](https://github.com/russmatney/dino/commit/afc77e7e)) chore: some unique-ids that can't sit still
- ([`ec61e157`](https://github.com/russmatney/dino/commit/ec61e157)) feat: impl quest for returning sheep to a 'pen'

  > Reusing the dino quest addon. Some improvements could be made, but it's
  > not too bad for supporting some basic logic. Needs some UI integration.
  > 
  > Should probably pull the SheepPen area2d and it's connect logic out, but
  > maybe there's some other reusable way to cut out the entered/exited
  > bodies pattern.

- ([`3f9146a1`](https://github.com/russmatney/dino/commit/3f9146a1)) feat: Util for cleaner _config_warning api
- ([`f92cbc6f`](https://github.com/russmatney/dino/commit/f92cbc6f)) feat: add pretty print to ActiveQuest node

  > This could use a better name! Maybe just QuestNode or QuestObj?

- ([`8792163d`](https://github.com/russmatney/dino/commit/8792163d)) feat: player jumping over walls, animate throw/jump

  > little tween/scale effect goes a long way here!

- ([`032a4aae`](https://github.com/russmatney/dino/commit/032a4aae)) feat: toggle sheep wall collision while thrown

  > Can now throw sheep over walls. Woo!

- ([`d6556f8d`](https://github.com/russmatney/dino/commit/d6556f8d)) feat: connect player/sheep dying signals

  > cleaning up references to dying nodes.

- ([`ed639c20`](https://github.com/russmatney/dino/commit/ed639c20)) feat: sheep hit/dead handling
- ([`a7c41d6a`](https://github.com/russmatney/dino/commit/a7c41d6a)) feat: Util.play_then_return

  > Helper for playing an animation, then returning to whatever was already playing.

- ([`b8d1cb7b`](https://github.com/russmatney/dino/commit/b8d1cb7b)) wip: player hit and death states

  > Some animations and initial machine states for hit and death.

- ([`e90cc886`](https://github.com/russmatney/dino/commit/e90cc886)) fix: check if homing_target has been freed

  > Another BulletUpHell crash - after freeing the player, this line was
  > crashing. The crash is strange - it shouldn't happen b/c of this `get`,
  > it should happen later when we try to use the value. For whatever reason
  > using the dictionary[key] syntax was fine.
  > 
  > Feels like a bug in gdscript? Either way, we probably want to check if
  > the instance is valid before continuing in this conditional.

- ([`93c42c53`](https://github.com/russmatney/dino/commit/93c42c53)) feat: bullet/spawnPatterns on wolf, home by group

  > Moves the bullet/spawnPatterns back to the wolf scene, drops the
  > HerdBulletPatterns autoload. The bullet/spawnPattern ids are updated to
  > per-instance ids in _enter_tree(), which lets us manage the wolves'
  > patterns on the wolf itself, which is nice. Hopefully this won't lead to
  > performance issues, but that should be capped somewhat by the pool size.
  > 
  > Moves the homing logic to use groups instead of using
  > Spawning.change_property to update a node_path. This is a bit cleaner
  > and probably feels better from a gameplay perspective anyway, and
  > removes some of the need for a `target` reference on the wolf itself.


### 3 May 2023

- ([`0864c26f`](https://github.com/russmatney/dino/commit/0864c26f)) feat: screenshake on hit, initial HUD displaying health

  > Basic HUD, pretty simple! Could think about the HeartsContainer
  > listening to Hotel itself... or maybe opting in to whatever
  > groups/keys/etc it gets its data from...

- ([`3dff165c`](https://github.com/russmatney/dino/commit/3dff165c)) feat: bullets on enemy-projectile collision layer

  > Also adds hotel-based health to player and sheep.

- ([`be4cdce0`](https://github.com/russmatney/dino/commit/be4cdce0)) feat: wolves firing homing bullets!
- ([`56fbfc2b`](https://github.com/russmatney/dino/commit/56fbfc2b)) fix: some BulletUpHell fixes

  > Update change_property to work again (call_deferred never returns.).
  > There are few more functions like this that could use the same refactor,
  > as they probably don't work.
  > 
  > Impl some fallbacks if some homing properties are missing (node_homing,
  > homing_steer, homing_duration). Set a better default for homing_steer so
  > it doesn't zero out by default.
  > 
  > Add expected 'symmetric' prop to remaining SpawnPatterns (prevents
  > crashes in a few spots).
  > 
  > It feels like there will be more lurking bugs - for my usage, I'd like
  > to update props in code, but most of them seem to be set/handled in
  > _ready().
  > 
  > I'm using the lib like this from code:
  > 
  > ```
  > Spawning.change_property('bullet', 'bulletPattern1', 'homing_target', target.get_path())
  > Spawning.change_property('bullet', 'bulletPattern1', 'homing_steer', 100)
  > Spawning.change_property('bullet', 'bulletPattern1', 'homing_duration', 3)
  > Spawning.spawn(self, 'spawnPattern1')
  > ```


### 2 May 2023

- ([`554bf1bc`](https://github.com/russmatney/dino/commit/554bf1bc)) wip: trying to make bulletUpHell work

  > Just trying to have two wolves fire. So far, the plugin's unique_id
  > usage seems to prevent a second instance of the 'same' bullet spawner
  > from working.

- ([`229b435c`](https://github.com/russmatney/dino/commit/229b435c)) dep: vendorize BulletUpHell

  > Pulls in BulletUpHell latest for some godot bullet hell magic!
  > Many thanks to Dark-Peace for the addon!

- ([`04183293`](https://github.com/russmatney/dino/commit/04183293)) feat: wolves idle/firing impls

  > No fire yet, but setting/unsetting target is working as expected.

- ([`89d1e46c`](https://github.com/russmatney/dino/commit/89d1e46c)) feat: basic wolf with los and detectbox
- ([`6f647096`](https://github.com/russmatney/dino/commit/6f647096)) feat: grab and throw sheep

  > Impled a quick Util.get_(opts, key, default) so that dictionaries with
  > nil values on keys don't get set. So don't use nil to overwrite values
  > if you're going to use this function!
  > 
  > Also add support for a maximum distance to actions. it might actually be
  > a minimum distance? but you have to be 'below' it for it to be true, and
  > i could see some minimum distance coming into play later on. The default
  > proximity check is just that the actor is in the actionArea itself, so
  > this lets us be more specific per action.

- ([`5d473d64`](https://github.com/russmatney/dino/commit/5d473d64)) fix: restore .gdignore

  > No need to parse/show these files in the editor.

- ([`f64586f7`](https://github.com/russmatney/dino/commit/f64586f7)) refactor: capitalize Machine/State, fix script_templates

  > Found a lowly prefix `s` in my templates_search_path settings. what a headache!

- ([`0bde3955`](https://github.com/russmatney/dino/commit/0bde3955)) feat: sheep follow player after 'call'
- ([`942815ba`](https://github.com/russmatney/dino/commit/942815ba)) feat: basic sheep calling
- ([`84a89179`](https://github.com/russmatney/dino/commit/84a89179)) fix: set a zoom margin
- ([`999ca138`](https://github.com/russmatney/dino/commit/999ca138)) feat: show action_hint on action_area/sources

  > ActionHints can now be shown on the source itself, rather than on the
  > player. This might be better in almost every case.

- ([`4fd2ffd5`](https://github.com/russmatney/dino/commit/4fd2ffd5)) feat: typical action api setup

  > Players can 'call' to sheep.

- ([`ed697e11`](https://github.com/russmatney/dino/commit/ed697e11)) feat: init sheep with basic anim and state machine
- ([`e50b781e`](https://github.com/russmatney/dino/commit/e50b781e)) feat: basic colors for idle/run states
- ([`0e515672`](https://github.com/russmatney/dino/commit/0e515672)) feat: basic player movement
- ([`21301490`](https://github.com/russmatney/dino/commit/21301490)) feat: init Herd

  > Moves Game, DinoGame, PlayerSpawnPoint into src/dino/*.
  > 
  > Creates DinoGym with a maybe_spawn_player. Impls manages_scene with
  > simple sfp.contains(/src/herd).
  > 
  > Attempts to make script_templates work, but no luck.

- ([`6b6369ba`](https://github.com/russmatney/dino/commit/6b6369ba)) feat: runner camera improvements

  > Also adds hotel and ensure_hud to the runner player, but nothing much
  > else for now.


### 1 May 2023

- ([`bf83b43a`](https://github.com/russmatney/dino/commit/bf83b43a)) refactor: pull Actions API and comps in to Trolley

  > More Hood diaspora, now feeding into Trolley, where actions and controls
  > will be friends.

- ([`2f47a463`](https://github.com/russmatney/dino/commit/2f47a463)) feat: pull jumbotron out of Hood and into Quest addon
- ([`2721f5dc`](https://github.com/russmatney/dino/commit/2721f5dc)) refactor: move Quests into it's own addon
- ([`83b3ba4d`](https://github.com/russmatney/dino/commit/83b3ba4d)) feat: Hotel.book supporting node

  > Hotel.book now handles a node, and is expected mostly from
  > _enter_tree(), unless you are pre-emptively passing paths to a games
  > maps to support connecting things like elevators.
  > 
  > Adds dungeonCrawler player to hotel to test it.
  > 
  > This is big b/c otherwise Hotel wasn't working unless the nodes existed
  > in a pre-registered 'root' scene, which is not a limitation we care to continue.

- ([`9bd38089`](https://github.com/russmatney/dino/commit/9bd38089)) refactor: big sound DRY up

  > Pulls all SoundMaps into DJZ.play(DJZ.<some-key>).
  > 
  > Naming can be better, but now we've done away with string keys, so
  > things should be simple to clean up as needed.

- ([`eddcf2ac`](https://github.com/russmatney/dino/commit/eddcf2ac)) refactor: drop Hood.player in favor of Game.player

  > Hood took on some player state in it's initial impl, but it's time to
  > let the professionals deal with it.

- ([`8e0233fd`](https://github.com/russmatney/dino/commit/8e0233fd)) chore: update danger.russmatney.com links

### 29 Apr 2023

- ([`bc16df0b`](https://github.com/russmatney/dino/commit/bc16df0b)) feat: gunner hud break-the-targets data via Hotel

  > Adding the 'quests' as a root group to make this work for now, but we
  > should probably improve the key building to 'just-work'. Not sure how
  > just yet - can we determine the place in the tree at 'book' time?
  > probably not from the scene_file_path, but we probably can in
  > _enter_tree().
  > 
  > Also pretty brittle - using strings in hud to pull hotel keys/data that
  > other nodes checked in. could instead grab data or a whole component
  > from the quest node? Can we grab actual nodes from hotel?

- ([`6459066c`](https://github.com/russmatney/dino/commit/6459066c)) fix: Util.animate requires node.anim :/
- ([`5595109f`](https://github.com/russmatney/dino/commit/5595109f)) refactor: gunner health/pickups HUD via hotel

### 28 Apr 2023

- ([`6bce4ba7`](https://github.com/russmatney/dino/commit/6bce4ba7)) refactor: DRY up OffscreenIndicator, animate/animate_rotate
- ([`d273229e`](https://github.com/russmatney/dino/commit/d273229e)) refactor: move menus+credits into src/dino/*
- ([`14d2f99e`](https://github.com/russmatney/dino/commit/14d2f99e)) chore: delete dead gyms/runner games/dinocamera2d
- ([`e167ebe5`](https://github.com/russmatney/dino/commit/e167ebe5)) fix: restore runner leaf/ground sprites
- ([`0824c65b`](https://github.com/russmatney/dino/commit/0824c65b)) refactor: drop Util.ensure_connection for Util._connect

  > Much cleaner!

- ([`8621eddd`](https://github.com/russmatney/dino/commit/8621eddd)) feat: snake, uh, sort of playable again

### 27 Apr 2023

- ([`08e08143`](https://github.com/russmatney/dino/commit/08e08143)) fix: restore most of snake's gameplay

  > still missing the grid-clearing

- ([`ebf0de97`](https://github.com/russmatney/dino/commit/ebf0de97)) feat: restore pluggs!

  > new lil tilemap, fixed anim.animation = to anim.play(), misc cleanup.

- ([`afc7fa2b`](https://github.com/russmatney/dino/commit/afc7fa2b)) fix: restore tower jet playthrough

  > Dropped the first level b/c it's... gone?
  > 
  > The rest don't have the same tiles they used to... reptile's tile gen
  > needs a rework anyway, so we'll save it for that.

- ([`7e62a0e8`](https://github.com/russmatney/dino/commit/7e62a0e8)) chore: drop unused tiles
- ([`7b00f6a1`](https://github.com/russmatney/dino/commit/7b00f6a1)) feat: restore player hud

  > It loads, health and notifs work. break targets/enemies remaining won't
  > get restored yet b/c they ought to go through hotel.

- ([`e245b4e1`](https://github.com/russmatney/dino/commit/e245b4e1)) fix: bullet player .is_dead flag, redraw enemy robot gym
- ([`78ff1ead`](https://github.com/russmatney/dino/commit/78ff1ead)) fix: redraw target gym, pickup gym

  > Also pre-empts a potential invalid instance in camera code

- ([`63404335`](https://github.com/russmatney/dino/commit/63404335)) fix: update pickup collision layers
- ([`7ed67f1e`](https://github.com/russmatney/dino/commit/7ed67f1e)) fix: set reasonable notif font on gunner player
- ([`b23266e0`](https://github.com/russmatney/dino/commit/b23266e0)) refactor: gunner player gym redraw tilemap
- ([`d4967b05`](https://github.com/russmatney/dino/commit/d4967b05)) feat: include notifications in fallback hud

  > Refactors the Hood.ensure_hud to allow the fallback hud to include
  > components that depend on Hood. The lesson is that an autoload can't
  > preload a scene that depends on the same autoload (circular dep).
  > 
  > Now we get notifs for free with a simple Hood.ensure_hud() in any
  > node (likely the player).

- ([`88ab2dd1`](https://github.com/russmatney/dino/commit/88ab2dd1)) fix: better gunner camera defaults

  > copied from ghost house

- ([`14c751d5`](https://github.com/russmatney/dino/commit/14c751d5)) feat: add a POI to the target

  > Doesn't make much difference, but it's something

- ([`21eaf467`](https://github.com/russmatney/dino/commit/21eaf467)) fix: drop break-the-targets hud dep

  > This kind of quest should get reimpled in terms of hotel, and the
  > hud/game can read the state from there.

- ([`334d609b`](https://github.com/russmatney/dino/commit/334d609b)) fix: target use new animation.play() func

  > Setting the animation silently does nothing since godot 4.
  > 
  > Also, the animation never 'finishes' if it's looping, so we had to tweak
  > that too.

- ([`c7f80c53`](https://github.com/russmatney/dino/commit/c7f80c53)) fix: cam2d handles pois being freed
- ([`cf02ff30`](https://github.com/russmatney/dino/commit/cf02ff30)) fix: remove text effects (and noisy errors) from gunner player

  > The text effects seem to throw errors - not sure why, disabling for now.


### 25 Apr 2023

- ([`a692d1bc`](https://github.com/russmatney/dino/commit/a692d1bc)) chore: restore harvey deformation animations
- ([`b47cb6b8`](https://github.com/russmatney/dino/commit/b47cb6b8)) chore: delete src/_old script examples
- ([`11fa9b86`](https://github.com/russmatney/dino/commit/11fa9b86)) fix: missing commas in credits
- ([`e407cfa7`](https://github.com/russmatney/dino/commit/e407cfa7)) chore: drop demo plugins

  > Maybe useful reading at some point, but no need for the noise when we've
  > got so much going on already.

- ([`db905ae7`](https://github.com/russmatney/dino/commit/db905ae7)) chore: drop MaxSizeContainer
- ([`6a4d216a`](https://github.com/russmatney/dino/commit/6a4d216a)) chore: drop todo.org

  > This is going to come from the org mind garden instead.

- ([`ad638ab3`](https://github.com/russmatney/dino/commit/ad638ab3)) docs: readme refresh
- ([`bd984cac`](https://github.com/russmatney/dino/commit/bd984cac)) docs: update readme to include latest credits
- ([`e0949aa4`](https://github.com/russmatney/dino/commit/e0949aa4)) chore: drop unused fonts, update credits

  > Adds attributions for all externally used assets. There are still some
  > sulosounds songs in the repo, but they can be added when they get used.


### 13 Apr 2023

- ([`a96f87ee`](https://github.com/russmatney/dino/commit/a96f87ee)) wip: towards setting current room in ghosts hud
- ([`6be9b3bb`](https://github.com/russmatney/dino/commit/6be9b3bb)) fix: support hotel.query({scene_file_path='some-path'})

  > Perfectly explains why things were odd, forgot to support this key in
  > hotel.query. Could reach for a generic dictionary match similar to the
  > ensure_camera options pattern that was just impled.

- ([`c42d8750`](https://github.com/russmatney/dino/commit/c42d8750)) fix: larger hotel UI fonts

  > Clicking on a db entry now at least focuses the name, which sets a
  > background.

- ([`fdc6e518`](https://github.com/russmatney/dino/commit/fdc6e518)) refactor: GhostHouse impling DinoGame, using Hotel

  > Not quite perfect, but mostly working.

- ([`76bfe76b`](https://github.com/russmatney/dino/commit/76bfe76b)) chore: rearrange MetroRoom - ready on top
- ([`367ee51b`](https://github.com/russmatney/dino/commit/367ee51b)) feat: hotel.check_in_sfp, ghosts player data via hotel

  > Moves ghosts player data mgmt to hotel, cleans up ghosts autoload.
  > 
  > Adds a new hotel check_in_sfp func for updating an entry when you only
  > have the scene_file_path.

- ([`d06cf573`](https://github.com/russmatney/dino/commit/d06cf573)) feat: cam support arbitrary cam opts

  > Can now overwrite any camera param via ensure_camera

- ([`54b00e08`](https://github.com/russmatney/dino/commit/54b00e08)) refactor: ensure_camera expects data-dict

  > sets mode to FOLLOW_AND_POIS by default.
  > 
  > I'm not totally sure the player option is required here - it probably
  > helps reparent in situations where the player is recreated.

- ([`1de7c76a`](https://github.com/russmatney/dino/commit/1de7c76a)) feat: ensure_camera zoom_rect_min, zoom_margin_min opts

### 11 Apr 2023

- ([`06ef39f6`](https://github.com/russmatney/dino/commit/06ef39f6)) fix: move to juicy cam in ghosts
- ([`781bd511`](https://github.com/russmatney/dino/commit/781bd511)) fix: ghosts using hearts container component
- ([`f1d26367`](https://github.com/russmatney/dino/commit/f1d26367)) refactor: ghosts using Hood.notif, and Hood.ensure_hud
- ([`0b079970`](https://github.com/russmatney/dino/commit/0b079970)) chore: convert dictionaries to non-string plus =
- ([`6196b555`](https://github.com/russmatney/dino/commit/6196b555)) chore: refactor callable, emit_signal, call_deferred usage

  > godot 4's callable and signal improvements allow us to avoid the use of
  > strings in these functions, so here's a fix-it-everywhere commit for the
  > remaining uses of strings as functions/signals.

- ([`2ff24a60`](https://github.com/russmatney/dino/commit/2ff24a60)) refactor: ghost player/door using actions api

  > Now showing travel as an action hint

- ([`5a4c7ab6`](https://github.com/russmatney/dino/commit/5a4c7ab6)) chore: misc plugin enter_tree log clean up

### 9 Apr 2023

- ([`91388362`](https://github.com/russmatney/dino/commit/91388362)) chore: fix maze link
- ([`7481c78f`](https://github.com/russmatney/dino/commit/7481c78f)) refactor: move print() to Debug.pr()

  > Reorders some autoloads, which and fixes some side-effects (debug
  > overlay showing via debug_label and ensure_debug_overlay)

- ([`72866fb9`](https://github.com/russmatney/dino/commit/72866fb9)) refactor: use Metro.zones_group, Metro.rooms_group

  > Instead of hard-coded strings.

- ([`e33b5c23`](https://github.com/russmatney/dino/commit/e33b5c23)) fix: move metro.gd to plugin.gd

  > OSX is case-insensitive, so we can't have both metro.gd and Metro.gd

- ([`778d3eeb`](https://github.com/russmatney/dino/commit/778d3eeb)) wip: attempts to restore the hanging lights

  > These are very stiff now... not sure how to get them moving again :/

- ([`2d3d5b33`](https://github.com/russmatney/dino/commit/2d3d5b33)) feat: restore remaining ghost house rooms

  > Some tilesets data remained, just had to trace over them with the newly
  > created terrains.

- ([`3a1e8219`](https://github.com/russmatney/dino/commit/3a1e8219)) fix: update shader_param -> shader_parameter everywhere
- ([`dbba7979`](https://github.com/russmatney/dino/commit/dbba7979)) fix: a few godot 3 to 4 api updates

  > Restores some sprite frames and updates some api crashes.
  > 
  > 'Oh no! you want me to lerp from 0 to 0.1? BUT HOW?! Ah, you mean 0.0, i get it now.'
  > - Godot4.

- ([`ab222aeb`](https://github.com/russmatney/dino/commit/ab222aeb)) fix: redraw house/office ghost-house tilesets

  > Tilesets are unfortunately lost in the godot 3 to 4 move, so he we
  > redraw a few ghost rooms.

- ([`433c4b89`](https://github.com/russmatney/dino/commit/433c4b89)) fix: restore ghost house tiles

  > Recreates the ghost house tiles with the pirate ship assets. Also
  > removes the dead TileSetTools.gd script from a few other tilesets.


### 7 Apr 2023

- ([`8a061986`](https://github.com/russmatney/dino/commit/8a061986)) feat: create TwoGeon in Metro zone/room style

  > Metro officially supporting a quick hack of a Dungeon Crawler!
  > 
  > Huzzah!

- ([`a887e0ef`](https://github.com/russmatney/dino/commit/a887e0ef)) chore: manually open and resave scenes to fix uid warns

  > Kind of a PITA.

- ([`a1ca5001`](https://github.com/russmatney/dino/commit/a1ca5001)) fix: playable demoland, after adjusting autoload order

  > A sign of a problem - the games list expects games as autoloads, which
  > means Games needs to load AFTER the games themselves. It's likely we
  > don't actually want to autoload game scripts, so something else probably
  > makes more sense here... not sure how else to let them determine which
  > paths they manage tho, unless we rely on directory structure, which is
  > yucky.

- ([`c8540344`](https://github.com/russmatney/dino/commit/c8540344)) refactor: break mvania19 dir into hatbot, demoland

  > Breaks out a DemoLand 'DinoGame' script, and adds it to the main
  > menu (not working yet).

- ([`206a5d41`](https://github.com/russmatney/dino/commit/206a5d41)) feat: play zones in unmanaged mode

  > Restores individual zone scene testing! The zones have some setup
  > helpers that run in _ready() to ensure a current game in Game, a current
  > zone in Metro, and to spawn a player (if one isn't already spawning).
  > 
  > I introduced then fixed a bug here related to unmanaged travel - if you
  > travel to a new area, it should always take you to the other end of the
  > elevator. the side-effectful nature of the zone's spawn_path in
  > player_spawn_coords() was causing the spawn_path to be cleared before
  > the Game._respawn_player eventually looked up player_coords. This was
  > b/c I opted to pass spawn_coords through the maybe_spawn_player funcs.
  > Instead, we pass a function that will later be called. In the traveling
  > case, the unmanaged helper never fires (b/c we're already respawning due
  > to the navi-change-scene signal-listener), but the side effectful coords
  > calc was then clearing the spawn_path, so the player was spawning at
  > whatever dev-spawn-point was still in play.
  > 
  > Perhaps we should allow the zones to be responsible for spawning the
  > player, rather than doing it from the game when navi changes the scene?
  > I'd like the Game to be able to manage the player independent of the
  > game-impls/zone-impls, but maybe they're already coupled...
  > 
  > This also moves the player and zones to booking with Hotel in their
  > enter_tree() method, and removes the player booking from the game
  > register function. I'm not sure if this makes sense or not, so,
  > something to keep an eye on. I tried to remove the full game register(),
  > but if you don't register zones, the elevators don't work (b/c there's
  > no scene in hotel to fetch and load when traveling). Moving the zone
  > book to enter_tree() resolved a bunch of warnings from hotel for all the
  > children calling register/check-in/check-out.
  > 
  > I don't want metro or the zones to depend on the game impls (e.g.
  > hatbot), so instead Game.gd does - this could happen in a separate
  > autoload (Games.gd ?), but there's no circular-dep yet, so this might
  > last. Game.ensure_current_game() should let the zones be tested
  > independently without too much fuss - just need to impl
  > DinoGame.manages_scene for each game.

- ([`218f44e4`](https://github.com/russmatney/dino/commit/218f44e4)) fix: `not string` is not allowed, let's crash!

  > Removes some noisy warnings when in the editor.

- ([`cf3b919f`](https://github.com/russmatney/dino/commit/cf3b919f)) refactor: move mvaniaGame/Area/Room naming to metro_

  > Deletes the MvaniaGame/Area/Room scripts, and updates existing scenes
  > and scripts to reference the Metro* based versions.

- ([`8f065156`](https://github.com/russmatney/dino/commit/8f065156)) feat: create Metro plugin with Mvania Game/Area/Room

  > Renamed 'area' to 'zone'. Area has plenty of overlap with area2d
  > already, and zone is probably more specific to what this is anyway.


### 6 Apr 2023

- ([`ba3fa7c9`](https://github.com/russmatney/dino/commit/ba3fa7c9)) chore: some call_deferred refactors
- ([`5a53b2ff`](https://github.com/russmatney/dino/commit/5a53b2ff)) feat: DinoGame class with HatBot's public funcs
- ([`1f22826f`](https://github.com/russmatney/dino/commit/1f22826f)) refactor: break MvaniaGame into HatBot, Game autoloads

  > The game and player life-cycle details are now handled by Game.gd, which
  > can hopefully be extended to run as the main game autoload for all dino games.
  > 
  > HatBot takes on more HatBot specific things, like the area and player
  > scenes, plus gluing some Game.current_game usage to the MvaniaGame. We
  > will make HatBot a DinoGame next, so the Game.gd use of it is
  > repeatable.
  > 
  > MvaniaGame will be renamed soon. For now it has a few helpers that seem
  > reusable enough: load_area, travel_to, get_spawn_coords, and
  > update_rooms. All of these could be implemented in HatBot - the question
  > is how much to implement in there vs leave in a reusable something or
  > other. We'll have similar questions for the MvaniaArea and MvaniaRoom
  > impls shortly.

- ([`72c6f0a2`](https://github.com/russmatney/dino/commit/72c6f0a2)) refactor: cut down Mvania surface area

  > Removes some unnecessary MvaniaGame helpers that were really just player
  > proxy functions, and starts to pull HatBot logic out of it.

- ([`d9df1a44`](https://github.com/russmatney/dino/commit/d9df1a44)) refactor: switch pois to poas... not much better
- ([`5067f175`](https://github.com/russmatney/dino/commit/5067f175)) refactor: harvey using ensure_cam, adds POIs to game elements

  > Camera isn't great at the moment. maybe these should be POFs, or POAs?

- ([`3c9fc933`](https://github.com/russmatney/dino/commit/3c9fc933)) fix: prevent camera reparenting for non-player nodes

  > A one-off fix for bots that inherit from a player that calls ensure_cam.
  > Probably shouldn't call that, but w/e.

- ([`d9c637c6`](https://github.com/russmatney/dino/commit/d9c637c6)) fix: lingering conditional array

  > My least favorite thing about godot 3 to 4.

- ([`62ff34d0`](https://github.com/russmatney/dino/commit/62ff34d0)) fix: set harvey bot to npc collision layer

  > Completes the harvey actions api refactor!

- ([`92c72002`](https://github.com/russmatney/dino/commit/92c72002)) refactor: harvey plots using actions api

  > Much cleaner this way :)

- ([`6ece3f51`](https://github.com/russmatney/dino/commit/6ece3f51)) feat: actions api - current_actions for an area

  > Plus some action detector doc strings.

- ([`4410303c`](https://github.com/russmatney/dino/commit/4410303c)) wip: harvey actions api refactor

  > Updates most of Harvey to use the new actions api. Just plots remain.
  > Not quite perfect - seems to be some difference between the current
  > action and the nearest action.

- ([`4fb4d0cd`](https://github.com/russmatney/dino/commit/4fb4d0cd)) feat: actionArea.is_current_for_any_actor

  > Useful for areas that want to update the ui when some actor can perform
  > an action immediately.

- ([`c4a255ee`](https://github.com/russmatney/dino/commit/c4a255ee)) feat: action detector find nearest support
- ([`296e69bf`](https://github.com/russmatney/dino/commit/296e69bf)) fix: cam reparent fails/warns, deferring fixes it

### 5 Apr 2023

- ([`f893b836`](https://github.com/russmatney/dino/commit/f893b836)) fix: restore harvey sprites

  > These have been broken since the 3 to 4 transition - harvey is now
  > playable again (if it ever was).

- ([`01408600`](https://github.com/russmatney/dino/commit/01408600)) refactor: dungeon crawler using juicy cam
- ([`9ce21558`](https://github.com/russmatney/dino/commit/9ce21558)) refactor: dungeonCrawler using actions api

  > Move the dungeon crawler door and player to the actionArea and
  > ActionDetector setup, along with the action hint component displaying
  > the available actions.

- ([`379c0442`](https://github.com/russmatney/dino/commit/379c0442)) refactor: action fns first arg is actor

  > This makes most of the action fn impls much simpler, and skips the
  > headache of connecting entities and the player some other way.


### 19 Mar 2023

- ([`98836356`](https://github.com/russmatney/dino/commit/98836356)) feat: add logger/log macro for bb commands

### 17 Mar 2023

- ([`2109501c`](https://github.com/russmatney/dino/commit/2109501c)) chore: readme note
- ([`90481b61`](https://github.com/russmatney/dino/commit/90481b61)) chore: readme update
- ([`0077ef70`](https://github.com/russmatney/dino/commit/0077ef70)) chore: quick readme update

### 14 Mar 2023

- ([`72b6f657`](https://github.com/russmatney/dino/commit/72b6f657)) feat: update windows exec name, embed linux pck
- ([`7e45d142`](https://github.com/russmatney/dino/commit/7e45d142)) build: update some export settings
- ([`04669f0d`](https://github.com/russmatney/dino/commit/04669f0d)) feat: update bb deploy handling

  > Now supporting more than just web builds.

- ([`e9d5683e`](https://github.com/russmatney/dino/commit/e9d5683e)) build: exports/deploys for linux + web
- ([`ad52e6d7`](https://github.com/russmatney/dino/commit/ad52e6d7)) build: update export_files for mvania builds
- ([`e77c34bd`](https://github.com/russmatney/dino/commit/e77c34bd)) fix: boss knockback velocity fix
- ([`46de4c32`](https://github.com/russmatney/dino/commit/46de4c32)) fix: no stunned->warping if dead
- ([`e64fe594`](https://github.com/russmatney/dino/commit/e64fe594)) feat: boss timing/damage fixup, protect against invalid MvaniaGame.player usage
- ([`28b5eaa1`](https://github.com/russmatney/dino/commit/28b5eaa1)) feat: gloomba dead frame
- ([`7583a218`](https://github.com/russmatney/dino/commit/7583a218)) feat: enemy hurt noise

  > i don't think this state gets called :/

- ([`7a4bf565`](https://github.com/russmatney/dino/commit/7a4bf565)) feat: boss/enemy 'laugh' sounds

  > Not great, but at least it's something.

- ([`d919e91e`](https://github.com/russmatney/dino/commit/d919e91e)) refactor: heart container now scalable

  > Refactors the heart icon from a sprite into an atlas texture to support
  > proper control node features, so it can now be sized appropriately for
  > the player vs enemy statuses.

- ([`b1842d3c`](https://github.com/russmatney/dino/commit/b1842d3c)) fix: clamp health, dev-only spawn points, input map update
- ([`a3b5e297`](https://github.com/russmatney/dino/commit/a3b5e297)) fix: support shift from input map (lowercased)
- ([`693ce567`](https://github.com/russmatney/dino/commit/693ce567)) door fixes: open only from back, open when no coins

  > Also adds an on_room_entered to be sure doors don't skip de-activating
  > their POFs.

- ([`555df83a`](https://github.com/russmatney/dino/commit/555df83a)) feat: can now only open doors from behind them

  > Otherwise the coin door script is the only way to open them.

- ([`ea8841d0`](https://github.com/russmatney/dino/commit/ea8841d0)) fix: remove 'you?!?' patron joke

  > kind of lame.

- ([`72a86eb7`](https://github.com/russmatney/dino/commit/72a86eb7)) feat: update compression on mac

  > Tho, I think i'll have to reimport everything for this to actually
  > apply... won't that lead to a mess of git .import updates that toggle
  > based on each build?
  > 
  > Perhaps people only do their builds in the cloud where the .imports are
  > throw-away.

- ([`5a7859d2`](https://github.com/russmatney/dino/commit/5a7859d2)) fix: remove particles from candle, add build for macos

### 13 Mar 2023

- ([`f9e19f4e`](https://github.com/russmatney/dino/commit/f9e19f4e)) fix: disable candle particles

  > These crashed the game completely on osx :/

- ([`62458f26`](https://github.com/russmatney/dino/commit/62458f26)) feat: double heart container size

  > Makes the enemy status healths too big :/

- ([`5c944ce2`](https://github.com/russmatney/dino/commit/5c944ce2)) fix: emit 2 hearts

  > apparently emitting 1 particle from a one-shot cpu emitter is a no-go.

- ([`ad64ce88`](https://github.com/russmatney/dino/commit/ad64ce88)) fix: more level tweaks, failed gpu->cpu particles attempt
- ([`f321a2fb`](https://github.com/russmatney/dino/commit/f321a2fb)) chore: more small level tweaks/fixes
- ([`4392135c`](https://github.com/russmatney/dino/commit/4392135c)) wip: variable jump height

  > Not pursuing this for now, but likely shortly after the jam.

- ([`58e98acc`](https://github.com/russmatney/dino/commit/58e98acc)) feat: smoother landing site + simulation rooms
- ([`401f6835`](https://github.com/russmatney/dino/commit/401f6835)) feat: connect levelZero and landing site, update export
- ([`e1c7a7ec`](https://github.com/russmatney/dino/commit/e1c7a7ec)) feat: create level zero with in-game tut + credits
- ([`75aafd2d`](https://github.com/russmatney/dino/commit/75aafd2d)) feat: city, mountain parallax bgs with rough blur
- ([`576ae72c`](https://github.com/russmatney/dino/commit/576ae72c)) wip: tile destruction animation, feat: redraw after tile deletion
- ([`39a6f622`](https://github.com/russmatney/dino/commit/39a6f622)) feat: skull, heart particles on death, heal
- ([`242cd531`](https://github.com/russmatney/dino/commit/242cd531)) feat: show area and room name on minimap
- ([`225bf53b`](https://github.com/russmatney/dino/commit/225bf53b)) feat: show collected powerups in HUD
- ([`156c68f2`](https://github.com/russmatney/dino/commit/156c68f2)) feat: focus player when sitting, traveling
- ([`ba94527d`](https://github.com/russmatney/dino/commit/ba94527d)) feat: show elevator destination in action label
- ([`a46f4be2`](https://github.com/russmatney/dino/commit/a46f4be2)) feat: support label_fn for dynamic action labels
- ([`996d30fe`](https://github.com/russmatney/dino/commit/996d30fe)) feat: portraits for all enemies in status comp
- ([`945c46c2`](https://github.com/russmatney/dino/commit/945c46c2)) feat: player flash on hurt, boss backlights
- ([`b18d4901`](https://github.com/russmatney/dino/commit/b18d4901)) feat: add pop anim to spell bullet
- ([`6145e24e`](https://github.com/russmatney/dino/commit/6145e24e)) fix: prevent reusing freed enemy statuses with same names

  > Hopefully this resolves the bug, which has cropped up twice now.


### 12 Mar 2023

- ([`3fe5a87e`](https://github.com/russmatney/dino/commit/3fe5a87e)) feat: candle sounds, arrow explosion + sound
- ([`d8c61754`](https://github.com/russmatney/dino/commit/d8c61754)) sounds: boss shoot, warp, block destory, player heal
- ([`a79c5a3a`](https://github.com/russmatney/dino/commit/a79c5a3a)) sounds: climb start, collect powerup, toggle jumbotron
- ([`2d9b229f`](https://github.com/russmatney/dino/commit/2d9b229f)) chore: drop unimpled anim
- ([`9528f029`](https://github.com/russmatney/dino/commit/9528f029)) chore: drop a bunch of debug labels

  > Chasing a perf issue that ended up being unrelated, but probably still
  > for the best.

- ([`baf3c7d0`](https://github.com/russmatney/dino/commit/baf3c7d0)) feat: big art update - boss anims, player sit, bigger sword

  > Plus misc other tweaks.

- ([`884d12ea`](https://github.com/russmatney/dino/commit/884d12ea)) feat: bunch of art: bosses, icons, sit anim
- ([`cd1126bb`](https://github.com/russmatney/dino/commit/cd1126bb)) fix: title and initial position
- ([`e5708e54`](https://github.com/russmatney/dino/commit/e5708e54)) feat: update export to run latest
- ([`35a9c93c`](https://github.com/russmatney/dino/commit/35a9c93c)) chore: usual godot4 uid toggling

  > ought to get this fixed soon

- ([`3b1c15d4`](https://github.com/russmatney/dino/commit/3b1c15d4)) chore: add text effects to action hint and jumbotron rtls
- ([`724510ef`](https://github.com/russmatney/dino/commit/724510ef)) feat: ensure_camera accepts player now

  > bit of a hard-coded reparent here, but it works for the current use-cases.

- ([`bf7f10e0`](https://github.com/russmatney/dino/commit/bf7f10e0)) fix: player death mgmt - move to queue_free and blocking on spawning

  > Saw a bug calling player.free(), and know we can't get away with it.
  > this causes some camera swish at startup, but might be fine for now.

- ([`2179c01b`](https://github.com/russmatney/dino/commit/2179c01b)) fix: enemy updates on damage, add shooty-crawly to enemies group
- ([`a260f6a7`](https://github.com/russmatney/dino/commit/a260f6a7)) fix: only connect once, disconnect after use

  > Fixes bug that was firing zombie jumbotron on_close signals long after
  > the jumbo was used.

- ([`cffe999c`](https://github.com/russmatney/dino/commit/cffe999c)) feat: enemy health, coins, deaths in HUD
- ([`68cde890`](https://github.com/russmatney/dino/commit/68cde890)) feat: enemy status component

### 11 Mar 2023

- ([`3d190fec`](https://github.com/russmatney/dino/commit/3d190fec)) fix: larger jumbotron text
- ([`595d7a7a`](https://github.com/russmatney/dino/commit/595d7a7a)) feat: larger font size on notifs, boss secrets
- ([`0124352f`](https://github.com/russmatney/dino/commit/0124352f)) feat: add boss-defeat-quest to other boss rooms
- ([`9ed3d305`](https://github.com/russmatney/dino/commit/9ed3d305)) chore: misc

  > Also not sure what this noise is...

- ([`e6044718`](https://github.com/russmatney/dino/commit/e6044718)) chore: bunch of uid miss mess

  > This can't be on purpose, but I'm not sure the godot maintainers know
  > this is an issue. Seems to happen when moving between machines, i
  > suspect b/c there's a database being kept in `.import/*` that isn't
  > shared across devices.

- ([`a4a24114`](https://github.com/russmatney/dino/commit/a4a24114)) fix: move to DJSounds key
- ([`c0108770`](https://github.com/russmatney/dino/commit/c0108770)) feat: siblings function.... does this already exist?
- ([`30b8c617`](https://github.com/russmatney/dino/commit/30b8c617)) feat: boss-defeat-quest script impl
- ([`cdf37e0d`](https://github.com/russmatney/dino/commit/cdf37e0d)) feat: restore basic minimap

  > Couple hotel queries! Looking ok, not great.

- ([`a49ed5c5`](https://github.com/russmatney/dino/commit/a49ed5c5)) feat: track death count in hotel
- ([`b851e74a`](https://github.com/russmatney/dino/commit/b851e74a)) feat: death, powerup jumbotrons block inputs until closed
- ([`9eb4be2b`](https://github.com/russmatney/dino/commit/9eb4be2b)) chore: removing more dev powerups/spawn-points
- ([`5fbce9c1`](https://github.com/russmatney/dino/commit/5fbce9c1)) fix: player hud updating on startup, powerups not overwriting with empty array
- ([`cefbaf9c`](https://github.com/russmatney/dino/commit/cefbaf9c)) feat: spawn points active/inactive, candle lit adds spawn_point
- ([`9cf11c37`](https://github.com/russmatney/dino/commit/9cf11c37)) chore: reduce logs/noise
- ([`a529d870`](https://github.com/russmatney/dino/commit/a529d870)) fix: support resetting player health when respawning after death
- ([`1a2b6a39`](https://github.com/russmatney/dino/commit/1a2b6a39)) fix: reset both tweens when running a new one

  > Rogue zombie tweens were surviving, fading the current room in an
  > annoying way (after death and re-spawning).

- ([`42fa7467`](https://github.com/russmatney/dino/commit/42fa7467)) feat: filter and sort recent active markers

  > This sets up candles as the return point after deaths.

- ([`bd0989b6`](https://github.com/russmatney/dino/commit/bd0989b6)) feat: support passing player into hood

  > this cuts off the find_player mechanic, and also re-emits
  > Hood.found_player when a player is recreated, which can be useful for
  > any listeners (e.g. mvania game, for now).

- ([`57e14037`](https://github.com/russmatney/dino/commit/57e14037)) feat: proper nested children group get

  > This was only going two layers, now it's properly recursive.

- ([`99a480f9`](https://github.com/russmatney/dino/commit/99a480f9)) fix: handle Debug.pr.bind() cases

  > Not pretty but not crashing for now.

- ([`ac216b12`](https://github.com/russmatney/dino/commit/ac216b12)) wip: player restart after death nearly working

  > The room is coming back faded :/

- ([`acd64318`](https://github.com/russmatney/dino/commit/acd64318)) feat: clean up jumbotron

  > Hide action_hint/details when none passed

- ([`5ed4f88e`](https://github.com/russmatney/dino/commit/5ed4f88e)) fix: doors run at tool-time, so now so do campofs

  > everything eventually becomes a tool script!

- ([`f07be4da`](https://github.com/russmatney/dino/commit/f07be4da)) feat: darkening volcano/landing-site
- ([`6f1d9dd7`](https://github.com/russmatney/dino/commit/6f1d9dd7)) feat: coin, spell, door lights. DJSounds map with enum keys
- ([`ed6063aa`](https://github.com/russmatney/dino/commit/ed6063aa)) feat: add CamPOFs to doors, toggle while opening/closing
- ([`44273a7d`](https://github.com/russmatney/dino/commit/44273a7d)) feat: give player all powerups unless we're in a 'managed' game
- ([`e666033e`](https://github.com/russmatney/dino/commit/e666033e)) feat: add light to player, darken some canvases
- ([`a389eb3d`](https://github.com/russmatney/dino/commit/a389eb3d)) feat: helper for toggling pof/poi/poa camera groups
- ([`fbd93490`](https://github.com/russmatney/dino/commit/fbd93490)) feat: hotel ui has_group, is_root feats

  > Includes a Hotel.register option for opting in to being a root element,
  > which is useful for one-offs like the HotelUI itself as a component.
  > 
  > Also includes a few helpers on Hotel.query() for common
  > groups (player/enemies/bosses).


### 10 Mar 2023

- ([`1dc44584`](https://github.com/russmatney/dino/commit/1dc44584)) feat: bgs, canvas modulates on the areas
- ([`7f7d97d3`](https://github.com/russmatney/dino/commit/7f7d97d3)) chore: misc lighting fixes
- ([`972f8485`](https://github.com/russmatney/dino/commit/972f8485)) feat: coins and coin door quests in the kingdom
- ([`d5d5ab53`](https://github.com/russmatney/dino/commit/d5d5ab53)) feat: coins and doors you can open/close
- ([`efe25cbb`](https://github.com/russmatney/dino/commit/efe25cbb)) feat: add candle to each zone
- ([`69efe5ff`](https://github.com/russmatney/dino/commit/69efe5ff)) feat: sit at candles to heal
- ([`0382e037`](https://github.com/russmatney/dino/commit/0382e037)) feat: dev_notif every hotel check_in
- ([`fa9cdc22`](https://github.com/russmatney/dino/commit/fa9cdc22)) feat: action-hint on stamps optional
- ([`c8c43474`](https://github.com/russmatney/dino/commit/c8c43474)) fix: prevent run/jump transit from kicking us to idle
- ([`dc35b789`](https://github.com/russmatney/dino/commit/dc35b789)) feat: persist crawl on side
- ([`e81a232d`](https://github.com/russmatney/dino/commit/e81a232d)) feat: shooty-crawlies shooting and crawling

  > tho not quite always dying.

- ([`5f3a4ed3`](https://github.com/russmatney/dino/commit/5f3a4ed3)) fix: better grassy hallway layout
- ([`292ed8ad`](https://github.com/russmatney/dino/commit/292ed8ad)) feat: crawlies stick to whatever surface they overlap with
- ([`ed1c27ff`](https://github.com/russmatney/dino/commit/ed1c27ff)) wip: mostly complete lil crawly

  > Plus art to make him shooty.
  > 
  > Dries up more enemy machine usage into a reusable scene.

- ([`d1919966`](https://github.com/russmatney/dino/commit/d1919966)) fix: skip editor error
- ([`95726a6e`](https://github.com/russmatney/dino/commit/95726a6e)) feat: introduce giant goomba, refactor shared enemy state machine

  > Trying some shared state machine patterns with signals and actor
  > properties/methods.

- ([`ce3075e4`](https://github.com/russmatney/dino/commit/ce3075e4)) refactor: merge boss state machines

  > These are not different enough to warrant the duplication (and doubling
  > the fixing time on the shared states.)
  > 
  > If they're really that different, we can create separate versions of
  > whichever unique states.

- ([`ab9b2a88`](https://github.com/russmatney/dino/commit/ab9b2a88)) fix: queue and replay dev_notifs, remove spammy warning
- ([`c0bbf6a8`](https://github.com/russmatney/dino/commit/c0bbf6a8)) feat: introduce Hotel.register()

  > Cleans up the hotel api slightly - supports (requires) a
  > `check_out(data)` and `hotel_data() -> Dictionary` function for
  > restoring nodes from their hotel data and creating a new dict to be
  > stored from that data. Should be called from _ready().
  > 
  > In check_out(data), be sure to not overwrite local settings if no value
  > is passed from hotel! The intent here is to make it easy to restore the
  > state from a previous hotel_data call when re-creating a node, but the
  > first _ready() call needs to be careful. Perhaps it could skip the
  > check_out(data) call entirely...?

- ([`4eaf10dc`](https://github.com/russmatney/dino/commit/4eaf10dc)) feat: introduce dev_notif

  > which doesn't seem to work yet?


### 9 Mar 2023

- ([`dab90fc9`](https://github.com/russmatney/dino/commit/dab90fc9)) fix: swoop using global_position
- ([`c9655498`](https://github.com/russmatney/dino/commit/c9655498)) feat: same two bosses instead of a new third one

  > bit lazy, but i'm tired!

- ([`5ceb83fa`](https://github.com/russmatney/dino/commit/5ceb83fa)) feat: hints showing intended swoop positions

  > Kind of janky, but kind of a boss fight, i suppose.

- ([`2daa0f16`](https://github.com/russmatney/dino/commit/2daa0f16)) chore: clean up prints
- ([`b5509954`](https://github.com/russmatney/dino/commit/b5509954)) wip: Monstroar swoop rough impl
- ([`4f04012c`](https://github.com/russmatney/dino/commit/4f04012c)) chore: misc leftover Hood.warn/err calls
- ([`c0130d5e`](https://github.com/russmatney/dino/commit/c0130d5e)) refactor: Util cleanup, plus some new nearby helpers
- ([`8687828c`](https://github.com/russmatney/dino/commit/8687828c)) wip: port beefstronaut to monstroar before refactor
- ([`4ebe2f6a`](https://github.com/russmatney/dino/commit/4ebe2f6a)) feat: persist health/position, some hopeful state fixes
- ([`3f6566c4`](https://github.com/russmatney/dino/commit/3f6566c4)) feat: impl beefstronaut warping. boss battle feature-complete

  > Lots of tweaking remains to make it feel better.

- ([`37b73c49`](https://github.com/russmatney/dino/commit/37b73c49)) feat: knockback, stunned, dead states impled
- ([`81629ab0`](https://github.com/russmatney/dino/commit/81629ab0)) feat: idle every n bullets, remove collision exception

  > Never copy paste! this collision exception thing explains an hour of
  > debugging from this morning.

- ([`f9333d38`](https://github.com/russmatney/dino/commit/f9333d38)) refactor: Beefstronaut idle/firing state machine
- ([`555cf1e5`](https://github.com/russmatney/dino/commit/555cf1e5)) feat: fired back bullets hitting beefstronaut

### 8 Mar 2023

- ([`5bdfe2a6`](https://github.com/russmatney/dino/commit/5bdfe2a6)) feat: flip collision masks/layers when hitting bullets back
- ([`c0c2a03a`](https://github.com/russmatney/dino/commit/c0c2a03a)) feat: introduce camPOAs, knock back bullets

  > POAs are anchor-guides for the camera, so we can use POFs properly to
  > keep things on-screen all the time.

- ([`16e47557`](https://github.com/russmatney/dino/commit/16e47557)) chore: move from poi/pof to pois/pofs

  > Groups names should be plural. Except 'player'?

- ([`2a14ee95`](https://github.com/russmatney/dino/commit/2a14ee95)) wip: first boss rough firing mechanic

  > todo: boss movement, knocking bullets back, taking damage, etc.

- ([`59656ab6`](https://github.com/russmatney/dino/commit/59656ab6)) fix: rearrange landing site to fix room-reveal bug
- ([`f6fc3550`](https://github.com/russmatney/dino/commit/f6fc3550)) feat: wallclimb powerup pickup added and implemented
- ([`b931847f`](https://github.com/russmatney/dino/commit/b931847f)) fix: jumbotron layout fixes

  > Mixing control and 2d animations is a pain for consistent layouts :/

- ([`3afc3d94`](https://github.com/russmatney/dino/commit/3afc3d94)) feat: sword directional attack

  > woo!

- ([`3495b0de`](https://github.com/russmatney/dino/commit/3495b0de)) fix: persist powerups across reloads
- ([`93a8de96`](https://github.com/russmatney/dino/commit/93a8de96)) feat: Hood.Jumbotron via Hood.jumbo_notif

  > A take-over that displays a header and body plus an action_hint.
  > 
  > Not too shabby!

- ([`576e6700`](https://github.com/russmatney/dino/commit/576e6700)) fix: improve soldier pursue logic

  > Really we should add another state here - otherwise the post-combat mode
  > is a toggle between run/idle for a while, when it should be more of a
  > pursue/engage/look-around before moving back to one or the other.

- ([`e2396a4c`](https://github.com/russmatney/dino/commit/e2396a4c)) chore: update print('WARN') to use Debug.warn
- ([`7ca83c8a`](https://github.com/russmatney/dino/commit/7ca83c8a)) fix: slow down x velocity in idle, dead states
- ([`ab2d9ee3`](https://github.com/russmatney/dino/commit/ab2d9ee3)) fix: use low and high line of sights

  > Otherwise the player isn't seen when a step below the soldier.

- ([`b7dbcf44`](https://github.com/russmatney/dino/commit/b7dbcf44)) feat: soldiers pursue player in line of sight

  > Bit of annoying hard-coding here, but it's working.

- ([`5c345309`](https://github.com/russmatney/dino/commit/5c345309)) feat: soldiers turn before falling down

  > Uses a raycast to turn when not colliding with anything.

- ([`62ee923b`](https://github.com/russmatney/dino/commit/62ee923b)) feat: add health to hud

  > Wired up with hotel signals. Not 100% on this pattern - hotel's state
  > _could_ get out of sync with the player... but it really shouldn't.

- ([`359f9ddc`](https://github.com/russmatney/dino/commit/359f9ddc)) chore: re-save scenes to update invalid uids

  > Not sure the reason for this oscillation - it seems to flip between my
  > machines, so maybe these uids are stored in the .gitignored .import/ dir?


### 7 Mar 2023

- ([`e9d21bdd`](https://github.com/russmatney/dino/commit/e9d21bdd)) feat: double jump pickup and impl
- ([`4e6cd831`](https://github.com/russmatney/dino/commit/4e6cd831)) feat: sword destroying destructible tiles
- ([`f2772289`](https://github.com/russmatney/dino/commit/f2772289)) feat: sword as a pickup
- ([`20d1e12f`](https://github.com/russmatney/dino/commit/20d1e12f)) feat: kingdom, volcano initial maps
- ([`f680c526`](https://github.com/russmatney/dino/commit/f680c526)) feat: landing site, simulation initial layouts
- ([`1ec4c369`](https://github.com/russmatney/dino/commit/1ec4c369)) refactor: pull existing areas into 'demoland'

  > Also fixes a soldier init bug, and adds elevator destinations to
  > hotel_data().

- ([`cb395f82`](https://github.com/russmatney/dino/commit/cb395f82)) fix: restore elevator travel to instanced rooms with elevators
- ([`74c690b3`](https://github.com/russmatney/dino/commit/74c690b3)) fix: soldier initial positions fixed

  > These were drifting b/c of the position vs global_position bug.

- ([`8e27bfdd`](https://github.com/russmatney/dino/commit/8e27bfdd)) feat: support setting root-db items (player)

  > Areas already had this functionality b/c they were at the top of their
  > heirarchy, but this allows other db items to be 'root', such as
  > nodes/scenes with the 'player' group.

- ([`36c5ce89`](https://github.com/russmatney/dino/commit/36c5ce89)) feat: update player data when taking a hit
- ([`78525c9c`](https://github.com/russmatney/dino/commit/78525c9c)) fix: bug in soldier hotel_data/restore

  > Gotta be consistent on position/global_position.
  > Also, can't machine.transit until there's a machine to use.

- ([`a983dc8c`](https://github.com/russmatney/dino/commit/a983dc8c)) feat: don't reload when traveling within the same area
- ([`b537aa41`](https://github.com/russmatney/dino/commit/b537aa41)) refactor: elevators store dest area name, not path

  > Also updates Util.packed_scene_info to set scene_file_path if the path
  > is used as input. This is necessary to load the next room when using
  > Mvania elevators, tho maybe there's a better way to work around that. We
  > could instead lookup the path in MvaniaGame using the area name, but
  > that'd be duplicating Hotel's purpose a bit - it's annoying we can't
  > reliably get the path from Hotel, which is already our in-game state db.

- ([`9f1fa33f`](https://github.com/russmatney/dino/commit/9f1fa33f)) feat: updating hotel ui entries in real time!
- ([`0f3024b5`](https://github.com/russmatney/dino/commit/0f3024b5)) fix: support room_name on hotel entries

  > Now filtering nicely!

- ([`813c8838`](https://github.com/russmatney/dino/commit/813c8838)) feat: improved hotel ui toggle behavior
- ([`9661aefd`](https://github.com/russmatney/dino/commit/9661aefd)) feat: include area_name, room_name on hotel data
- ([`8c4c7171`](https://github.com/russmatney/dino/commit/8c4c7171)) chore: mvania general clean up

  > MvaniaGame current_area now set from an area when loaded. Some wip
  > elevator validation that should probably wait for the elevator selection
  > logic to land.


### 6 Mar 2023

- ([`cb557c2b`](https://github.com/russmatney/dino/commit/cb557c2b)) fix: some tweaks to soldier life cycle, better hotel warnings
- ([`3c35042f`](https://github.com/russmatney/dino/commit/3c35042f)) feat: nodes check_in, restore via hotel

  > Somewhat decoupled hotel db checkins - data is preserved across area
  > loads, so it seems to be working!

- ([`4cd32e75`](https://github.com/russmatney/dino/commit/4cd32e75)) feat: room updating it's own data via flat hotel style
- ([`3cb120ae`](https://github.com/russmatney/dino/commit/3cb120ae)) wip: flat, recrusive hotel.book impl

  > Books everything. Maybe moving to an opt-in by group model.

- ([`7747fde7`](https://github.com/russmatney/dino/commit/7747fde7)) feat: toggle hotel ui in debug overlay
- ([`f09a99c1`](https://github.com/russmatney/dino/commit/f09a99c1)) feat: hotelui dropdowns for selecting areas, groups
- ([`4f1019b2`](https://github.com/russmatney/dino/commit/4f1019b2)) feat: highlight slashes in names, use to_pretty newlines
- ([`f7938744`](https://github.com/russmatney/dino/commit/f7938744)) feat: reasonable HotelDB UI, listing entries and showing details

  > Includes code for omitting databased on keys, and defaulting to only
  > showing the first 10 array entries. Note this doesn't cover all arrays
  > or very long to_string impls for various types (e.g. tile_data).

- ([`1aae5b4c`](https://github.com/russmatney/dino/commit/1aae5b4c)) feat: initial HotelUI main screen plugin

  > Includes a reload-plugin button for speeding up that dev-loop.

- ([`cb2a8cff`](https://github.com/russmatney/dino/commit/cb2a8cff)) chore: remove light rotation, misc uid updates
- ([`d9c87bcc`](https://github.com/russmatney/dino/commit/d9c87bcc)) fix: warn/err logs skip rich color wrappers

  > push_warn and push_error don't render rich text colors, so we skip the
  > color when building those strings.

- ([`7bf8c6ea`](https://github.com/russmatney/dino/commit/7bf8c6ea)) wip: drop noisy prnts
- ([`ab7a9dcf`](https://github.com/russmatney/dino/commit/ab7a9dcf)) wip: more directional light angle wip

### 4 Mar 2023

- ([`95fc7ed3`](https://github.com/russmatney/dino/commit/95fc7ed3)) wip: light direction reacting to player position
- ([`474cc471`](https://github.com/russmatney/dino/commit/474cc471)) feat: soldier kick action, player knockback and death

  > A bunch of little things to fix - dead enemies kicking, for example.

- ([`4dc32703`](https://github.com/russmatney/dino/commit/4dc32703)) fix: test rooms in isolation, nil-pun area

  > Not the best solution here - things should sort of 'work' - maybe
  > loading a room should also load the area underneath it?


### 28 Feb 2023

- ([`37707ea0`](https://github.com/russmatney/dino/commit/37707ea0)) fix: reassign elevators with new data

  > Should really create full-fledged UI for doing this...

- ([`bb1ec7c6`](https://github.com/russmatney/dino/commit/bb1ec7c6)) feat: clean up elevator assignment with Hotel.query api

  > Now we're cooking with grease!

- ([`b38c5b98`](https://github.com/russmatney/dino/commit/b38c5b98)) feat: pretty print highlighting brackets and commas
- ([`2944fa90`](https://github.com/russmatney/dino/commit/2944fa90)) feat: restore area traversal without area_db

  > Now relying on Hotel's db impl.

- ([`511dec6c`](https://github.com/russmatney/dino/commit/511dec6c)) wip: disable minimap, start area/room storage refactor
- ([`c9f71c95`](https://github.com/russmatney/dino/commit/c9f71c95)) feat: Hotel initial update implementation
- ([`24cd4612`](https://github.com/russmatney/dino/commit/24cd4612)) feat: fine-grained color for Vector2s, NodePaths and StringNames
- ([`bfd15ce1`](https://github.com/russmatney/dino/commit/bfd15ce1)) feat: pretty print arrays and dicts

  > Should have done this years ago!

- ([`6ebe1216`](https://github.com/russmatney/dino/commit/6ebe1216)) wip: Hotel addon for managing area/room/scene data
- ([`b806adad`](https://github.com/russmatney/dino/commit/b806adad)) feat: add mvania rooms/areas to groups, include groups in packed_scene_data
- ([`b1c6b6b8`](https://github.com/russmatney/dino/commit/b1c6b6b8)) poc: accessing room data in packed scene (avoiding instantiate)
- ([`ceb4edb2`](https://github.com/russmatney/dino/commit/ceb4edb2)) refactor: move mvaniaArea, mvaniaRoom scripts out of maps/
- ([`b1dfbd81`](https://github.com/russmatney/dino/commit/b1dfbd81)) feat: RepTileMap.gd with exported recalc_autotile helper

  > Important to make sure this recalc is reasonable before drawing lots of
  > tilemaps - fortunately this works fine, and adding alt tiles after the
  > fact won't be a terrible PITA.


### 27 Feb 2023

- ([`c2137fc0`](https://github.com/russmatney/dino/commit/c2137fc0)) wip: add snow tile variants

  > Annoying to redraw these tilemaps after updating the autotiles - can
  > probably be automated.

- ([`eab85ee8`](https://github.com/russmatney/dino/commit/eab85ee8)) feat: hint at elevator dest with tiles
- ([`64bf85ba`](https://github.com/russmatney/dino/commit/64bf85ba)) wip: toying with tile variations

  > Adding variants to tiles isn't too bad - just mark more tiles with the
  > correct terrain bitmask.

- ([`36b2a677`](https://github.com/russmatney/dino/commit/36b2a677)) fix: ignore symlinked assets

  > Unfortunately not vendoring these assets breaks things for other users -
  > but i'm reluctant to include them directly just yet.


### 26 Feb 2023

- ([`3fecd943`](https://github.com/russmatney/dino/commit/3fecd943)) chore: update mvania export
- ([`9c42768a`](https://github.com/russmatney/dino/commit/9c42768a)) feat: toggle debug labels per module

  > Also moves all the debug stuff from hood to debug.

- ([`6d9ec6d5`](https://github.com/russmatney/dino/commit/6d9ec6d5)) chore: clean up print
- ([`72f3db57`](https://github.com/russmatney/dino/commit/72f3db57)) feat: pofs now respect a max x/y distance

  > If a pof is outside the pof_max vector, an offset will be applied to
  > keep it within the boundaries. This fixes issues with the camera zooming
  > out way too far to show room-corner-pofs in large rooms.

- ([`b997de9f`](https://github.com/russmatney/dino/commit/b997de9f)) refactor: clean up new elevator get_state via Util.packed_scene_data helper

  > A nice function converting the crazy SceneState api into a dictionary of
  > instance data.

- ([`cb88e1dc`](https://github.com/russmatney/dino/commit/cb88e1dc)) misc: don't slow-mo the editor
- ([`acb94e70`](https://github.com/russmatney/dino/commit/acb94e70)) fix: avoid loading the current scene while saving

  > Elevators pointing to other elevators in the same scene were causing the
  > editor to crash - seems to be because of an underlying state problem
  > when reading from a packedscene's state while also trying to save that
  > scene. woof!
  > 
  > The good news is that we now know how to work with packed scenes more closely.

- ([`7167e922`](https://github.com/russmatney/dino/commit/7167e922)) feat: add elevators to new worlds, some more error dodging

  > Editor crashes when saving the snow scene for some reason - maybe b/c of
  > the snow tiles?

- ([`85d67841`](https://github.com/russmatney/dino/commit/85d67841)) fix: support proper poi importance, proximity tweaks
- ([`8655725e`](https://github.com/russmatney/dino/commit/8655725e)) feat: move poi statline to poi weighted point

### 25 Feb 2023

- ([`1cd89e5f`](https://github.com/russmatney/dino/commit/1cd89e5f)) feat: improved poi weighting

  > proximity between 50 and 200, multiplied by importance, which is 0.7 for now.

- ([`ef80fd19`](https://github.com/russmatney/dino/commit/ef80fd19)) fix: include focuses frame rect
- ([`6793fcad`](https://github.com/russmatney/dino/commit/6793fcad)) refactor: wip for poi support

  > better handling for large rooms, just b/c we're weighting pois at 0.7
  > when contributing to the camera frame.

- ([`edd9605d`](https://github.com/russmatney/dino/commit/edd9605d)) feat: draw camera focus dots and coords
- ([`769f3d47`](https://github.com/russmatney/dino/commit/769f3d47)) feat: create Debug autoload in addons/core
- ([`d9db5a7c`](https://github.com/russmatney/dino/commit/d9db5a7c)) wip: camera tweaks

  > Setup pois with similar activate/deactivate behavior.
  > 
  > Toying with pois on room corners - the hard threshold cutoff is making
  > it too choppy - should probably create a gradient for it so it's not so
  > jumpy, per the original proximity * importance spec.


### 24 Feb 2023

- ([`2d235aae`](https://github.com/russmatney/dino/commit/2d235aae)) fix: stamp the action before switching to the next one

  > Order matters!
  > 
  > Also tweaks the default hitstop, and sets the action hitstop vars.

- ([`5919716a`](https://github.com/russmatney/dino/commit/5919716a)) feat: add monster.stamp() to action, jump, swing

  > refactor: move cam keybds to Camera autoload

- ([`6a0f6f6b`](https://github.com/russmatney/dino/commit/6a0f6f6b)) feat: include action_hint on player stamps

  > Pretty fun for two lines!

- ([`8e2b62c3`](https://github.com/russmatney/dino/commit/8e2b62c3)) feat: add 6 more tilesets and 2 quick areas
- ([`ee569742`](https://github.com/russmatney/dino/commit/ee569742)) feat: create 16x16 snow, stone tile sets, areas, and rooms

  > Plus the first 8x8 tileset: quick-tiles-8.

- ([`7233c634`](https://github.com/russmatney/dino/commit/7233c634)) feat: add basic tileset aseprite file

### 23 Feb 2023

- ([`83830987`](https://github.com/russmatney/dino/commit/83830987)) wip: some elevator lighting
- ([`65197e90`](https://github.com/russmatney/dino/commit/65197e90)) feat: impl to_data and restore for candles and soldiers

  > Now perserving kills and lights/unlights across travel.
  > 
  > Not too shabby!

- ([`e185f624`](https://github.com/russmatney/dino/commit/e185f624)) feat: support persisting arbitrary room data

  > Any room children that impl to_data and restore will be persisted and
  > restored via those functions whenever area travel is used.

- ([`34636902`](https://github.com/russmatney/dino/commit/34636902)) feat: children_by_name helper in Util
- ([`055782a3`](https://github.com/russmatney/dino/commit/055782a3)) feat: walk player to center of elevator

  > Impls support for forcing characters to walk to arbitrary positions, and
  > hiding available actions until the target is cleared.

- ([`f5977f82`](https://github.com/russmatney/dino/commit/f5977f82)) feat: faster door opening/closing anim
- ([`27596c6f`](https://github.com/russmatney/dino/commit/27596c6f)) feat: elevator doors animate, modify z-index

  > A bit more interactive, travel-wise. Could move to opening doors to
  > travel first, then blocking the opening based on requirements...

- ([`e1b8fc64`](https://github.com/russmatney/dino/commit/e1b8fc64)) feat: add soldiers to pois group

  > Nothing doing yet, but one day.

- ([`0e28fd50`](https://github.com/russmatney/dino/commit/0e28fd50)) feat: alias debug_label to debug_log

  > I type this wrong often enough.

- ([`f3301c69`](https://github.com/russmatney/dino/commit/f3301c69)) fix: hitstop timer now ignores the timescale

  > A much easier calculation, timers can now ignore timescale, so
  > hitstop/freezeframe is easily configured.
  > 
  > Adds hitstop to the sword hits.

- ([`bc577de4`](https://github.com/russmatney/dino/commit/bc577de4)) feat: add slowmo to debug_overlay to aid debugging
- ([`63918704`](https://github.com/russmatney/dino/commit/63918704)) fix: sword attack hits on frames 1-3 instead of 0

  > The original implementation here was hitting only initially - it now
  > checks for contact via the frame_changed signal, which feels much
  > better.

- ([`a8f5b5d6`](https://github.com/russmatney/dino/commit/a8f5b5d6)) feat: action_hint supports input_action label

  > The action_hint now attempts to find an input_action and keys assigned
  > to it from the project input map. if none is found, the passed text is
  > used directly, to support one-off keys (in particular, supporting groups
  > in action hints, like 'WASD' for 'move', which is several input maps.
  > This could be cleaned up at some point, and hopefully shared across
  > controller types.)

- ([`53743cd9`](https://github.com/russmatney/dino/commit/53743cd9)) feat: actions pulling keys with input map and input action

  > Actions can now be assigned an input_action (like 'attack', 'jump',
  > 'action' - whatever is in the input map), and the keys assigned will be
  > pulled and used in the action_hint.
  > 
  > Probably the action_hint should be handed the input_action string
  > directly...

- ([`990d5539`](https://github.com/russmatney/dino/commit/990d5539)) feat: actionHint component consumed by actionDetector

  > A tweak that prevents actionDetector actors from needing to impl this
  > display/hide logic every time - tho they still need to add and place an
  > action_hint on the actor.
  > 
  > There's an instinct to add this action_hint to the actionDetector, but
  > for now there are cases where the player wants to use it - specifically
  > for a sword attack when there is something to hit. Should that be
  > absorbed and impled via the action api?

- ([`749eeeeb`](https://github.com/russmatney/dino/commit/749eeeeb)) wip: the candle particle color has changed?

  > not sure why/how, maybe it happened with the godot4rc3 switch?


### 22 Feb 2023

- ([`6f2cd8c9`](https://github.com/russmatney/dino/commit/6f2cd8c9)) chore: update mvania19 export
- ([`8a859a03`](https://github.com/russmatney/dino/commit/8a859a03)) feat: move elevator to new ActionArea style
- ([`087beec0`](https://github.com/russmatney/dino/commit/087beec0)) refactor: move candle from area2d to node2d

  > Doesn't need to be an area2d anymore!

- ([`2ae887b7`](https://github.com/russmatney/dino/commit/2ae887b7)) feat: impl action source proximity

  > Can now only perform actions when the actionDetector's actor is in the
  > actionArea's actors list, which is updated based on that area's
  > collision detection.

- ([`b5487f03`](https://github.com/russmatney/dino/commit/b5487f03)) refactor: pull candle interactions into ActionDetector pattern
- ([`851683c1`](https://github.com/russmatney/dino/commit/851683c1)) fix: reorder autoloads

  > Moves addon autoloads ahead of game autoloads. Next, to disable game
  > autoloads when we're not running that game... perhaps these shouldn't be
  > autoloads? Maybe we need a single Dino autoload to manage them?

- ([`61820107`](https://github.com/russmatney/dino/commit/61820107)) feat: use local/root http-server to support godot 4 web build headers

  > Depending on a local edit of http-server for now.

- ([`36039a0b`](https://github.com/russmatney/dino/commit/36039a0b)) feat: add basic particle effect to candle
- ([`84ce95ec`](https://github.com/russmatney/dino/commit/84ce95ec)) chore: update func signature for gdfxr

### 21 Feb 2023

- ([`28da8564`](https://github.com/russmatney/dino/commit/28da8564)) fix: move candle into proper room

  > working on godot 4 rc3!

- ([`3f46af6b`](https://github.com/russmatney/dino/commit/3f46af6b)) misc: adds a bunch of candles around, and a player occluder
- ([`9590feab`](https://github.com/russmatney/dino/commit/9590feab)) feat: basic candle light/unlighting actions
- ([`c1308dae`](https://github.com/russmatney/dino/commit/c1308dae)) chore: remove action_hint ready log
- ([`4f0d38fa`](https://github.com/russmatney/dino/commit/4f0d38fa)) wip: basic candle with light
- ([`5e1cf0a1`](https://github.com/russmatney/dino/commit/5e1cf0a1)) feat: move/jump action hints in first two rooms
- ([`fde3f33e`](https://github.com/russmatney/dino/commit/fde3f33e)) refactor: break out ActionHint component
- ([`d0655425`](https://github.com/russmatney/dino/commit/d0655425)) fix: close world gaps, fix room auto-pof duplication

### 20 Feb 2023

- ([`bfe5f62e`](https://github.com/russmatney/dino/commit/bfe5f62e)) chore: more build exports
- ([`e0ee5eaa`](https://github.com/russmatney/dino/commit/e0ee5eaa)) feat: soldier hit/dead sounds, screenshake on death
- ([`ceda7730`](https://github.com/russmatney/dino/commit/ceda7730)) chore: update gdfxr to latest, including new SaveAs feat
- ([`4f21a855`](https://github.com/russmatney/dino/commit/4f21a855)) export: latest mvania required resources
- ([`57712686`](https://github.com/russmatney/dino/commit/57712686)) feat: enemy state machine, sword attack working
- ([`80a87492`](https://github.com/russmatney/dino/commit/80a87492)) feat: show sword action hint when a body is detected
- ([`e567beb6`](https://github.com/russmatney/dino/commit/e567beb6)) feat: sword animation, weapon, and swing attack
- ([`745ca589`](https://github.com/russmatney/dino/commit/745ca589)) feat: clean up exports, remove unused music preloads

  > Cuts the mvania build down to 33mb from 177mb - daayumm! Should load
  > much more quickly on itch now.

- ([`7e2b4946`](https://github.com/russmatney/dino/commit/7e2b4946)) feat: quick action hint via new fonts

  > Using some new fonts to communicate expected inputs at elevators. Pretty
  > sweet!
  > 
  > I didn't add the fonts to the project, instead just symlinked to my
  > game-assets dir. Not sure the best way to handle purchased content in an
  > open-source project.............

- ([`4c7b6773`](https://github.com/russmatney/dino/commit/4c7b6773)) chore: cleans up a bunch of print usage

  > Hood.prn provides colors and auto-injects the call-site's module name.
  > 
  > Consider Hood.debug_label for called too-often/too-noisey print usage.

- ([`bdcc9bec`](https://github.com/russmatney/dino/commit/bdcc9bec)) feat: customize stamp anim via options
- ([`20cd697e`](https://github.com/russmatney/dino/commit/20cd697e)) feat: basic fade tween on monster trail
- ([`f080bc4f`](https://github.com/russmatney/dino/commit/f080bc4f)) wip: rough stamp_frame func for pasting the current animation frame
- ([`ac339eb7`](https://github.com/russmatney/dino/commit/ac339eb7)) feat: cleaner debug label impl

  > Disables rearrangement for now.

- ([`cc67586f`](https://github.com/russmatney/dino/commit/cc67586f)) fix: couple nil-punny bugs

  > Some things are so much cleaner in clojure...

- ([`21fa0879`](https://github.com/russmatney/dino/commit/21fa0879)) wip: debug labels group by source file
- ([`78c35d25`](https://github.com/russmatney/dino/commit/78c35d25)) refactor: cleaner, colorized print prefixes

  > Also passes call_site along to debug labels.

- ([`6766e9ac`](https://github.com/russmatney/dino/commit/6766e9ac)) feat: consume Hood.prn for existing prn usage

  > Now printing a bit cleaner with some new logger functions.
  > 
  > - Hood.prn()  replaces  `print()`
  > - Hood.warn() replaces  `print('[WARN]: ', ...)`
  > - Hood.err()  replaces  `push_error()`


### 19 Feb 2023

- ([`ee05806e`](https://github.com/russmatney/dino/commit/ee05806e)) feat: add some new_room_blips via gdfxr!

  > Love this plugin - helps to get some game feel going without ever
  > leaving godot!

- ([`e001407c`](https://github.com/russmatney/dino/commit/e001407c)) feat: add text effects to debugLabel
- ([`64525a8d`](https://github.com/russmatney/dino/commit/64525a8d)) feat: debug labels use call stack for label_id

  > Kind of a nice api - no need to create or pass a unique label, we just
  > use the call stack to make it unique-by-callsite in the consuming
  > function.

- ([`6b7ff2ab`](https://github.com/russmatney/dino/commit/6b7ff2ab)) fix: round rather than floor zoom level

  > also moves to a min + margin setup

- ([`949d4058`](https://github.com/russmatney/dino/commit/949d4058)) fix: drop look-at point in player

  > the new zoom work makes this less necessary

- ([`aa6662dc`](https://github.com/russmatney/dino/commit/aa6662dc)) feat: MUCH nicer camera work, MvaniaRooms auto-add pofs
- ([`e5dc3bc6`](https://github.com/russmatney/dino/commit/e5dc3bc6)) wip: more camera refactor wip

  > Getting closer to understanding what's going on here

- ([`0fd709ea`](https://github.com/russmatney/dino/commit/0fd709ea)) fix: this setter kicks of a recursive loop

  > Actually crashed the editor - i was able to debug by running
  > `godot4rc2 -d -e` from the command line.

- ([`c400ceeb`](https://github.com/russmatney/dino/commit/c400ceeb)) fix: resave some pluggs scenes to get rid of warnings
- ([`9124f825`](https://github.com/russmatney/dino/commit/9124f825)) refactor: camera updates, renaming, reworking
- ([`6b83dca7`](https://github.com/russmatney/dino/commit/6b83dca7)) feat: basic togglable debug overlay with Hood.debug_label helper

  > A quick way to throw some numbers on the screen. Should be better than
  > blasting prints into the output window.

- ([`753b861c`](https://github.com/russmatney/dino/commit/753b861c)) wip: toying with the old 2d cam
- ([`9db8630b`](https://github.com/russmatney/dino/commit/9db8630b)) wip: rough pof work in area01

  > The zoom logic isn't quite there - we need to adjust the zoom/offset
  > until all pofs are in focus.

- ([`a86b22b1`](https://github.com/russmatney/dino/commit/a86b22b1)) feat: minimap centering current room

  > Not perfect, but probably good enough for a while - ideally the
  > right/bottom limits would dynamically calc a slightly better value.
  > For now they scroll a bit farther than i'd like.

- ([`04120e2a`](https://github.com/russmatney/dino/commit/04120e2a)) feat: basic minimap working
- ([`b1fb1532`](https://github.com/russmatney/dino/commit/b1fb1532)) wip: minimap updating when moving between rooms

  > Tho still not zooming/centering very well.

- ([`c58cbf7e`](https://github.com/russmatney/dino/commit/c58cbf7e)) wip: toward minimap glory
- ([`e5a92d26`](https://github.com/russmatney/dino/commit/e5a92d26)) feat: area_db signals, room contains player flag

### 18 Feb 2023

- ([`95ab783b`](https://github.com/russmatney/dino/commit/95ab783b)) fix: set better initial zoom/offset for laptop

  > Not sure what's up with this, but it's way too zoomed out to be
  > reasonable by default on my osx laptop.
  > 
  > Gotta rework/rethink this zoom/offset logic.

- ([`2e05d9e5`](https://github.com/russmatney/dino/commit/2e05d9e5)) wip: minimap attempt

  > Drawing the rooms for the current area. Next is updates and camera work.

- ([`fbe6523e`](https://github.com/russmatney/dino/commit/fbe6523e)) refactor: add player if missing after 2s

  > Should only apply to testing mvaniaAreas - otherwise,
  > MvaniaGame.load_area should immediately load the player.
  > 
  > Also updates the spawn point logic to fallback on elevator coords.

- ([`5a8eacca`](https://github.com/russmatney/dino/commit/5a8eacca)) misc: room adjustments
- ([`16b88c24`](https://github.com/russmatney/dino/commit/16b88c24)) fix: move room.used_rect according to tilemap position

  > Otherwise a tilemap that's not on the origin ends up with an offset
  > roombox.

- ([`342155c5`](https://github.com/russmatney/dino/commit/342155c5)) fix: move elevators into rooms

  > This way they get automatically hidden (instead of floating out in
  > space).
  > 
  > Fixes some logic in the elevator path builder that used owner instead of
  > parent.

- ([`84e6bd90`](https://github.com/russmatney/dino/commit/84e6bd90)) feat: quick area 3 and 4 plus more elevators

  > Making sure these travel points and room_data get persisted and
  > reloaded. You have to be a bit careful about the rooms at the moment -
  > if the tilemaps have a transform, the area2d ends up offset by that
  > transform, which leads to strange results and missed player enter/exit
  > signals.

- ([`c7bf7dab`](https://github.com/russmatney/dino/commit/c7bf7dab)) feat: persisting visited rooms across travel via room_data

  > Hopefully this pattern works for respawns and other room details as
  > well.
  > 
  > room_data is set at startup, updated as we enter/exit rooms, and pulled
  > and set when rooms are dropped/recreated across area elevator travel.

- ([`5c24f912`](https://github.com/russmatney/dino/commit/5c24f912)) feat: traveling between elevators!

  > Well, wow! this actually worked without a hiccup.
  > 
  > Includes a basic actions api on the player.
  > 
  > When you hit 'action' on an elevator, the destination area is loaded,
  > and the destination elevator is used as the spawn coordinate.

- ([`4ca46b18`](https://github.com/russmatney/dino/commit/4ca46b18)) feat: fancy elevator destination export assignment

  > Using _get_property_list to traverse the mvania/maps directory searching
  > for areas, then once selected, load+instancing the area to search for
  > elevators, finally allowing a destination elevtor 'path' to be selected.
  > 
  > Next, to put these together so visiting one elevator supports traveling
  > to a new area.

- ([`21c69bf7`](https://github.com/russmatney/dino/commit/21c69bf7)) feat: elevator exporting pre-popped area selector
- ([`ac336a73`](https://github.com/russmatney/dino/commit/ac336a73)) feat: add Elevator node, mark rooms visited

  > We only fade visited rooms, otherwise they remain hidden.

- ([`48768efc`](https://github.com/russmatney/dino/commit/48768efc)) feat: area02 quick layout, fade other rooms (rather than hide)
- ([`08bf2539`](https://github.com/russmatney/dino/commit/08bf2539)) fix: don't update rooms when no current area

  > This player-fired signal isn't relevant when demoing rooms, so we
  > nil-pun it when we are in an invalid state.

- ([`ce7b5bc7`](https://github.com/russmatney/dino/commit/ce7b5bc7)) feat: updated player and soldier animations

### 17 Feb 2023

- ([`9961ba23`](https://github.com/russmatney/dino/commit/9961ba23)) feat: toying with directional light 2D
- ([`3059a4a0`](https://github.com/russmatney/dino/commit/3059a4a0)) feat: mvania19 export, readme games update
- ([`661b770b`](https://github.com/russmatney/dino/commit/661b770b)) feat: game runs from main menu

  > Fixes for the MvaniaGame.restart_game() code path.
  > 
  > - Clears extra player instances left in areas/rooms
  > - Updates Navi.nav_to to support passed instances
  > - Rearranges MvaniaGame player creation to ensure navi has set the scene
  >   before the player is added
  > - Updates Hood to search for the player after the HUD has been ensured,
  >   which makes more sense than on _ready() (b/c the Hood.ensure_hud call
  >   comes from the player, we're more likely to be successful)

- ([`b0d143aa`](https://github.com/russmatney/dino/commit/b0d143aa)) chore: clean up
- ([`0d1df11b`](https://github.com/russmatney/dino/commit/0d1df11b)) chore: logs for proving soldiers aren't processing
- ([`a7966f2d`](https://github.com/russmatney/dino/commit/a7966f2d)) feat: pause rooms we're not in
- ([`a87e05d1`](https://github.com/russmatney/dino/commit/a87e05d1)) feat: add gravity to soldiers, fix room pausing
- ([`8ed88a00`](https://github.com/russmatney/dino/commit/8ed88a00)) fix: only update rooms based on player
- ([`296201e5`](https://github.com/russmatney/dino/commit/296201e5)) feat: showing active room upon entering!
- ([`382ebee3`](https://github.com/russmatney/dino/commit/382ebee3)) fix: clean up roomboxes when adding
- ([`2501e522`](https://github.com/russmatney/dino/commit/2501e522)) fix: update collision masks/layers in monster/soldier
- ([`22d040a3`](https://github.com/russmatney/dino/commit/22d040a3)) feat: mvaniaRooms adding their own area2d RoomBoxes
- ([`7a228a83`](https://github.com/russmatney/dino/commit/7a228a83)) wip: hiding all but current room

  > A shot at managing area/room state, with the hope of things working from
  > MvaniaGame.restart_game() and when loading an arbitrary area.

- ([`5efc6b9b`](https://github.com/russmatney/dino/commit/5efc6b9b)) refactor: move logic around - to_room_data

  > MvaniaGame connecting to Hood for hud/player ready signals.

- ([`84f2de58`](https://github.com/russmatney/dino/commit/84f2de58)) wip: maybe viable MvaniaGame recreate_db at game startup
- ([`5600e1c2`](https://github.com/russmatney/dino/commit/5600e1c2)) feat: writing and reading area/room data via MvaniaGame

  > Pseudo area and room data storage, and a new type: MvaniaArea.

- ([`5ec5af92`](https://github.com/russmatney/dino/commit/5ec5af92)) feat: drawing room border lines

  > Coming along!

- ([`04fcabc8`](https://github.com/russmatney/dino/commit/04fcabc8)) feat: MvaniaRoom and MapEditor script init: rect calc funcs

  > Calcing room rectangles in tile and local coords.


### 16 Feb 2023

- ([`71795fb4`](https://github.com/russmatney/dino/commit/71795fb4)) feat: 8 rooms - quick area 1 map
- ([`65d6fb34`](https://github.com/russmatney/dino/commit/65d6fb34)) fix: update stretch/mode to something godot 4 supported

  > Not sure this is the desired mode, but w/e for now.

- ([`41c1c288`](https://github.com/russmatney/dino/commit/41c1c288)) fix: deprecated shader_param warnings, restore harvey gameplay
- ([`e53f23a6`](https://github.com/russmatney/dino/commit/e53f23a6)) feat: updates the max zoom

  > Rather than scaling the art like usual, i'm updating the camera to be
  > able to zoom in.

- ([`0232d419`](https://github.com/russmatney/dino/commit/0232d419)) feat: clone monster into greyhat, move to lilbighat sprites

  > This player is a nice starting point for whatever going forward.
  > 
  > Adds new sprites: lilbighat, with some animations - updates the
  > monster (player) to use the new animations.

- ([`be6cde72`](https://github.com/russmatney/dino/commit/be6cde72)) feat: add outline to orange soldier
- ([`79fce1f4`](https://github.com/russmatney/dino/commit/79fce1f4)) wip: mvania initial enemy art and scenes
- ([`9503d5c3`](https://github.com/russmatney/dino/commit/9503d5c3)) art: add old concept aseprite file

### 15 Feb 2023

- ([`d5674718`](https://github.com/russmatney/dino/commit/d5674718)) misc: clean up some prints, add mvania game script
- ([`f7881752`](https://github.com/russmatney/dino/commit/f7881752)) wip: init boxes, treasure, doors

  > Adds art and basic nodes + scripts for boxes, treasure, and doors.

- ([`5bf0442e`](https://github.com/russmatney/dino/commit/5bf0442e)) misc: tile clean up
- ([`86fab9d7`](https://github.com/russmatney/dino/commit/86fab9d7)) feat: add fall, heavyfall sounds
- ([`722ceabe`](https://github.com/russmatney/dino/commit/722ceabe)) feat: restore screenshake

  > floats vs ints yet again. thanks for the trivia, gdscript!

- ([`4e2d0f5e`](https://github.com/russmatney/dino/commit/4e2d0f5e)) feat: coyote time, fall speed shake/damage calc
- ([`7526b281`](https://github.com/russmatney/dino/commit/7526b281)) wip: more detailed demo map
- ([`5ca68ff8`](https://github.com/russmatney/dino/commit/5ca68ff8)) fix: slimmer collision shape, to slip through 1 tile gaps
- ([`e7611e0a`](https://github.com/russmatney/dino/commit/e7611e0a)) fix: slow down in idle state

  > experienced some locking/ghost running - might still be a bug in some
  > state in here.

- ([`c3c1d511`](https://github.com/russmatney/dino/commit/c3c1d511)) feat: some jump sounds
- ([`9c9f08cf`](https://github.com/russmatney/dino/commit/9c9f08cf)) feat: add save-dupe to gdfxr (now for godot 4)

  > I did this for godot 3 a few weeks ago here:
  > 
  > https://github.com/russmatney/dino/commit/f28459fe436f5b10ada14558c92b9e5d4497f7d4

- ([`0bdd5740`](https://github.com/russmatney/dino/commit/0bdd5740)) feat: djSoundMap class, mvania sound map, jump sound
- ([`01bbd5b5`](https://github.com/russmatney/dino/commit/01bbd5b5)) feat: mvania, basic player state machine
- ([`c525f493`](https://github.com/russmatney/dino/commit/c525f493)) feat: misc hood notif fixes
- ([`341a7378`](https://github.com/russmatney/dino/commit/341a7378)) fix: canvas layers shouldn't follow viewport, queue early notifs
- ([`c170dac9`](https://github.com/russmatney/dino/commit/c170dac9)) feat: mvania19 - player (monster), demo tiles
- ([`ff9df7d0`](https://github.com/russmatney/dino/commit/ff9df7d0)) feat: Hood basic fallback HUD with notifications
- ([`a09435f2`](https://github.com/russmatney/dino/commit/a09435f2)) feat: basic coldfire tiles

  > One tilemap this time, with custom data and physics layers applied.

- ([`00cea6f4`](https://github.com/russmatney/dino/commit/00cea6f4)) chore: misc clean up

### 14 Feb 2023

- ([`3b4cf0c0`](https://github.com/russmatney/dino/commit/3b4cf0c0)) wip: MapGen at least generating an image again

  > Still no tiles being created, but maybe MapGen provides a better devloop.

- ([`493800d4`](https://github.com/russmatney/dino/commit/493800d4)) wip: towards restoring tower jet

  > MapGen not working yet, but we're at least through the reported errors.

- ([`a27ecc76`](https://github.com/russmatney/dino/commit/a27ecc76)) feat: refactor away from more popup panels

  > And prefer NaviButtonLists where relevant.

- ([`cfd47130`](https://github.com/russmatney/dino/commit/cfd47130)) feat: navi refactor, move dino menu to canvas layer

  > sets canvas layers for the other navi menus.

- ([`1d57a15b`](https://github.com/russmatney/dino/commit/1d57a15b)) fix: restore pause/win/death menus

  > Moved these from PopupPanels to CanvasLayers to maintain control of them
  > - that structure is likely a better fit anyway. Also updates the
  > NaviButtonList to work of 'fn' callables instead of 'obj' and 'method',
  > which is an awful lot cleaner.


### 13 Feb 2023

- ([`cf62160e`](https://github.com/russmatney/dino/commit/cf62160e)) misc: clean up menus somewhat, mostly poking at popups
- ([`7f86b4ef`](https://github.com/russmatney/dino/commit/7f86b4ef)) wip: drop room.tscn, redraw maze.tscn

  > Maze is dead, apparently

- ([`7d471d52`](https://github.com/russmatney/dino/commit/7d471d52)) fix: restore info, action, debug labels on dungeon crawler player
- ([`e6df41d2`](https://github.com/russmatney/dino/commit/e6df41d2)) feat: dungeon crawler playable again

  > Restores door action collision detection via updated collision mask.

- ([`4a7b40f2`](https://github.com/russmatney/dino/commit/4a7b40f2)) fix: restore goomba wall bounce, animation, turn
- ([`b23c7180`](https://github.com/russmatney/dino/commit/b23c7180)) feat: recreates a 3x3 tilemap and tileset, and draws it in dungeon crawler

  > Creates a basic tilemap and tileset to learn and impl godot 4's
  > autotiling and tile collision setup.
  > 
  > Draws a basic working tilemap on dungeon crawler.

- ([`182268d3`](https://github.com/russmatney/dino/commit/182268d3)) chore: drop tileSetTools - not relevant in godot 4

  > Godot 4's UI improves the things tileSetTools.gd was handling -
  > specifically making it easy to apply a collision shape to multiple
  > tiles. Now you can do the same via the 'paint' interaction on a tileset.

- ([`7c72445a`](https://github.com/russmatney/dino/commit/7c72445a)) wip: delete existing tilemaps and tilesets

### 11 Feb 2023

- ([`a68bc068`](https://github.com/russmatney/dino/commit/a68bc068)) docs: godot 4 readme note
- ([`ec971830`](https://github.com/russmatney/dino/commit/ec971830)) chore: remaining errors and warnings (via lsp-ui-flycheck-list)

  > Much easier to find and fix things with the editor cooperating!

- ([`b202a805`](https://github.com/russmatney/dino/commit/b202a805)) chore: delete all the tests. yep! godot-ing wild!
- ([`f13374f0`](https://github.com/russmatney/dino/commit/f13374f0)) chore: drop Kink. I've dropped ink as well, will come back to this
- ([`8f380d35`](https://github.com/russmatney/dino/commit/8f380d35)) chore: drop gut (hopefully only temporary)

  > I wasn't using it much either way. Will add back in once things are
  > smoother and i can focus on it.

- ([`26a318b1`](https://github.com/russmatney/dino/commit/26a318b1)) fix: more parser errors revealed after fixing lsp port

  > The lsp port moved! Debugging experience is much better when we can rely
  > on the editor, should have seen this detail sooner!

- ([`29279e06`](https://github.com/russmatney/dino/commit/29279e06)) chore: drop godot-sfxr. I've moved to gdfxr completely
- ([`42c07299`](https://github.com/russmatney/dino/commit/42c07299)) feat: dino export added, sort of running

  > Well hey, things are sort of back. not normal - need to redo the menus,
  > cameras, tiles, shaders.... but it should be smoother from here.

- ([`cec1d848`](https://github.com/russmatney/dino/commit/cec1d848)) fix: bunch of unparsable scripts in ghosts

  > game is now running! No tiles tho, so everywhere is a free-fall.

- ([`b28f5213`](https://github.com/russmatney/dino/commit/b28f5213)) fix: bindv, not bind. runner running (with errors, no tiles)

  > Bunch of re-arting to do here, but i'm pretty ok with that across the
  > board given the current state of this repo.

- ([`7bcbe1e3`](https://github.com/russmatney/dino/commit/7bcbe1e3)) fix: dungeon crawler running again (no tiles or doors)

  > No crashes, at least.
  > 
  > Menus, zoom still a mess. Likely some quick camera refactor wins.


### 10 Feb 2023

- ([`33f6c8d1`](https://github.com/russmatney/dino/commit/33f6c8d1)) feat: pull godot-4 gdfxr latest, reimport sounds, enable plugin

  > web export playing sound!

- ([`da85d30c`](https://github.com/russmatney/dino/commit/da85d30c)) feat: include everything in gunner export - working web export!
- ([`ecf28489`](https://github.com/russmatney/dino/commit/ecf28489)) wip: web export attempt (unsuccessful)
- ([`bd8a2ab8`](https://github.com/russmatney/dino/commit/bd8a2ab8)) fix: don't add empty array of args to every signal
- ([`e5be7ea8`](https://github.com/russmatney/dino/commit/e5be7ea8)) wip: more godot 4 resource auto-rewrites
- ([`d5982213`](https://github.com/russmatney/dino/commit/d5982213)) fix: more arrays as bools, renames, dropped anim code
- ([`0badea44`](https://github.com/russmatney/dino/commit/0badea44)) fix: more lurkers. not sure why these are showing up now
- ([`38134e4a`](https://github.com/russmatney/dino/commit/38134e4a)) fix: add input map keys back

  > Seems these get dropped in 3 to 4

- ([`371e4334`](https://github.com/russmatney/dino/commit/371e4334)) wip: basic tileset with collision

  > Some solid ground to stand on.

- ([`f3ad3337`](https://github.com/russmatney/dino/commit/f3ad3337)) fix: recreate dropped (?!) sprite frames, fix camera add

  > No more errors in gunner PlayerGym! besides the complete lack of tiles.

- ([`bf742bb8`](https://github.com/russmatney/dino/commit/bf742bb8)) hack: get text effects running (character, absolute_index -> glyph_index)

  > This is not an equivalent fix, but at least gets these 'running' again.

- ([`89f97b0b`](https://github.com/russmatney/dino/commit/89f97b0b)) wip: cam and hud in gunner at least starting up!
- ([`3ad07493`](https://github.com/russmatney/dino/commit/3ad07493)) misc: logs and debugging and some refactor
- ([`a98c3180`](https://github.com/russmatney/dino/commit/a98c3180)) fix: @export conversion helper breaks file syntax

  > The entire script wasn't parsing, but running the project doesn't
  > indicate this at all. Finally i realized the player's _ready() was never
  > being called, and eventually got an error for this.

- ([`bca4f5b8`](https://github.com/russmatney/dino/commit/bca4f5b8)) fix: await owner.ready seems to not work

  > Moving to manually starting the state machine, which might be better
  > anyway.

- ([`fe0f0deb`](https://github.com/russmatney/dino/commit/fe0f0deb)) fix: set default texture_filter for pixel art

  > A new godot4 option that covers this 'everywhere', but not in sprite frame animations.


### 9 Feb 2023

- ([`696c60e3`](https://github.com/russmatney/dino/commit/696c60e3)) chore: runner running again (tho not really working)
- ([`dd19cc9c`](https://github.com/russmatney/dino/commit/dd19cc9c)) wip: tower rendering again (no player tho)
- ([`3d0b271e`](https://github.com/russmatney/dino/commit/3d0b271e)) wip: some things happening in harvey!

  > animations and controls broken, but it's alive again.

- ([`1202cd00`](https://github.com/russmatney/dino/commit/1202cd00)) fix: couple more lurkers

  > - OS.window_size lines completely deleted leaving some invalid
  >   functions, which were never parsing, causing upstream classes to go missing
  > - a lurking FastNoiseLite conversion under that error
  > - 'ready' var now unavailable
  > - bunch of noise for various scenes recreating themselves as i browse around

- ([`19c96ceb`](https://github.com/russmatney/dino/commit/19c96ceb)) fix: main menu running!
- ([`3c0e887a`](https://github.com/russmatney/dino/commit/3c0e887a)) chore: end of errors/warnings

  > (Now, why doesn't TowerRoom exist?)

- ([`dd07b1d6`](https://github.com/russmatney/dino/commit/dd07b1d6)) fix: replacing 'ord()', removing 'deprecated' shader impls
- ([`a7b10baf`](https://github.com/russmatney/dino/commit/a7b10baf)) fix: bunch of breaking changes
- ([`a3ac1998`](https://github.com/russmatney/dino/commit/a3ac1998)) chore: drop ink (will replace with godot-4 version)
- ([`7871de29`](https://github.com/russmatney/dino/commit/7871de29)) chore: more 3 to 4 nonsense
- ([`9f091277`](https://github.com/russmatney/dino/commit/9f091277)) chore: bunch more 3 to 4 hide and seek updates
- ([`051cbe11`](https://github.com/russmatney/dino/commit/051cbe11)) fix: bunch of 3 to 4 api changes

  > Breaking all the things.

- ([`7a7ac61c`](https://github.com/russmatney/dino/commit/7a7ac61c)) fix: editor_hint is now is_editor_hint()

  > according to the docs, it's because it's read-only.... maniacs.

- ([`0afa6d83`](https://github.com/russmatney/dino/commit/0afa6d83)) chore: godot 3to4 tool automatic updates, plus asset reimport

### 8 Feb 2023

- ([`2f0b3f27`](https://github.com/russmatney/dino/commit/2f0b3f27)) wip: navi button list refactor

### 5 Feb 2023

- ([`314de027`](https://github.com/russmatney/dino/commit/314de027)) feat: snake fixes and build update
- ([`ad806163`](https://github.com/russmatney/dino/commit/ad806163)) feat: win refactor, bug squashing, snake main menu

  > DJ song pause/resume helpers


### 4 Feb 2023

- ([`da566d8c`](https://github.com/russmatney/dino/commit/da566d8c)) chore: update exports

  > Snake not quite working again.

- ([`1f34ff96`](https://github.com/russmatney/dino/commit/1f34ff96)) feat: quick quest-clear and level system

  > Two levels. Lots of clean up, but it's sort of working.

- ([`c8fea8c7`](https://github.com/russmatney/dino/commit/c8fea8c7)) wip: multiple grids running

  > Not yet connected.

- ([`d05c24af`](https://github.com/russmatney/dino/commit/d05c24af)) fix: show trapped rotation better
- ([`bf3e9826`](https://github.com/russmatney/dino/commit/bf3e9826)) feat: support optional, fail-only, count-based quests

  > Impl StayAlive as a quest.

- ([`e7297b86`](https://github.com/russmatney/dino/commit/e7297b86)) feat: quest status showing complete/not
- ([`b89171b6`](https://github.com/russmatney/dino/commit/b89171b6)) wip: basic quest autoload, registry, status panel
- ([`d88d3d62`](https://github.com/russmatney/dino/commit/d88d3d62)) feat: basic killTheSnakes node
- ([`ff8d31ad`](https://github.com/russmatney/dino/commit/ff8d31ad)) refactor: pulls snake scenes/scripts into dirs
- ([`aca691a1`](https://github.com/russmatney/dino/commit/aca691a1)) feat: snakes chomp/eat each other
- ([`2a15a8ab`](https://github.com/russmatney/dino/commit/2a15a8ab)) feat: move player setup to Player.gd, DJ song don't play twice
- ([`34e6c965`](https://github.com/russmatney/dino/commit/34e6c965)) wip: differentiating which snake we're biting
- ([`1afaf5b1`](https://github.com/russmatney/dino/commit/1afaf5b1)) feat: basic snake heads for readability
- ([`0d0a8d9c`](https://github.com/russmatney/dino/commit/0d0a8d9c)) feat: green player snake, dry up set random frame
- ([`1af1cc5c`](https://github.com/russmatney/dino/commit/1af1cc5c)) feat: lazer/leap sound effect
- ([`9ff44bb0`](https://github.com/russmatney/dino/commit/9ff44bb0)) feat: juicier leap (flash, text effect)
- ([`c50c343b`](https://github.com/russmatney/dino/commit/c50c343b)) feat: rough clear-the-grid script

  > Maybe a good base for the upcoming Quest addon

- ([`e92ba15f`](https://github.com/russmatney/dino/commit/e92ba15f)) fix: only connect to player signals in Player.gd
- ([`ce561a0f`](https://github.com/russmatney/dino/commit/ce561a0f)) feat: add enemy in grid

  > Kind of fun to toy with. needs a different color.

- ([`a8e3ad7d`](https://github.com/russmatney/dino/commit/a8e3ad7d)) feat: pull player out of Snake, move grid to ~snakes~
- ([`da7920e2`](https://github.com/russmatney/dino/commit/da7920e2)) feat: hold shift to slow down and move manually

  > Feeling good, tho pretty chaotic.

- ([`7b2e8933`](https://github.com/russmatney/dino/commit/7b2e8933)) feat: collect combo juice from yellow cells

  > Not too shabby! 46 lines.


### 3 Feb 2023

- ([`8ab34113`](https://github.com/russmatney/dino/commit/8ab34113)) wip: inheritance :puke:
- ([`9aea3eda`](https://github.com/russmatney/dino/commit/9aea3eda)) feat: snake export/deploy
- ([`adc5b890`](https://github.com/russmatney/dino/commit/adc5b890)) feat: text highlight when bumping into yourself
- ([`03f3ad08`](https://github.com/russmatney/dino/commit/03f3ad08)) feat: fun text effect when eating food
- ([`35b3e2c4`](https://github.com/russmatney/dino/commit/35b3e2c4)) feat: leap to food when aligned

  > A fun feature - now jumping to the next food bit when moving toward it.

- ([`97ed7228`](https://github.com/russmatney/dino/commit/97ed7228)) fix: cleaner food cell animation
- ([`30fb5ac1`](https://github.com/russmatney/dino/commit/30fb5ac1)) feat: tweaking cell deformation

  > Moved away from knockback for the moment.

- ([`322eb4e1`](https://github.com/russmatney/dino/commit/322eb4e1)) refactor: clean up snake/grid coord impls

  > A bit cleaner... still not loving it.


### 2 Feb 2023

- ([`576d18f7`](https://github.com/russmatney/dino/commit/576d18f7)) feat: add particle effect and some textures

  > Also, less screenshake in snake.

- ([`1fb1943e`](https://github.com/russmatney/dino/commit/1fb1943e)) refactor: snake logic cleanup and some var renames
- ([`4fbb2775`](https://github.com/russmatney/dino/commit/4fbb2775)) fix: camera bug, better zoom levels for snake

  > Not quite zooming on slow mo yet, but getting there.

- ([`048d152f`](https://github.com/russmatney/dino/commit/048d152f)) fix: better cam mode 3 logic (don't require 'pof_follows')

  > Now we get proper zooming even if the player isn't in the 'pof'
  > group (and no other pofs show up).
  > 
  > Also adds zoom on the time-slow-down in snake.

- ([`13cbfbc7`](https://github.com/russmatney/dino/commit/13cbfbc7)) feat: loop all songs
- ([`0c3ff2ac`](https://github.com/russmatney/dino/commit/0c3ff2ac)) feat: extend DJ to support default opts, tuples

  > DJ can now play songs configured in sound_maps. default opts can be
  > passed to setup_sound_map, and per-audio-stream opts can be passed if
  > you nest the stream in a tuple (2nd arg is an opts dict).

- ([`3f4489dd`](https://github.com/russmatney/dino/commit/3f4489dd)) feat: add some tunes courtesy of sulosounds
- ([`43a3f503`](https://github.com/russmatney/dino/commit/43a3f503)) feat: speed up sounds, and faster speeds
- ([`4c8d5ff9`](https://github.com/russmatney/dino/commit/4c8d5ff9)) feat: sound when bumping into existing snake
- ([`56b5ed6a`](https://github.com/russmatney/dino/commit/56b5ed6a)) feat: Hood.notif and NotifRichLabel supporting text effects
- ([`758385ea`](https://github.com/russmatney/dino/commit/758385ea)) feat: show speed level in hud
- ([`111b1ef4`](https://github.com/russmatney/dino/commit/111b1ef4)) feat: add step counter
- ([`0cd57cf0`](https://github.com/russmatney/dino/commit/0cd57cf0)) feat: snake hood showing food count

  > Pulls more hud logic into Hood helpers.

- ([`7e8c0e73`](https://github.com/russmatney/dino/commit/7e8c0e73)) feat: reusable Hood.Notifications component

  > Initial Snake HUD with some notifications. Learned to use a panel
  > container to set a background - not too bad.

- ([`6cca4046`](https://github.com/russmatney/dino/commit/6cca4046)) feat: bounce all on food pickup
- ([`63ac76e4`](https://github.com/russmatney/dino/commit/63ac76e4)) feat: initial snake walk, pickup sounds
- ([`9c38d577`](https://github.com/russmatney/dino/commit/9c38d577)) feat: snake walk, pickup sounds
- ([`f28459fe`](https://github.com/russmatney/dino/commit/f28459fe)) feat: gdfxr quick duplicate support
- ([`3977358e`](https://github.com/russmatney/dino/commit/3977358e)) feat: default slowmo speed
- ([`8f031124`](https://github.com/russmatney/dino/commit/8f031124)) feat: hold shift for slowmo
- ([`522b80ca`](https://github.com/russmatney/dino/commit/522b80ca)) feat: more bounce tweaks

### 1 Feb 2023

- ([`6a2b3307`](https://github.com/russmatney/dino/commit/6a2b3307)) feat: rotate segment, food bounces
- ([`1d42ce24`](https://github.com/russmatney/dino/commit/1d42ce24)) feat: a very bouncy snake game
- ([`0f50105c`](https://github.com/russmatney/dino/commit/0f50105c)) feat: mark touched tiles, use _process

  > Refactors away from a tween (fixing a leaky tweens bug)

- ([`4479c16a`](https://github.com/russmatney/dino/commit/4479c16a)) fix: slower speedup, attempt at zooming in
- ([`5454b159`](https://github.com/russmatney/dino/commit/5454b159)) feat: ensure camera, add screenshake
- ([`2e56eaeb`](https://github.com/russmatney/dino/commit/2e56eaeb)) chore: format snake gdscripts
- ([`c8a48a41`](https://github.com/russmatney/dino/commit/c8a48a41)) feat: speed up every 3 foods eaten
- ([`5a52e7f4`](https://github.com/russmatney/dino/commit/5a52e7f4)) feat: consuming food and growing
- ([`b044fb9f`](https://github.com/russmatney/dino/commit/b044fb9f)) feat: steering snake in directions

  > Went with a queue of moves. Ignores movement against the current
  > direction. Movement in the same direction has no effect, but maybe it
  > could give a boost?

- ([`a29ed172`](https://github.com/russmatney/dino/commit/a29ed172)) feat: snake crawling
- ([`3c62586c`](https://github.com/russmatney/dino/commit/3c62586c)) feat: initing snake on grid
- ([`bb02fbe6`](https://github.com/russmatney/dino/commit/bb02fbe6)) feat: basic cell, grid drawing sprites
- ([`18a8652e`](https://github.com/russmatney/dino/commit/18a8652e)) chore: format all

### 23 Jan 2023

- ([`e5a91ff8`](https://github.com/russmatney/dino/commit/e5a91ff8)) docs: add tower and update some addons in readme

### 22 Jan 2023

- ([`1b3768e1`](https://github.com/russmatney/dino/commit/1b3768e1)) fix: include all tower files in build
- ([`d625e336`](https://github.com/russmatney/dino/commit/d625e336)) fix: prevent text wrap
- ([`eb8c95fb`](https://github.com/russmatney/dino/commit/eb8c95fb)) fix: disable menu music

  > this sometimes takes so long to start that it comes on during the game. :/

- ([`2f2ef8c2`](https://github.com/russmatney/dino/commit/2f2ef8c2)) feat: adds FINAL level and a bit more juice
- ([`eaa055af`](https://github.com/russmatney/dino/commit/eaa055af)) feat: buncha more sounds
- ([`8580f25c`](https://github.com/russmatney/dino/commit/8580f25c)) feat: indicators for blue/red tile effects
- ([`ac6df9c8`](https://github.com/russmatney/dino/commit/ac6df9c8)) feat: enemy aims a bit higher, much larger vision box
- ([`b7e28992`](https://github.com/russmatney/dino/commit/b7e28992)) fix: fall damage based on speed, not distance
- ([`b7e94cfc`](https://github.com/russmatney/dino/commit/b7e94cfc)) feat: level progression
- ([`f3f6c955`](https://github.com/russmatney/dino/commit/f3f6c955)) feat: play through 5 tower climb levels
- ([`6217d38d`](https://github.com/russmatney/dino/commit/6217d38d)) feat: improve hud with panels, add enemy counts
- ([`d9e0706d`](https://github.com/russmatney/dino/commit/d9e0706d)) fix: offscreen indicator looks for player even after 'ready'
- ([`268e739d`](https://github.com/russmatney/dino/commit/268e739d)) feat: break out 3 towerclimb levels
- ([`5c15eb5a`](https://github.com/russmatney/dino/commit/5c15eb5a)) feat: ensure enemy/player spawn points are above floor tiles
- ([`7d09dce4`](https://github.com/russmatney/dino/commit/7d09dce4)) refactor: reptile/tower room cleanup

### 21 Jan 2023

- ([`9a902096`](https://github.com/russmatney/dino/commit/9a902096)) feat: sort-of-working regen_rooms while playing
- ([`61b056ab`](https://github.com/russmatney/dino/commit/61b056ab)) wip: more room regen attempts
- ([`73298c6c`](https://github.com/russmatney/dino/commit/73298c6c)) wip: regenerating world per play through
- ([`a56752fb`](https://github.com/russmatney/dino/commit/a56752fb)) feat: death/win states handled, print clean up

  > Misc other fixes

- ([`d3a12d42`](https://github.com/russmatney/dino/commit/d3a12d42)) feat: rooms add player/enemy spawn points

  > Some lifecycle handling for spawning players, enemies when the level
  > start/when items are collected.

- ([`8229a3ff`](https://github.com/russmatney/dino/commit/8229a3ff)) feat: red/blue hot/cold jetpack influence

  > and other jetpack/run speed tweaks

- ([`5d58e143`](https://github.com/russmatney/dino/commit/5d58e143)) feat: player knockback, damage, and death
- ([`92bde0d4`](https://github.com/russmatney/dino/commit/92bde0d4)) feat: enemy robots shooting at players

  > if the player is in the visionBox and the first collider via
  > ray-cast (line of sight), the robot shoots!

- ([`ee55eb42`](https://github.com/russmatney/dino/commit/ee55eb42)) feat: bullets killing enemy robots
- ([`0673a204`](https://github.com/russmatney/dino/commit/0673a204)) feat: basic enemy robot
- ([`edc3a748`](https://github.com/russmatney/dino/commit/edc3a748)) feat: emit signal on targets cleared

  > also reduces last-target slowmo even further.

- ([`d17db707`](https://github.com/russmatney/dino/commit/d17db707)) feat: wiggling, rotating pickups and targets
- ([`a04199ed`](https://github.com/russmatney/dino/commit/a04199ed)) feat: add offscreen indicator to pickups, pickups to tower climb

  > Also a shine shader to the offscreen indicator arrow.

- ([`0d77a07c`](https://github.com/russmatney/dino/commit/0d77a07c)) feat: re-enable screenwrapping

  > If you get stuck, you can fire your way out via the destructible tiles. :shrug:

- ([`03ea7e85`](https://github.com/russmatney/dino/commit/03ea7e85)) feat: destructible tiles

  > Also disables wrapping of player and bullets. Gotta prevent wrapping if
  > there's a wall on the other side first.

- ([`a1d4b6c2`](https://github.com/russmatney/dino/commit/a1d4b6c2)) feat: basic player world wrap in tower climb
- ([`724b2ad8`](https://github.com/russmatney/dino/commit/724b2ad8)) feat: calc_rect(_global) in reptile room returns size in local/global coords
- ([`10cec7fb`](https://github.com/russmatney/dino/commit/10cec7fb)) feat: add color variants to tilesets

  > idea from squirrel's camera juicing talk demos


### 20 Jan 2023

- ([`a729b60f`](https://github.com/russmatney/dino/commit/a729b60f)) feat: create tower specific tiles, adjust player colors based on background tile
- ([`f19b863f`](https://github.com/russmatney/dino/commit/f19b863f)) fix: more off palette lurkers
- ([`8c33dec7`](https://github.com/russmatney/dino/commit/8c33dec7)) fix: move errything over to coldfire colors
- ([`60a7b8cc`](https://github.com/russmatney/dino/commit/60a7b8cc)) chore: 'tower' build, export, menus, hud, autoload

  > Breaks a few reusable feats out of the gunner autoload: respawner, hood,
  > gunnerSounds.
  > 
  > Writes a tower autoload and configures a tower build and export.

- ([`279b7c62`](https://github.com/russmatney/dino/commit/279b7c62)) fix: remove slow mo for entire last target
- ([`d950f012`](https://github.com/russmatney/dino/commit/d950f012)) chore: move tower logic to top-level game dir
- ([`27180069`](https://github.com/russmatney/dino/commit/27180069)) feat: latest playable something or other
- ([`927a4169`](https://github.com/russmatney/dino/commit/927a4169)) feat: tilemap_cells helpers, spawn targets in random locations

  > Now adding targets when regenerating tiles!

- ([`df369072`](https://github.com/russmatney/dino/commit/df369072)) feat: add img_rotate to reptile room
- ([`b8d20b5e`](https://github.com/russmatney/dino/commit/b8d20b5e)) feat: add flip_x/y to reptile rooms

### 19 Jan 2023

- ([`8cd6a96d`](https://github.com/russmatney/dino/commit/8cd6a96d)) refactor: move to 'tower' dir, build 32x32 cell map with border
- ([`8919a2a2`](https://github.com/russmatney/dino/commit/8919a2a2)) refactor: pull towerClimb logic into towerRoom, start/middle/end

  > Nearly to something workable, and starting to benefit from the
  > interactivity. Learning lessons about set_owner, editable_children, and
  > disabling the 2d-editor panning constraint.

- ([`158ef4c3`](https://github.com/russmatney/dino/commit/158ef4c3)) refactor: rename reptile gen helpers

  > ReptileRoom and ReptileGroup, better than MapRoom and MapGroup.
  > 
  > Removes generated maps from initial MapGen toying.

- ([`c34e4781`](https://github.com/russmatney/dino/commit/c34e4781)) fix: cleaner MapGen scene

  > This thing is just about dead - could serve as a reference for using
  > MapRooms going forward.

- ([`b782a1cd`](https://github.com/russmatney/dino/commit/b782a1cd)) refactor: promote MapGroup to node to support more room regen

  > MapGroups now expose bounds and tiles for editing/updating generated
  > rooms after they have been generated. A bit annoying as a dev cycle in
  > the editor, but as a proof of concept for editing constraints in
  > real-time, it's pretty cool.


### 18 Jan 2023

- ([`788d9620`](https://github.com/russmatney/dino/commit/788d9620)) chore: fix whiney warning
- ([`9d674a9c`](https://github.com/russmatney/dino/commit/9d674a9c)) feat: randomize room inputs, toggle misc tile collisions

  > TowerClimb is sort of playable now?

- ([`517f1696`](https://github.com/russmatney/dino/commit/517f1696)) feat: gen room above/below/left/right previous
- ([`346f92d0`](https://github.com/russmatney/dino/commit/346f92d0)) refactor: pull MapRoom out of MapGen

  > Move to creating rooms and letting rooms regenerate themselves after the
  > fact.

- ([`0720e38e`](https://github.com/russmatney/dino/commit/0720e38e)) feat: towerclimb adding mapgens that remain editable

  > starting to get somewhere! Generating connected maps along with
  > instances of mapgen to regen/edit the created images.

- ([`b1c897fb`](https://github.com/russmatney/dino/commit/b1c897fb)) feat: towerclimb consuming latest MapGen api
- ([`3119e495`](https://github.com/russmatney/dino/commit/3119e495)) chore: explicitly save coldfire tilesets

  > I think this is the best practice. I'd hoped this would solve a strange
  > error, but no dice.

- ([`2d767414`](https://github.com/russmatney/dino/commit/2d767414)) feat: MapGen ensures images if missing, optionally skips images

  > Also breaks out internal classes, in case this is what's breaking the
  > reload.

- ([`441c1e32`](https://github.com/russmatney/dino/commit/441c1e32)) wip: nearly working multi-map-gen from TowerClimb scene
- ([`aee1ee07`](https://github.com/russmatney/dino/commit/aee1ee07)) refactor: clean up tree pretty print, prints

  > Also .free() instead of queue_free() on gen_node children.

- ([`48228e77`](https://github.com/russmatney/dino/commit/48228e77)) feat: add clear trigger to mapgen

  > for easier removal of generated rooms.

- ([`5937fa80`](https://github.com/russmatney/dino/commit/5937fa80)) chore: rename force-reload, reload-scene

### 17 Jan 2023

- ([`db7eedcd`](https://github.com/russmatney/dino/commit/db7eedcd)) chore: clean up MapGen prints
- ([`fa8cc861`](https://github.com/russmatney/dino/commit/fa8cc861)) core: add 'Force Reload' control to editor container

  > Adds a button that calls `reload_scene_from_path` for the currently
  > edited node, which forces the editor to use the latest version of the
  > script.

- ([`3a0dd6c5`](https://github.com/russmatney/dino/commit/3a0dd6c5)) misc: MapGen updates
- ([`f44c4cc9`](https://github.com/russmatney/dino/commit/f44c4cc9)) refactor: MapGen dicts now internal MapGroup and CoordCtx types

  > Probably too early to solidify these, but these might help break more
  > behavior out of this class.

- ([`ac6e7409`](https://github.com/russmatney/dino/commit/ac6e7409)) feat: reptile MapGen as a class

  > Toying with ways of consuming MapGen - realized it doesn't need to be an
  > instance, and learned to print a filtered list of script variables.

- ([`0ed9a174`](https://github.com/russmatney/dino/commit/0ed9a174)) feat: MapGen writing tilemaps to sibling nodes

  > Adds collisions to coldfire tiles.


### 16 Jan 2023

- ([`fce9eccf`](https://github.com/russmatney/dino/commit/fce9eccf)) feat: finish out jetpack pickup item
- ([`1184b2c8`](https://github.com/russmatney/dino/commit/1184b2c8)) feat: some jetpack camera shake, new jet echo sound
- ([`caac4b9b`](https://github.com/russmatney/dino/commit/caac4b9b)) fix: run transit to fall if falling

  > The logic was holding the run state if you hold run while falling.

- ([`815d0b56`](https://github.com/russmatney/dino/commit/815d0b56)) feat: restore jet echo, transit to fall from jetpack
- ([`9a37045c`](https://github.com/russmatney/dino/commit/9a37045c)) feat: jetpack, landing sounds, more jetpack tweaks
- ([`14859791`](https://github.com/russmatney/dino/commit/14859791)) feat: jetpack flame animatio
- ([`9f3ebc1d`](https://github.com/russmatney/dino/commit/9f3ebc1d)) feat: tweaking jetpack values

  > As impled: a strong burst and then a second to ramp up to 'full'.

- ([`1f35a0f9`](https://github.com/russmatney/dino/commit/1f35a0f9)) fix: better initial zoom, decrease bullet shake

  > bullets add tons of shake very rapidly - .1 and .2 are imperceptible,
  > but .3 x 3 bullets it way too much.

- ([`d918c698`](https://github.com/russmatney/dino/commit/d918c698)) feat: initial player jetpack

  > Now we're talking

- ([`8c6ba523`](https://github.com/russmatney/dino/commit/8c6ba523)) feat: gray sprites, color reassign shader, hat/body pickups
- ([`e9fe08e7`](https://github.com/russmatney/dino/commit/e9fe08e7)) fix: more impactful bullet shake

  > the 0.2 is imperceptible, this turns it up a notch.

- ([`62bb7ea9`](https://github.com/russmatney/dino/commit/62bb7ea9)) feat: add shake on heavy landings

  > Also refactors the gunner player state machine to transition from jump
  > to fall.

- ([`9081d4f6`](https://github.com/russmatney/dino/commit/9081d4f6)) feat: screenshake trauma and open-simplex-noise based

  > Many thanks to this excellent talk, which gets into juicing cameras in
  > detail: https://www.youtube.com/watch?v=tu-Qe66AvtY

- ([`130c104e`](https://github.com/russmatney/dino/commit/130c104e)) refactor: zoom logic dry up
- ([`fde7ca0a`](https://github.com/russmatney/dino/commit/fde7ca0a)) feat: tween camera zoom in/out
- ([`e909db15`](https://github.com/russmatney/dino/commit/e909db15)) feat: basic mouse scroll to zoom in/out

### 15 Jan 2023

- ([`2d9fe438`](https://github.com/russmatney/dino/commit/2d9fe438)) feat: working offscreen indicator

  > Had to find some voodoo to properly rescale the root viewport size with
  > against various window sizes - hopefully this function covers all
  > use-cases!

- ([`acb2681b`](https://github.com/russmatney/dino/commit/acb2681b)) wip: nearly working off-screen indicator

  > Can't quite get a proper rectangle for the current viewport/window...
  > kind killing me.

- ([`bdce2673`](https://github.com/russmatney/dino/commit/bdce2673)) chore: slightly more helpful can't-find-hud handling
- ([`321f613d`](https://github.com/russmatney/dino/commit/321f613d)) feat: coldfire palette introduced as tiles, mapGen colors

  > https://lospec.com/palette-list/coldfire-gb By Kerrie Lake

- ([`6df0ab38`](https://github.com/russmatney/dino/commit/6df0ab38)) feat: quick GuestStar - proc-gen tiles and gunner in runner

  > Pre-dash, jetpack, and better camera-work.


### 14 Jan 2023

- ([`e7032af2`](https://github.com/russmatney/dino/commit/e7032af2)) docs: notes for future me

  > Getting groups into a more dynamic (list-based) input without
  > sacrificing the drag-drop updating would be excellent. Don't need it
  > yet, so, leaving it for now, in the hopes that i learn some better way
  > to do it first.

- ([`fb9bcaba`](https://github.com/russmatney/dino/commit/fb9bcaba)) refactor: pulls some mapGen funcs into ReptileMap autoload

  > Finally working again. NOBODY TOUCH IT.

- ([`0716ad1e`](https://github.com/russmatney/dino/commit/0716ad1e)) feat: pack and save maps as resources

  > Also re-tiling the map when changing any inputs - a much better feedback
  > loop!

- ([`940a0c62`](https://github.com/russmatney/dino/commit/940a0c62)) chore: gunner export settings
- ([`e08b61f8`](https://github.com/russmatney/dino/commit/e08b61f8)) refactor: pull MapGen into reptile addon

  > Extends it to support modifiable colors and tilemaps, automatic
  > rescaling of tilemaps toward a target cell size, and general robustness.


### 13 Jan 2023

- ([`9c71e94f`](https://github.com/russmatney/dino/commit/9c71e94f)) feat: add a middle bound, gen and save a few maps
- ([`bb8a9089`](https://github.com/russmatney/dino/commit/bb8a9089)) feat: generating tilemaps to match the colorized image
- ([`a33b39f3`](https://github.com/russmatney/dino/commit/a33b39f3)) feat: colorizing noise

  > This is working pretty great!

- ([`6b489706`](https://github.com/russmatney/dino/commit/6b489706)) feat: generating images via OpenSimplexNoise

### 12 Jan 2023

- ([`aeeb049b`](https://github.com/russmatney/dino/commit/aeeb049b)) wip: shockwave shader attempt and fail
- ([`2a85fc42`](https://github.com/russmatney/dino/commit/2a85fc42)) docs: brief readme update
- ([`c7b8b2cd`](https://github.com/russmatney/dino/commit/c7b8b2cd)) fix: drop debug notif
- ([`1ab4ffb4`](https://github.com/russmatney/dino/commit/1ab4ffb4)) fix: don't overwrite Navi.add_child

  > This was a nice function, but the menu containers were then getting
  > added to the current scene as well, which means they get destroyed when
  > we navigate.

- ([`223c6da9`](https://github.com/russmatney/dino/commit/223c6da9)) feat: hud showing targets destroyed and remaining
- ([`9b55c821`](https://github.com/russmatney/dino/commit/9b55c821)) feat: move hud label and theme to hood
- ([`0f3fe4c7`](https://github.com/russmatney/dino/commit/0f3fe4c7)) feat: basic HUD with notifications, controls, health

  > Also extends the player's notif to leave the notif at the
  > notification-time position.

- ([`7927f112`](https://github.com/russmatney/dino/commit/7927f112)) refactor: pull some HUD components into 'hood' addon
- ([`b2eea998`](https://github.com/russmatney/dino/commit/b2eea998)) feat: shine on player level_up
- ([`d204c428`](https://github.com/russmatney/dino/commit/d204c428)) feat: target destroyed text effect
- ([`9750aff0`](https://github.com/russmatney/dino/commit/9750aff0)) addon: add teeb.text_effects/transitions
- ([`4c25c92d`](https://github.com/russmatney/dino/commit/4c25c92d)) feat: slowmo register, break-the-targets logic

  > slowmo when 1 target remains, freeze-frame during 'complete'!, automatic
  > respawn afterwards.

- ([`62f8d679`](https://github.com/russmatney/dino/commit/62f8d679)) feat: gunner pause with restart, respawn handling

  > `r` to respawn targets, shift-r to reload the current scene.
  > 
  > Includes:
  > 
  > - initial gunner pause menu and controls widget
  > - Util.remove_matching for removing matching array elems
  > - Cam.ensure_camera fix


### 11 Jan 2023

- ([`3d1d62d0`](https://github.com/russmatney/dino/commit/3d1d62d0)) feat: distinguish poi and pof

  > point of interest vs point of focus. pois will influence the camera
  > based on proximity and importance. (someday.)

- ([`6b918cd6`](https://github.com/russmatney/dino/commit/6b918cd6)) wip: brief rotational screenshake attempt
- ([`20a9fa28`](https://github.com/russmatney/dino/commit/20a9fa28)) feat: refactor into Camera.freezeframe func

  > Camera getting some juicing funcs! Maybe that's the direction to take
  > that whole addon.

- ([`325cdad6`](https://github.com/russmatney/dino/commit/325cdad6)) feat: more targets, remove 'idle' sound effect
- ([`aa90b093`](https://github.com/russmatney/dino/commit/aa90b093)) feat: quick slow-down effect

  > Pretty cool, and simple!

- ([`8f023fef`](https://github.com/russmatney/dino/commit/8f023fef)) feat: add target with coin sounds on kill
- ([`d2b2259a`](https://github.com/russmatney/dino/commit/d2b2259a)) feat: better screenshake params

  > loops, variance, amplitude, duration (loop duration).

- ([`53015752`](https://github.com/russmatney/dino/commit/53015752)) feat: camera screenshake func, gunner re-format
- ([`ba35e387`](https://github.com/russmatney/dino/commit/ba35e387)) feat: new addon for cameras

  > Refactors the DinoCamera into a new 'camera' addon.
  > 
  > Adds a Cam autoload with an ensure_camera(mode = null) helper, for
  > easily ensuring a camera is added in _ready() funcs.
  > 
  > Adds a LookaheadPOI to the player to push the camera ahead in the
  > player's faced direction.

- ([`4ef852d4`](https://github.com/russmatney/dino/commit/4ef852d4)) feat: jump ripple fade in/out, clamp jump speed

  > No more wall-launching yourself into oblivion.

- ([`f0a9f6fa`](https://github.com/russmatney/dino/commit/f0a9f6fa)) feat: bullet kill anim and sound
- ([`0153f9d2`](https://github.com/russmatney/dino/commit/0153f9d2)) feat: set collision layers/masks, bullet kill on collision
- ([`918b30ac`](https://github.com/russmatney/dino/commit/918b30ac)) feat: landing, restored walljump sounds

  > Plus varing pitch-scale randomly, per call.

- ([`b2ce23bb`](https://github.com/russmatney/dino/commit/b2ce23bb)) feat: gunner laser and jump sounds

  > Extends DJ with more sound setup and play helpers.
  > 
  > This sound_map feels like a good step - towards a data model to be
  > supported by a DJ dashboard.

- ([`07ad82a7`](https://github.com/russmatney/dino/commit/07ad82a7)) addon: gdfxr added

  > godot-sfxr is nice, but gdfxr supports simpler serialization and history
  > of generated sounds, which seems like it will avoid headaches.

- ([`47ed2d67`](https://github.com/russmatney/dino/commit/47ed2d67)) feat: player knockback when firing
- ([`35065674`](https://github.com/russmatney/dino/commit/35065674)) feat: hold to fire working properly

  > No more fast-tap to fire more than the fire_rate

- ([`cfc87c7a`](https://github.com/russmatney/dino/commit/cfc87c7a)) feat: unlimited wall jumps, strafing while firing

  > And smaller arrows.

- ([`37bede6d`](https://github.com/russmatney/dino/commit/37bede6d)) feat: cozy gunner basic bullets (arrows for now)
- ([`9a729c6a`](https://github.com/russmatney/dino/commit/9a729c6a)) feat: maybe this makes a difference?
- ([`f1ee92c0`](https://github.com/russmatney/dino/commit/f1ee92c0)) feat: juicier state label

  > 'following' the player around.

- ([`89359770`](https://github.com/russmatney/dino/commit/89359770)) chore: misc gdscript, beehive clean up

  > - drops extra lines
  > - prefers actor to owner in state machine states

- ([`21ee6e0b`](https://github.com/russmatney/dino/commit/21ee6e0b)) feat: cozy gunner begins, player controller

  > Got a bit hairy impling a state machine without copy-pasting.
  > 
  > Need to be more aware of the api, spent too long writing
  > _physics_process instead of physics_process.


### 10 Jan 2023

- ([`64b17dba`](https://github.com/russmatney/dino/commit/64b17dba)) feat: add godot-sfxr addon

### 9 Jan 2023

- ([`7f93b50c`](https://github.com/russmatney/dino/commit/7f93b50c)) build: remaining harvey exports
- ([`50644adf`](https://github.com/russmatney/dino/commit/50644adf)) fix: restore HUD time, misc time adjustments
- ([`93af186c`](https://github.com/russmatney/dino/commit/93af186c)) feat: basic sounds for a few state changes
- ([`5dcdbea0`](https://github.com/russmatney/dino/commit/5dcdbea0)) feat: timeup menu showing score, adds restart opt to pause

  > Score is currently gathered and passed from the HUD.

- ([`9fb0bf39`](https://github.com/russmatney/dino/commit/9fb0bf39)) feat: harvey pause menu, navi pause menu overwriting
- ([`2b7418b5`](https://github.com/russmatney/dino/commit/2b7418b5)) feat: add controls to HUD
- ([`4fac59d9`](https://github.com/russmatney/dino/commit/4fac59d9)) build: harvey main scene, create first 'map'
- ([`4bb2b87c`](https://github.com/russmatney/dino/commit/4bb2b87c)) feat: subclass the player and add bot logic

  > Harvey's farm is now producing at a significantly higher ergonomic rate,
  > thanks to the HarvBot9000.


### 8 Jan 2023

- ([`131a371d`](https://github.com/russmatney/dino/commit/131a371d)) fix: update harvey build exports
- ([`cc4f4202`](https://github.com/russmatney/dino/commit/cc4f4202)) feat: basic HUD with timer and produce scores

  > Also hides state labels behind a Harvey.debug_mode() flag.

- ([`3e2a6d66`](https://github.com/russmatney/dino/commit/3e2a6d66)) feat: update delivery, tool, plot to new action style
- ([`5f8e6c2b`](https://github.com/russmatney/dino/commit/5f8e6c2b)) feat: filtering current action on can_perform_ax
- ([`9b780bfa`](https://github.com/russmatney/dino/commit/9b780bfa)) feat: select nearest action

  > Also adds an arrow to point to the current action's source.

- ([`b28e946a`](https://github.com/russmatney/dino/commit/b28e946a)) feat: new dino camera mode for handling nearby POIs

  > The camera has a new mode that will center the camera on nearby 'poi'
  > groupped items. A bit janky, but it's a start. Mostly pulled from some
  > advent-of-godot work from last month.

- ([`30a3a9e6`](https://github.com/russmatney/dino/commit/30a3a9e6)) feat: Util.map helper

  > Not much functional in gdscript, but we can start to cover it.

- ([`ccd4d498`](https://github.com/russmatney/dino/commit/ccd4d498)) wip: player using actionDetector to discover actions
- ([`a2132b3a`](https://github.com/russmatney/dino/commit/a2132b3a)) feat: larger seed icon when carrying
- ([`d620d297`](https://github.com/russmatney/dino/commit/d620d297)) juice: squash and stretch on plot actions, produce delivery

  > Feels like this deformation code should be dried up somehow. maybe as a
  > library? It feels tied to the shader itself, but i can't see a clean way
  > to attach gdscript to shaders directly... maybe it becomes an animated
  > sprite script or class...

- ([`68993031`](https://github.com/russmatney/dino/commit/68993031)) feat: squash and stretch shader

  > From this tutorial: https://github.com/PlayWithFurcifer/SpriteDeformation
  > 
  > Adds a shader for deforming sprites, including some knockback. Adds it
  > to the seed boxes.


### 7 Jan 2023

- ([`a3a13401`](https://github.com/russmatney/dino/commit/a3a13401)) misc: harvey export fixes, drop dead control
- ([`4f8dd32c`](https://github.com/russmatney/dino/commit/4f8dd32c)) feat: delivering harvested produce via delivery box
- ([`0c8600de`](https://github.com/russmatney/dino/commit/0c8600de)) feat: plots: planting, watering, harvesting via items
- ([`233d86fb`](https://github.com/russmatney/dino/commit/233d86fb)) feat: picking up tools
- ([`208b26bd`](https://github.com/russmatney/dino/commit/208b26bd)) feat: player picking up and showing seeds of each type
- ([`5b60b504`](https://github.com/russmatney/dino/commit/5b60b504)) feat: seedbox and actions abstraction on player
- ([`b0393d93`](https://github.com/russmatney/dino/commit/b0393d93)) fix: reimport without filter for pixel assets
- ([`11dc19bb`](https://github.com/russmatney/dino/commit/11dc19bb)) feat: basic player animations and movement
- ([`51176691`](https://github.com/russmatney/dino/commit/51176691)) feat: harvey art + sounds: veggie icons, tools, etc
- ([`588469c1`](https://github.com/russmatney/dino/commit/588469c1)) feat: harvey build/export configured
- ([`190be0b3`](https://github.com/russmatney/dino/commit/190be0b3)) feat: init harvey - menu, controls, etc

### 5 Jan 2023

- ([`9b20d723`](https://github.com/russmatney/dino/commit/9b20d723)) feat: pluggs main scene override and export config
- ([`ed4c88ef`](https://github.com/russmatney/dino/commit/ed4c88ef)) feat: add pluggs to readme, dino menu
- ([`5642127f`](https://github.com/russmatney/dino/commit/5642127f)) feat: improved pluggs animations

  > smarter transitions for moving between states - running to dragging,
  > bucket to standing, moving from transition animations to idle ones.


### 3 Jan 2023

- ([`a1ae647a`](https://github.com/russmatney/dino/commit/a1ae647a)) feat: pluggs bucket, reach, drag anims
- ([`10fcbafb`](https://github.com/russmatney/dino/commit/10fcbafb)) feat: pluggs initial movement via state machine
- ([`b8db4c04`](https://github.com/russmatney/dino/commit/b8db4c04)) feat: add pluggs animated spriteframes, initial pluggs scene
- ([`2f34c430`](https://github.com/russmatney/dino/commit/2f34c430)) feat: add dino icon

### 18 Dec 2022

- ([`742cb711`](https://github.com/russmatney/dino/commit/742cb711)) feat: add mkdir -p to build-web task

  > Also updates the runner exports.

- ([`60eaa318`](https://github.com/russmatney/dino/commit/60eaa318)) feat: add pit door in library
- ([`87d59897`](https://github.com/russmatney/dino/commit/87d59897)) fix: space between ghost and house
- ([`b1f0abc4`](https://github.com/russmatney/dino/commit/b1f0abc4)) misc: ghosts title screen, add more ghost blocks, rearrange some doors

### 17 Dec 2022

- ([`2a173ff0`](https://github.com/russmatney/dino/commit/2a173ff0)) feat: add ghostblocks to the rest of the levels
- ([`3a7a2ad8`](https://github.com/russmatney/dino/commit/3a7a2ad8)) feat: add a few notifications
- ([`aa6106b9`](https://github.com/russmatney/dino/commit/aa6106b9)) feat: count and display gloomba KOs
- ([`c16cf342`](https://github.com/russmatney/dino/commit/c16cf342)) feat: ghosts hud refactor
- ([`7a9cad03`](https://github.com/russmatney/dino/commit/7a9cad03)) feat: show Death menu and support proper player data reset

  > Could have a direct restart button, but this is fine for now.

- ([`d1449e47`](https://github.com/russmatney/dino/commit/d1449e47)) feat: preserve player data across room transitions

  > Creates a GhostsRoom script that works with PlayerSpawners and the
  > Ghosts autoload to save and restore player data across room transitions.

- ([`1483ec16`](https://github.com/russmatney/dino/commit/1483ec16)) feat: rearranged pause menu
- ([`1f0325b3`](https://github.com/russmatney/dino/commit/1f0325b3)) feat: Ghosts title screen, credits clean up
- ([`9afe02aa`](https://github.com/russmatney/dino/commit/9afe02aa)) refactor: NaviMenu is now NaviButtonList

  > Refactors tests, DinoMenu into three lists. Moving this logic to a
  > VBoxContainer helps reusability and focuses the feature.

- ([`4ac6539a`](https://github.com/russmatney/dino/commit/4ac6539a)) feat: Navi simpler main_menu nav, configurable main_menu scene
- ([`2a487d31`](https://github.com/russmatney/dino/commit/2a487d31)) fix: rename MainMenu to DinoMenu

### 16 Dec 2022

- ([`9c05bef6`](https://github.com/russmatney/dino/commit/9c05bef6)) feat: more pit lights
- ([`204c571c`](https://github.com/russmatney/dino/commit/204c571c)) new rooms: office, cells, pit
- ([`897be56d`](https://github.com/russmatney/dino/commit/897be56d)) feat: ghost blocks collisions disabled at alpha threshold

  > Includes fix to InvisibleShader that was inverting alpha's meaning.

- ([`1236a195`](https://github.com/russmatney/dino/commit/1236a195)) fix: player idle state applies gravity

  > important to support falling when a block disappears to be working.

- ([`632c7544`](https://github.com/russmatney/dino/commit/632c7544)) feat: animated player burst, small player glow
- ([`c4556adf`](https://github.com/russmatney/dino/commit/c4556adf)) feat: player burst stuns gloomba, can hit while stunned

  > Includes gloomba death. :(

- ([`7181afed`](https://github.com/russmatney/dino/commit/7181afed)) feat: basic player flashlight
- ([`ecf7e752`](https://github.com/russmatney/dino/commit/ecf7e752)) feat: add font, tileset to credits
- ([`b1bee828`](https://github.com/russmatney/dino/commit/b1bee828)) fix: create_tween on the node, not the tree

  > Creating with Node.create_tween() binds the tween to the node, so it is
  > cleaned up when the node is freed.
  > 
  > Fix game-breaking freeze when moving between rooms.

- ([`89bd99f6`](https://github.com/russmatney/dino/commit/89bd99f6)) fix: enable camera on library, add one more door back to the house
- ([`40b7746b`](https://github.com/russmatney/dino/commit/40b7746b)) feat: move to referencing paths instead of packed scenes

  > This is too bad, but is necessary to avoid a circular reference.

- ([`d667760e`](https://github.com/russmatney/dino/commit/d667760e)) feat: moves to House as first scene, connects to library via door
- ([`f8628e45`](https://github.com/russmatney/dino/commit/f8628e45)) feat: player actions api, doors loading destinations

### 15 Dec 2022

- ([`a978698b`](https://github.com/russmatney/dino/commit/a978698b)) feat: extend navi.nav_to to support packedScenes
- ([`5b5b5e8b`](https://github.com/russmatney/dino/commit/5b5b5e8b)) wip: doors in the house, shader material
- ([`be30207d`](https://github.com/russmatney/dino/commit/be30207d)) feat: initial House map

  > Intended as a Hub - it'll get a door to the library next.

- ([`f780a13c`](https://github.com/russmatney/dino/commit/f780a13c)) feat: misc gloomba code

  > not yet used! need to add player attack style

- ([`0823bc29`](https://github.com/russmatney/dino/commit/0823bc29)) wip: pull pins on player death

  > I'd hoped this would look a bit better - probably we could re-enable the
  > collision layers to improve the look a bit. the rod sticks to the player
  > pretty well - i'm not sure what is keeping it there! I'd hoped the whole
  > thing would fall in a pile.

- ([`e9605e96`](https://github.com/russmatney/dino/commit/e9605e96)) feat: player knockback, dying, dead animations
- ([`23010030`](https://github.com/russmatney/dino/commit/23010030)) feat: add Dead state to player state machine

  > Also prevent further collisions after death... tho maybe we could leave
  > these if we want to be spelunky.

- ([`8c04ec50`](https://github.com/russmatney/dino/commit/8c04ec50)) feat: player knockback on gloomba collision
- ([`86e084bd`](https://github.com/russmatney/dino/commit/86e084bd)) fix: drop rest of gloomba ink stuff
- ([`5e41e758`](https://github.com/russmatney/dino/commit/5e41e758)) feat: gloomba random hopping, drop ink integration

  > Adds more gloombas to the library.

- ([`b3e5ae5c`](https://github.com/russmatney/dino/commit/b3e5ae5c)) feat: gloomba sprites, animations
- ([`c2d00e81`](https://github.com/russmatney/dino/commit/c2d00e81)) feat: add glowmba.ink as a story
- ([`d66b36f5`](https://github.com/russmatney/dino/commit/d66b36f5)) fix: autoformatting fixes

  > Starting godot from emacs apparently runs an autoformatter :shrug:

- ([`7367bb73`](https://github.com/russmatney/dino/commit/7367bb73)) feat: HUD notifications with ttl and fade tween

  > Adds a Ghosts autoload that the HUD connects to, and uses a
  > create_notification func and notification signal to write text to the
  > HUD's notification list.
  > 
  > These fade and are removed after an overwritable TTL.

- ([`4df927e8`](https://github.com/russmatney/dino/commit/4df927e8)) feat: heart-y health icons
- ([`e409117c`](https://github.com/russmatney/dino/commit/e409117c)) wip: heart health icon incoming!
- ([`7e76358c`](https://github.com/russmatney/dino/commit/7e76358c)) feat: basic ghosts HUD with pause button, player health
- ([`7a12df63`](https://github.com/russmatney/dino/commit/7a12df63)) feat: Trolley ActionsList on default PauseMenu

  > Breaks action data structure logic into Trolley autoload with filtering
  > by prefix helpers.
  > 
  > Breaks out TrolleyActionsList scene, adds it to the NaviPauseMenu.
  > 
  > Not amazing, but at least exposing controls on the pause menu now.

- ([`4fa35c51`](https://github.com/russmatney/dino/commit/4fa35c51)) feat: trolley controls comps: actionLabel and keyIcon
- ([`5bbf8155`](https://github.com/russmatney/dino/commit/5bbf8155)) feat: Trolley initial bottom panel listing controls

  > Unfortunately the bottom panel scene does most of the work for now, b/c
  > it's a better dev loop than editing code in a tool-autoload (which seems
  > to require a full project reload when updated to run in the editor).
  > Maybe this isn't a problem for working with the built-in editor - i
  > couldn't find a clear way to force the reload yet - if anyone knows of
  > one, plz lmk.


### 14 Dec 2022

- ([`5051b992`](https://github.com/russmatney/dino/commit/5051b992)) docs: nit 'vendorizing'
- ([`27b0c5d2`](https://github.com/russmatney/dino/commit/27b0c5d2)) docs: org quote block
- ([`7f53bb51`](https://github.com/russmatney/dino/commit/7f53bb51)) docs: s/`/ for correct org :pre blocks
- ([`8d277275`](https://github.com/russmatney/dino/commit/8d277275)) wip: attempt to simplify rod + light horizontal flip

  > This groups the angler light lamp and chain, in the hope that the flip
  > could done to the parent, or a group of children. It seems to upset some
  > of the pins....

- ([`80292d62`](https://github.com/russmatney/dino/commit/80292d62)) fix: remove parallel() from shader tweens - restore expected color change
- ([`80d1dabc`](https://github.com/russmatney/dino/commit/80d1dabc)) fix: update anglerLightRod position based on player.facing_direction

  > Now sticking to the 'facing' side.

- ([`d69b3050`](https://github.com/russmatney/dino/commit/d69b3050)) feat: set animation for idle, run, air animations
- ([`eb0becea`](https://github.com/russmatney/dino/commit/eb0becea)) feat: add air animation, enable 'playing'
- ([`786df68b`](https://github.com/russmatney/dino/commit/786df68b)) feat: set facing_direction on player
- ([`06f0369b`](https://github.com/russmatney/dino/commit/06f0369b)) feat: extend fishing concept with jank

  > I don't know what I'm doing... lol
  > 
  > I made the 'rod' show up and then I tried using a dampingspringjoint to have it
  > track the mouse, but that was too weird so I made it very subtle.
  > 
  > I also reworked the chain to make it more like a fishing line w/ a bobber.
  > 
  > I tried to make the pole stay in 'front' of the player's movement, but it
  > doesn't move the other bits with it and it doesn't stay as I'd expect it to :/
  > 
  > Overall, fun to mess with still :)


### 13 Dec 2022

- ([`84df5d4a`](https://github.com/russmatney/dino/commit/84df5d4a)) wip: kink register, current_message

  > The funcs, signals, connects, etc in Glowmba.gd should be moved into a
  > nicer api in Kink - probably assertions and connects in Kink.register()

- ([`01927010`](https://github.com/russmatney/dino/commit/01927010)) wip: kink addon for inkgd integration

  > plus initial node consumer, Glowmba

- ([`2fa8520a`](https://github.com/russmatney/dino/commit/2fa8520a)) feat: add light2d to glowmba
- ([`9c61ba55`](https://github.com/russmatney/dino/commit/9c61ba55)) feat: basic glowmba, some rearranging
- ([`827aab80`](https://github.com/russmatney/dino/commit/827aab80)) feat: Make the git status output for addons better

  > Rather than the full message for the git status output, which gets a bit lost
  > when being emitted for each addon repo, use git status -sb to show the short
  > format with the branch and tracking information.
  > 
  > Additionally, it seems prudent to fetch from the remote prior to checking the
  > status, to see how much divergence has taken place.

- ([`cc428a8c`](https://github.com/russmatney/dino/commit/cc428a8c)) feat: Add custom dir-prefix to install system

  > The Addons system may be in the process of being removed but as long as the
  > commands exist here, other users may want the repos cloned in a different
  > location than directly under their home directory. This change makes the
  > addons-* and install-script-templates commands take variadic additional args
  > from the command line, each word of which will be interpreted as a part of the
  > path under the user's $HOME directory in which they want the repos to be cloned,
  > or in the case of the script_templates, where the respective repo can be found
  > on the local machine.

- ([`42b22cae`](https://github.com/russmatney/dino/commit/42b22cae)) feat: Use new babashka.fs/home

  > For better portability and longevity, remove bb-godot.tasks/home-dir in favor of
  > the new babashka.fs/home.


### 12 Dec 2022

- ([`6699adc9`](https://github.com/russmatney/dino/commit/6699adc9)) feat: downward light texture and node

  > Plus more player light tweaking

- ([`cd720f04`](https://github.com/russmatney/dino/commit/cd720f04)) feat(ghosts): remove one player headlight pin, reverse light gravity

  > Now the player light floats above. Still a bit choppy, but this could
  > easily be a light item/variant.

- ([`707d9fe8`](https://github.com/russmatney/dino/commit/707d9fe8)) feat: tweaking hangingLight pinjoints

  > Boost gravity on the lamp (50x), set softness on the first/last pin joint.
  > 
  > I experimented with bias as well, but it makes things much springier.

- ([`babe9c72`](https://github.com/russmatney/dino/commit/babe9c72)) fix: angler-fish style player light tweaks

  > Disables collision on the invisible rigid body holding the light up,
  > reduces it's size, and removes a few links in the chain.

- ([`512dc317`](https://github.com/russmatney/dino/commit/512dc317)) fix: more reasonable light texture

  > The light texture in use had a square background, rather than
  > transparent, which looked odd - this moves to a dithered yellow
  > semi-transparent light texture, which looks much nicer.

- ([`cf81a07b`](https://github.com/russmatney/dino/commit/cf81a07b)) docs: ghosts readme note
- ([`cb25d989`](https://github.com/russmatney/dino/commit/cb25d989)) docs: brief note re: install-addons
- ([`1b00419c`](https://github.com/russmatney/dino/commit/1b00419c)) feat: wippy anglerfish style light, larger library to explore
- ([`4f78dfc8`](https://github.com/russmatney/dino/commit/4f78dfc8)) fix: ghosts export actually working

### 11 Dec 2022

- ([`f31e01b8`](https://github.com/russmatney/dino/commit/f31e01b8)) feat: invisible sprite shader
- ([`927eb68c`](https://github.com/russmatney/dino/commit/927eb68c)) feat: add cartridge tile glitch shader and tween it
- ([`e5ecaa25`](https://github.com/russmatney/dino/commit/e5ecaa25)) feat: lights on chains, background tile layer
- ([`118d5b48`](https://github.com/russmatney/dino/commit/118d5b48)) feat: darkness via canvas modulate, some lights

  > Also prevent music toggles in the editor.

- ([`ca466888`](https://github.com/russmatney/dino/commit/ca466888)) feat: basic tiles and initial level
- ([`7574369b`](https://github.com/russmatney/dino/commit/7574369b)) chore: drop dead lospec plugin, update addon logs
- ([`86074873`](https://github.com/russmatney/dino/commit/86074873)) feat: initial ghosts game - player controller and camera

### 16 Nov 2022

- ([`f3c8d2af`](https://github.com/russmatney/dino/commit/f3c8d2af)) feat: activate blocks room, gym

  > Blocks change color when player collides with them.
  > 
  > Blocks can still get flung off into space, so that has to be dealt with a bit.

- ([`3cacc128`](https://github.com/russmatney/dino/commit/3cacc128)) feat: player restarting after collision with rib

  > Not the right feel yet, but at least the collision detection is
  > happening.


### 15 Nov 2022

- ([`78c6ae22`](https://github.com/russmatney/dino/commit/78c6ae22)) wip: basic dodge room with goomba

  > Collision detection woes

- ([`aed8a5ff`](https://github.com/russmatney/dino/commit/aed8a5ff)) feat: create prime rooms: Gap, Win, Climb, Fall
- ([`5d0767b2`](https://github.com/russmatney/dino/commit/5d0767b2)) fix: handle missing data cases in Runner.gd
- ([`95be46a5`](https://github.com/russmatney/dino/commit/95be46a5)) wip: initialize new runner track, 'Prime'
- ([`62fdf178`](https://github.com/russmatney/dino/commit/62fdf178)) fix: vendorize addons

  > Until now, third party dependencies have been symlinks. Ideally these
  > would get some kind of version and version-locking, but vendorizing
  > them (copying them into the repo) is also a fine practice - this allows
  > dino to own those projects a bit more, tho it complicates the upgrade
  > and giving-back process somewhat. More helpers to improve this can be
  > added going forward, but this should at least allow for onboarding
  > without requiring cli skills.


### 13 Nov 2022

- ([`076f6bb2`](https://github.com/russmatney/dino/commit/076f6bb2)) wip: knockEm room block collisions
- ([`ec813b4b`](https://github.com/russmatney/dino/commit/ec813b4b)) fix: Gravity running again

  > Toying with some knockback is_finished logic here.

- ([`53f005ad`](https://github.com/russmatney/dino/commit/53f005ad)) feat: Blocks autoload, pull out reusable room components

  > wip: KnockEm room

- ([`ad41aafe`](https://github.com/russmatney/dino/commit/ad41aafe)) feat: call setup() in prep_room

  > Also calls cleanup() when the player exits - but i feel like it
  > shouldn't be so immediate - there could be another room hook before it
  > gets requeued.

- ([`00b280e7`](https://github.com/russmatney/dino/commit/00b280e7)) fix: update Util function name

  > Completely missed this in the last few commits. Need to clean up my
  > local diff!

- ([`c01bc096`](https://github.com/russmatney/dino/commit/c01bc096)) feat: enter/exit box working! huzzah!

  > Subtracts rather than adds the x_offset to the accumulated width.
  > 
  > Glad this is working! Simplifies a major pain point for working with
  > rooms.

- ([`ba30b097`](https://github.com/russmatney/dino/commit/ba30b097)) feat: room.x_offset for enterBox working

  > A bit more fool-proof - calcs the expected room x-offset regardless of
  > the area2d and collision2d positions.

- ([`f7d42fbb`](https://github.com/russmatney/dino/commit/f7d42fbb)) feat: anomaly adding/cleaning up gravity blocks

  > The Anomaly room now adds blocks upon entering, and clears them upon
  > exiting. Kind of interesting?


### 12 Nov 2022

- ([`01e0ba24`](https://github.com/russmatney/dino/commit/01e0ba24)) feat: some rigid blocks for the anomaly

  > Unfortunately area2d physics overrides don't work on kinematic bodies :/
  > 
  > Here's some blocks that get pushed around instead.

- ([`188efaa5`](https://github.com/russmatney/dino/commit/188efaa5)) feat: nil-pun get_node, fix anomaly run counting logic

  > Turns out is_finished() can't have side-effects.

- ([`81228dec`](https://github.com/russmatney/dino/commit/81228dec)) wip: runner 'Gravity' track

  > Adding some new levels to work with in Runner.


### 11 Nov 2022

- ([`40afff70`](https://github.com/russmatney/dino/commit/40afff70)) wip: runner room api refactor

  > Towards enter/exitbox support. Offset not quite right yet.

- ([`1c9da003`](https://github.com/russmatney/dino/commit/1c9da003)) wip: player HUD

### 9 Nov 2022

- ([`2d7be992`](https://github.com/russmatney/dino/commit/2d7be992)) feat: add 2 layer parallax background to runner

  > An initial parallax bg for running through the forest. Scrappy for now,
  > but better than the yellow.
  > 
  > Also scales up the player sprite a bit.


### 6 Nov 2022

- ([`684179fa`](https://github.com/russmatney/dino/commit/684179fa)) fix: restore 'win' in runner

  > The parkLeaf and parkWin rooms were failing to load b/c their scripts
  > had somehow become orphaned? feels like a bug, i didn't do anything
  > except detach and reattach the scripts... not sure where that state is
  > stored, but the .tscns are the same :/

- ([`807d50f4`](https://github.com/russmatney/dino/commit/807d50f4)) fix: adjust dungeon crawler export

  > Fires the arrow ok now.

- ([`b4d1622e`](https://github.com/russmatney/dino/commit/b4d1622e)) fix: pixel snapping, misc anchors
- ([`f7d23183`](https://github.com/russmatney/dino/commit/f7d23183)) chore: build-web supporting passed argument

  > Can now export dino, runner, or dungeon-crawler from the command line
  > via `bb build-web runner`, etc.

- ([`304828cb`](https://github.com/russmatney/dino/commit/304828cb)) feat: restore credits (new resolution), add patrons

  > Many thanks to my new patrons!


### 3 Nov 2022

- ([`4b9834ff`](https://github.com/russmatney/dino/commit/4b9834ff)) docs: add games to readme

### 2 Nov 2022

- ([`d12c342c`](https://github.com/russmatney/dino/commit/d12c342c)) feat: export and push to itch for dino, runner, dungeon-crawler

  > Adds support for exporting multiple web builds, for runner,
  > dungeon-crawler, and dino's main menu itself.
  > 
  > Adds bb commands that use butler to publish directly to itch.io.
  > 
  > Pretty happy this was possible/simple in godot! Tho it should be noted,
  > the dungeon-crawler's build crashes when arrows are fired... for
  > whatever reason. possibly the navi autoload isn't included?


### 25 Oct 2022

- ([`2ec9beda`](https://github.com/russmatney/dino/commit/2ec9beda)) chore: add funding.yml

### 21 Oct 2022

- ([`66c1390b`](https://github.com/russmatney/dino/commit/66c1390b)) docs: quick readme runner game note

### 20 Oct 2022

- ([`81c5c12b`](https://github.com/russmatney/dino/commit/81c5c12b)) refactor: tweaked player movement
- ([`065f7ec0`](https://github.com/russmatney/dino/commit/065f7ec0)) feat: LeafDrops room, improved room offset gluing

  > The Area2d must still be at the room origin, but the collisionShape's
  > offset is now taken into account.
  > 
  > Nice to remove this bit of logic from the runner, but it feels like we
  > might prefer an entrance-position/exit-position api instead - then some
  > logic for getting those to align. That'd be a nice way to break us away
  > from the origin a bit.

- ([`b633fdb1`](https://github.com/russmatney/dino/commit/b633fdb1)) feat: LeafSteps room, with gym/demo

  > a more interesting room.

- ([`2fb6e36e`](https://github.com/russmatney/dino/commit/2fb6e36e)) feat: add leaf ground, sprites, ParkLeaf room, Leaf pickup
- ([`64d26dc1`](https://github.com/russmatney/dino/commit/64d26dc1)) feat: add leaf concept to ParkWin

### 19 Oct 2022

- ([`db339be3`](https://github.com/russmatney/dino/commit/db339be3)) feat: ParkCoinGuard - an example room depending on player stats

  > This room can only be finished by the player passing through with 4
  > coins - otherwise it gets requeued.

- ([`83cd6492`](https://github.com/russmatney/dino/commit/83cd6492)) feat: player stat log
- ([`87610835`](https://github.com/russmatney/dino/commit/87610835)) refactor: cleans up some logic and adds comments

  > At a reasonable version of this runner room management concept.
  > 
  > Now for some real rooms!

- ([`0cd62660`](https://github.com/russmatney/dino/commit/0cd62660)) refactor: now, showing each room_option once

  > Rather than randomly pull from room options, we now show each option
  > once, then pull gaps/unfinisheds until all are complete.

- ([`6bfeb3a4`](https://github.com/russmatney/dino/commit/6bfeb3a4)) feat: support setting number of finishable rooms

  > We now decrement rooms-to-add only when an unfinished room is added.

- ([`39198d60`](https://github.com/russmatney/dino/commit/39198d60)) feat: room 'finishing' basically working

  > Rooms can now implement an `is_finished()` api, and unfinished rooms
  > will be requeued until completed.
  > 
  > Introduces a 'Gap' room to support running until it makes sense to pop
  > the old room in front of the player again.
  > 
  > Still remaining is correcting the initial room choices, which could
  > disproportionately select any room in particular.


### 18 Oct 2022

- ([`68073de7`](https://github.com/russmatney/dino/commit/68073de7)) feat: show final room once create_rooms hits limit
- ([`28972a84`](https://github.com/russmatney/dino/commit/28972a84)) feat: Util.ensure_connection, better Runner room cleanup
- ([`7670bede`](https://github.com/russmatney/dino/commit/7670bede)) feat: basic coin pickup
- ([`b1968d28`](https://github.com/russmatney/dino/commit/b1968d28)) feat: adding and removing rooms on the fly
- ([`4363e2b2`](https://github.com/russmatney/dino/commit/4363e2b2)) feat: rooms detecting player via signals
- ([`c15ca4f4`](https://github.com/russmatney/dino/commit/c15ca4f4)) wip: RunnerRoom, RoomBox, Player DetectBox

  > Setting up detection of which room the player is in.

- ([`f314dedc`](https://github.com/russmatney/dino/commit/f314dedc)) feat: creating runner rooms in Runner.ready()

### 17 Oct 2022

- ([`82d5e3bb`](https://github.com/russmatney/dino/commit/82d5e3bb)) refactor: basic park 'rooms' as separate scenes
- ([`abc272e0`](https://github.com/russmatney/dino/commit/abc272e0)) feat: player falling, running and jumping
- ([`577b0245`](https://github.com/russmatney/dino/commit/577b0245)) init: runner, with player scene and initial script

### 18 Sep 2022

- ([`38772e8d`](https://github.com/russmatney/dino/commit/38772e8d)) feat: export presets for web
- ([`5f1364b3`](https://github.com/russmatney/dino/commit/5f1364b3)) feat: quick navi win menu

  > Something to show after a victory.

- ([`4cb23344`](https://github.com/russmatney/dino/commit/4cb23344)) feat: boss dead state, dungeon win-state

  > Now detecting when all bosses are dead in a dungeon.

- ([`41a1a7fd`](https://github.com/russmatney/dino/commit/41a1a7fd)) feat: display player health, coins, and keys

  > crappy little output spot right now. Could maybe create a console or
  > some other notification overlay.

- ([`bfa7e9a6`](https://github.com/russmatney/dino/commit/bfa7e9a6)) feat: core font resource
- ([`3d67056f`](https://github.com/russmatney/dino/commit/3d67056f)) fix: add enemy_projectile group to bowling ball
- ([`83ca62cc`](https://github.com/russmatney/dino/commit/83ca62cc)) fix: camera prevent crash when player is removed
- ([`e0c575b3`](https://github.com/russmatney/dino/commit/e0c575b3)) feat: player health/death and debug messages
- ([`33943477`](https://github.com/russmatney/dino/commit/33943477)) feat: basic Navi death menu

  > Could one day set up a restart-replay-whatever other option.
  > 
  > Also resizes the Navi Pause menu to the smaller resolution.

- ([`a5c107b0`](https://github.com/russmatney/dino/commit/a5c107b0)) feat: colorRect backgrounds in each room
- ([`0b0046c7`](https://github.com/russmatney/dino/commit/0b0046c7)) fix: much larger detect boxes for bowlingbosses
- ([`adbe9173`](https://github.com/russmatney/dino/commit/adbe9173)) feat: action button uses weapon if no other actions
- ([`81b82760`](https://github.com/russmatney/dino/commit/81b82760)) chore: clean up Goomba.gd
- ([`9f7566b3`](https://github.com/russmatney/dino/commit/9f7566b3)) feat: doors add message if locked

  > Nice to solve this completely in the Door.gd - actions passing in
  > messages was great!

- ([`0df09aa2`](https://github.com/russmatney/dino/commit/0df09aa2)) feat: better goomba death, player idle/run animations
- ([`863be44c`](https://github.com/russmatney/dino/commit/863be44c)) fix: quicker bow re-focusing

  > 'dead' goombas were holding the bow's focus while their death animation
  > played out - this helps release it sooner by flagging 'dead', and the
  > current_target fn now filters out dead bodies.

- ([`e886e451`](https://github.com/russmatney/dino/commit/e886e451)) feat: player LOS check when selecting target
- ([`d9d82a7f`](https://github.com/russmatney/dino/commit/d9d82a7f)) feat: more interesting rooms
- ([`44d57772`](https://github.com/russmatney/dino/commit/44d57772)) feat: OneGeon completely playable

  > Flow complete!
  > 
  > Tho, lacking some features, like player health, HUD, so much juice.

- ([`c16860c4`](https://github.com/russmatney/dino/commit/c16860c4)) feat: moving goombas

  > Walk and bounce, that's it.

- ([`493ebc3a`](https://github.com/russmatney/dino/commit/493ebc3a)) fix: body, or the body's owner?

  > Hitting on some objs vs duck typing annoyance.

- ([`004ff1fd`](https://github.com/russmatney/dino/commit/004ff1fd)) feat: magnetic bow, key
- ([`19584e7c`](https://github.com/russmatney/dino/commit/19584e7c)) feat: killable bosses - health on BowlingBoss

  > Also a tweak to the arrowProjectile pattern.
  > 
  > Seem to be arriving at an area2D pattern - detect all bodies/areas,
  > filter owners by group and impled method. Probably worth unit testing
  > and capturing/simplifying. Might come with some
  > visualization/relationship/debugging helpers?

- ([`52be481d`](https://github.com/russmatney/dino/commit/52be481d)) fix: set default goomba anim, quicker death anim.
- ([`aee01dc6`](https://github.com/russmatney/dino/commit/aee01dc6)) feat: bowling boss fire+move state machine cycle

### 17 Sep 2022

- ([`3bd54e96`](https://github.com/russmatney/dino/commit/3bd54e96)) feat: magnetic coins!

  > A fun one, and not too complicated.

- ([`e9bccb5f`](https://github.com/russmatney/dino/commit/e9bccb5f)) feat: auto-aim for the dungeon crawler player bow

### 16 Sep 2022

- ([`1a1980b1`](https://github.com/russmatney/dino/commit/1a1980b1)) refactor: bowling func on actor, not state

  > Plus BowlingBossTest scene for quicker testing.

- ([`406df20b`](https://github.com/russmatney/dino/commit/406df20b)) fix: reparent in a deferred, in case the nodes isn't ready
- ([`e4262840`](https://github.com/russmatney/dino/commit/e4262840)) feat: create named collision layers

  > the bowling bosses were deflecting the balls upon firing - separating
  > out some collision layers is one way to handle this, and avoids some
  > annoying 'smart' disabling of collision boxes. Probably easier to toggle
  > a collision layer anyway, so we might as well use them.

- ([`9f91afdf`](https://github.com/russmatney/dino/commit/9f91afdf)) wip: firing basic bowling ball in attack state
- ([`4564e6ab`](https://github.com/russmatney/dino/commit/4564e6ab)) wip: basic state change on player detection
- ([`23270e99`](https://github.com/russmatney/dino/commit/23270e99)) wip: initial bowling boss state machines
- ([`54f16f45`](https://github.com/russmatney/dino/commit/54f16f45)) feat: support 'actor' as machine.owner in state fns
- ([`d49bc01f`](https://github.com/russmatney/dino/commit/d49bc01f)) dungeon: wip - initial fred + barney bowling boss
- ([`85302139`](https://github.com/russmatney/dino/commit/85302139)) misc: menu and resolution adjustments
- ([`a3e9b9e5`](https://github.com/russmatney/dino/commit/a3e9b9e5)) fix: remove type annotation causing circular dep

  > Perhaps a sign that these shouldn't reference each other?


### 11 Sep 2022

- ([`4fe244f1`](https://github.com/russmatney/dino/commit/4fe244f1)) feat: lock the doors!
- ([`649cd673`](https://github.com/russmatney/dino/commit/649cd673)) feat: basic goomba coin/key drops
- ([`bc743a32`](https://github.com/russmatney/dino/commit/bc743a32)) feat: collecting coins
- ([`9b89487f`](https://github.com/russmatney/dino/commit/9b89487f)) feat: goomba death frame
- ([`6f6267fc`](https://github.com/russmatney/dino/commit/6f6267fc)) feat: smaller display, new default env color
- ([`01605824`](https://github.com/russmatney/dino/commit/01605824)) feat: player can unlock doors
- ([`6601b959`](https://github.com/russmatney/dino/commit/6601b959)) feat: door updating actions on state change
- ([`000a0975`](https://github.com/russmatney/dino/commit/000a0975)) feat: door lock/unlock actions, DoorTest scene

  > Every scene could use a <scene>Test, couldn't it?
  > 
  > Dino needs a better godot default_env.


### 10 Sep 2022

- ([`d4be358b`](https://github.com/russmatney/dino/commit/d4be358b)) feat: refactor arrow collision to area2d

  > not sure why the rigidBody body_entered never fires here... seems odd,
  > but maybe that's not the intended usage. We continue using the rigid
  > body, but disable the collision layers - it's really just for the
  > apply_impulse so we don't have to move the arrow ourselves. A new area2d
  > added to the arrow is used to detect a collision, apply 'hit' to any
  > bodies that support it, and kill the arrow.

- ([`77cd70c2`](https://github.com/russmatney/dino/commit/77cd70c2)) feat: quick goomba
- ([`0194bac1`](https://github.com/russmatney/dino/commit/0194bac1)) feat: firing arrow in 4 directions
- ([`4eea83b0`](https://github.com/russmatney/dino/commit/4eea83b0)) feat: working bow, key pickup, bow attachment
- ([`a3a59bb5`](https://github.com/russmatney/dino/commit/a3a59bb5)) feat: pull in art from protomoon and other free assets

### 9 Sep 2022

- ([`68a14eed`](https://github.com/russmatney/dino/commit/68a14eed)) feat: Player opening doors in the dungeon crawler

  > Truly a remarkable achievement.

- ([`7abb8b95`](https://github.com/russmatney/dino/commit/7abb8b95)) wip: player has_method 'add_action' not working?

  > Nearly able to open doors, but adding the action isn't working -
  > has_method seems to not know about the methods i've added to the player script

- ([`971823ae`](https://github.com/russmatney/dino/commit/971823ae)) feat: door asset, scene, and script

  > A basic door, not quite openable.

- ([`ccd25813`](https://github.com/russmatney/dino/commit/ccd25813)) feat: basic first dungeon crawler map

  > 5 rooms and an amplifier?

- ([`8a082900`](https://github.com/russmatney/dino/commit/8a082900)) feat: camera 'anchor' mode

  > A basic camera anchor mode - moves to the closest anchor to the
  > 'follow_group' (i.e. the player).


### 8 Sep 2022

- ([`caa5743d`](https://github.com/russmatney/dino/commit/caa5743d)) feat: texture bg - some color in the mix!
- ([`14d3fd6e`](https://github.com/russmatney/dino/commit/14d3fd6e)) feat: add autoloads to core, dj, navi, trolley
- ([`1977a257`](https://github.com/russmatney/dino/commit/1977a257)) feat: pull in 'lights' from dice-nine, attach to bowling ball
- ([`9cc6c33b`](https://github.com/russmatney/dino/commit/9cc6c33b)) feat: dungeon wall tiles, and reptile/maze clean up

  > renames maze -> dungeon crawler.
  > pulls some reptile assets into templates dir


### 7 Sep 2022

- ([`4af31c2c`](https://github.com/russmatney/dino/commit/4af31c2c)) reptile: aseprite 16/32/64 tilemap template files
- ([`386fe644`](https://github.com/russmatney/dino/commit/386fe644)) feat: drop pirate tiles into existing maze

  > Kind of a hack, as it re-uses the 3x3TileMap scene, swapping out the
  > tileset and overwriting the cell size and scale.
  > 
  > Not sure if there's some other preferred path - i suppose a 64x64 res
  > tilemap scene would be simpler to swap underlying tilesets with.

- ([`72f68852`](https://github.com/russmatney/dino/commit/72f68852)) feat: pull ship tiles from pirates into reptile

### 2 Sep 2022

- ([`c50ebe5d`](https://github.com/russmatney/dino/commit/c50ebe5d)) misc: gut font tweak, machine type hint
- ([`0928fe4b`](https://github.com/russmatney/dino/commit/0928fe4b)) feat: working and configured basic ink story
- ([`5139766e`](https://github.com/russmatney/dino/commit/5139766e)) feat: install inkgd addon

  > Includes a few templates.

- ([`b67c714f`](https://github.com/russmatney/dino/commit/b67c714f)) feat: import autumn glow palette

### 31 Aug 2022

- ([`ff901cc3`](https://github.com/russmatney/dino/commit/ff901cc3)) feat: barney sprites and maze usage

### 29 Aug 2022

- ([`607a8f9b`](https://github.com/russmatney/dino/commit/607a8f9b)) feat: bowling balls as kinematic bouncy balls
- ([`ce9a4103`](https://github.com/russmatney/dino/commit/ce9a4103)) docs: note current dependency trouble
- ([`8857408e`](https://github.com/russmatney/dino/commit/8857408e)) refactor: rearrange into a 'maze' folder

  > Rather than trying to break everything out from the beginning, we create
  > a 'maze' folder. This unblocks some of the design problems when more
  > than one scheme/style (top down vs platformer) could be applied - now
  > the things in the 'maze' dir can work together without trying to share
  > code too directly.

- ([`ce5fae9c`](https://github.com/russmatney/dino/commit/ce5fae9c)) feat: create 'core' addon with fonts and util

  > Been looking for a reason to move this Util into an addon, and I'm not
  > making a 'fonts' addon - 'core' will now bring in fonts and other useful
  > core assets, plus utils and other things not warranting a full addon.

- ([`2ab2d852`](https://github.com/russmatney/dino/commit/2ab2d852)) feat: thanks plugin providing re-usable Credits scene/script
- ([`9a032ad4`](https://github.com/russmatney/dino/commit/9a032ad4)) chore: move clawe autoload to autoloads dir
- ([`99582ffe`](https://github.com/russmatney/dino/commit/99582ffe)) feat: DJ autoload playing music in Navi menus

### 28 Aug 2022

- ([`861c4a0f`](https://github.com/russmatney/dino/commit/861c4a0f)) wip: clawe dashboard begun (no content)
- ([`954d52a5`](https://github.com/russmatney/dino/commit/954d52a5)) chore: clone-addons task
- ([`2de8caf0`](https://github.com/russmatney/dino/commit/2de8caf0)) feat: bowling ball item in maze
- ([`b78088b5`](https://github.com/russmatney/dino/commit/b78088b5)) feat: fred 32, 64 pixel sprites
- ([`89db6b73`](https://github.com/russmatney/dino/commit/89db6b73)) feat: camera reparents itself to the found node

  > May need to deal with 'owner' in this reparent helper, but we will wait
  > and see for now.

- ([`e14f4cce`](https://github.com/russmatney/dino/commit/e14f4cce)) fix: shrink player collision shape

  > Easier to squeeze between those tight places

- ([`b7057654`](https://github.com/russmatney/dino/commit/b7057654)) chore: `old` to `_old` for sorting in filesystem view
- ([`b503fd94`](https://github.com/russmatney/dino/commit/b503fd94)) reptile: basic 2x2 and 3x3 autotile asset, tileset, tilemap

  > Reptile now provides a starter tilemap asset, which can be used to
  > quickly doodle a tilemap with auto-tiling. For more serious usage, the
  > tileset resources can be 'made-unique' in godot, and the source png can
  > be updated via 'edit-dependencies' (once you've created a new image to
  > point to). Note that editing deps on a resource typically requires a
  > reload-current-project.


### 27 Aug 2022

- ([`b6af2e93`](https://github.com/russmatney/dino/commit/b6af2e93)) demo: basic maze with tile, spawn point, top-down-player, camera
- ([`27107f2c`](https://github.com/russmatney/dino/commit/27107f2c)) feat: add 2x2 and 3x3 autotiles
- ([`9e1eeb22`](https://github.com/russmatney/dino/commit/9e1eeb22)) feat: TileSetTools script, rename tyle -> reptile

### 25 Jul 2022

- ([`35325b6a`](https://github.com/russmatney/dino/commit/35325b6a)) beehive: state template, machine logging

### 23 Jul 2022

- ([`04193886`](https://github.com/russmatney/dino/commit/04193886)) feat: impl clone addon

  > Now cloning from github!

- ([`2f176734`](https://github.com/russmatney/dino/commit/2f176734)) navi: move PauseMenu dependent ui elems into navi

  > The Navi autoload requires a working Pause Menu Scene, which needs it's
  > dependencies to be present - this moves them so they are included in the
  > addons/navi dir.

- ([`f731532b`](https://github.com/russmatney/dino/commit/f731532b)) beehive: state providing direct `transit` call

  > Also emitting transitioned with the initial state, and including the
  > owner in the transit logs.


### 22 Jul 2022

- ([`62b92cc4`](https://github.com/russmatney/dino/commit/62b92cc4)) docs: todo update and brainstorm
- ([`896b9948`](https://github.com/russmatney/dino/commit/896b9948)) feat: working navi pause menu

  > Uses a popup panel and ensured by Navi on autoload. Working great from
  > dino's main menu.
  > 
  > Testing and what goes where is a wip. Definitely want to write a few
  > tests for this, as it was kind of a pain.
  > 
  > The Navi node creates a canvasLayer node to attach the in-lined
  > PausePopup, so that it takes over the screen/camera properly (otherwise
  > it was landing at (0, 0)).
  > 
  > The thinking is that we want to support several versions of this being
  > consumed:
  > - the game jam case where we just don't do anything and the pause menu
  > is consumed
  > - the mid-range game that can re-use the scene type OR the script to get
  > a decently branded pause-panel with minimal effort
  > - the end-game that can get away with using Navi yet impling it's own
  > pause menu
  > 
  > Perhaps we should write tests for each? But then again, creating our own
  > test scene and testing that might provide coverage for all three.

- ([`c40e9dae`](https://github.com/russmatney/dino/commit/c40e9dae)) feat: Navi pause, resume via Trolley.is_pause(event)

  > The Navi autoload now supports calling pause, when an unhandled input
  > event passes the Trolly is_pause predicate.
  > 
  > The autoload ensures it is in the PROCESS pause_mode, so that it can
  > unpause the event.
  > 
  > the pause_menu is optional, but is coming in the next commit.

- ([`fd37996b`](https://github.com/russmatney/dino/commit/fd37996b)) dino: basic mainMenu in place using NaviMenu
- ([`1c05713f`](https://github.com/russmatney/dino/commit/1c05713f)) navi: NaviMenu deduping, setting disabled

  > With unit tests!

- ([`d456386c`](https://github.com/russmatney/dino/commit/d456386c)) fix: more formatting
- ([`7992d45d`](https://github.com/russmatney/dino/commit/7992d45d)) feat: Navi, NaviMenu supporting 'nav_to' menu item key

  > Includes a working MainMenu.gd as an example

- ([`b47955f5`](https://github.com/russmatney/dino/commit/b47955f5)) format: a bunch of files?

  > Not sure when this will stabilize, but we've got to learn somehow.

- ([`72cbb32a`](https://github.com/russmatney/dino/commit/72cbb32a)) addon: MattUV/MaxSizeContainer
- ([`38488032`](https://github.com/russmatney/dino/commit/38488032)) feat: add lospec palette list

  > Helper for grabbing palettes

- ([`54198b5a`](https://github.com/russmatney/dino/commit/54198b5a)) feat: bb-godot 'addons' command does a git-status on addons

  > A quick way to check the local git status of addons.

- ([`2c91dc77`](https://github.com/russmatney/dino/commit/2c91dc77)) feat: add lospec-palette-list addon
- ([`57671ba1`](https://github.com/russmatney/dino/commit/57671ba1)) feat: display state above players head

  > Includes a few little machine fixes.
  > 
  > Starting to see how this would be unit testable.
  > Feels specific to _this_ state machine, but that's the process
  > to provide tools for anyway.

- ([`825ed8b1`](https://github.com/russmatney/dino/commit/825ed8b1)) feat: basic platformer state machine

  > And a few scenes using it. What should the tests for this look like?

- ([`d0a7d025`](https://github.com/russmatney/dino/commit/d0a7d025)) feat: impl basic state machine for player

  > Idle, Run, and Air. Input mappings not yet handled.


### 21 Jul 2022

- ([`dadc9fad`](https://github.com/russmatney/dino/commit/dadc9fad)) fix: ignore this per-machine editor config
- ([`2b730cd3`](https://github.com/russmatney/dino/commit/2b730cd3)) test: setting up state machine test

  > Player node, animated sprite, collision shape. Classic.

- ([`e22726cf`](https://github.com/russmatney/dino/commit/e22726cf)) feat: basic state machine impl from gdquest
- ([`c8baaa01`](https://github.com/russmatney/dino/commit/c8baaa01)) fix: get this tree outta here

  > Make like a leave?

- ([`15c6b773`](https://github.com/russmatney/dino/commit/15c6b773)) docs: some todo brainstorming
- ([`a624540c`](https://github.com/russmatney/dino/commit/a624540c)) fix: remove test orphans
- ([`f2fe7328`](https://github.com/russmatney/dino/commit/f2fe7328)) feat: initial util autoload

  > This may end up as in a catch-all 'extras' addon.

- ([`b1009112`](https://github.com/russmatney/dino/commit/b1009112)) feat: unit tests for NaviMenu.add_menu_item

  > Not too bad!

- ([`49ac1a2d`](https://github.com/russmatney/dino/commit/49ac1a2d)) refactor: clean up the src dir
- ([`c8681948`](https://github.com/russmatney/dino/commit/c8681948)) wip: toying with OS and a gd shell_script
- ([`03758740`](https://github.com/russmatney/dino/commit/03758740)) refactor: format the reset of the current files
- ([`28ef0d15`](https://github.com/russmatney/dino/commit/28ef0d15)) feat: --no-window when exporting
- ([`2699d358`](https://github.com/russmatney/dino/commit/2699d358)) refactor: conforms to auto-formatter's tabs *sigh*
- ([`df2f7b31`](https://github.com/russmatney/dino/commit/df2f7b31)) feat: gut with no window, test-match helpers
- ([`44fd7ecc`](https://github.com/russmatney/dino/commit/44fd7ecc)) feat: add GUT and `bb test`, plus example test file

  > Also adds the behavior tree plugin...

- ([`fc10f6ec`](https://github.com/russmatney/dino/commit/fc10f6ec)) navi: initial NaviMenu, config warning, add_menu_item

  > Implements the beginnings of a NaviMenu.
  > 
  > First ever configuration warning. Perhaps this should be a full-on type,
  > not just a script? Perhaps?
  > 
  > add_menu_item expects a dict with 'label', 'method', and 'obj', which it
  > uses to connect the MenuButton's 'pressed' event to. Should make for
  > convenient button creation.

- ([`80a1d154`](https://github.com/russmatney/dino/commit/80a1d154)) feat: adds a bunch of fonts

  > Roboto-font from link on https://kidscancode.org/godot_recipes/ui/labels/
  > 
  > at01 font: https://itch.io/queue/c/733269/godot-pixel-fonts?game_id=707314
  > 
  > born2bsportyv2
  > by japanyoshi
  > http://www.pentacom.jp/pentacom/bitfontmaker2/gallery/?id=383
  > 
  > adventurer
  > by brian j smith
  > http://www.pentacom.jp/pentacom/bitfontmaker2/gallery/?id=195
  > 
  > bad comic, Eirian, Turpis, Qaz
  > by GGBotNet
  > 
  > https://ggbot.itch.io/bad-comic-font
  > https://ggbot.itch.io/eirian-font
  > https://ggbot.itch.io/turpis-font
  > https://ggbot.itch.io/qaz-font
  > 
  > License
  > 
  > This Font Software is licensed under the SIL Open Font License, Version 1.1.
  > This license is available with a FAQ at: https://scripts.sil.org/OFL

- ([`109b62b7`](https://github.com/russmatney/dino/commit/109b62b7)) refactor: introduce demos, ui dirs in /src
- ([`3a4403ae`](https://github.com/russmatney/dino/commit/3a4403ae)) refactor: move scenes/scripts into src, images to assets
- ([`ac86e6e0`](https://github.com/russmatney/dino/commit/ac86e6e0)) fix: actually implement the new addons-map syntax

  > Totally forgot to finish this refactor - we're dealing with the
  > godot-dep map now, not the raw map input.

- ([`1c099b3b`](https://github.com/russmatney/dino/commit/1c099b3b)) docs: update for cleaner addons syntax
- ([`9328e050`](https://github.com/russmatney/dino/commit/9328e050)) feat: support {:nivo :russmatney/dino} as addon-map
- ([`da355e18`](https://github.com/russmatney/dino/commit/da355e18)) feat: support cleaner install-addons map

  > The original format was ensuring that pattern is supported, but as i've
  > seen more 'libraries', and since i'm going to be consuming my own, i'd
  > rather lean harder into the convention, which seems to be pretty
  > consistent.
  > 
  > Mostly i'm referring to where people put the `addons` dir in their
  > `addon` lib, and whether the names match the repo name, etc.
  > 
  > The assumption here is that the name used in the :keyword matches the
  > addons/<dir-name> that needs to be symlinked.
  > 
  > repo-id is a concept that means <user-or-org-name>/<repo-name>, but as a
  > string. tho it could also be a namespace keyword....hmmmmm.


### 20 Jul 2022

- ([`0c541995`](https://github.com/russmatney/dino/commit/0c541995)) Merge remote-tracking branch 'bb-godot/main'

  > Rewrites the bb-godot readme as part of dino.

- ([`fb5904fb`](https://github.com/russmatney/dino/commit/fb5904fb)) rename project: 'dino'
- ([`ed0c1ea3`](https://github.com/russmatney/dino/commit/ed0c1ea3)) wip: first menu button

  > about to rename to dino and go ham.

- ([`ad464820`](https://github.com/russmatney/dino/commit/ad464820)) fix: troll -> trolley

  > I like this name better.

- ([`7336ff85`](https://github.com/russmatney/dino/commit/7336ff85)) demo: example editor script
- ([`0143833c`](https://github.com/russmatney/dino/commit/0143833c)) demo: import demo

  > https://docs.godotengine.org/en/stable/tutorials/plugins/editor/import_plugins.html

- ([`624cc7d0`](https://github.com/russmatney/dino/commit/624cc7d0)) demo: godot main screen plugin tut

  > https://docs.godotengine.org/en/stable/tutorials/plugins/editor/making_main_screen_plugins.html

- ([`012721b1`](https://github.com/russmatney/dino/commit/012721b1)) demo: godot custom dock tutorial

  > https://docs.godotengine.org/en/stable/tutorials/plugins/editor/making_plugins.html

- ([`e868653b`](https://github.com/russmatney/dino/commit/e868653b)) demo: custom button addon

  > Courtesy of this tutorial: https://docs.godotengine.org/en/stable/tutorials/plugins/editor/making_plugins.html

- ([`83ec6440`](https://github.com/russmatney/dino/commit/83ec6440)) feat: init beehive, troll, dj, tyle
- ([`acbf31f0`](https://github.com/russmatney/dino/commit/acbf31f0)) feat: init navi
- ([`bcb86b6a`](https://github.com/russmatney/dino/commit/bcb86b6a)) feat: init godot project

  > The usual create-elsewhere-and-move-here-b/c-the-project-can't-be
  > created-if-the-dir-isn't-empty work-around.

- ([`6a745937`](https://github.com/russmatney/dino/commit/6a745937)) init: readme and todos
- ([`6b75694e`](https://github.com/russmatney/dino/commit/6b75694e)) feat: build-web, deploy-web, zip

  > Adds a few basic commands that I ended up using in the last two game
  > jams.


### 13 Jul 2022

- ([`77299de8`](https://github.com/russmatney/dino/commit/77299de8)) feat: pixels recursively searching directories for .aseprite files

### 11 Jul 2022

- ([`9910881c`](https://github.com/russmatney/dino/commit/9910881c)) feat: initial install-script-templates

### 9 Jul 2022

- ([`72289d00`](https://github.com/russmatney/dino/commit/72289d00)) feat: basic install-addons creating symlinks

  > Updates the bb.edn w/ example usage.
