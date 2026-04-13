extends CanvasLayer

@onready var time: Label = $VBoxContainer3/Time
@onready var targets: ProgressBar = $VBoxContainer3/HSplitContainer/TargetsBar
@onready var collectibles: ProgressBar = $VBoxContainer3/HSplitContainer2/Collectibles

func _ready() -> void:
	var stats = Globals.LEVEL.get_level_stats()
	var sec = stats[2] % 60
	var mins = stats[2] / 60
	time.text = "%02d:%02d | %04d" % [mins, sec, stats[3]]
	targets.value = stats[0]
	collectibles.value = stats[1]

func _on_continue_pressed() -> void:
	var scene_to_load = Globals.GAME.get_scene_at_current_location()
	get_tree().change_scene_to_file(scene_to_load)

func _on_quit_pressed() -> void:
	LogWriter.close_log_file()
	get_tree().quit(0)


func _on_return_pressed() -> void:
	get_tree().change_scene_to_file(Globals.SCENES.MAIN_MENU)
