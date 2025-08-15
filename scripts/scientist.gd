extends Human

class_name Scientist

var timer = 0
var models: Array
var index = 0

@export var time_to_evolve: float = 10

func _ready() -> void:
    models.append($House)
    models.append($Building)
    models.append($Skyscraper)

func _process(delta: float) -> void:
    if index >= models.size() -1:
        return
    
    timer += delta
    
    if timer >= 10:
        evolve()
        

func evolve():
    timer = 0
    (models[index] as Node3D).visible = false
    
    index += 1
    (models[index] as Node3D).visible = true
