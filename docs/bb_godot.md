#+title: BB-(babashka-)Godot

At one point I was thinking I'd build up a babashka-based godot addon manager,
but that seems crazy and unnecessary now.

I definitely love my bb helpers though. I have an Aseprite Scripting Dev Log (on
[my youtube channel](https://www.youtube.com/@russmatney) coming soon that features some of them.

--

`bb-godot`: Utilities for managing Godot Projects via Babashka

- watch and exporting aseprite files on-save
- build and serve a local web build
- deploy to itch.io via butler

# `bb watch`

A file watcher that could run other commands, but for now is automatically
exporting Aseprite files as pngs.

--

This was less useful once I integrated AsepriteWizard - now I want something
that re-invokes Aseprite Wizard's import on file-save, which might require a socket or
connection to the running Godot instance... tho maybe it could just be invoked from
the command line?

# `bb build-web`: Build project for web

Build your project, for web.

Builds using godot's HTML5 template, in the `./dist` directory.

This can be served locally with a web server helper (`bb serve`)

# `bb serve-built`: run a local webserver

This depends on a local fork of babashka/http-server that sets the
`SharedArrayBuffer` header.

# `bb butler-push <game-name> <build-type>`: Push project to matching itch.io game

# `bb zip`: Zip project
zip the `./dist` dir into a `dist.zip`, which can be uploaded to itch.io

# deprecated tasks

## deploying to s3

    NOTE: I'm not doing this so much anymore, b/c butler and itch.io are great for
    hosting web games. Maybe it still works?

### `bb deploy-web <s3-bucket>`: Deploy project to s3

Deploy a project to an s3 bucket.

Depends on a working and logged-in `aws` cli tool.

## symlinked addon support

At this point I've moved to vendoring the deps completely within the project, to
avoid burdening other contributors with cloning/installing these deps. These
commands might still be useful in some cases, but are not required to run the
project.

### `bb addons`

An quick status check for your addons-map

### `bb install-addons`

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

### `bb install-script-templates`

Copy templates from external paths into your project

I needed this one time, tho it seems like addons should do this themselves?
Maybe going through the asset library works that way?
