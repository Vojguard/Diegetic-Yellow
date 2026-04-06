class_name Collectible
extends Interactable

var _last_time_appeared : float = 0

func interact():
	SignalBus.item_collected.emit(self)
	queue_free()


func _on_screen_entered() -> void:
	on_screen_appearance += 1
	_last_time_appeared = Time.get_ticks_msec()
	print("heya" + name)


func _on_screen_exited() -> void:
	on_screen_time += (Time.get_ticks_msec() - _last_time_appeared)
	print("byea" + name)
