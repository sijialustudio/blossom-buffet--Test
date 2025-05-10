# This script is attached to Dudu, a helper character. It handles Dudu's appearance, cutting action, and interaction with bad food.
# - The _process(delta) function checks for the cut action and triggers Dudu's cutting animation and logic.
# - The appear_next_to_bubu() function positions Dudu next to Bubu.
# - The cut_animation() function plays the cut animation.
# - The _on_area_2d_body_entered(body) and _on_area_2d_area_entered(area) functions handle collision with bad food, triggering its destruction.
# - The _on_timer_timeout() function re-enables cutting and increments the cut count.

extends Node2D
class_name Dudu


@export var cut_duration = 0.5 # How long Dudu appears
@onready var dudu_animation: AnimationPlayer = $DuduAnimation
@onready var dudu_position: Marker2D = $"../Bubu/DuduPosition"
@onready var dudu_original_position: Marker2D = $"../dudu_original_position"

var cutting = false
var disable_cutting = false
@export var cut_count = 4
@onready var cut_bar: ProgressBar = $"../CanvasLayer/CutBar"
@onready var dudu_timer: Timer = $DuduTimer

@onready var dudu_one: TextureRect = $"../CanvasLayer/Control/DuduOne"
@onready var dudu_two: TextureRect = $"../CanvasLayer/Control/DuduTwo"
@onready var dudu_three: TextureRect = $"../CanvasLayer/Control/DuduThree"
@onready var dudu_four: TextureRect = $"../CanvasLayer/Control/DuduFour"

@onready var hit_sound: AudioStreamPlayer2D = $"../AudioStreamPlayer2D2"


func _ready():
	visible = false


func _process(_delta):
	if (Input.is_action_just_released("cut")):
		if (disable_cutting):
			#print("cant cut")
			visible = false
			return
		else:
			#print("this ran")
			cutting = true
			appear_next_to_bubu()
			
			cut_animation()
			cut_count -= 1
			var _temp_count = cut_count
			#cut_count = min(0, temp_count)
			cut_bar.value = cut_count
			update_dudu_visibility()
			dudu_timer.start()
			if (cut_count <= 0):
				disable_cutting = true

func appear_next_to_bubu():
	visible = true
	global_position = dudu_position.global_position

func cut_animation():
	dudu_animation.play("cut")


func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("dudu found ", body.name)
	if (body.is_in_group("bad_food")):
		pass
		#print("bad food found")
func _on_area_2d_area_entered(area: Area2D) -> void:
	#print("dudu found an area ", area.name)
	if (area.is_in_group("bad_food")):
		#print("bad food found")
		hit_sound.play()
		area.die()
		global_position = dudu_original_position.global_position
		visible = false


func _on_timer_timeout() -> void:
	disable_cutting = false
	var temp_count = cut_count + 1
	cut_count = min(temp_count, 4)
	cut_bar.value = cut_count
	update_dudu_visibility()
	#print("adding count")


func _on_dudu_timer_timeout() -> void:
	global_position = dudu_original_position.global_position
	visible = false
func update_dudu_visibility():
	dudu_one.visible = cut_count >= 1
	dudu_two.visible = cut_count >= 2
	dudu_three.visible = cut_count >= 3
	dudu_four.visible = cut_count >= 4
