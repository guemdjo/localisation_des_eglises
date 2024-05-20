import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:localisation_des_eglise/Feature/Home/presentation/home_screen.dart';
import 'package:location/location.dart';

import 'Core/theme/theme.dart';
import 'Feature/auth/presentation/bloc/auth_bloc.dart';
import 'Feature/auth/presentation/bloc/auth_event.dart';
import 'Feature/auth/presentation/pages/login_page.dart';
import 'Feature/dependencies.dart';
import 'common/cubits/app_user/app_user_cubit.dart';

Future<void> fetchLocationUpdates() async {
  bool serviceEnabled;
  final box = GetStorage();
  var locationController = Location();
  PermissionStatus permissionGranted;
  serviceEnabled = await locationController.serviceEnabled();
  print("Service enabled: $serviceEnabled");

  if (serviceEnabled) {
    serviceEnabled = await locationController.requestService();
    print("Service enable if: $serviceEnabled");
  } else {
    return;
  }
  permissionGranted = await locationController.hasPermission();
  print("has permission: $permissionGranted");
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await locationController.requestPermission();
    print("1");
    if (permissionGranted != PermissionStatus.granted) {
      print("2");
      return;
    }
  }
  locationController.onLocationChanged.listen((currentLocation) {
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      box.write("currentLatitude", currentLocation.latitude!);
      box.write("currentlongitude", currentLocation.longitude!);
      print("Current Position ${currentLocation}");
    }
  });
  locationController.enableBackgroundMode(enable: true);
}

void main() async {
  //initialise supabase
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await initDependencies();
  await fetchLocationUpdates();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => serviceLocator<AppUserCubit>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<AuthBloc>(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.darkThemeMode,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLoggedInstate) {
          if (isLoggedInstate) {
            return HomeScreen();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
