extends Node2D

var zoom: float = 4
var dragging: bool = false
var last_mouse_pos: Vector2 = Vector2(0, 0)
var offset: Vector2 = Vector2(0, 0)
@onready var c: Vector2 = Vector2($VBoxContainer/JuliaOnly/C/X.value, $VBoxContainer/JuliaOnly/C/Y.value)
@onready var color1 = Vector4($VBoxContainer/Color1/R.value, $VBoxContainer/Color1/G.value, $VBoxContainer/Color1/B.value, 1)
@onready var color2 = Vector4($VBoxContainer/Color2/R.value, $VBoxContainer/Color2/G.value, $VBoxContainer/Color2/B.value, 1)
@onready var accent = Vector4($VBoxContainer/Accent/R.value, $VBoxContainer/Accent/G.value, $VBoxContainer/Accent/B.value, 1)
@onready var shader: ShaderMaterial = $SubViewportContainer/SubViewport/ColorRect.material

@onready var julia: Control = $VBoxContainer/JuliaOnly

@onready var fractals = [
	load("res://mandelbrot.tres"),
	load("res://julia.tres")
]

func _on_save_button_pressed() -> void:
	await RenderingServer.frame_post_draw
	
	var img = $SubViewportContainer/SubViewport.get_texture().get_image()
	var filename = var_to_str(Time.get_unix_time_from_system()) + ".png"
	if OS.has_feature("web"):
		var base64 = Marshalls.raw_to_base64(img.save_png_to_buffer())
		JavaScriptBridge.eval("""
			var a = document.createElement("a")
			a.href = "data:image/png;base64," + "{image}"
			a.download = "{name}"
			a.click()
		""".format({"image": base64, "name": filename}))
		
	else:
		img.save_png(OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP) + "/" + filename)


func _ready() -> void:
	zoom = 4
	shader.set_shader_parameter("color1", color1)
	shader.set_shader_parameter("color2", color2)
	shader.set_shader_parameter("accent", accent)
	_on_power_value_changed(2)
	$VBoxContainer/Power.value = 2
	_on_iterations_value_changed(100)
	$VBoxContainer/Iterations.value = 100

func _process(delta: float) -> void:
	if Input.is_action_just_released("scroll_up"):
		zoom *= 0.9
	elif Input.is_action_just_released("scroll_down"):
		zoom /= 0.9
	shader.set_shader_parameter("zoom", zoom)

func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			last_mouse_pos = event.position

	if event is InputEventMouseMotion and dragging:
		var delta = event.position - last_mouse_pos
		last_mouse_pos = event.position

		offset -= delta * 0.01 * zoom
		shader.set_shader_parameter("offset", offset)

func _on_type_item_selected(index: int) -> void:
	shader = fractals[index]
	$SubViewportContainer/SubViewport/ColorRect.material = shader
	_ready()
	if index == 1: julia.show()
	else: julia.hide()

func _on_iterations_value_changed(value: float) -> void:
	shader.set_shader_parameter("max_iterations", value)

func _on_power_value_changed(value: float) -> void:
	shader.set_shader_parameter("power", value)


func _on_color1_r_value_changed(value: float) -> void:
	color1.x = value
	shader.set_shader_parameter("color1", color1)

func _on_color1_g_value_changed(value: float) -> void:
	color1.y = value
	shader.set_shader_parameter("color1", color1)

func _on_color1_b_value_changed(value: float) -> void:
	color1.z = value
	shader.set_shader_parameter("color1", color1)


func _on_color2_r_value_changed(value: float) -> void:
	color2.x = value
	shader.set_shader_parameter("color2", color2)

func _on_color2_g_value_changed(value: float) -> void:
	color2.y = value
	shader.set_shader_parameter("color2", color2)

func _on_color2_b_value_changed(value: float) -> void:
	color2.z = value
	shader.set_shader_parameter("color2", color2)


func _on_accent_r_value_changed(value: float) -> void:
	accent.x = value
	shader.set_shader_parameter("accent", accent)

func _on_accent_g_value_changed(value: float) -> void:
	accent.y = value
	shader.set_shader_parameter("accent", accent)

func _on_accent_b_value_changed(value: float) -> void:
	accent.z = value
	shader.set_shader_parameter("accent", accent)
	

func _on_intensity_value_changed(value: float) -> void:
	shader.set_shader_parameter("accent_intensity", value)
	

# Julia set only 
func _on_c_x_value_changed(value: float) -> void:
	c.x = value
	shader.set_shader_parameter("c", c)

func _on_c_y_value_changed(value: float) -> void:
	c.y = value
	shader.set_shader_parameter("c", c)
