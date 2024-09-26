import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:galaxmovie/view_model/auth_viewmodel.dart';
import 'package:galaxmovie/view/screens/auth.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF313131),
      appBar: AppBar(
        backgroundColor: const Color(0xFF313131),
        automaticallyImplyLeading: false, 
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: _buildBody(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.mark_email_unread_outlined,
          size: 140,
          color: Colors.white,
        ),
        const SizedBox(height: 20),
        const Text(
          'Email Verification',
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _buildText('Verify your email address.'),
              _buildText(
                  'We have sent an email verification link to your email.'),
              _buildText(
                  'Please check your email and click on this link to verify your email address.'),
              _buildText(
                  'If you have verified your email address, click on the Continue button.'),
            ],
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {
            authViewModel.checkEmailVerificationStatus(context);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF313131),
            side: const BorderSide(color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: Text(
              'Continue',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AuthScreen()),
            );
          },
          child: const Text(
            'Back to Login',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }
}
