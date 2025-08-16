extends Node3D

class_name Asteroid

var direction: Vector3
var moving: bool
@export var speed: float

func set_destination(pos: Vector3):
    position = pos + pos.normalized() * 15
    direction = -pos.normalized()
    
    look_at(pos)
    
    ($Explosion/Debris.process_material as ParticleProcessMaterial).gravity = direction.normalized() * -9.8 / 2
    ($Explosion/Smoke.process_material as ParticleProcessMaterial).gravity = direction.normalized() * -5 / 10
    ($Explosion/Fire.process_material as ParticleProcessMaterial).gravity = direction.normalized() * -5 / 10
        
    moving = true

func _process(delta: float) -> void:
    if moving:
        position += direction * delta * speed
    
    $MeshInstance3D.rotate_x(-delta * 5)

func _on_area_3d_area_entered(area: Area3D) -> void:
    if area.name == "ShockwaveCollisionSphere":
        hit_by_water()
    if area.name == "HexagonCollisionSphere":
        hit_by_land()

func hit_by_water():
    pass
    
func hit_by_land():
    moving = false
    
    print(($Explosion/Smoke.process_material as ParticleProcessMaterial).gravity)
    
    $Explosion/Debris.emitting = true
    $Explosion/Fire.emitting = true
    $Explosion/Smoke.emitting = true
    
    $MeshInstance3D.visible = false
    $AsteroidCollisionSphere.position = Vector3.ZERO
    
    $SmokeTrail.emitting = false
    
    await get_tree().create_timer(2).timeout
    queue_free()
