extends CharacterBody3D

var checkpoint : Vector3 = Vector3(0,1,0)
var SPEED = 5.0
var JUMP_VELOCITY = 4.5
@onready var inventory := $"../wheelscene/UI/Selectionwheel"
@onready var shroomtimer = $ShroomTimer
@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var hand := $Neck/hand
@onready var animationplayer := $Neck/hand/AnimationPlayer
@onready var ishandvisible = false
@onready var coyotetimer = $CoyoteTimer
var shrooms : bool = false
var shroomdoses : int = 2
var flourdoses : int = 2
var lsddoses : int = 2

func _physics_process(delta: float) -> void:
	hand.visible = ishandvisible
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or not coyotetimer.is_stopped()):
		velocity.y = JUMP_VELOCITY
		if JUMP_VELOCITY != 4.5:
			JUMP_VELOCITY = 4.5

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if Input.is_action_just_pressed("Reset"):
		global_position = checkpoint
		flourdoses = 2
#Using drugs
	if Input.is_action_just_pressed("Snort"):
		if inventory.options[inventory.select].name == "Nothing":
			pass
		if inventory.options[inventory.select].name == "Cocaine" && flourdoses > 0:
			ishandvisible = true
			animationplayer.play("snort")
			flourdoses -= 1
			JUMP_VELOCITY += 4.5
		if inventory.options[inventory.select].name == "Shrooms" && shroomdoses > 0 && shrooms == false:
			shrooms = true
			shroomtimer.start(10)
	if Input.is_action_pressed("Snort") and inventory.options[inventory.select].name == "Speedball":
		SPEED = 10
	if Input.is_action_just_released("Snort") and inventory.options[inventory.select].name == "Speedball":
		SPEED = 5

	var was_on_floor = is_on_floor()
	move_and_slide()
	if was_on_floor && !is_on_floor():
		coyotetimer.start()




func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.002)
			camera.rotate_x(-event.relative.y * 0.003)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-50), deg_to_rad(80))




func _on_animation_player_animation_finished(snort):
	ishandvisible = false
#	$Cocainetimer.start(10)
#	SPEED = 10
#	JUMP_VELOCITY = 9


func _on_shroom_timer_timeout() -> void:
	shrooms = false
