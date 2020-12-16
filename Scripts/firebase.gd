extends Node

const API_KEY = "AIzaSyBnqRXwpRyU9uNWCzHFjmPqiXWqFa6aZGc"
const PROJECT_ID = "englicosados"

const REGISTER_URL = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=%s" % API_KEY
const LOGIN_URL = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=%s" % API_KEY
const FIRESTORE_URL = "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/" %PROJECT_ID

var user_info := {}

func _getUserInfo(result: Array) -> Dictionary:
	var resultBody := JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
	return {
		"token": resultBody.idToken,
		"id": resultBody.localId
	}
	
func getRequestHeaders() -> PoolStringArray:
	return PoolStringArray([
		"Content-Type: application/json",
		"Authorization: Bearer %s" % user_info.token
	])
	
func register(email: String, password: String, http: HTTPRequest) -> void:
	var body := {
		"email": email,
		"password": password,
	}
# warning-ignore:return_value_discarded
	http.request(REGISTER_URL, [], false, HTTPClient.METHOD_POST, to_json(body))
	var result := yield(http, "request_completed") as Array
	if result[1] == 200:
		user_info = _getUserInfo(result)

func login(email: String, password: String, http: HTTPRequest) -> void:
	var body := {
		"email": email,
		"password": password,
		"returnSecureToken": true
	}
# warning-ignore:return_value_discarded
	http.request(LOGIN_URL, [], false, HTTPClient.METHOD_POST, to_json(body))
	var result := yield(http, "request_completed") as Array
	if result[1] == 200:
		user_info = _getUserInfo(result)
		
func saveDocument(path: String, fields: Dictionary, http: HTTPRequest) -> void:
	var document := {"fields": fields}
	var body := to_json(document)
	var url := FIRESTORE_URL + path
# warning-ignore:return_value_discarded
	http.request(url, getRequestHeaders(), false, HTTPClient.METHOD_POST, body)
	print(user_info.token)
	
func getDocument(path: String, http: HTTPRequest) -> void:
	user_info.token = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjY5NmFhNzRjODFiZTYwYjI5NDg1NWE5YTVlZTliODY5OGUyYWJlYzEiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vZW5nbGljb3NhZG9zIiwiYXVkIjoiZW5nbGljb3NhZG9zIiwiYXV0aF90aW1lIjoxNjA4MDAzMTczLCJ1c2VyX2lkIjoidUYxMVk1TlhUSGUwZUgzM3g1M2V3ZER2THZKMyIsInN1YiI6InVGMTFZNU5YVEhlMGVIMzN4NTNld2REdkx2SjMiLCJpYXQiOjE2MDgwMDMxNzMsImV4cCI6MTYwODAwNjc3MywiZW1haWwiOiJmcmRhdmliYW5kZWlyYUBob3RtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJlbWFpbCI6WyJmcmRhdmliYW5kZWlyYUBob3RtYWlsLmNvbSJdfSwic2lnbl9pbl9wcm92aWRlciI6InBhc3N3b3JkIn19.Vp7i_k9p5V9Yhd7fncEmMFbiNskTClIrsyxq9ZTl95S5-NaUXmaN12-MTCvKWpbyZcHFIOE61dzB870_HaB2oWlbaWYYwUwYMi6DmWG0SfGy5QFWlGJbu9RK29B73APzuBx59E1PtNb0eM0CJW_s793RqaoxKe8Z5MV9OCPIej9rxp0GD9TqZjhFlySjRN3WamY-A91TpLZcQ2cH8O4veYsR0WzJUout1Xknsgj6tw2pJCMKDtrML2INgSFQSVRf3428YgqCSENGHIVMscjXQqu1EN4L06D3Hdpmn7eF2Tc5U2-JUBWOqbJ4Z1XKM4diFiHwp9XHfw_nvHT9Enf3ag"
	var url := FIRESTORE_URL + path
	print(url)
	print(http)
# warning-ignore:return_value_discarded
	http.request(url, getRequestHeaders(), false, HTTPClient.METHOD_GET)
	
func updateDocument(path: String, fields: Dictionary, http: HTTPRequest) -> void:
	var document := { "fields": fields}
	var body := to_json(document)
	var url := FIRESTORE_URL + path
# warning-ignore:return_value_discarded
	http.request(url, getRequestHeaders(), false, HTTPClient.METHOD_PATCH, body)
	print(user_info.token)
	
func deleteDocument(path: String, http: HTTPRequest) -> void:
	var url := FIRESTORE_URL + path
# warning-ignore:return_value_discarded
	http.request(url, getRequestHeaders(), false, HTTPClient.METHOD_DELETE)
