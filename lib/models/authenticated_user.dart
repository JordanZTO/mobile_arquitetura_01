class AuthenticatedUser {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? gender;
  final String? image;
  final String accessToken;
  final String? refreshToken;

  const AuthenticatedUser({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.gender,
    this.image,
    required this.accessToken,
    this.refreshToken,
  });

  String get fullName {
    final name = "$firstName $lastName".trim();
    return name.isEmpty ? username : name;
  }

  factory AuthenticatedUser.fromJson(Map<String, dynamic> json) {
    return AuthenticatedUser(
      id: (json["id"] as num).toInt(),
      username: json["username"] ?? "",
      email: json["email"] ?? "",
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      gender: json["gender"],
      image: json["image"],
      accessToken: json["accessToken"] ?? json["token"] ?? "",
      refreshToken: json["refreshToken"],
    );
  }

  AuthenticatedUser copyWith({String? accessToken, String? refreshToken}) {
    return AuthenticatedUser(
      id: id,
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      image: image,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "gender": gender,
      "image": image,
      "accessToken": accessToken,
      "refreshToken": refreshToken,
    };
  }
}
