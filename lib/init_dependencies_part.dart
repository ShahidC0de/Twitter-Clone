import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:twitter_clone/core/constants/constants.dart';
import 'package:twitter_clone/core/cubits/app_user/app_user_cubit.dart';
import 'package:twitter_clone/core/cubits/current_user_data/current_user_data_cubit.dart';
import 'package:twitter_clone/features/auth/data/remote_data_source/remote_data_source_impl.dart';
import 'package:twitter_clone/features/auth/data/repositories/repostory_impl.dart';
import 'package:twitter_clone/features/auth/domain/repositories/auth_repository.dart';
import 'package:twitter_clone/features/auth/domain/use_cases/get_current_user.dart';
import 'package:twitter_clone/features/auth/domain/use_cases/sign_in_usecase.dart';
import 'package:twitter_clone/features/auth/domain/use_cases/sign_up_usecase.dart';
import 'package:twitter_clone/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:twitter_clone/features/home/data/local_data_source/home_local_data_source.dart';
import 'package:twitter_clone/features/home/data/remote_data_source/home_remote_data_source.dart';
import 'package:twitter_clone/features/home/data/repository_impl/home_repository_impl.dart';
import 'package:twitter_clone/features/home/domain/repositories/home_repository.dart';
import 'package:twitter_clone/features/home/domain/usecases/fetch_current_user_data_usecase.dart';

import 'package:twitter_clone/features/home/presentation/bloc/home_bloc.dart';

part "init_dependencies.dart";
