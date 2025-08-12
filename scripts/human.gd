extends Node3D

class_name Human

func _on_static_body_3d_area_entered(area: Area3D) -> void:
    hit_by_water()
    
func hit_by_water():
    IcoSphere.instance.kill_human(self)

func _process(delta: float) -> void:
    var r = randf_range(0, 1)
    
    if r < GameRules.instance.human_evolution_chance:
        IcoSphere.instance.evolve_human(self)
