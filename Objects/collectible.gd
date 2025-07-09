class_name Collectible
extends Interactable

func interact():
	queue_free()


func _on_screen_entered() -> void:
	print("heya")


func _on_screen_exited() -> void:
	print("byea")
