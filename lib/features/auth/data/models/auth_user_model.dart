class AuthUserModel extends AuthUserEntity {
  AuthUserModel({required super.id, required super.email});

  // fromJson method....
  factory AuthUserModel.fromJson(Map<String, dynamic> map) {
    return AuthUserModel(id: map['id'] ?? '', email: map['email'] ?? '');
  }
  // copyWith method....
  AuthUserModel copyWith({
    String? id,
    String? email,
  }) {
    return AuthUserModel(id: id ?? this.id, email: email ?? this.email);
  }
  // toJson method
}

class AuthUserEntity {
  final String id;
  final String email;
  AuthUserEntity({
    required this.id,
    required this.email,
  });
}
