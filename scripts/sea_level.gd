extends MeshInstance3D

class_name SeaLevel

var height: int = 0
var base_size: float
var base_scale: Vector3

var targetHeight: float = 0
var startingHeight: float = 0
@export var sea_level_change_speed: float

var t: float = 999

var sub_height: int
@export var sub_height_max: int

func _ready():
    base_size = scale.x
    #base_scale = mesh.surface_get_material().

func rise():
    height = height + 1
    
    set_sea_level()

func sink():
    height = height - 1
    
    set_sea_level()
    
func destory_ice():
    sub_height = sub_height + 1
    
    if sub_height >= sub_height_max:
        sub_height = 0
        rise()    

func set_sea_level():
    targetHeight = 1 + height * 0.04
    startingHeight = scale.x
    
    t = 0
    
func _process(delta):
    if t < sea_level_change_speed:
        t = clampf(t + delta, 0, sea_level_change_speed)
    
        var lerp = lerpf(startingHeight, targetHeight, t / sea_level_change_speed)
        scale = Vector3(lerp, lerp, lerp)
        
        if t == sea_level_change_speed:
            sea_level_rise.emit(height)
    
signal sea_level_rise(height: int)
    
    
    
    
