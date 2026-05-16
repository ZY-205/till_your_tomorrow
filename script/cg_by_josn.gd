extends Node

var file
var content
var data

func prepareload(filename:String):
	file = FileAccess.open(filename, FileAccess.READ)
	content = file.get_as_text()
	data = JSON.parse_string(content)
	
func start_cg(stage:int) -> void:
	var roles = {}
	for characters in data.characters:
		var temp = data.scene+characters
		roles[characters] = get_node(temp)
		
	for datas in data.content:
		if datas.stage == stage:
			for datass in datas.action:
				if datass.action == "do":
					roles[datass.who].call_deferred("callv", datass.what, datass.parameter)
				elif datass.action == "set":
					for i in range(datass.what.size()):
						roles[datass.who].set(datass.what[i], datass.parameter[i])
				elif datass.action == "wait":
					await get_tree().create_timer(datass.timekeep).timeout
			
