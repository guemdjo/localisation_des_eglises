import 'package:fpdart/fpdart.dart';

import '../../../../Core/error/failure.dart';
import '../../../../Core/usecase/usecase.dart';
import '../entity/user.dart';
import '../repository/auth_repository.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;

  CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    // TODO: implement call
    return await authRepository.currentUser();
  }
}

class NoParams {}
