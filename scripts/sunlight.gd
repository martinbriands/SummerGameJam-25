extends Node3D

@export var rotation_speed: float
@export var axis: Vector3 = Vector3.UP

func _process(delta):
    rotate_object_local(axis, delta * rotation_speed)
