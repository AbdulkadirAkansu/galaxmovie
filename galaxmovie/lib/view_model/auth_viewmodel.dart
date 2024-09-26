import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:galaxmovie/view/screens/auth.dart';
import 'package:galaxmovie/view/screens/home.dart';

class AuthViewModel extends ChangeNotifier {
  late String _email;
  late String _password;
  String? _emailErrorMessage;
  String? _passwordErrorMessage;
  bool _isLoggedIn = false;
  User? _currentUser;

  bool get isLoggedIn => _isLoggedIn;
  User? get currentUser => _currentUser;
  String get email => _email;
  String get password => _password;
  String? get emailErrorMessage => _emailErrorMessage;
  String? get passwordErrorMessage => _passwordErrorMessage;

  void setEmail(String email) {
    _email = email;
  }

  void setPassword(String password) {
    _password = password;
  }

  String? validateEmail(String email) {
    if (!email.contains('@')) {
      return 'Invalid email format';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> signUp(BuildContext context) async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      await userCredential.user!.sendEmailVerification();

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification email sent.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (error) {
      // ignore: avoid_print
      print('Sign up failed: $error');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign up failed. Please try again later.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> checkEmailVerificationStatus(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.reload();
      user = FirebaseAuth.instance.currentUser;

      if (user!.emailVerified) {
      
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email is not verified yet.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User is not authenticated.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> signIn(BuildContext context) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);

     
      if (!userCredential.user!.emailVerified) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please verify your email to continue.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        await FirebaseAuth.instance.signOut();
      } else {
        _isLoggedIn = true;
        notifyListeners();
        // ignore: avoid_print
        print('User signed in: ${userCredential.user!.uid}');
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      }
    } catch (error) {
      // ignore: avoid_print
      print('Sign in failed: $error');
      String errorMessage = 'Username or password incorrect';
      if (error is FirebaseAuthException) {
        if (error.code == 'wrong-password') {
          errorMessage = 'Invalid password';
        } else if (error.code == 'user-not-found') {
          errorMessage = 'User not found';
        }
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      _isLoggedIn = false;
      notifyListeners();
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    } catch (error) {
      // ignore: avoid_print
      print('Sign out failed: $error');
    }
  }

  Future<void> resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      _isLoggedIn = true;
      notifyListeners();
    } catch (error) {
      // ignore: avoid_print
      print('Password reset failed: $error');
    }
  }

  void setEmailErrorMessage(String? message) {
    _emailErrorMessage = message;
    notifyListeners();
  }

  void setPasswordErrorMessage(String? message) {
    _passwordErrorMessage = message;
    notifyListeners();
  }
}
