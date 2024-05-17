# CHANGELOG


## Untagged


### 17 May 2024

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