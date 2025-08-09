extends MeshInstance3D

@export var Plate : PackedScene

var hexagons: Array[Hexagon]

var bounds_x: Vector2 = Vector2(-0.5, 0.5)
var bounds_y: Vector2 = Vector2(-0.5, 0.5)

func _ready():    
    
    var max = 0
    var min = 0
    
    for face in mesh.get_faces():
        var hexagon = Plate.instantiate() as Node3D
        add_child(hexagon)
        #b.position = face
        #b.look_at(position)
        #b.position += randi_range(0, 6) * (b.position - position).normalized() / 50
        
        #print(b.position.y)
                
        hexagon.set_hexagon(self, face)
        hexagon.apply_bounds(bounds_x, bounds_y)
        
        hexagons.append(hexagon)
        
        max = max(face.y, max)
        min = min(face.y, min)
        
        #if (b.position.y > 0.5) or (b.position.y < -0.5):
            #print("we should change color")
            #var s = b as Hexagon
            #s.set_color(Color(1,1,1,1))
    
    print(max)
    print(min)

        
