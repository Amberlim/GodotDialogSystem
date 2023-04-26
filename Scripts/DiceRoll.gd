extends GraphNode


var node_type = "DiceRoll"
var id = UUID.v4()


func _ready():
	title = node_type + "Node (" + id + ")"
