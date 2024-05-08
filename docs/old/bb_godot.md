BB-(babashka-)Godot
===================

Dino was originally called 'godot-extras', and separately I created a 'bb-godot'
repo to provide some nice CLI gamedev features. I also built up a rough
babashka-based addon manager.... this was soon incorporated into Dino as I
leaned into it's monorepo-ness.

I definitely love my bb helpers, even tho most of these are no longer useful.

Somewhat related, I made an [Aseprite Scripting Dev
Log](https://youtu.be/yKHnLkeyGzc) in January/Feb 2024, tho I don't think that
video touches on babashka directly. Maybe more useful is the example repo: https://github.com/russmatney/aseprite-scripting

Below is some old documentation - maybe useful for some ideas/tools to build out
in the future.

--

`bb-godot`: Utilities for managing Godot Projects via Babashka

- watch and exporting aseprite files on-save
- build and serve a local web build
- deploy to itch.io via butler

# `bb watch`

A file watcher that could run other commands, but for now is automatically
exporting Aseprite files as pngs.

--

This was less useful once I integrated [Aseprite
Wizard](https://github.com/viniciusgerevini/godot-aseprite-wizard) - now I want
something that re-invokes Aseprite Wizard's import on file-save, which might
require a socket or connection to the running Godot instance... tho maybe it
could just be invoked from the command line?

# `bb build-web`: Build project for web

Build your project, for web.

Builds using godot's HTML5 template, in the `./dist` directory.

This can be served locally with a web server helper (`bb serve`)

I don't use this so much anymore in Dino, b/c CI automatically builds and
deploys, but it was useful for building Dino's sub-games or manually
testing/deploying a web build.

# `bb serve-built`: run a local webserver

This depends on a local fork of babashka/http-server that sets the
`SharedArrayBuffer` header.

# `bb butler-push <game-name> <build-type>`: Push project to matching itch.io game

# `bb zip`: Zip project
zip the `./dist` dir into a `dist.zip`, which can be uploaded to itch.io


# deploying to s3

    NOTE: I'm not doing this so much anymore, b/c butler and itch.io are great for
    hosting web games. Maybe it still works?

## `bb deploy-web <s3-bucket>`: Deploy project to s3

Deploy a project to an s3 bucket.

Depends on a working and logged-in `aws` cli tool.

# symlinked addon support

At this point I've moved to vendoring the deps completely within the project, to
avoid burdening other contributors with cloning/installing these deps. These
commands might still be useful in some cases, but are not required to run the
project.

## `bb addons`

An quick status check for your addons-map

## `bb install-addons`

An approximation of a dependency manager.

Clones and symlinks godot addons, using a clojure map as the manifest

Here's a bit of the current bb.edn for this project

``` clojure
{:tasks
{:requires ([bb-godot.tasks :as tasks])

install-addons
(tasks/install-addons
{:behavior_tree :kagenash1/godot-behavior-tree
    :gut           :bitwes/Gut})}}
```

A project consuming some of dino's addons (plus gdunit) might look like:

``` clojure
{:tasks
{:requires ([bb-godot.tasks :as tasks])

install-addons
(tasks/install-addons
{:gdUnit4       :MikeSchulze/gdUnit4
    :navi          :russmatney/dino
    :dj            :russmatney/dino
    :trolley       :russmatney/dino
    :core          :russmatney/dino
    :reptile       :russmatney/dino
    :beehive       :russmatney/dino})}}
```

## `bb install-script-templates`

Copy templates from external paths into your project

I needed this one time, tho it seems like addons should do this themselves?
Maybe going through the asset library works that way?
