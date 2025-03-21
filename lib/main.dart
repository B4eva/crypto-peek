import 'package:crypto_tracker/scr/pages/home_page.dart';
import 'package:crypto_tracker/scr/pages/revamp/revamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ProviderScope(child:   MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coin Peek',
      theme: ThemeData(
        scaffoldBackgroundColor:
            Colors.white, // Set scaffold background to white
        textTheme: GoogleFonts.poppinsTextTheme(
          // Use Poppins font
          Theme.of(context)
              .textTheme
              .apply(bodyColor: Colors.black, displayColor: Colors.black),
        ),
        primarySwatch: Colors.blue, // Customize primary color
      ),
      home:  const Scaffold(
        body: CryptoRiskScanner(),
      ),
    );
  }
}
