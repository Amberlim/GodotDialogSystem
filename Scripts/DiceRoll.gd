extends GraphNode


var node_type = "NodeDiceRoll"
var id = UUID.v4()


func _ready():
	title = node_type + " (" + id + ")"
