extends CanvasLayer

@onready var datetime_label : Label = $MarginContainer/HBoxContainer/VBoxContainer2/DateTime

func _process(_delta: float) -> void:
	var date_time = Time.get_datetime_dict_from_system()
	datetime_label.text = ("%02d-%02d-%04d %02d:%02d:%02d" % [date_time.day, date_time.month, date_time.year, date_time.hour, date_time.minute, date_time.second])

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://MainScene/main_scene.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit(0)
