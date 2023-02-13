extends Node2D

export(Dictionary) var skills = {
	"Charisma": 0,
	"Intellect": 0,
	"Endurance": 0,
	"Dexterity": 0
}

export(Dictionary) var variables = {
	"happy": false,
	"sad": false,
	"angry": false
}

export(Dictionary) var visited = {
	"Node 0": 0,
	"Node 1": 0,
	"Node 2": 0,
	"Node 3": 0,
}

export(Dictionary) var brownies = {
	"Letty": 0,
	"Raymond": 0
}

export(Dictionary) var character
