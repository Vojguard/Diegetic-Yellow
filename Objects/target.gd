class_name Target
extends  StaticBody3D

@export var hit_color : Color = Color.GREEN

@onready var _mesh : MeshInstance3D = $MeshInstance3D

func take_hit() -> void:
	_mesh.get_active_material(0).albedo_color = hit_color
	
func _on_screen_entered() -> void:
	print("bonjour")


func _on_screen_exited() -> void:
	print("adios")
