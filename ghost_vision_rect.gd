extends ColorRect


@export var transition_duration: float = 0.5

@export var world: CanvasGroup

var grayscale_active: bool = false
var current_tween: Tween

func _ready() -> void:
	world.material.set_shader_parameter(
		"fade_amount",
		0.0
	)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_grayscale"):
		toggle_grayscale()
	for clue in get_tree().get_nodes_in_group("clue_objects"):
		clue.set_ghost_vision_active(grayscale_active)

func toggle_grayscale() -> void:
	grayscale_active = !grayscale_active

	var target_fade: float = (
		1.0 if grayscale_active else 0.0
	)

	if current_tween and current_tween.is_valid():
		current_tween.kill()

	current_tween = create_tween()

	current_tween.tween_property(
		world.material,
		"shader_parameter/fade_amount",
		target_fade,
		transition_duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
