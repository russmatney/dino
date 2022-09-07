extends Credits

var dino_credits = [
  ["A set of godot addons and games that use them"],
  ["Created to cut out overhead when building prototypes"],
  ["Made in Godot, Aseprite, and Emacs"],
  [
    "Songs",
    "",
    "Late Night Radio",
    "Kevin MacLeod (incompetech.com)",
    "Licensed under Creative Commons: By Attribution 4.0 License",
    "http://creativecommons.org/licenses/by/4.0",
  ],
  [
    "Art",
    "",
    "Pirate Bomb",
    "Pixel Frog",
      # TODO get proper attribution in here
    "CC-0",
    "",
  ],
  [
    "Fonts",
    "",
    "born2bsportyv2",
    "japanyoshi",
    "http://www.pentacom.jp/pentacom/bitfontmaker2/gallery/?id=383",
    "Public Domain",
  ],
  ["Many thanks to all the testers and brainstormers who listened and gave feedback!",
    "",
    "Thank you!"],
]

func get_credit_lines():
	return dino_credits
