class_name Target
extends  StaticBody3D

@export var hit_color : Color = Color.GREEN
var hit : bool = false
@onready var _mesh : MeshInstance3D = $MeshInstance3D

func take_hit() -> void:
	if !hit:
		hit = true
		SignalBus.target_hit.emit(self)
		#_mesh.get_active_material(0).albedo_color = hit_color
		queue_free()
	
func _on_screen_entered() -> void:
	if !hit:
		print("bonjour")


func _on_screen_exited() -> void:
	if !hit:
		print("adios")
