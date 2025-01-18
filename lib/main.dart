import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/core/cubits/app_user/app_user_cubit.dart';
import 'package:twitter_clone/core/theme/app_theme.dart';
import 'package:twitter_clone/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:twitter_clone/features/auth/presentation/screens/login.dart';
import 'package:twitter_clone/features/home/features/saving_user_data/presentation/bloc/saving_user_data_bloc.dart';
import 'package:twitter_clone/features/home/presentation/bloc/home_bloc.dart';
import 'package:twitter_clone/features/home/presentation/screens/home.dart';
import 'package:twitter_clone/init_dependencies_part.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (_) => serviceLocator<AppUserCubit>(),
    ),
    BlocProvider(
      create: (_) => serviceLocator<AuthBloc>(),
    ),
    BlocProvider(
      create: (_) => serviceLocator<HomeBloc>(),
    ),
    BlocProvider(
      create: (_) => serviceLocator<SavingUserDataBloc>(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twitter Clone',
      theme: AppTheme.theme,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, state) {
          if (state) {
            return const Home();
          }
          return const Login();
        },
      ),
    );
  }
}
