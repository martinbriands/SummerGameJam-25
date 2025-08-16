extends Human

class_name Racist

var timer = 0

var progress_timer = 0
@export var progress_delay = 10

func _process(delta: float) -> void:
    if progress_timer < progress_delay:
        progress_timer += delta
        
        if progress_timer >= progress_delay:
            GameRules.instance.on_mayhem(GameRules.human_type.RACIST)
            progress_timer = 0
    
    timer += delta
    
    if timer >= GameRules.instance.racist_lifetime:
        IcoSphere.instance.kill_human(self)

func _ready() -> void:
    (self as Node3D).rotate_z(randf_range(0, 360))
