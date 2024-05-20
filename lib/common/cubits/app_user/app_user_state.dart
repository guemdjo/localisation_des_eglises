part of 'app_user_cubit.dart';

sealed class AppUserState {}

class AppUserInitial extends AppUserState {}

final class AppUserLoggedIn extends AppUserState {
  final User user;

  AppUserLoggedIn({required this.user});
}

//core can't depend on another feature
