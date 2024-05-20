import 'package:fpdart/src/either.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../Core/error/exception.dart';
import '../../../../Core/error/failure.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthrepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthrepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, UserModel>> signInWithEmailPassword(
      {required String email, required String password}) async {
    // TODO: implement signInWithEmailPassword

    return _getUser(
      () async => await remoteDataSource.LoginWithEmailPassword(
        password: password,
        email: email,
      ),
    );
  }

  @override
  Future<Either<Failure, UserModel>> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    return _getUser(() async => await remoteDataSource.signUpWithEmailPassword(
        name: name, email: email, password: password));
  }

  Future<Either<Failure, UserModel>> _getUser(
      Future<UserModel> Function() fn) async {
    try {
      final user = await fn();
      return right(user);
    } on AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserModel>> currentUser() async {
    // TODO: implement currentUser
    try {
      final user = await remoteDataSource.getCurrentUserData();
      if (user != null) {
        return right(user);
      } else {
        return left(Failure("User not logged in"));
      }
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
