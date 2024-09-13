import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student/constants/global_variables.dart';

import 'package:student/providers/user_provider.dart';
import 'package:student/router.dart';
import 'package:student/screens/authentication_screen.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyA9MwbWmkFNGQRJUQCIrCqwKTXbLFGtui4",
          projectId: "elimubora-b8fa3",
          storageBucket: "elimubora-b8fa3.appspot.com",
          messagingSenderId: "703257590814",
          appId: "1:703257590814:web:7cf669f22d3854c5f2420f"));

  MpesaFlutterPlugin.setConsumerKey(mConsumerKey);
  MpesaFlutterPlugin.setConsumerSecret(mConsumerSecret);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
        GlobalKey<ScaffoldMessengerState>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'schoolShare',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: const Scaffold(
        body: AuthenticationScreen(),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}
