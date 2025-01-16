import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/core/common/loader.dart';
import 'package:twitter_clone/core/common/rounded_small_button.dart';
import 'package:twitter_clone/core/constants/ui_constants.dart';
import 'package:twitter_clone/core/theme/pallete.dart';
import 'package:twitter_clone/core/utils/utilities.dart';
import 'package:twitter_clone/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:twitter_clone/features/auth/presentation/screens/sign_up.dart';
import 'package:twitter_clone/features/auth/presentation/widgets/auth_field.dart';
import 'package:twitter_clone/features/home/presentation/screens/home.dart';

class Login extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const Login());

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final appBar = UiConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // everytime the screen refreshes it will not need to call the function again, so storing it in the variable will ba a optimized approach.
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackBar(context, state.message);
            } else if (state is AuthSuccess) {
              Navigator.pushAndRemoveUntil(
                  context, Home.route(), (route) => false);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Loader();
            }

            return SingleChildScrollView(
              // its login so there will be textfields and when the keyboard appear for it, we dont want to be overflowed so....
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    AuthField(
                      controller: emailController,
                      hintText: 'Email',
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    AuthField(
                      controller: passwordController,
                      hintText: 'Password',
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: RoundedSmallButton(
                        onTap: () {
                          context.read<AuthBloc>().add(SignInEvent(
                              email: emailController.text,
                              password: passwordController.text));
                        },
                        label: 'Done',
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Dont't have an account?",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        children: const [
                          TextSpan(
                              text: '  Sign up ',
                              style: TextStyle(
                                color: Pallete.blueColor,
                                fontSize: 16,
                              ))
                        ],
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(context, SignUp.route());
                          },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
