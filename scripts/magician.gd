extends Human

class_name Magician

func _process(delta: float) -> void:
    pass

func _ready() -> void:
    (self as Node3D).rotate_z(randf_range(0, 360))
