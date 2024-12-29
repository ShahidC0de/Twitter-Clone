import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/core/common/common.dart';
import 'package:twitter_clone/core/constants/constants.dart';
import 'package:twitter_clone/core/theme/theme.dart';
import 'package:twitter_clone/features/auth/presentation/screens/login.dart';
import 'package:twitter_clone/features/auth/presentation/widgets/auth_field.dart';

class SignUp extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignUp());
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final appBar = UiConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: SingleChildScrollView(
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
                    onTap: () {},
                    label: 'Done',
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                RichText(
                  text: TextSpan(
                    text: "Already have an account?",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    children: const [
                      TextSpan(
                          text: '  Login ',
                          style: TextStyle(
                            color: Pallete.blueColor,
                            fontSize: 16,
                          ))
                    ],
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(context, Login.route());
                      },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}