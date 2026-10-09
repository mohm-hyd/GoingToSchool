
extends CanvasLayer

signal puzzle_solved(puzzle_id: String)
signal puzzle_closed

@onready var title_label: Label = $DimBackground/CenterContainer/PuzzlePanel/Content/Title
@onready var description_label: Label = $DimBackground/CenterContainer/PuzzlePanel/Content/Description
@onready var sequence_display: HBoxContainer = $DimBackground/CenterContainer/PuzzlePanel/Content/SequenceDisplay
@onready var symbol_buttons: GridContainer = $DimBackground/CenterContainer/PuzzlePanel/Content/SymbolButtons
@onready var feedback_label: Label = $DimBackground/CenterContainer/PuzzlePanel/Content/Feedback
@onready var reset_button: Button = $DimBackground/CenterContainer/PuzzlePanel/Content/Buttons/ResetButton
@onready var close_button: Button = $DimBackground/CenterContainer/PuzzlePanel/Content/Buttons/CloseButton
@onready var feedback_timer: Timer = $FeedbackTimer

var current_puzzle_id: String = ""
var symbols: Array[String] = []
var correct_sequence: Array[String] = []
var player_sequence: Array[String] = []
var solved: bool = false


func _ready() -> void:
	hide()
	add_to_group("puzzle_ui")

	reset_button.pressed.connect(reset_sequence)
	close_button.pressed.connect(close_puzzle)
	feedback_timer.timeout.connect(_on_feedback_timer_timeout)

func _on_feedback_timer_timeout() -> void:
	feedback_label.text = ""


func open_puzzle(
	puzzle_id: String,
	puzzle_title: String,
	puzzle_description: String,
	available_symbols: Array[String],
	sequence: Array[String]
) -> void:
	current_puzzle_id = puzzle_id
	symbols = available_symbols.duplicate()
	correct_sequence = sequence.duplicate()
	player_sequence.clear()
	solved = false

	title_label.text = puzzle_title
	description_label.text = puzzle_description
	feedback_label.text = ""
	reset_button.disabled = false

	build_symbol_buttons()
	update_sequence_display()
	show()


func build_symbol_buttons() -> void:
	for child in symbol_buttons.get_children():
		symbol_buttons.remove_child(child)
		child.queue_free()

	for symbol in symbols:
		var button := Button.new()
		button.text = symbol
		button.custom_minimum_size = Vector2(400, 200)
		button.pressed.connect(_on_symbol_pressed.bind(symbol))
		symbol_buttons.add_child(button)


func _on_symbol_pressed(symbol: String) -> void:
	if solved:
		return

	var index := player_sequence.size()

	if index >= correct_sequence.size():
		return

	if symbol != correct_sequence[index]:
		feedback_label.text = "Incorrect sequence. Try again."
		feedback_timer.start()
		player_sequence.clear()
		update_sequence_display()
		return

	player_sequence.append(symbol)
	update_sequence_display()

	if player_sequence.size() == correct_sequence.size():
		solved = true
		feedback_label.text = "Correct! The sequence is solved."
		reset_button.disabled = true
		puzzle_solved.emit(current_puzzle_id)



func update_sequence_display() -> void:
	for child in sequence_display.get_children():
		sequence_display.remove_child(child)
		child.queue_free()

	for i in range(correct_sequence.size()):
		var slot := Label.new()
		slot.custom_minimum_size = Vector2(100, 100)
		slot.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		slot.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

		if i < player_sequence.size():
			slot.text = player_sequence[i]
		else:
			slot.text = "?"

		sequence_display.add_child(slot)


func reset_sequence() -> void:
	if solved:
		return

	player_sequence.clear()
	feedback_label.text = ""
	update_sequence_display()


func close_puzzle() -> void:
	hide()
	puzzle_closed.emit()
