import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../Core/error/exception.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImp implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImp(this.supabaseClient);
  @override
  @override
  // TODO: implement currentUserSession
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  Future<UserModel> LoginWithEmailPassword(
      {required String password, required String email}) async {
    try {
      final response = await supabaseClient.auth
          .signInWithPassword(password: password, email: email);
      print(response);

      if (response.user == null) {
        throw ServerException('User is null');
      }

      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      print("Not ok ${e.toString()}");
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    // TODO: implement signUpWithEmailPassword

    print('email = $email');
    print('password = $password');
    print('name = $name');

    try {
      final response = await supabaseClient.auth
          .signUp(password: password, email: email, data: {'name': name});
      print(response);

      if (response.user == null) {
        throw ServerException('User is null');
      }
      print("ojjnj");
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      print("Not ok ${e.toString()}");
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    // TODO: implement getCurrentUserData
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);
        return UserModel.fromJson(userData.first);
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
