import 'package:crypto_tracker/scr/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CryptoRiskScannerBanner extends StatelessWidget {
  const CryptoRiskScannerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          // Background Layer
          Container(
            height: 350,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: const Color(0xFF2752E7),
                borderRadius: BorderRadius.circular(20)),
          ),
          // Curved Shapes (You can replace these with SVGs if necessary)
          const Positioned(
            top: -80,
            left: -80,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Color(0xFF4B82EF),
            ),
          ),

          const Positioned(
            bottom: -150,
            right: -150,
            child: CircleAvatar(
              radius: 120,
              backgroundColor: Color(0xFF4B82EF),
            ),
          ),

          // Content Layer
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Crypto Risk Scanner",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "CoinPeek helps you uncover hidden and potential risks \nin any cryptocurrency",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: () {},
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.white,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //     padding: const EdgeInsets.all(20),
                //   ),
                //   child: const Text(
                //     "Get started",
                //     style: TextStyle(
                //         color: Colors.black,
                //         fontWeight: FontWeight.bold,
                //         fontSize: 12),
                //   ),
                // ),
              ],
            ),
          ),

          // Icons Layer
          Positioned(
            top: 30,
            right: constraints.maxWidth >= kMinDesktopWidth ? 50 : 5,
            child: SvgPicture.asset(
              'assets/svgs/btc.svg',
              width: constraints.maxWidth >= kMinDesktopWidth ? null : 90,
            ),
          ),
          Positioned(
            bottom: -10,
            right: 100,
            child: SvgPicture.asset(
              'assets/svgs/eth.svg',
              width: constraints.maxWidth >= kMinDesktopWidth ? null : 90,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 300,
            child: SvgPicture.asset(
              'assets/svgs/luna.svg',
              width: constraints.maxWidth >= kMinDesktopWidth ? null : 90,
            ),
          ),
        ],
      ),
    );
  }
}
