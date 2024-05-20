import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localisation_des_eglise/Feature/Home/presentation/home_screen.dart';
import 'package:localisation_des_eglise/Feature/auth/presentation/pages/signup_page.dart';

import '../../../../Core/Widgets/GradientElevaedButton.dart';
import '../../../../Core/Widgets/auth_field.dart';
import '../../../../Core/theme/palette.dart';
import '../../../../Core/utils/loader.dart';
import '../../../../Core/utils/snackbar.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  late TapGestureRecognizer _tapPressRecognizer;

  @override
  void initState() {
    super.initState();
    _tapPressRecognizer = TapGestureRecognizer()..onTap = _handlePress;
  }

  void _handlePress() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return SignupPage();
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tapPressRecognizer.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          // TODO: implement listener//juniormalcom912@gmail.com

          if (state is AuthSuccess) {
            showSnackBar(context, "${state.user.id} User login Successfuly");
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (ctx) {
              return HomeScreen();
            }));
          } else if (state is AuthFailure) {
            showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return LoaderWidget();
          }
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Authentification",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  AuthField(
                    hintText: "Address Email",
                    controller: emailController,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  AuthField(
                    hintText: "Mot de passe",
                    controller: passwordController,
                    isPassword: true,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GradientElevatedButton(
                    text: "Sign in",
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                              AuthSignIn(
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            );
                      }
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'As-tu un compte ? ',
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            recognizer: _tapPressRecognizer,
                            text: "enregistrez vous ?",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppPallete.gradient2,
                                  fontWeight: FontWeight.bold,
                                ),
                          )
                        ]),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
