extends CharacterBody3D

@export var movementSpeed : float = 500.0

func _process(delta: float) -> void:
	var dir : Vector3 = _handle_input()
	if dir.length() > 0.9:
		velocity = dir * movementSpeed * delta
	else :
		velocity = Vector3.ZERO
	move_and_slide()

func _handle_input() -> Vector3:
	var direction : Vector3 = Vector3.ZERO
	if Input.is_action_pressed("forward"):
		direction = direction + Vector3.FORWARD
	if Input.is_action_pressed("backward"):
		direction = direction + Vector3.BACK
	if Input.is_action_pressed("left"):
		direction = direction + Vector3.LEFT
	if Input.is_action_pressed("right"):
		direction = direction + Vector3.RIGHT
	var normDir = direction.normalized()
	return normDir
