import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:galaxmovie/firebase_options.dart';
import 'package:galaxmovie/view/screens/auth.dart';
import 'package:galaxmovie/view/screens/home.dart';
import 'package:galaxmovie/view_model/auth_viewmodel.dart';
import 'package:galaxmovie/view_model/favori_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:galaxmovie/view_model/home_viewmodel.dart';
import 'package:galaxmovie/view_model/search_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AnaUygulama());
}

class AnaUygulama extends StatelessWidget {
  const AnaUygulama({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkUserLoggedIn(),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasData) {
            bool isLoggedIn = snapshot.data!;
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => HomeViewModel()),
                ChangeNotifierProvider(create: (_) => SearchViewModel()),
                ChangeNotifierProvider(create: (_) => AuthViewModel()),
                ChangeNotifierProvider(create: (_) => FavoritesProvider())     
              ],
              child: MaterialApp(
                home: isLoggedIn ? const Home() : const AuthScreen(),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        }
      },
    );
  }
}

Future<bool> checkUserLoggedIn() async {
  User? user = FirebaseAuth.instance.currentUser;
  return user != null;
}
