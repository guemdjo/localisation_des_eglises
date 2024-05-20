import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/Widgets/GradientElevaedButton.dart';
import '../../../../Core/Widgets/auth_field.dart';
import '../../../../Core/theme/palette.dart';
import '../../../../Core/utils/loader.dart';
import '../../../../Core/utils/snackbar.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
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
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const LoaderWidget();
            }

            return Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Enregistrement",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AuthField(
                      hintText: "Nom",
                      controller: nameController,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    AuthField(
                      hintText: "adresse email",
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
                      text: "SignUp",
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(AuthSignUp(
                                email: emailController.text,
                                name: nameController.text,
                                password: passwordController.text,
                              ));
                        }
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Already have an account ? ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              recognizer: _tapPressRecognizer,
                              text: "Sign in",
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
          listener: (context, state) {
            if (state is AuthSuccess) {
              showSnackBar(context, "${state.user.id} User add Successfuly");
            } else if (state is AuthFailure) {
              showSnackBar(context, state.message);
            }
          },
        ),
      ),
    );
  }
}
