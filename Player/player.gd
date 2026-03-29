class_name PlayerController
extends CharacterBody3D

const SHOOT_RAY_LENGHT = 1000
const ADS_FOV = 45
const DEF_FOV = 75

@export var movement_speed : float = 500.0
@export var default_mouse_sensivity : float = 0.005
@export var ads_mouse_sensivity : float = 0.001
@export var camera_vertical_limit : float = 45
@export var jump_force : float = 5

var _ads : bool = false
var _current_mouse_sensivity

@onready var _camera : Camera3D = $Camera
@onready var _interaction_cast : ShapeCast3D = $Camera/InteractionCast
@onready var _shoot_cast : RayCast3D = $Camera/ShootCast

func _ready() -> void:
	_camera.fov = DEF_FOV
	_current_mouse_sensivity = default_mouse_sensivity
	_interaction_cast.add_exception(self)
	_interaction_cast.set_enabled(false)
	_shoot_cast.set_enabled(false)
	SignalBus.player_loaded.emit(self)

func _physics_process(delta: float) -> void:
	
	_handle_horizontal_movement(delta)
	
	_handle_vertical_movement(delta)
	
	_handle_actions()
	
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

func _handle_actions() -> void:
	if Input.is_action_just_pressed("ads") and !_ads:
		_ads = true
		_camera.fov = ADS_FOV
		_current_mouse_sensivity = ads_mouse_sensivity
	if Input.is_action_just_released("ads") and _ads:
		_ads = false
		_camera.fov = DEF_FOV
		_current_mouse_sensivity = default_mouse_sensivity
	
	if Input.is_action_just_pressed("shoot"):
		# await RenderingServer.frame_post_draw
		# $Camera.get_viewport().get_texture().get_image().save_png("user://Screenshot.png")
		print("pew pew")
		_shoot_cast.set_enabled(true)
		_shoot_cast.force_raycast_update()
		var hit : Object = _shoot_cast.get_collider()
		if hit is Target:
			hit.take_hit()
			print(hit)
		_shoot_cast.set_enabled(false)
		
	if Input.is_action_just_pressed("interact"):
			print("cmon do something")
			_interaction_cast.set_enabled(true)
			_interaction_cast.force_shapecast_update()
			var collisions : int = _interaction_cast.get_collision_count()
			if collisions > 0:
				var hit : Object = _interaction_cast.get_collider(0)
				if hit is Interactable:
					hit.interact()
					print(hit)
			_interaction_cast.set_enabled(true)

#func _input(event: InputEvent) -> void:
	#if event is InputEventKey:
		#if event.is_action_pressed("interact"):
			#print("cmon do something")
		

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * _current_mouse_sensivity)
		
		_camera.rotate_x(-event.relative.y * _current_mouse_sensivity)
		_camera.rotation.x = clamp(_camera.rotation.x, deg_to_rad(-camera_vertical_limit), deg_to_rad(camera_vertical_limit))

# function that shoot a ray from the camera forward returning the result dictionary
func _shoot_ray_from_camera() -> Dictionary:
	var space_state : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var mouse_position : Vector2 = get_viewport().get_mouse_position()
		
	# create the ray from center of the screen forward
	var from : Vector3 = _camera.project_ray_origin(mouse_position)
	var to : Vector3 = from + _camera.project_ray_normal(mouse_position) * SHOOT_RAY_LENGHT
	var query : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = [self] #ignore the hit of the players bounding box
		
	var result : Dictionary = space_state.intersect_ray(query)
	return result
