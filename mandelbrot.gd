extends Node2D

var time: float = 0
var power: float = 0.1
@onready var shader: ShaderMaterial = $ColorRect.material

func _process(delta: float) -> void:
	time += delta;
	power += delta * 0.1;
	var zoom: float = 6 / pow(time, power);
	shader.set_shader_parameter("zoom", zoom);
	
	
	var mouse_pos: Vector2 = get_global_mouse_position();
	print(var_to_str(mouse_pos.x / 1152) + " " + var_to_str(mouse_pos.y / 648));
	
	shader.set_shader_parameter("offset_x", mouse_pos.x / 1152 * zoom);
	shader.set_shader_parameter("offset_y", mouse_pos.y / 648 * zoom);
