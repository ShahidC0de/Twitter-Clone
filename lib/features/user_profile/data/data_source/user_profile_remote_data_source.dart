import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_clone/core/constants/constants.dart';
import 'package:twitter_clone/core/exceptions/auth_exceptions.dart';
import 'package:twitter_clone/features/home/data/models/tweetmodel.dart';

abstract interface class UserProfileRemoteDataSource {
  Future<List<Tweetmodel>> getUserTweets(String userId);
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  final FirebaseFirestore _firebaseFirestore;
  UserProfileRemoteDataSourceImpl({
    required FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore;
  @override
  Future<List<Tweetmodel>> getUserTweets(String userId) async {
    try {
      final QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(FirebaseConstants.usersTweetsCollection)
          .doc(userId)
          .collection('tweets')
          .get();
      List<Tweetmodel> userTweets = querySnapshot.docs
          .map((doc) => Tweetmodel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      return userTweets;
    } on FirebaseException catch (e) {
      throw ServerException(
          message: e.toString(), stackTrace: StackTrace.current);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
