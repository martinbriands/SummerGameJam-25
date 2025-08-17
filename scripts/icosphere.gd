extends MeshInstance3D

class_name IcoSphere

static var instance: IcoSphere

@export var plate : PackedScene
@export var heat_map: Sprite2D
@export var sea_level: SeaLevel

var hexagons: Array[Hexagon]

var bounds_x: Vector2 = Vector2(-0.5, 0.5)
var bounds_y: Vector2 = Vector2(-0.5, 0.5)
var bounds_z: Vector2 = Vector2(-0.5, 0.5)

var image_data: Image

func _ready():    
    instance = self
        
    image_data = heat_map.texture.get_image()
    
    var faces = mesh.get_faces()
    var faces_no_duplicates = []

    for face in faces:
        if not faces_no_duplicates.has(face):
            faces_no_duplicates.append(face)
    
    for face in faces_no_duplicates:
        var hexagon = plate.instantiate() as Node3D
        add_child(hexagon)

        hexagon.set_hexagon(self, face)
        hexagon.apply_bounds(bounds_x, bounds_y, bounds_z, image_data)
        
        hexagons.append(hexagon)
    
    $Spawner.init()

func get_face_height(pos: Vector3) -> float:
    var lat = rad_to_deg(atan2(pos.z,sqrt(pos.x*pos.x+pos.y*pos.y)))
    var lng =  rad_to_deg(atan2(pos.y, pos.x))
    
    var x = clampf(image_data.get_height() * (180 + lng) / 360, 0, 255)
    var y = clampf(image_data.get_width() * (90 - lat) / 180, 0, 255)
        
    var color = image_data.get_pixel(x, y)
    
    return float(color.r) / 10
    
func _process(delta):
    pass

func kill_human(human: Human):  
    $Spawner.kill(human, true)
    
            
