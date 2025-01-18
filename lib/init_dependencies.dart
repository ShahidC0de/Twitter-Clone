part of 'init_dependencies_part.dart';

final serviceLocator = GetIt.instance;
Future<void> initDependencies() async {
  try {
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
    _initAuth();
    _initHome();

    log('Firebase Initialized');
  } catch (e) {
    throw FirebaseException(
        plugin: e.toString(), message: 'Failed to initialize Firebase');
  }
}

void _initAuth() {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  serviceLocator.registerLazySingleton(() => AppUserCubit());
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
  serviceLocator.registerFactory<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(firebaseFirestore: serviceLocator()));
  serviceLocator.registerFactory<HomeRepository>(
      () => HomeRepositoryImpl(homeRemoteDataSource: serviceLocator()));
  serviceLocator.registerFactory(
      () => FetchCurrentUserDataUsecase(homeRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => HomeBloc(fetchCurrentUserDataUsecase: serviceLocator()));
  _initHomeSavingUserDataBloc();
}

void _initHomeSavingUserDataBloc() {
  serviceLocator
      .registerFactory<SavingUserDataSource>(() => SavingUserDataSourceImpl(
            firestore: serviceLocator(),
            firebaseAuth: serviceLocator(),
          ));
  serviceLocator.registerFactory<SavingUserDataRepository>(() =>
      SavingUserDataRepositoryImpl(savingUserDataSource: serviceLocator()));

  serviceLocator.registerFactory(
      () => SaveUserDataUseCase(homeRepository: serviceLocator()));

  serviceLocator.registerLazySingleton(
      () => SavingUserDataBloc(saveUserDataUseCase: serviceLocator()));
}
