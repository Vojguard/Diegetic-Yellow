extends Node3D

const TARGET_HIT_SCORE = 10
const COLLECTABLE_SCORE = 2

var player: PlayerController = null

var _score: int = 0

func _ready() -> void:
	SignalBus.player_loaded.connect(_on_player_loaded)
	SignalBus.target_hit.connect(_on_target_hit)
	SignalBus.item_collected.connect(_on_item_collected)

func _on_player_loaded(p : PlayerController) -> void:
	player = p
	print("player_loaded")

func _on_target_hit(t : Target) -> void:
	_score += TARGET_HIT_SCORE
	print("target hit %d" % _score)

func _on_item_collected(ci : Collectible) -> void:
	_score += COLLECTABLE_SCORE
	print("item collected %d" % _score)
