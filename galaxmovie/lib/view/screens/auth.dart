import 'package:flutter/material.dart';
import 'package:galaxmovie/view/screens/singup.dart';
import 'package:galaxmovie/view/widgets/resetpassword.dart';
import 'package:galaxmovie/view_model/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF313131),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 115),
              const Text(
                'Log In',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Hello there, Sign in to continue',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.white),
                  fillColor: const Color.fromARGB(160, 72, 78, 70),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFF7FF00)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorText: authViewModel.emailErrorMessage,
                ),
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                cursorColor: const Color(0xFFF7FF00),
                onChanged: (value) {
                  authViewModel.setEmail(value);
                  authViewModel
                      .setEmailErrorMessage(authViewModel.validateEmail(value));
                },
              ),
              const SizedBox(height: 22),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white),
                  fillColor: const Color.fromARGB(160, 72, 78, 70),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFF7FF00)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorText: authViewModel.passwordErrorMessage,
                ),
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                cursorColor: const Color(0xFFF7FF00),
                onChanged: (value) {
                  authViewModel.setPassword(value);
                  authViewModel.setPasswordErrorMessage(
                      authViewModel.validatePassword(value));
                },
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ResetPasswordDialog(
                            authViewModel: authViewModel,
                          );
                        },
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    authViewModel.signIn(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF7FF00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 70),
              Column(
                children: [
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      "Don't have an account",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: const Text(
                        'Register Now',
                        style: TextStyle(color: Color(0xFFF7FF00)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
