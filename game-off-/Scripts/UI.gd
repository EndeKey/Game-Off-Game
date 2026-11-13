extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Select"):
		$Selectionwheel.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_action_just_released("Select"):
		var tool = $Selectionwheel.Close()
		$Label.text = "Player equipped:" + tool
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
