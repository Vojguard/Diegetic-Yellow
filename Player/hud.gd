class_name PlayerHUD
extends CanvasLayer

@onready var score_display : Label = $Score

func _ready() -> void:
	SignalBus.score_updated.connect(_on_score_update)

func _on_score_update(new_score : int) -> void:
	score_display.text = ("Score : %d " % new_score)
