extends CanvasLayer

@export var game_version : Globals.GAME_VERSIONS

var date_time = null

@onready var popup: Window = $Popup
@onready var datetime_label : Label = $MarginContainer/HBoxContainer/VBoxContainer2/DateTime
@onready var mouse_sensitivity_val: Label = $MarginContainer/HBoxContainer/Main/Settings/MouseSensitivityVal
@onready var full_screen: CheckBox = $MarginContainer/HBoxContainer/Main/Settings/HBoxContainer/FullScreen
@onready var version: Label = $MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/Version
@onready var nickname_label: Label = $MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/Nickname
@onready var main_buttons: VBoxContainer = $MarginContainer/HBoxContainer/Main/MainButtons
@onready var settings: VBoxContainer = $MarginContainer/HBoxContainer/Main/Settings
@onready var instructions: ColorRect = $Instructions

func _ready() -> void:
	instructions.visible = false
	Globals.GAME.set_chosen_game_version(game_version)
	version.text = Globals.GAME.version_string_name
	nickname_label.text = Globals.GAME.nickname
	mouse_sensitivity_val.text = "MOUSE SENSITIVITY : %f" % Globals.GAME.mouse_sens_modifier
	full_screen.button_pressed = (
		DisplayServer.window_get_mode() == DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN
	)
	if Globals.GAME.nick_entered == false:
		popup.show()

func _process(_delta: float) -> void:
	date_time = Time.get_datetime_dict_from_system()
	datetime_label.text = ("%02d-%02d-%04d %02d:%02d:%02d" % [date_time.day, date_time.month, date_time.year, date_time.hour, date_time.minute, date_time.second])

func _on_play_pressed() -> void:
	date_time = Time.get_datetime_dict_from_system()
	LogWriter.open_log_file(date_time)
	LogWriter.print_header_to_log(date_time, LogWriter.EVENT_TAG.NG, Globals.GAME.version_string_name)
	var scene_to_load = Globals.GAME.get_scene_at_current_location()
	get_tree().change_scene_to_file(scene_to_load)

func _on_quit_pressed() -> void:
	LogWriter.close_log_file()
	get_tree().quit(0)


func _on_logs_pressed() -> void:
	var log_path = ProjectSettings.globalize_path(Globals.LOGS.LOG_FOLDER)
	OS.shell_open(log_path)


func _on_settings_pressed() -> void:
	main_buttons.visible = false
	settings.visible = true

func _on_back_pressed() -> void:
	settings.visible = false
	main_buttons.visible = true


func _on_full_screen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_mouse_sensitivity_slid_value_changed(value: float) -> void:
	Globals.GAME.mouse_sens_modifier = value
	mouse_sensitivity_val.text = "MOUSE SENSITIVITY : %f" % value


func _on_instruction_back_pressed() -> void:
	instructions.visible = false


func _on_main_play_pressed() -> void:
	if Globals.GAME.get_current_walkthrough_location() > 0:
		_on_play_pressed()
	else:
		instructions.visible = true

func _on_nickname_text_submitted(nick_entered: String) -> void:
	Globals.GAME.set_nickname(nick_entered)
	nickname_label.text = Globals.GAME.nickname
	popup.hide()
