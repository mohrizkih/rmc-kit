import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rmc_kit/Screens/Auth/Login/login.dart';
import 'package:rmc_kit/Screens/Auth/Signup/sign_up.dart';
import 'package:rmc_kit/Screens/Auth/Welcome/components/welcome_body.dart';
import 'package:rmc_kit/Screens/Auth/Welcome/wlcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:rmc_kit/models/user.dart';
import 'package:rmc_kit/Screens/Auth/Services/auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        StreamProvider<MyUser>.value(value: AuthService().user),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/signUp': (context) => SignUp(),
        '/login': (context) => Login(),
        '/WelcomeBody': (context) => WelcomeBody(),
      },
      debugShowCheckedModeBanner: false,
      title: 'RMC kit',
      theme: ThemeData(fontFamily: 'Source Sans Pro'),
      home: Welcome(),
    );
  }
}
