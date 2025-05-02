extends Node

const HEADERS = ["User-Agent: GodotScript"]

signal download_complete(id: int)

func download_file(url: String):
	print("Downloading File {0}".format([url]))
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	http_request.request(url)
	
	var result = await http_request.request_completed
	
	http_request.queue_free()
	
	if result[0] != 0:
		print("Error")
		return
	
	return result[3]


func on_complete(result, response_code, headers, body: PackedStringArray) -> void:
		download_complete.emit()


func get_folder_contents(repo_owner: String, repo: String, folder: String) -> Dictionary:
	var url = "https://api.github.com/repos/%s/%s/contents/%s" % [repo_owner, repo, folder]
	
	print("Downloading Folder Contents from {0}".format([url]))
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	http_request.request(url, HEADERS)
	
	var result = await http_request.request_completed
	
	print("Result: {0}".format([result[1]]))
	
	if result[1] != 200:
		return {}
	
	var body: Array = JSON.parse_string(result[3].get_string_from_utf8())
	
	http_request.queue_free()
	
	if not body is Array:
		print("Error getting folder contents from {0}".format([url]))
		return {}
	
	var parsed = {}
	
	for item in body:
		var file_name = item.get("name", "")
		var download_url = item.get("download_url")
		parsed[file_name] = download_url
	
	print("Got file contents from {0}".format([url]), parsed)

	return parsed
