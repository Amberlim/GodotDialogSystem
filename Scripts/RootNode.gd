extends GraphNode


var id = UUID.v4()
var node_type = "Root"


func _ready():
	title = node_type + "Node (" + id + ")"

