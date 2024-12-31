part of 'init_dependencies_part.dart';

final serviceLocator = GetIt.instance;
Future<void> initDependencies() async {
  try {
    Client client = Client()
        .setEndpoint(AppwriteConstants.endPoint)
        .setProject(AppwriteConstants.projectId);
    Account account = Account(client);
    serviceLocator.registerLazySingleton(() => account);
    _initAuth();
  } catch (e, stackTrace) {
    throw ServerException(message: e.toString(), stackTrace: stackTrace);
  }
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(account: serviceLocator()));
  serviceLocator.registerFactory<AuthRepository>(
      () => RepostoryImpl(authRemoteDataSource: serviceLocator()));
  serviceLocator
      .registerFactory(() => UserSignUp(authRepository: serviceLocator()));
}
