import 'package:crypto/scr/constants/colors.dart';
import 'package:flutter/material.dart';

class MainDesktop extends StatelessWidget {
  const MainDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
        padding: const EdgeInsets.only(left: 30),
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        constraints: const BoxConstraints(minHeight: 350),
        height: screenSize.height / 1.2,
        width: double.maxFinite,
        // color: Colors.lightBlue,
        //child: const CryptoRiskForm(),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 150.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Crypto Risk Scanner',
                    style: TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                        color: CustomColors.whitePrimary),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'CoinPeek helps you uncover hidden and potential risks in any cryptocurrency.',
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: CustomColors.whitePrimary),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 230, 212, 47),
                      minimumSize: const Size(
                          200, 60), // Set minimum size for width and height
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // Set border radius
                      ),
                    ),
                    child: const Text(
                      'Get started',
                      style: TextStyle(
                        color: Colors.white, // Set text color to white
                        fontSize: 18, // Set text size to 18
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Image.asset(
                'assets/images/crypto.gif',
                width: screenSize.width / 2,
              ),
            )
          ],
        ));
  }
}
