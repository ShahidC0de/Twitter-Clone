import 'package:twitter_clone/core/entities/auth_user_entity.dart';

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
