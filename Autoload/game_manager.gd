class_name GameManager
extends Node3D

const target_hit_score = Globals.GAME.TARGET_HIT_SCORE
const collectable_score = Globals.GAME.COLLECTABLE_SCORE

var player: PlayerController = null

var start_time = 0
var score: int = 0

@export var next_level : Globals.LEVELS

func _ready() -> void:
	LogWriter.print_header_to_log(Time.get_datetime_dict_from_system(), LogWriter.EVENT_TAG.EL)
	_connect_signals()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _connect_signals() -> void:
	print("connection")
	SignalBus.player_loaded.connect(_on_player_loaded)
	SignalBus.target_hit.connect(_on_target_hit)
	SignalBus.item_collected.connect(_on_item_collected)

func _disconnect_signals() -> void:
	SignalBus.player_loaded.disconnect(_on_player_loaded)
	SignalBus.target_hit.disconnect(_on_target_hit)
	SignalBus.item_collected.disconnect(_on_item_collected)

func _on_player_loaded(p : PlayerController) -> void:
	player = p
	score = 0
	start_time = Time.get_ticks_msec()
	LogWriter.print_event_to_log(get_time(), LogWriter.EVENT_TAG.PL, score)
	print("player_loaded")

func _on_target_hit(_t : Target) -> void:
	_update_score(target_hit_score)
	LogWriter.print_event_to_log(get_time(), LogWriter.EVENT_TAG.TH, score)
	print("target hit %d" % score)

func _on_item_collected(_ci : Collectible) -> void:
	_update_score(collectable_score)
	LogWriter.print_event_to_log(get_time(), LogWriter.EVENT_TAG.IC, score)
	print("item collected %d" % score)

func _update_score(score_update : int) -> void:
	score += score_update
	SignalBus.score_updated.emit(score)

func _on_exit_body_entered(body: Node3D) -> void:
	if body is PlayerController:
		var next_level_string : String = ""
		if next_level == Globals.LEVELS.MAIN:
			next_level_string = Globals.SCENES.MAIN_MENU
		elif next_level == Globals.LEVELS.ONE:
			next_level_string = Globals.GAME.get_chosen_pair_scene(0)
		elif next_level == Globals.LEVELS.TWO:
			next_level_string = Globals.GAME.get_chosen_pair_scene(1)
		else:
			printerr("Unspecified next level")
		call_deferred("_load_next_scene", next_level_string)
		

func _load_next_scene(next : String) -> void:
	LogWriter.print_event_to_log(get_time(), LogWriter.EVENT_TAG.FL, score)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_disconnect_signals()
	get_tree().change_scene_to_file(next)

func _return_to_main_menu() -> void:
	_load_next_scene(Globals.SCENES.MAIN_MENU)

func get_time() -> int:
	return (Time.get_ticks_msec() - start_time) / 1000
