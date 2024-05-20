// import 'package:fluttercleanarchitecturewithbloc/Core/usecase/usecase.dart';
//

import 'package:fpdart/src/either.dart';

import '../../../../Core/error/failure.dart';
import '../../../../Core/usecase/usecase.dart';
import '../entity/user.dart';
import '../repository/auth_repository.dart';

class UserSignIn implements UseCase<User, SignInParams> {
  final AuthRepository authRepository;

  UserSignIn(this.authRepository);
  @override
  Future<Either<Failure, User>> call(SignInParams params) async {
    // TODO: implement call
    return await authRepository.signInWithEmailPassword(
        email: params.email, password: params.password);
  }
}

class SignInParams {
  final String email;
  final String password;

  SignInParams({required this.email, required this.password});
}
