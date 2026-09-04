extends Control

@onready var category_list: VBoxContainer = $"Mods/PanelContainer/HBoxContainer/VBoxContainer/ScrollContainer/Page Holder"
@onready var content_display: RichTextLabel = $"Mods/PanelContainer/HBoxContainer/MarginContainer/Mod Desc/MarginContainer/RichTextLabel"

const MODS_PATH := "res://Mods/"
const WIKI_FOLDER := "Wiki"

var _last_raw_text: String = ""

func _ready() -> void:
	content_display.bbcode_enabled = true
	add_to_group("SettingsReceivers")

func initialize() -> void:
	_load_all_wikis()

func _load_all_wikis() -> void:
	for child in category_list.get_children():
		child.queue_free()

	var dir := DirAccess.open(MODS_PATH)
	if not dir:
		return
	dir.list_dir_begin()
	var mod_name := dir.get_next()
	while mod_name != "":
		if dir.current_is_dir() and not mod_name.begins_with("."):
			_load_mod_wiki(MODS_PATH + mod_name + "/Mod Directory/" + WIKI_FOLDER + "/")
		mod_name = dir.get_next()
	dir.list_dir_end()

func _load_mod_wiki(wiki_path: String) -> void:
	var dir := DirAccess.open(wiki_path)
	if not dir:
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".json"):
			_parse_wiki_file(wiki_path + file_name, file_name.get_basename())
		file_name = dir.get_next()
	dir.list_dir_end()

func _parse_wiki_file(path: String, category: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		return
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK:
		return
	var pages: Dictionary = json.get_data()
	_build_category_ui(category, pages)

func _build_category_ui(category: String, pages: Dictionary) -> void:
	var label := Label.new()
	label.text = category
	label.add_theme_font_size_override("font_size", 16)
	category_list.add_child(label)

	var sep := HSeparator.new()
	category_list.add_child(sep)

	for page_name in pages:
		var btn := Button.new()
		btn.text = page_name
		btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.pressed.connect(_show_page.bind(pages[page_name]))
		category_list.add_child(btn)

	var spacer := Control.new()
	spacer.custom_minimum_size.y = 8
	category_list.add_child(spacer)

func _show_page(content: String) -> void:
	_last_raw_text = content
	content_display.text = _parse_controller_icons(content)

func on_settings_applied(_settings: Dictionary) -> void:
	if _last_raw_text != "":
		content_display.text = _parse_controller_icons(_last_raw_text)

func _parse_controller_icons(raw_text: String) -> String:
	var icon_set: int = 0
	var pause_menu = get_tree().get_first_node_in_group("Pause Menu")
	if pause_menu and pause_menu.currentSettings.has("controller_icons"):
		icon_set = pause_menu.currentSettings.get("controller_icons", 0)

	var aliases = {
		"Right Stick Click": "R3",
		"Left Stick Click": "L3",
		"Right Shoulder Button": "RB",
		"Left Shoulder Button": "LB",
		"Joystick Left": "LstickL"
	}

	var parsed = raw_text

	for key in ControllerIcon.ICON_MAP.keys():
		var paths: Array = ControllerIcon.ICON_MAP[key]
		var idx = clamp(icon_set, 0, paths.size() - 1)
		var img_tag = "[img=22]" + ControllerIcon.BASE + paths[idx] + "[/img]"
		parsed = parsed.replace("{" + key + "}", img_tag)

	for alias in aliases.keys():
		var target_key = aliases[alias]
		if ControllerIcon.ICON_MAP.has(target_key):
			var paths: Array = ControllerIcon.ICON_MAP[target_key]
			var idx = clamp(icon_set, 0, paths.size() - 1)
			var img_tag = "[img=22]" + ControllerIcon.BASE + paths[idx] + "[/img]"
			parsed = parsed.replace("{" + alias + "}", img_tag)

	return parsed
