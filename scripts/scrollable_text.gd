extends RichTextLabel

@export var speed: float
@export var delay: float

var origin

func _ready() -> void:
    origin = position
    self_destruct()
    
    
func self_destruct():
    await get_tree().create_timer(delay).timeout
    
    position = origin

func _process(delta: float) -> void:
    position.x += delta * speed
