extends Human

class_name Racist

var timer = 0

func _process(delta: float) -> void:
    timer += delta
    
    if timer >= GameRules.instance.racist_lifetime:
        IcoSphere.instance.kill_human(self)

func _ready() -> void:
    (self as Node3D).rotate_z(randf_range(0, 360))
