extends CharacterBody3D

@export var movementSpeed : float = 500.0
@export var mouseSensivity : float = 0.005
@export var cameraVerticalLimit : float = 45

@onready var _camera : Camera3D = $Camera

func _process(delta: float) -> void:
	var dir : Vector3 = _handle_input()
	if dir.length() > 0.9:
		velocity = transform.basis * dir * movementSpeed * delta
	else :
		velocity = Vector3.ZERO
	move_and_slide()

func _handle_input() -> Vector3:
	var direction : Vector3 = Vector3.ZERO
	if Input.is_action_pressed("forward"):
		direction.z += -1 
	if Input.is_action_pressed("backward"):
		direction.z += 1
	if Input.is_action_pressed("left"):
		direction.x += -1
	if Input.is_action_pressed("right"):
		direction.x += 1
	var normDir = direction.normalized()
	return normDir

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouseSensivity)
		_camera.rotate_x(-event.relative.y * mouseSensivity)
		_camera.rotation.x = clamp(_camera.rotation.x, deg_to_rad(-cameraVerticalLimit), deg_to_rad(cameraVerticalLimit))
