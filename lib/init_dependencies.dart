part of 'init_dependencies_part.dart';

final serviceLocator = GetIt.instance;
Database? myDb;
Future<void> initDependencies() async {
  try {
    final myDB = await _getDb();
    serviceLocator.registerLazySingleton<Database>(() => myDB);
    if (Platform.isAndroid) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyBFm6liY8qRRFzH10oySU-WxDuajaXXAhQ',
          appId: '1:175033586289:android:95ef4493f28651644681d0',
          messagingSenderId: '175033586289',
          projectId: 'todolistapp344',
          storageBucket: 'todolistapp344.appspot.com',
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    serviceLocator.registerLazySingleton(() => firebaseAuth);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    serviceLocator.registerLazySingleton(() => firestore);
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    serviceLocator
        .registerLazySingleton<FirebaseStorage>(() => firebaseStorage);
    serviceLocator.registerLazySingleton(() => AppUserCubit());

    _initAuth();
    _initHome();

    log('Firebase Initialized');
  } catch (e) {
    throw FirebaseException(
        plugin: e.toString(), message: 'Failed to initialize Firebase');
  }
}

Future<Database> _getDb() async {
  if (myDb == null) {
    final db = await _openDb();
    return db;
  } else {
    final db = myDb;
    return db!;
  }
}

Future<Database> _openDb() async {
  try {
    Directory directory = await getApplicationDocumentsDirectory();
    String directoryPath = join(directory.path, 'mydb.db');
    return await openDatabase(directoryPath, version: 1,
        onCreate: (db, version) {
      db.execute(
          'create table ${LocalStorageConstants.currentUserDataTableInSQL}(${LocalStorageConstants.idColumn} TEXT PRIMARY KEY , ${LocalStorageConstants.nameColumn} TEXT, ${LocalStorageConstants.emailColumn} TEXT, ${LocalStorageConstants.followersColumn} TEXT, ${LocalStorageConstants.followersColumn} TEXT, ${LocalStorageConstants.profilePicColumn} TEXT, ${LocalStorageConstants.bannerPicColumn} TEXT, ${LocalStorageConstants.bioColumn} TEXT, ${LocalStorageConstants.isTwitterBlueColumn} INTEGER)');
    });
  } catch (e) {
    throw Exception(e.toString());
  }
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(() =>
      AuthRemoteDataSourceImpl(
          firebaseAuth: serviceLocator(), firebaseFirestore: serviceLocator()));
  serviceLocator.registerFactory<AuthRepository>(
      () => RepostoryImpl(authRemoteDataSource: serviceLocator()));
  serviceLocator
      .registerFactory(() => UserSignUp(authRepository: serviceLocator()));
  serviceLocator
      .registerFactory(() => UserSignIn(authRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => GetCurrentUser(authRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => AuthBloc(
        userSignUp: serviceLocator(),
        userSignIn: serviceLocator(),
        getCurrentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ));
}

void _initHome() {
  serviceLocator.registerFactory<HomeLocalDataSource>(
      () => HomeLocalDataSourceImpl(database: serviceLocator()));
  serviceLocator.registerFactory<StorageRemoteDataSource>(
      () => StorageRemoteDataSourceImpl(firebaseStorage: serviceLocator()));
  serviceLocator
      .registerFactory<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(
            firebaseFirestore: serviceLocator(),
            firebaseAuth: serviceLocator(),
            storageRemoteDataSource: serviceLocator(),
          ));
  serviceLocator.registerFactory<HomeRepository>(() => HomeRepositoryImpl(
      homeRemoteDataSource: serviceLocator(),
      homeLocalDataSource: serviceLocator()));
  serviceLocator.registerFactory(() => TweetParser());

  serviceLocator.registerFactory(
      () => FetchAllTweetsUsecase(homeRepository: serviceLocator()));
  serviceLocator.registerFactory(() => CreateTweetUsecase(
      homeRepository: serviceLocator(), tweetParser: serviceLocator()));
  serviceLocator.registerFactory(
      () => GetUserDataUsecase(homeRepository: serviceLocator()));

  serviceLocator.registerLazySingleton(() => HomeBloc(
        fetchAllTweetsUsecase: serviceLocator(),
        getUserDataUsecase: serviceLocator(),
        createTweetUsecase: serviceLocator(),
      ));
}
