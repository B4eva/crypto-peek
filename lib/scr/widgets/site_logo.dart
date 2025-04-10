import 'package:flutter/material.dart';

class SiteLogo extends StatelessWidget {
  final VoidCallback tap;
  const SiteLogo({super.key, required this.tap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        //color: const Color(0xFFFEDA03),
        borderRadius: BorderRadius.circular(8),
      ),
      child:   Row(
        children: [
        Image.asset(
                 'assets/images/coinpeek-white.png',
             
        //  height: 60,
        //  width: 60,
         fit: BoxFit.cover,
 
),
SizedBox(width: 5),
              const Text(
                "CoinPeek",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              
       
        ],
      ),
    );
  }
}
