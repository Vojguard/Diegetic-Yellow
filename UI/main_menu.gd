extends CanvasLayer

@export var game_version : Globals.GAME_VERSIONS

var date_time = null

@onready var datetime_label : Label = $MarginContainer/HBoxContainer/VBoxContainer2/DateTime

func _ready() -> void:
	Globals.GAME.set_chosen_game_version(game_version)
	$MarginContainer/HBoxContainer/VBoxContainer2/Label2.text = Globals.GAME.version_string_name

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
