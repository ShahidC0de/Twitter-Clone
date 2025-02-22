import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/core/common/loader.dart';
import 'package:twitter_clone/core/entities/user_entity.dart';
import 'package:twitter_clone/core/theme/pallete.dart';
import 'package:twitter_clone/features/home/presentation/bloc/home_bloc.dart';
import 'package:twitter_clone/features/home/presentation/bloc/home_state.dart';
import 'package:twitter_clone/features/home/presentation/widgets/searched_user_tile.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _controller = TextEditingController();
  List<UserEntity> filteredUsers = [];
  Map<String, UserEntity> allUsers = {};

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _filteredUsers(String query) {
    if (query.isEmpty) {
      allUsers.values.toList();
    } else {
      setState(() {
        filteredUsers = allUsers.values.where((user) {
          return user.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: SizedBox(
            height: 50,
            child: TextField(
              controller: _controller,
              onChanged: (value) {
                _filteredUsers(value);
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10).copyWith(left: 20),
                hintText: 'Search tweet',
                fillColor: Pallete.searchBarColor,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(
                    color: Pallete.searchBarColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(
                    color: Pallete.searchBarColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.isLoading == false) {
              if (allUsers.isEmpty) {
                allUsers = state.users;
                filteredUsers = allUsers.values.toList();
              }
            }
            return filteredUsers.isEmpty
                ? const Loader()
                : ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      UserEntity user = filteredUsers[index];
                      return SearchedUserTile(userEntity: user);
                    });
          },
        ));
  }
}
