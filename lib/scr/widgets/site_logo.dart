import 'package:flutter/material.dart';

class SiteLogo extends StatelessWidget {
  final VoidCallback tap;
  const SiteLogo({super.key, required this.tap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFEDA03),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        "CP",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
