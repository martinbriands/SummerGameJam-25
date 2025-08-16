extends Human

class_name Magician

var progress_timer = 0
@export var progress_delay = 10

func _process(delta: float) -> void:
    if progress_timer < progress_delay:
        progress_timer += delta
        
        if progress_timer >= progress_delay:
            GameRules.instance.on_progress(GameRules.human_type.MAGICIAN)
            progress_timer = 0

func _ready() -> void:
    (self as Node3D).rotate_z(randf_range(0, 360))
