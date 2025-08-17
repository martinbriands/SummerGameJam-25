extends Node3D

@export var Bullet : PackedScene

var longlats = []

    
func random_on_sphere(num_points: int, radius: float) -> Array:
    var points = []
    var golden_ratio = (1 + sqrt(5)) / 2
    var angle_increment = PI * 2 * golden_ratio

    for i in range(num_points):
        var t = float(i) / num_points
        var phi = acos(1 - 2 * t)  # Latitude angle
        var theta = angle_increment * i  # Longitude angle

        var x = radius * sin(phi) * cos(theta)
        var y = radius * sin(phi) * sin(theta)
        var z = radius * cos(phi)

        points.append(Vector3(x, y, z))
        
        longlats.append(Vector2(phi, theta))
        
    return points
    

var num_rows = 30
var num_cols = 10

var R = 1

func random_mercator_sphere(radius: float) -> Array:
    var points = []
    
    for row in num_rows:
        var longitude = float(row) / num_rows * 2*PI
        for col in num_cols:
            var value = (float(col) / num_cols)
            var lattitude = atan(exp(value * PI)) * 2 - PI/2
            
            #print(lattitude)
            
            var x = radius * cos(lattitude) * cos(longitude)
            var y = radius * cos(lattitude) * sin(longitude)
            var z = radius * sin(lattitude)
        
            points.append(Vector3(x,y,z))
            
        for col in num_cols:
            var lattitude = -atan(exp((float(col) / num_cols) *PI)) * 2 + PI/2
            
            #print(lattitude)
            
            var x = radius * cos(lattitude) * cos(longitude)
            var y = radius * cos(lattitude) * sin(longitude)
            var z = radius * sin(lattitude)
        
          #  points.append(Vector3(x,y,z))
    
    return points
            
