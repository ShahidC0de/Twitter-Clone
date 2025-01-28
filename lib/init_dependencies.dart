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
    Directory directory = await getApplicationDocumentsDirectory();
    String directoryPath = join(directory.path, 'mydb.db');
    return await openDatabase(directoryPath, version: 1,
        onCreate: (db, version) {
      db.execute(
          'create table $tableName($idColumn TEXT PRIMARY KEY , $nameColumn TEXT, $emailColumn TEXT, $followersColumn TEXT, $followingColumn TEXT, $profilePicColumn TEXT, $bannerPicColumn TEXT, $bioColumn TEXT, $isTwitterBlueColumn INTEGER)');
    });
  } catch (e) {
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
  serviceLocator.registerLazySingleton<CurrentUserDataCubit>(
      () => CurrentUserDataCubit());
  serviceLocator.registerFactory<HomeLocalDataSource>(
      () => HomeLocalDataSourceImpl(database: serviceLocator()));
  serviceLocator
      .registerFactory<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(
            firebaseFirestore: serviceLocator(),
            firebaseAuth: serviceLocator(),
          ));
  serviceLocator.registerFactory<HomeRepository>(() => HomeRepositoryImpl(
      homeRemoteDataSource: serviceLocator(),
      homeLocalDataSource: serviceLocator()));
  serviceLocator.registerFactory(
      () => FetchCurrentUserDataUsecase(homeRepository: serviceLocator()));
  serviceLocator.registerFactory(
      () => FetchAllTweetsUsecase(homeRepository: serviceLocator()));
  serviceLocator.registerFactory(() => HomeBloc(
      fetchAllTweetsUseCase: serviceLocator(),
      fetchCurrentUserDataUsecase: serviceLocator(),
      currentuserDataCubit: serviceLocator()));
  _initCreateTweet();
}

void _initCreateTweet() {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  serviceLocator.registerLazySingleton<FirebaseStorage>(() => firebaseStorage);
  serviceLocator.registerFactory<FirebaseStorageDataSource>(
      () => FirebaseStorageDataSourceImpl(firebaseStorage: serviceLocator()));
  serviceLocator.registerFactory<CreateTweetRemoteDataSource>(
      () => CreateTweetRemoteDataSourceImpl(
            firebaseFirestore: serviceLocator(),
            firebaseStorageDataSource: serviceLocator(),
          ));
  serviceLocator.registerFactory<CreateTweetRepository>(() =>
      CreateTweetRepositoryImpl(createTweetRemoteDataSource: serviceLocator()));
  serviceLocator.registerFactory(() => TweetParser());
  serviceLocator.registerFactory(() => CreateTweetUsecase(
      createTweetRepository: serviceLocator(), tweetParser: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => CreateTweetBloc(createTweetUsecase: serviceLocator()));
}
