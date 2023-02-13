extends Node
var dict = {
	"one": 1,
	"two": 2
}

func _ready():
	var node_name = "Node 200"
	node_name = int(node_name.lstrip("Node ")) 
