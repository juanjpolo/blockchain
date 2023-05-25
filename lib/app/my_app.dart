import 'package:flutter/material.dart';

import 'presentation/modules/home/view/home_view.dart';
import 'presentation/modules/sign_in/view/sign_in_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blockchain',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (_) => const HomeView(),
        '/sign-in': (_) => const SignInView()
      },
    );
  }
}
