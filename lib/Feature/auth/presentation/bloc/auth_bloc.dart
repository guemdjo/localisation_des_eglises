import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../common/cubits/app_user/app_user_cubit.dart';
import '../../domain/entity/user.dart';
import '../../domain/usecase/current_user.dart';
import '../../domain/usecase/sign_in_params.dart';
import '../../domain/usecase/user_sign_up.dart';
import 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);

    on<AuthSignIn>(_onAuthSignIn);
    on<AuthIsUserLoggedIn>(_onAuthIsLoggedIn);
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    print('email = ${event.name}');
    print('password = ${event.password}');
    print('name = ${event.name}');
    final res = await _userSignUp(UserSignUpParams(
        name: event.name, password: event.password, email: event.email));
    res.fold((l) => emit(AuthFailure(message: l.message)),
        (user) => emitAuthSuccess(user, emit));
  }

  void _onAuthSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    final res = await _userSignIn(
        SignInParams(email: event.email, password: event.password));
    res.fold((l) => emit(AuthFailure(message: l.message)),
        (user) => emitAuthSuccess(user, emit));
  }

  void _onAuthIsLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    final res = await _currentUser(NoParams());
    res.fold((l) => emit(AuthFailure(message: l.message)),
        (user) => emitAuthSuccess(user, emit));
  }

  void emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }
}
