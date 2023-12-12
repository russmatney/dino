extends PanelContainer

func set_label(text):
	$%WeaponLabel.text = "[center]%s[/center]" % text
	$%WeaponLabel.visible = true

func set_icon(texture):
	$%WeaponIcon.set_texture(texture)
