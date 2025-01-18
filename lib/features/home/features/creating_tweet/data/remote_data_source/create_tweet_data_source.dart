import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract interface class CreateTweetRemoteDataSource {
  String get getCurrentUserId;
}

class CreateTweetRemoteDataSourceImpl implements CreateTweetRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;
  CreateTweetRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
    required FirebaseStorage firebaseStorage,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore,
        _firebaseStorage = firebaseStorage;
// getting the current userId;
  @override
  String get getCurrentUserId => _firebaseAuth.currentUser!.uid;
}
