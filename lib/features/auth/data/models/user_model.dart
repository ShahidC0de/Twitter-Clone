import 'package:twitter_clone/core/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required super.id, required super.email});

  // fromJson method....
  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(id: map['id'] ?? '', email: map['email'] ?? '');
  }
  // copyWith method....
  UserModel copyWith({
    String? id,
    String? email,
  }) {
    return UserModel(id: id ?? this.id, email: email ?? this.email);
  }
  // toJson method
}
