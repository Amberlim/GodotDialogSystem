extends Node2D

@export var skills: Dictionary = {
	"Charisma": 0,
	"Intellect": 0,
	"Endurance": 0,
	"Dexterity": 0
}

@export var variables: Dictionary = {
	"happy": false,
	"sad": false,
	"angry": false
}

@export var visited: Dictionary = {
	"Node 0": 0,
	"Node 1": 0,
	"Node 2": 0,
	"Node 3": 0,
}

@export var brownies: Dictionary = {
	"Letty": 0,
	"Raymond": 0
}

@export var character: Dictionary
