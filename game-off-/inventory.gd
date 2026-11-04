@tool
extends Control

@export var bg_color : Color
@export var line_color : Color

@export var outer_radius : int = 256
@export var inner_radius : int = 64
@export var line_width : int = 4
@export var options = []

# Called when the node enters the scene tree for the first time.
func _draw() -> void:
	draw_circle(Vector2.ZERO, outer_radius, bg_color)
	draw_arc(Vector2.ZERO, inner_radius, 0, TAU, 128, line_color, line_width, true)
	
	if len(options) >= 3:
		
		for i in range(len(options) - 1):
			var rads = TAU * i / (len(options) - 1)
			var point = Vector2.from_angle(rads)
			draw_line(
				point * inner_radius,
				point * outer_radius,
				line_color,
				line_width,
				true
			)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
