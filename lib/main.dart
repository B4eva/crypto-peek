import 'package:crypto_tracker/scr/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
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
      home: const Scaffold(
        body: HomePage(),
      ),
    );
  }
}
