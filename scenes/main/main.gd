extends Control

func _ready() -> void:
	var files = await GithubApi.get_folder_contents("Destruction-Studios", "AW-Library-API", "API")
	
	for file_name in files:
		var link = files[file_name]
		#print("Downloading {0} from {1}".format([file_name, link]))
		
		var result: PackedByteArray = await GithubApi.download_file(link)
		print(result.get_string_from_utf8())
