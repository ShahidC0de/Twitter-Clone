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

    log('Firebase Initialized');
  } catch (e) {
    throw FirebaseException(
        plugin: e.toString(), message: 'Failed to initialize Firebase');
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
      getCurrentUser: serviceLocator()));
}
