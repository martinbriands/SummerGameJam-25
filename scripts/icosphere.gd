extends MeshInstance3D

@export var Plate : PackedScene

func _ready():
    print("ready")
    
    for face in mesh.get_faces():
        var b = Plate.instantiate() as Node3D
        add_child(b)
        b.position = face
        b.look_at(position)
        b.position += randi_range(0, 6) * (b.position - position).normalized() / 200
        
        #print(b.position.y)
        
        if (b.position.y > 0.4) or (b.position.y < -0.4):
            print("we should change color")
            var s = b as Hexagon
            s.set_color(Color(1,1,1,1))

        
