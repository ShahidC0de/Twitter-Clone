import 'package:twitter_clone/core/type_def/datatype.dart';

abstract interface class Usecase<SuccessType, Params> {
  FutureEither<SuccessType> call(Params params);
}

class NoParams {}
