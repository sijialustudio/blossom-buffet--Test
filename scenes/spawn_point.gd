extends Marker2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().spawn_points.append(self)
	print("you have ", get_parent().spawn_points.size(), " spawn points")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
