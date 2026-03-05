extends CanvasLayer

var date_time = null

@onready var datetime_label : Label = $MarginContainer/HBoxContainer/VBoxContainer2/DateTime

func _process(_delta: float) -> void:
	date_time = Time.get_datetime_dict_from_system()
	datetime_label.text = ("%02d-%02d-%04d %02d:%02d:%02d" % [date_time.day, date_time.month, date_time.year, date_time.hour, date_time.minute, date_time.second])

func _on_play_pressed() -> void:
	date_time = Time.get_datetime_dict_from_system()
	LogWriter.open_log_file(date_time)
	LogWriter.print_header_to_log(date_time, LogWriter.EVENT_TAG.NG)
	get_tree().change_scene_to_file(Globals.SCENES.LEVEL_ONE)

func _on_quit_pressed() -> void:
	LogWriter.close_log_file()
	get_tree().quit(0)


func _on_logs_pressed() -> void:
	var log_path = ProjectSettings.globalize_path(Globals.LOGS.LOG_FOLDER)
	OS.shell_open(log_path)
