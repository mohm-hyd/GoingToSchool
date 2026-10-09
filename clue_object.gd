extends Area2D

@onready var highlight: Sprite2D = $Highlight

@export var puzzle_id: String = "safe_sequence"
@export var puzzle_title: String = "The Forgotten Code"
@export_multiline var puzzle_description: String = "Enter the symbols in the order revealed by the clues."

@export var available_symbols: Array[String] = ["☾", "★", "◉", "⚿"]
@export var correct_sequence: Array[String] = ["☾", "◉", "★", "⚿"]

var discovered := false
var ghost_vision_active := false

func _ready() -> void:
	add_to_group("clue_objects")
	highlight.visible = false

func set_ghost_vision_active(active: bool) -> void:
	ghost_vision_active = active
	highlight.visible = active

	if active and not discovered:
		discovered = true
		play_discovery_pulse()

func play_discovery_pulse() -> void:
	highlight.scale = Vector2.ONE * 0.5
	highlight.modulate.a = 1.0

	var tween := create_tween()
	tween.tween_property(
		highlight,
		"scale",
		Vector2.ONE * 1.4,
		0.25
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		highlight,
		"scale",
		Vector2.ONE,
		0.15
	)
func can_interact() -> bool:
	return discovered

func interact() -> void:
	if not can_interact():
		return

	var puzzle_ui = get_tree().get_first_node_in_group("puzzle_ui")

	if puzzle_ui:
		puzzle_ui.open_puzzle(
			puzzle_id,
			puzzle_title,
			puzzle_description,
			available_symbols,
			correct_sequence
		)
