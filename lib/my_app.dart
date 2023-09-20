import 'package:contatos/views/splash_screen_delay_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple, textTheme: GoogleFonts.robotoCondensedTextTheme()),
      home: const SplashScreenDelayView(),
    );
  }
}
