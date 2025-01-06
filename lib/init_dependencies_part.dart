import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:twitter_clone/features/auth/data/remote_data_source/remote_data_source_impl.dart';
import 'package:twitter_clone/features/auth/data/repositories/repostory_impl.dart';
import 'package:twitter_clone/features/auth/domain/repositories/auth_repository.dart';
import 'package:twitter_clone/features/auth/domain/use_cases/sign_up_usecase.dart';
import 'package:twitter_clone/features/auth/presentation/bloc/auth_bloc.dart';

part "init_dependencies.dart";
