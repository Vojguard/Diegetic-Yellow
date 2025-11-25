class_name PlayerHUD
extends CanvasLayer

var targets_hit : int = 0
var items_collected : int = 0
var _start_time : int = 0

@onready var score_display : Label = $Score
@onready var targets_hit_display : Label = $Targets
@onready var items_collected_display : Label = $Items
@onready var stopwatch_display : Label = $Stopwatch

func _ready() -> void:
	SignalBus.score_updated.connect(_on_score_update)
	SignalBus.target_hit.connect(_on_target_hit)
	SignalBus.item_collected.connect(_on_item_collected)
	_start_time = GameManager.start_time

func _process(_delta: float) -> void:
	var time_diff = (Time.get_ticks_msec() - _start_time) / 1000
	var sec = time_diff % 60
	var mins = time_diff / 60
	stopwatch_display.text = ("Time : %02d:%02d" % [mins, sec])

func _on_score_update(new_score : int) -> void:
	score_display.text = ("Score : %3d " % new_score)

func _on_target_hit(_t : Target) -> void:
	targets_hit += 1
	targets_hit_display.text = ("Targets : %2d " % targets_hit)

func _on_item_collected(_c : Collectible) -> void:
	items_collected += 1
	items_collected_display.text = ("Items : %2d " % items_collected)
