VAR has_key = false

-> try_again
== try_again

-> crawl_ashore


== crawl_ashore

You crawl ashore, wondering where you map has gone. Your head is throbbing.

    *   Walk north along the shore.[]
        -> go_north
    *   Climb the rocks to the south.[]
        -> go_south
    *   Swim west.[]
        -> go_west
    *   Forage east.[]
        -> go_east

== go_north

Walking to the north you find a key in the sand.
Oh happy day!
~ has_key = true

    *   Swim west.
        -> go_west
    *   Forage east.
        -> go_east

-> END

== go_south
The terrain grows more and more rocky.
Had you eaten your vegetables, you might have had the strength to survive.

Alas, you did not.
-> try_again

== go_west
You eventually drown, sad and alone.
-> try_again

== go_east

You forage into the woods, looking desperate for food.
Soon you come upon a treasure chest.

{has_key:
    You have the key!
-> open_treasure
-   else:
    You don't have the key
    -> no_key
}

== open_treasure

Wonderful!

The treasure turned out to be a portal into your dreams.
-> END

== no_key

You have no key, no treasure, no food.
Also, you've been without a phone a phone for several hours.
You die of boredom before starving to death.

-> try_again
