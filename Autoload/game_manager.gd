extends Node3D

const TARGET_HIT_SCORE = 10
const COLLECTABLE_SCORE = 2

var player: PlayerController = null

var start_time = 0
var score: int = 0

func _ready() -> void:
	_connect_signals()
	start_time = Time.get_ticks_msec()

func _connect_signals() -> void:
	SignalBus.player_loaded.connect(_on_player_loaded)
	SignalBus.target_hit.connect(_on_target_hit)
	SignalBus.item_collected.connect(_on_item_collected)

func _disconnect_signals() -> void:
	SignalBus.player_loaded.disconnect(_on_player_loaded)
	SignalBus.target_hit.disconnect(_on_target_hit)
	SignalBus.item_collected.disconnect(_on_item_collected)

func _on_player_loaded(p : PlayerController) -> void:
	player = p
	print("player_loaded")

func _on_target_hit(t : Target) -> void:
	_update_score(TARGET_HIT_SCORE)
	print("target hit %d" % score)

func _on_item_collected(ci : Collectible) -> void:
	_update_score(COLLECTABLE_SCORE)
	print("item collected %d" % score)

func _update_score(score_update : int) -> void:
	score += score_update
	SignalBus.score_updated.emit(score)

func _on_exit_body_entered(body: Node3D) -> void:
	if body is PlayerController:
		call_deferred("_return_to_main_menu")

func _return_to_main_menu() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_disconnect_signals()
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
