import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:get_it/get_it.dart';
import 'package:twitter_clone/core/constants/appwrite_constants.dart';
import 'package:twitter_clone/core/exceptions/auth_exceptions.dart';
import 'package:twitter_clone/features/auth/data/remote_data_source/remote_data_source_impl.dart';
import 'package:twitter_clone/features/auth/data/repositories/repostory_impl.dart';
import 'package:twitter_clone/features/auth/domain/repositories/auth_repository.dart';
import 'package:twitter_clone/features/auth/domain/use_cases/sign_up_usecase.dart';
import 'package:twitter_clone/features/auth/presentation/bloc/auth_bloc.dart';

part "init_dependencies.dart";
