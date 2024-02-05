class AuthUserModel {
  final String userId;
  final String email;
  final String name;

  AuthUserModel({
    required this.userId,
    required this.email,
    required this.name,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      userId: json['userId'],
      email: json['email'],
      name: json['name'],
    );
  }
}
