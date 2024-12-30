import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/type_def/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
typedef UserOfFuture<T> = Future<T>;


// these are custom datatype made, we dont want to write it again and again so we already declared it and it will be easy for us to use it.
// well in first typedef we dont know what will be the return type so why not require it in using, so T means dynamic and corresponds to dynamic.
// whatever you give it while using it.....
