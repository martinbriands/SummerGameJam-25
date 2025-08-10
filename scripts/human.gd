extends Node3D

func _on_static_body_3d_area_entered(area: Area3D) -> void:
    hit_by_water()
    
func hit_by_water():
    print("human died")
    queue_free()
