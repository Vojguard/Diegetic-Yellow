class_name Target
extends  Interactable

@export var hit_color : Color = Color.GREEN
var hit : bool = false
var _time_appeared : float = 0
@onready var _mesh : MeshInstance3D = $MeshInstance3D

func take_hit() -> void:
	if !hit:
		hit = true
		SignalBus.target_hit.emit(self)
		print("ouch")
		#_mesh.get_active_material(0).albedo_color = hit_color
		queue_free()
	
func _on_screen_entered() -> void:
	if !hit:
		print("bonjour"+ self.to_string())
		on_screen_appearance += 1
		_time_appeared = Time.get_ticks_msec()

func _on_screen_exited() -> void:
	if !hit:
		on_screen_time = (Time.get_ticks_msec() - _time_appeared)
		print("adios" + self.to_string())
