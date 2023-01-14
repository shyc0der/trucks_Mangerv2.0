// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucks_manager/src/modules/firebase_user_module.dart';
import 'package:trucks_manager/src/modules/user_modules.dart';
import 'package:trucks_manager/src/ui/pages/home_page.dart';
import 'package:trucks_manager/src/ui/widgets/input_fields.dart';

import '../models/response_model copy.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UserModule userModule = Get.put(UserModule());
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  bool emailError = false;
  bool emailInvalid = false;
  bool passwordError = false;
  bool passwordInvalid = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // email
            InputField('Email', emailController, emailError,
                invalid: emailInvalid, onChanged: (String val) {
              if (val.isNotEmpty) {
                setState(() {
                  emailError = false;
                  emailInvalid = false;
                });
              }
            }),

            // password
            InputField("Password", passwordController, passwordError,
                isHidden: true,
                invalid: passwordInvalid, onChanged: (String val) {
              if (val.isNotEmpty) {
                setState(() {
                  passwordError = false;
                  passwordInvalid = false;
                });
              }
            }),

            const SizedBox(
              height: 17,
            ),
            // login button
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      bool _errExist = false;
                      if (emailController.text.isEmpty) {
                        setState(() {
                          emailError = true;
                          _errExist = true;
                        });
                      }
                      if (!GetUtils.isEmail(emailController.text)) {
                        setState(() {
                          emailInvalid = true;
                          _errExist = true;
                        });
                      }
                      if (passwordController.text.isEmpty) {
                        setState(() {
                          passwordError = true;
                          _errExist = true;
                        });
                      }

                      if (!_errExist) {
                        // login
                        setState(() {
                          isLoading = true;
                        });

                        final _res = await FirebaseUserModule.login(
                            emailController.text, passwordController.text);
                        await Future.delayed(const Duration(seconds: 2));
                        if (_res.status == ResponseType.success) {
                          // get user

                          await userModule.setCurrentUser(_res.body.toString());
                          
                          //Get.offAndToNamed('/');
                          await Future.delayed(const Duration(seconds: 3));
                          //Get.off(const HomePage());
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const HomePage())));
                        }
                        if (_res.body == 'user-not-found') {
                          setState(() {
                            emailInvalid = true;
                          });
                        }
                        if (_res.body == 'wrong-password') {
                          setState(() {
                            passwordInvalid = true;
                          });
                        }

                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}
