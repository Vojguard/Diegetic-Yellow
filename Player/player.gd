class_name PlayerController
extends CharacterBody3D

@export var movement_speed : float = 500.0
@export var mouse_sensivity : float = 0.005
@export var camera_vertical_limit : float = 45
@export var jump_force : float = 5

@onready var _camera : Camera3D = $Camera

func _physics_process(delta: float) -> void:
	
	_handle_horizontal_movement(delta)
	
	_handle_vertical_movement(delta)
	
	move_and_slide()

func _handle_horizontal_movement(delta: float) -> void:
	var x_axis : float = Input.get_axis("left", "right")
	var z_axis : float = Input.get_axis("forward", "backward")
	var direction : Vector3 = Vector3(x_axis, 0, z_axis)
	
	var target_velocity = transform.basis * direction.normalized() * movement_speed * delta
	velocity.x = target_velocity.x
	velocity.z = target_velocity.z
	
	if abs(x_axis) < 0.01 and abs(z_axis) < 0.01:
		velocity *= Vector3.UP

func _handle_vertical_movement(delta: float) -> void:
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_force
	else:
		velocity.y += -9.81 * delta

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensivity)
		
		_camera.rotate_x(-event.relative.y * mouse_sensivity)
		_camera.rotation.x = clamp(_camera.rotation.x, deg_to_rad(-camera_vertical_limit), deg_to_rad(camera_vertical_limit))
