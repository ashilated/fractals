extends Node2D

var time: float = 0
var power: float = 0.1
var current_pos: Vector2 = Vector2(0, 0)
var last_mouse_pos: Vector2 = Vector2(0, 0)
@onready var zoom: HSlider = $VBoxContainer/Zoom
@onready var shader: ShaderMaterial = $ColorRect.material

func _process(delta: float) -> void:
	#time += delta
	#power += delta * 0.1
	#var zoom: float = 6 / pow(time, power)
	var zoom: float = zoom.value
	shader.set_shader_parameter("zoom", zoom)
	
	
	if Input.is_action_pressed("left"):
		current_pos -= last_mouse_pos - get_global_mouse_position()
		last_mouse_pos = get_global_mouse_position()
		print(var_to_str(current_pos.x / 1152) + " " + var_to_str(current_pos.y / 648))
		
		shader.set_shader_parameter("offset_x", current_pos.x / 1152 * zoom)
		shader.set_shader_parameter("offset_y", current_pos.y / 648 * zoom)
		
	#if Input.is_action_just_released("left"):
		#print("action released")
		#current_pos = get_global_mouse_position()
