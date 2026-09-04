extends RichTextLabel

var _is_parsing: bool = false

func _ready() -> void:
	bbcode_enabled = true
	add_to_group("SettingsReceivers")

# Intercept whenever the main Wiki script sets text on this label
func _set(property: StringName, value: Variant) -> bool:
	if property == &"text" and not _is_parsing:
		_parse_and_apply(str(value))
		return true
	return false

func on_settings_applied(_settings: Dictionary) -> void:
	_parse_and_apply(text)

func _parse_and_apply(raw_text: String) -> void:
	if raw_text == "":
		return

	# Determine icon set from Pause Menu (0 = Xbox, 1 = PS3, 2 = Switch, 3 = Steam Deck)
	var icon_set: int = 0
	var pause_menu = get_tree().get_first_node_in_group("Pause Menu")
	if pause_menu and pause_menu.currentSettings.has("controller_icons"):
		icon_set = pause_menu.currentSettings.get("controller_icons", 0)

	var parsed = raw_text

	# Loop through all mapped controller buttons
	for button_key in ControllerIcon.ICON_MAP.keys():
		var paths: Array = ControllerIcon.ICON_MAP[button_key]
		var idx = clamp(icon_set, 0, paths.size() - 1)
		var full_path = ControllerIcon.BASE + paths[idx]
		var img_tag = "[img=22]" + full_path + "[/img]"

		# Check for (A), {A}, or [A] in faz2.json
		parsed = parsed.replace("(" + button_key + ")", img_tag)
		parsed = parsed.replace("{" + button_key + "}", img_tag)
		parsed = parsed.replace("[" + button_key + "]", img_tag)

	# Apply parsed text back to RichTextLabel safely
	_is_parsing = true
	text = parsed
	_is_parsing = false
