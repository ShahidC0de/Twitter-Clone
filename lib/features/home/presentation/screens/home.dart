import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/features/home/presentation/bloc/home_bloc.dart';

class Home extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const Home());

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    context.read<HomeBloc>().add(SaveUserDataEvent(
        uid: '12345',
        name: 'name',
        email: 'email',
        followers: [],
        following: [],
        profilePic: '',
        bannerPic: '',
        bio: '',
        isTwitterBlue: ''));
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Center(
            child: Text('logged in'),
          )
        ],
      ),
    );
  }
}
