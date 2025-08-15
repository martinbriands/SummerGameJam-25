extends Node3D

class_name Human

func _on_static_body_3d_area_entered(area: Area3D) -> void:
    if area.name == "ShockwaveCollisionSphere":
        hit_by_water()
    if area.name == "HexagonCollisionSphere":
        hit_by_land(area)
    if area.name == "AsteroidCollisionSphere":
        hit_by_asteroid()
    
func hit_by_water():
    IcoSphere.instance.kill_human(self)

func hit_by_land(area: Area3D):
    pass

func hit_by_asteroid():
    IcoSphere.instance.kill_human(self)

func _process(delta: float) -> void:
    pass
    #var r = randf_range(0, 1)
    #
    #if r < GameRules.instance.human_evolution_chance:
        #IcoSphere.instance.evolve_human(self)

func _on_static_body_3d_body_entered(body: Node3D) -> void:
    print(body.name)
    
