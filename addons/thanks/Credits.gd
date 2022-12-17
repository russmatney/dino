tool
extends Control
class_name Credits

export(PackedScene) var credit_line_scene = preload("res://addons/thanks/CreditLine.tscn")
var credits_lines_container: VBoxContainer

var credits_scroll_container: ScrollContainer
var speed = 200

var initial_scroll_delay = 2.0
var scroll_delay_per_line = 0.05
var since_last_scroll = 0

var expected_nodes = ["CreditsScrollContainer", "CreditsLinesContainer"]

func _get_configuration_warning():
	for n in expected_nodes:
		var node = find_node(n)
		if not node:
			return "'Credits' node expects a child named '" + n + "'"
	return ""


var added_lines = []

func _ready():
  credits_scroll_container = find_node("CreditsScrollContainer")
  assert(credits_scroll_container, "Expected ScrollContainer node")
  credits_lines_container = find_node("CreditsLinesContainer")
  assert(credits_lines_container, "Expected VBoxContainer node")

  # support ready creating a clean credits view
  for l in added_lines:
	  credits_lines_container.remove_child(l)

  added_lines = []

  # TODO render at tool-time
  for lines in get_credit_lines():
    var new_line = credit_line_scene.instance()
    new_line.bbcode_text = "[center]\n"
    for line in lines:
      new_line.bbcode_text += line + "\n"
    new_line.bbcode_text += "[/center]"
    added_lines.append(new_line)
    credits_lines_container.add_child(new_line)

  if Engine.editor_hint:
    request_ready()

  # TODO opt-out if desired
  # TODO support passing a custom song
  # credits implying DJ dep
  DJ.resume_menu_song()

func _process(delta):
  if initial_scroll_delay <= 0:
    if since_last_scroll <= 0:
      credits_scroll_container.scroll_vertical += 1
      since_last_scroll = scroll_delay_per_line
    else:
      since_last_scroll -= delta
  else:
    initial_scroll_delay -= delta

var credits = [
  ["A game"],
  ["Created for the some game jam"],
  ["Made in Godot, Aseprite, and Emacs"],
  [
    "Songs",
    "",
    "Late Night Radio",
    "by Kevin MacLeod (incompetech.com)",
    "Licensed under Creative Commons: By Attribution 4.0 License",
    "http://creativecommons.org/licenses/by/4.0",
  ],
  [
    "Fonts",
    "",
    "born2bsportyv2",
    "by japanyoshi",
    "http://www.pentacom.jp/pentacom/bitfontmaker2/gallery/?id=383",
    "Public Domain",
    "https://creativecommons.org/publicdomain/zero/1.0/",
    "",
    "at10",
    "by grafxkid",
    "https://grafxkid.itch.io/at01",
    "Public Domain",
    "https://creativecommons.org/publicdomain/zero/1.0/",
  ],
  [
    "Art",
    "",
    "Pirate Bomb Tile Set",
    "By Pixel Frog",
    "https://pixelfrog-assets.itch.io/pirate-bomb",
    "Public Domain",
    "https://creativecommons.org/publicdomain/zero/1.0/",
  ],
  ["Patrons",
    "",
    "Cameron Kingsbury",
    "Duaa Osman",
    "Ryan Schmukler",
  ],
  ["Many thanks to all the testers and brainstormers who listened and gave feedback!",
    "",
    "Thank you!"],
]

func get_credit_lines():
	return credits
