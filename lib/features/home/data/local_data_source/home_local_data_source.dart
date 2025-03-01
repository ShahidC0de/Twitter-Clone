import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:twitter_clone/core/constants/constants.dart';
import 'package:twitter_clone/core/models/user_model.dart';

abstract interface class HomeLocalDataSource {
  Future<bool> insertCurrentUserData(UserModel usermodel);
  Future<UserModel?> getCurrentUserData();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final Database _database;
  HomeLocalDataSourceImpl({
    required Database database,
  }) : _database = database;

  @override
  Future<bool> insertCurrentUserData(UserModel usermodel) async {
    try {
      final existingUserData = await _database.query(
        LocalStorageConstants.currentUserDataTableInSQL,
        where: '${LocalStorageConstants.idColumn} = ?',
        whereArgs: [usermodel.uid],
      );
      if (existingUserData.isNotEmpty) {
        await _database.update(
          LocalStorageConstants.currentUserDataTableInSQL,
          where: '${LocalStorageConstants.idColumn}= ?',
          whereArgs: [usermodel.uid],
          {
            LocalStorageConstants.nameColumn: usermodel.name,
            LocalStorageConstants.emailColumn: usermodel.email,
            LocalStorageConstants.followersColumn:
                jsonEncode(usermodel.followers),
            LocalStorageConstants.followingColumn:
                jsonEncode(usermodel.following),
            LocalStorageConstants.profilePicColumn: usermodel.profilePic,
            LocalStorageConstants.bannerPicColumn: usermodel.bannerPic,
            LocalStorageConstants.bioColumn: usermodel.bio,
            LocalStorageConstants.isTwitterBlueColumn:
                usermodel.isTwitterBlue == true ? 1 : 0,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        return true;
      } else {
        int rowsEffected = await _database.insert(
          LocalStorageConstants.currentUserDataTableInSQL,
          {
            LocalStorageConstants.idColumn: usermodel.uid,
            LocalStorageConstants.nameColumn: usermodel.name,
            LocalStorageConstants.emailColumn: usermodel.email,
            LocalStorageConstants.followersColumn:
                jsonEncode(usermodel.followers),
            LocalStorageConstants.followingColumn:
                jsonEncode(usermodel.following),
            LocalStorageConstants.profilePicColumn: usermodel.profilePic,
            LocalStorageConstants.bannerPicColumn: usermodel.bannerPic,
            LocalStorageConstants.bioColumn: usermodel.bio,
            LocalStorageConstants.isTwitterBlueColumn:
                usermodel.isTwitterBlue == true ? 1 : 0,
          },
        );

        return rowsEffected > 0;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      List<Map<String, dynamic>> data = await _database
          .query(LocalStorageConstants.currentUserDataTableInSQL);
      if (data.isNotEmpty) {
        Map<String, dynamic> dataList = data.first;
        return UserModel(
          uid: dataList[LocalStorageConstants.idColumn],
          name: dataList[LocalStorageConstants.nameColumn],
          email: dataList[LocalStorageConstants.emailColumn],
          followers:
              _decodeJson(dataList[LocalStorageConstants.followersColumn]),
          following:
              _decodeJson(dataList[LocalStorageConstants.followingColumn]),
          profilePic: dataList[LocalStorageConstants.profilePicColumn],
          bannerPic: dataList[LocalStorageConstants.bannerPicColumn],
          bio: dataList[LocalStorageConstants.bioColumn],
          isTwitterBlue:
              dataList[LocalStorageConstants.isTwitterBlueColumn] == 1
                  ? true
                  : false,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  List<dynamic> _decodeJson(String? jsonString) {
    try {
      return jsonString != null ? jsonDecode(jsonString) : [];
    } catch (e) {
      return [];
    }
  }
}
