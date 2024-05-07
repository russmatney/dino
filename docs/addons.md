(Dino) Addons
=============

I created a number of experimental addons in Dino - at this point they've all
been pulled into 'addons/core', and they are being wittled down.

Below is documentation for them, even if some don't really exist any more - I'm
hopeful the ideas and related replacement libraries are useful.

For a quick look at what external addons Dino uses, check out the [`plug.gd` file](https://github.com/russmatney/dino/blob/main/plug.gd).

# Core

Core was originally a place for library code without a home, but now it contains
whatever remains of the rest of the addons documentted here.

- Util.gd
  - a bunch of static functions I can't live without
  - a GDScript-Standard-Lib-Extras of sorts
- Log.gd (now a separate plugin)
  - a pretty printer with a minimal API (`Log.pr(...args)`)
    - Pulled into a separate repo and proper godot addon in March 2024: [`russmatney/log.gd`](https://github.com/russmatney/log.gd)
- Assets
  - e.g. Fonts

# Beehive
Intended for working with state machines, behavior trees, GOAP, but only ever
included a small state machine.

The naming ended
up very close to [`bitbrain/beehave`](https://github.com/bitbrain/beehave),
which I'd recommend if you're looking for a behavior tree implementation.

At one point this included base controllers for players, enemies, and bosses
across three genres: `SideScroller`, `TopDown`, and `BeatEmUp`.
It also included integrations like powerups and weapons systems.

I eventually deconstructed beehive - I pulled most of the impls into `dino/src` proper, and moved the
Machine.gd and State.gd impls into `addons/core/machine`.
# Brick
A more recent proc-generation attempt. Pretty rough at the moment, but
somewhat generic. I'm hopeful to merge this implementation into Dino's Vania
code, which is a layer on top of MetSys: [`KoBeWi/Metroidvania-System`](https://github.com/KoBeWi/Metroidvania-System).

Related, I ought to look into consuming [`BenjaTK/Gaea`](https://github.com/BenjaTK/Gaea)
# Camera
I was quite proud of this when I first implemented it! But it fell into
disrepair. At this point I've moved to just consuming
[`ramokz/phantom-camera`](https://github.com/ramokz/phantom-camera),
and implementing the camera 'juice' via `addons/core/Juice.gd`.

--

2D Camera with modes for following the player, anchors, or centering based on
points of focus/interest.

Pulls heavily from Squirrel Eiserloh's [Juicing Your Cameras with Math](https://www.youtube.com/watch?v=tu-Qe66AvtY) video.

Includes functions for slowmo, freezeframe (hit-stop), and screenshake.
# DJ
For sounds and music management, such as background music that is maintained
across scene transitions.

This was nice, but by now it's just a thin layer on top of [`nathanhoad/godot_sound_manager`](https://github.com/nathanhoad/godot_sound_manager).

# Hood
Reusable HUD UI components, including an onscreen notification helper.

# Hotel
Most of my Hotel ideas are now deprecated in favor of
[bitbrain/pandora](https://github.com/bitbrain/pandora), which helped shrink
it's scope down to a couple data functions around node lifecycle.

--

An in-memory game state db.

Discussed in more detail: [russmatney.com/note/hotel_dino_plugin.html](https://russmatney.com/note/hotel_dino_plugin.html)
# Metro
Deprecated in favor of [KoBeWi/MetSys](https://github.com/KoBeWi/Metroidvania-System).

`Metro.gd`, `MetroZone.gd`, and `MetroRoom.gd` provide helpers for managing
zones (areas) and rooms in map-based games. (Metroidvanias, roguelikes, dungeon
crawlers, etc.)

Originally built along side HatBot, then refactored out
into it's own addon, and now waiting to be completely dropped in favor of Dino's
game modes and various consumers.
# Navi
Basic menus and pausing, some related components, and general scene loading/navigation.

NaviMenu - supporting `add_menu_item({label: "Blah", fn: self.some_func})`.
# Quest
Basic signals and checks for completing one or more tasks in a scene.

Recently Quests were refactored to support a QuestManager node - this will
attempt to find relevant quests for whatever nodes enter the scene, and surfaces
signals when those quests are updated or completed.
# Reptile
Tools, scripts and ui as a layer into working with Tilesets.

Includes some basic auto-tiles as assets to speed up prototyping.

The Reptile static class provides some tile-related helper functions.
# Thanks
A simple Credits scene and/or script that scrolls credits from a .txt file.

I debated naming this T. Hanks and using the Simpson's Tom Hanks character as a
logo, but it seemed like a long way to go for ~ 50 lines of gdscript. Still,
might be a fun project to build up - maybe even make the credits a game, like
after super-smash's classic mode.
# Trolley (renamed to Trolls.gd)
For handling controls inputs and remapping.

Input handling in godot is really simple, but it generally uses strings as
inputs, so this is a thin layer to use static function calls instead.

``` gdscript
var move_dir = Trolls.move_vector() # a normalized input direction

func _unhandled_input(event):
	# Because i can never remember the input event api
    if (Trolls.is_punch(event)):
        punch()
```

Trolley has been simplified and renamed to Trolls.

Related: [nathanhoad/godot_input_helper](https://github.com/nathanhoad/godot_input_helper)
