extends Label

@onready var http_request: HTTPRequest = $HTTPRequest

var ability_name: String = "Default"
var fancy_name: String = "Fancy"

func _ready() -> void:
	var repo_owner = "Destruction-Studios"
	var repo = "AW-Library-API"
	var folder = "API"
	#var url = "https://api.github.com/repos/%s/%s/contents/%s" % [repo_owner, repo, folder]
	#
	#var headers = ["User-Agent: GodotScript"]
	
	#var error = http_request.request(url, headers)
	#if error != OK:
		#print("HTTP Request error: ", error)
	print(await GithubApi.get_folder_contents(repo_owner, repo, folder))


func _on_http_request_request_completed(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	if json is Array:
		for item in json:
			var file_name = item.get("name", "")
			var download_url = item.get("download_url", "")
			print("Found file: ", file_name)
			print("Download URL: ", download_url)
	else:
		print("Unexpected JSON format")
