extends MeshInstance3D

class_name SeaLevel

var height: int = 0
var base_size: float

var targetHeight: float = 0
var startingHeight: float = 0
@export var sea_level_change_speed: float

var t: float = 0

func rise():
    height = height + 1
    
    set_sea_level()

func sink():
    height = height - 1
    
    set_sea_level()

func set_sea_level():
    targetHeight = 1 + height * 0.04
    startingHeight = scale.x
    #scale = Vector3(value, value, value)
    
    t = 0
    
func _process(delta):
    if t < sea_level_change_speed:
        t = clampf(t + delta, 0, sea_level_change_speed)
    
        var lerp = lerpf(startingHeight, targetHeight, t / sea_level_change_speed)
        scale = Vector3(lerp, lerp, lerp)
    
    
    
    
