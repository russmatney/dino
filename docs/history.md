# Dino History

Here's a hopefully brief history of the journey Dino has taken as a repo.

Missing from this but probably interesting is the games and addons themselves -
I hope to put together something more interesting (i.e. lessons learned,
patterns changed, etc.), but for now, there are some old lists: ['old'
games](https://russmatney.github.io/dino/#/old/games) and ['old'
addons](https://russmatney.github.io/dino/#/old/addons).

# 'Dino' the name

- Vaguely Flintstone-inspired (Fred's 'dog')
  - I also like it as a vague 'Dino Spimoni' reference (from Hey Arnold)
- I like the Museum and 'Exhibits' tie in
  - you know, Dinosoar bones and all
- 'Dino' is sort of close to the word 'demo'
  - via jaro-distance, maybe?
- One day, maybe we'll make it a Backronym

# Prototyping Sandbox

Dino was originally intended as a demos/example project - I wanted to cut out
the overhead of needing a new from-scratch godot project to try out whatever
idea. I also wanted to start defining and collecting game dev tools and systems.

For whatever reason, I felt I needed some common subject matter (characters,
places) to write tests and demos with. This was inspired by Python's use of
Monty Python actors as subjects in its unit tests.

Maybe I should lean harder into the flintstones in the addon naming? `bedrock`
for tilemap layouts, `bambam` for a weapons system, `pebbles` for particles
effects?

# A Multi-Game Monorepo

The goal in my first year of full-time game dev was to submit to lots of game
jams - a focus on finishing things. Dino grew to support that, picking up lots
of addon experiments along the way.

These games are documented in a few places, including a [Dino Year One Dev Log
on youtube](https://youtu.be/9cyAnNLGrZI) and this ['old'
games](https://russmatney.github.io/dino/#/old/games) page. Most of the
submitted jam versions are playable via [my itch.io
page](https://russmatney.itch.io). Note that they are of mixed quality!

I also freely started lots of addons, whenever I felt like there was some aspect
of game dev that might be useful as a bundle of code or components. Most of
these have come and gone, getting merged together or dropped completely as I
found better methods or better external addons to cover the use-cases. An old
version of docs is [here](https://russmatney.github.io/dino/#/old/addons) for
posterity, and hopefully a more put-together set of lessons will come in video
form someday.

# DRYing up

There were good and bad patterns across these games - after a year in Dino and a
couple breaks to work on other projects ([Dot
Hop](https://store.steampowered.com/app/2779710/Dot_Hop) and BeatEmUp City
(Steam page coming soon!!)), I dove back into Dino's code. The newer games felt
cleaner than the old ones, and I wanted to apply the new patterns back to the
earlier games to learn how good they actually were.

I was also interested in making the older games playable - some/all of them had
been broken by misc jam-time decisions, and there had been no real reason to fix
them up. I wanted to DRY up the code and reuse the entities across games,
because that felt slightly crazy, and I love anything vaguely mad-scientist.

My work with [PuzzleScript](https://www.puzzlescript.net/) on Flower Eater and
then Dot Hop also influenced me - I was curious how plaintext might influence
and support (and simplify?) level design.

# Finish Something

After my first steam launch (Dot Hop in March 2024), I decided Dino would be
next. I liked the challenge of designing from the current haphazard state of
it - the dino games had both unique and overlapping mechanics.

I also felt strongly that it was time to push Dino through a 'launch' - I've
been working on it long enough, time to finish and share something, so I can
open myself up to new projects without this one weighing on me.

At this point I've pulled most of Dino's existing elements into a couple of
systems, and I'm narrowing in on the procedural level generation to drop players
into rooms with random entities. There's not much 'game' there yet, but enough
things 'work'! I've got a few weeks before the (self-imposed) deadline... it
should be fine?

# Beyond

The motivation to launch is to finish any version of Dino. BUT! My long-term
outlook is very similar to that for Dot Hop - these projects were chosen because
I am excited to maintain them for the long-haul, in spare time between other
projects, or while working another job full time.

I want to come back to Dino and add new enemies, weapons, game modes, tilesets,
levels, proc-gen layouts, art, sounds, etc. Ideally with minimal overhead! It
should be a place for prototyping and toying with ideas - so, the launch
version's main goal is to solidify those patterns.

Once launched, I'm excited to use Dino for it's original purpose -
experimenting. The systems make it easy to extend the games, and I'm hopeful to
toy with new Godot addons as well (e.g. [Gaea](https://github.com/BenjaTK/Gaea)
looks really cool!).
