import 'package:crypto/scr/constants/colors.dart';
import 'package:flutter/material.dart';

class MainMobile extends StatelessWidget {
  const MainMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      // height: screenSize.height / 3,
      constraints: const BoxConstraints(minHeight: 560),
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 30.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/crypto.gif',
                width: screenSize.width / 2,
              ),
            ),
            const Text(
              'Crypto Risk Scanner',
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                  color: CustomColors.whitePrimary),
            ),
            const SizedBox(height: 20),
            const Text(
              'CoinPeek helps you uncover hidden and potential risks in any cryptocurrency.',
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  color: CustomColors.whitePrimary),
            ),
            const SizedBox(height: 15),
          ]),
    );
  }
}
