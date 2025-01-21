part of 'init_dependencies_part.dart';

final serviceLocator = GetIt.instance;
Database? myDb;

Future<void> initDependencies() async {
  try {
    await getDb();
    serviceLocator.registerLazySingleton(() => myDb!);

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
    serviceLocator.registerLazySingleton(() => AppUserCubit());

    _initAuth();
    _initHome();

    log('Firebase Initialized');
  } catch (e) {
    throw FirebaseException(
        plugin: e.toString(), message: 'Failed to initialize Firebase');
  }
}

Future<Database> getDb() async {
  if (myDb != null) {
    return myDb!;
  } else {
    final db = openDb();
    return db;
  }
}

Future<Database> openDb() async {
  try {
    Directory directory = await getApplicationDocumentsDirectory();
    String directoryPath = join(directory.path, 'mydb.d');
    return await openDatabase(directoryPath, version: 1,
        onCreate: (db, version) {
      final tableName = LocalStorageConstants.currentUserDataTableInSQL;
      const idColumn = 'uid';
      const nameColumn = 'name';
      const emailColumn = 'email';
      const followersColumn = 'followers';
      const followingColumn = 'following';
      const profilePicColumn = 'profilePic';
      const bannerPicColumn = 'bannerPic';
      const bioColumn = 'bio';
      const isTwitterBlueColumn = 'isTwitterBlue';

      db.execute(
          'create Table $tableName($idColumn text primary key, $nameColumn text, $emailColumn text, $followersColumn text, $followingColumn text, $profilePicColumn text, $bannerPicColumn text, $bioColumn text, $isTwitterBlueColumn integer)');
      log('local database is been initialized');
    });
  } catch (e) {
    log(e.toString());
    throw Exception(e.toString());
  }
}

void _initAuth() {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  serviceLocator.registerLazySingleton(() => firebaseAuth);
  serviceLocator.registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(firebaseAuth: serviceLocator()));
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
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  serviceLocator.registerLazySingleton(() => firestore);
  serviceLocator
      .registerFactory<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(
            firebaseFirestore: serviceLocator(),
            localDataSource: serviceLocator(),
            firebaseAuth: serviceLocator(),
          ));
  serviceLocator.registerFactory<HomeRepository>(
      () => HomeRepositoryImpl(homeRemoteDataSource: serviceLocator()));
  serviceLocator.registerFactory(
      () => FetchCurrentUserDataUsecase(homeRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => HomeBloc(fetchCurrentUserDataUsecase: serviceLocator()));
}
