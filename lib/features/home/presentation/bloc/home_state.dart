import 'package:flutter/material.dart';
import 'package:twitter_clone/core/entities/user_entity.dart';
import 'package:twitter_clone/features/home/domain/entities/tweet.dart';

@immutable
class HomeState {
  final List<Tweet> tweets;
  final Map<String, UserEntity> users;
  final bool isLoading;
  final String? errorMessage;

  const HomeState({
    required this.tweets,
    required this.users,
    required this.isLoading,
    this.errorMessage,
  });

  HomeState copyWith({
    List<Tweet>? tweets,
    Map<String, UserEntity>? users,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeState(
      tweets: tweets ?? this.tweets,
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // Allow null to reset errors
    );
  }
}

// Initial state
final class HomeInitial extends HomeState {
  const HomeInitial()
      : super(tweets: const [], users: const {}, isLoading: false);
}
