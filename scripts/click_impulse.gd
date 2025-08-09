extends MeshInstance3D

var moon

func _ready():
    moon = $Moon
    
    var pos = moon.position
    
    var lat = rad_to_deg(atan2(pos.z,sqrt(pos.x*pos.x+pos.y*pos.y)))
    var lng = rad_to_deg(atan2(pos.y, pos.x))
    
    var x = clampf(1 * (180 + lng) / 360, -100, 100)
    var y = clampf(1 * (90 - lat) / 180, -100, 100)
    
    print(x, " ",y)
    
