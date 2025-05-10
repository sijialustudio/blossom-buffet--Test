# This script is attached to the food spawner node. It handles the random spawning of good and bad food objects.
# - The _ready() function sets the spawn timer and connects its timeout signal to the spawn_food() function.
# - The spawn_food() function randomly selects and spawns either a good food or a bad food at a random position.
extends Node2D

@export var good_food_scenes: Array[PackedScene] # Add multiple good foods
@export var bad_food_scene: PackedScene # Bad food comes from right
@export var spawn_rate: float = 1.5 # Adjust spawn timing
@export var player: Node2D
@export var blossom: Node2D
@export var blossom_radius: float = 50
var spawn_points: Array[Marker2D] = []
@export var fruit_spawn_distance: float = 180
func _ready():
	# for child in get_children():
	# 	if child.is_in_group("spawn_points"):
	# 		spawn_points.append(child.position)
	# print("you have ", spawn_points.size(), " spawn points")
	$SpawnTimer.wait_time = spawn_rate
	$SpawnTimer.timeout.connect(spawn_food)

func spawn_food():
	var food_type = randi() % 2 # 0 = good food, 1 = bad food
	var food = null

	#print("Food type chosen:", food_type)

	# Spawn Good Food
	if food_type == 0 and good_food_scenes.size() > 0:
		var selected_scene = good_food_scenes.pick_random()
		#print("Good food selected:", selected_scene)  # Debug #print
		if selected_scene:
			food = selected_scene.instantiate()
			food.position = Vector2(randi_range(50, 750), 10) # Spawn from sky

	# Spawn Bad Food
	elif food_type == 1 and bad_food_scene != null:
		#print("Bad food spawned")  # Debug #print
		food = bad_food_scene.instantiate()
		food.position = Vector2(850, randi_range(100, 500)) # From the right
		food.speed = 0

	# Make sure food is actually added to the scene
	if food != null:
		#print("Adding food to scene:", food)
		get_parent().add_child(food)
	else:
		pass
		#print("Food is null, not added")


func _on_initial_timer_timeout() -> void:
	initial_spawn()


func initial_spawn():
	# Spawn 3 random food items around each marker
	for spawn_point in spawn_points:
		for i in range(2):
			var food_type = randi() % 2 # 0 = good food, 1 = bad food
			var food = null
			
			# Spawn Good Food
			if food_type == 0 and good_food_scenes.size() > 0:
				var selected_scene = good_food_scenes.pick_random()
				if selected_scene:
					food = selected_scene.instantiate()
					# Random offset from spawn point, 140 pixels in any direction
					var random_angle = randf() * 2 * PI
					var offset = Vector2(cos(random_angle), sin(random_angle)) * fruit_spawn_distance
					food.position = spawn_point.position + offset
					food.speed = 0

			elif food_type == 1 and bad_food_scene != null:
				food = bad_food_scene.instantiate()
				var random_angle = randf() * 2 * PI
				var offset = Vector2(cos(random_angle), sin(random_angle)) * fruit_spawn_distance
				food.position = spawn_point.position + offset
				food.speed = 0

			# Add food to scene
			if food != null:
				spawn_point.add_child(food)
