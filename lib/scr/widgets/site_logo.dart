import 'package:flutter/material.dart';

class SiteLogo extends StatelessWidget {
  final VoidCallback tap;
  const SiteLogo({super.key, required this.tap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      child: const Text('CP',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 230, 212, 47),
            decoration: TextDecoration.underline,
          )),
    );
  }
}
