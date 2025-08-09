extends DirectionalLight3D

@export var rotation_speed: float

func _process(delta):
    rotate_object_local(Vector3.UP, delta * rotation_speed)
