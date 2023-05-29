import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterbutter/firebase_options.dart';
import 'package:flutterbutter/models/listings.dart';
import 'package:flutterbutter/models/user_data.dart';
import 'package:flutterbutter/screens/add_listing_screen.dart';
import 'package:flutterbutter/screens/auth_screen.dart';
import 'package:flutterbutter/screens/home_screen.dart';
import 'package:flutterbutter/screens/listings_screen.dart';
import 'package:flutterbutter/screens/profile_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MyApp());
}

Future<void> initFirebase() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Handle the initialization error here, such as displaying an error message
    log('Firebase initialization error: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx2) => UserData(),
        ),
        ChangeNotifierProvider(
          create: (ctx2) => Listings(),
        ),
      ],
      child: MaterialApp(
        title: 'FlutterButter',
        theme: ThemeData(
          //https://flatuicolors.com/palette/cn
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color.fromARGB(255, 49, 190, 108),
            secondary: const Color(0xff1e90ff),
            error: const Color(0xffff4757),
            background: const Color(0xffdfe4ea),
          ),
        ),
        routes: {
          ListingsScreen.routeName: (ctx) => const ListingsScreen(),
          AddListingScreen.routeName: (ctx) => const AddListingScreen(),
          ProfileScreen.routeName: (ctx) => const ProfileScreen(),
        },
        home: FutureBuilder(
            future: initFirebase(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return FirebaseAuth.instance.currentUser == null
                  ? const AuthScreen()
                  : FutureBuilder(
                      future:
                          Provider.of<UserData>(ctx, listen: false).initUser(),
                      builder: (ctx2, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Scaffold(
                            body: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return const HomeScreen();
                      },
                    );
            }),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
