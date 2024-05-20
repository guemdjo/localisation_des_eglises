import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Core/secrets/app_secrets.dart';
import '../common/cubits/app_user/app_user_cubit.dart';
import 'auth/data/datasources/auth_remote_data_source.dart';
import 'auth/data/datasources/auth_remote_data_source_impl.dart';
import 'auth/data/repository/auth_repository_impl.dart';
import 'auth/domain/repository/auth_repository.dart';
import 'auth/domain/usecase/current_user.dart';
import 'auth/domain/usecase/sign_in_params.dart';
import 'auth/domain/usecase/user_sign_up.dart';
import 'auth/presentation/bloc/auth_bloc.dart';

final serviceLocator = GetIt.instance;
Future<void> initDependencies() async {
  _initAuth();
  // initBlog();
  final supabase = await Supabase.initialize(
      url: AppSecrets.supabaseUrl, anonKey: AppSecrets.supabaseApiKey);
  serviceLocator.registerLazySingleton(() => supabase.client);

  //Core dependencies

  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImp(serviceLocator<SupabaseClient>()));
  serviceLocator.registerFactory<AuthRepository>(
      () => AuthrepositoryImpl(serviceLocator()));

  serviceLocator.registerFactory(() => UserSignUp(serviceLocator()));
  serviceLocator.registerFactory(() => UserSignIn(serviceLocator()));
  serviceLocator.registerFactory(() => CurrentUser(serviceLocator()));
  serviceLocator.registerLazySingleton(() => AuthBloc(
        userSignUp: serviceLocator(),
        userSignIn: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ));
}

// void initBlog() {
//   serviceLocator.registerFactory<BlogRemoteDataSource>(
//       () => BlogRemoteDataSourceImpl(serviceLocator<SupabaseClient>()));
//   serviceLocator.registerFactory<BlogRepository>(
//       () => BlogRepositoryImpl(blogRemoteDataSource: serviceLocator()));
//   serviceLocator.registerFactory(() => UploadBlogUseCase(serviceLocator()));
//   serviceLocator.registerFactory(() => GetAllBlogUsecase(serviceLocator()));
//   serviceLocator.registerLazySingleton(() => BlogBloc(
//       uploadBlogUseCase: serviceLocator(),
//       getAllBlogUsecase: serviceLocator()));
// }
