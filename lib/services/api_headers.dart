class ApiHeaders {
  const ApiHeaders._();

  static Map<String, String> json() {
    return {"Content-Type": "application/json", "Accept": "application/json"};
  }

  static Map<String, String> withToken(String token) {
    return {...json(), "Authorization": "Bearer $token"};
  }
}
