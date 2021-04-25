import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:venyuu_partner/constants.dart';

import 'package:venyuu_partner/providers/database.dart';
import 'package:venyuu_partner/screens/bookings_screen.dart';

import 'package:venyuu_partner/screens/dashboard.dart';
import 'package:venyuu_partner/screens/forgot_password_screen.dart';
import 'package:venyuu_partner/screens/fourth_register_screen.dart';
import 'package:venyuu_partner/screens/login_screen.dart';
import 'package:venyuu_partner/screens/second_register_screen.dart';
import 'package:venyuu_partner/screens/register_screen.dart';
import 'package:venyuu_partner/screens/settings_screen.dart';
import 'package:venyuu_partner/screens/signup_screen.dart';
import 'package:venyuu_partner/screens/splash_screen.dart';
import 'package:venyuu_partner/screens/third_register_screen.dart';
import 'package:venyuu_partner/screens/venue_detail_screen.dart';
import 'package:venyuu_partner/screens/verify_screen.dart';
import 'package:venyuu_partner/screens/wallet_screen.dart';
import 'package:venyuu_partner/screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(OwnerApp());
}

class OwnerApp extends StatefulWidget {
  @override
  _OwnerAppState createState() => _OwnerAppState();
}

class _OwnerAppState extends State<OwnerApp> {
  bool get _loggedIn {
    return FirebaseAuth.instance.currentUser != null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Database(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(accentColor: kPrimaryColor, fontFamily: 'Nunito'),
        debugShowCheckedModeBanner: false,
        home: _loggedIn && FirebaseAuth.instance.currentUser.emailVerified
            ? Dashboard()
            : WelcomeScreen(),
        routes: {
          Dashboard.routeName: (ctx) => Dashboard(),
          ForgotPasswordScreen.routeName: (ctx) => ForgotPasswordScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          SecondRegisterFormScreen.routeName: (ctx) =>
              SecondRegisterFormScreen(),
          RegisterFormScreen.routeName: (ctx) => RegisterFormScreen(),
          SignUpScreen.routeName: (ctx) => SignUpScreen(),
          SplashScreen.routeName: (ctx) => SplashScreen(),
          VenueDetailScreen.routeName: (ctx) => VenueDetailScreen(),
          VerifyScreen.routeName: (ctx) => VerifyScreen(),
          WelcomeScreen.routeName: (ctx) => WelcomeScreen(),
          ThirdRegisterFormScreen.routeName: (ctx) => ThirdRegisterFormScreen(),
          FourthRegisterFormScreen.routeName: (ctx) =>
              FourthRegisterFormScreen(),
          BookingsScreen.routeName: (ctx) => BookingsScreen(),
          WalletScreen.routeName: (ctx) => WalletScreen(),
          SettingsScreen.routeName: (ctx) => SettingsScreen(),
        },
      ),
    );
  }
}
