extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var character_animation_player: AnimationPlayer = $characteranimation
@export var bubu: Bubu
# Called when the node enters the scene tree for the first time.
enum State {Sleep, Upset, Hurt}
var state: State = State.Sleep

func _ready() -> void:
	animation_player.play("breath")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if state == State.Sleep:
		character_animation_player.play("idle")
	elif state == State.Upset:
		character_animation_player.play("upset")
	elif state == State.Hurt:
		character_animation_player.play("hurt")


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		if state == State.Hurt:
			return
		state = State.Upset
	elif area.is_in_group("good_food"):
		bubu.increase_score(1)
		state = State.Sleep
	elif area.is_in_group("bad_food"):
		state = State.Hurt
		bubu.take_damage(20)
		area.die()


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		if state == State.Hurt:
			return
		state = State.Sleep
