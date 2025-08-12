extends Human

class_name Racist

var timer = 0

func _process(delta: float) -> void:
    timer += delta
    
    if timer >= GameRules.instance.racist_lifetime:
        IcoSphere.instance.kill_human(self)
