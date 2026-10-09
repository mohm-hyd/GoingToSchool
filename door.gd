extends StaticBody2D

@export var locked_message: String = \
	"You can't leave yet. You haven't unlocked the safe."

@onready var door_prompt: Label = \
	get_node("../UI/DoorInteractionPrompt")

@onready var message_timer: Timer = \
	get_node("../UI/DoorMessageTimer")


func can_interact() -> bool:
	return true


func interact() -> void:
	door_prompt.text = locked_message
	door_prompt.show()
	message_timer.start()

func _ready() -> void:
	message_timer.timeout.connect(_on_message_timer_timeout)


func _on_message_timer_timeout() -> void:
	door_prompt.hide()
