
import 'Package:flutter/material.dart';
import 'package:crypto_tracker/scr/widgets/site_logo.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

     EdgeInsets padding;
  if (screenSize.width < 400) {
    padding = const EdgeInsets.only(left: 8); // Small screens
  } else if (screenSize.width < 600) {
    padding = const EdgeInsets.all(16); // Medium screens
  } else if (screenSize.width < 900) {
    padding = const EdgeInsets.all(24); // Large screens
  } else {
    padding = const EdgeInsets.symmetric(horizontal: 100, vertical: 16); // Very large screens
  }
    
    return Padding(
      padding: padding,
      child: Container(
        // Assuming you have a footer background color
        padding: const EdgeInsets.all(20.0),
        child: screenSize.width < 600
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                    const SizedBox(height: 20),
                  // const Text(
                  //   'Get in Touch',
                  //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  // ),
                  const SizedBox(height: 20),
             //     _buildContactForm(),
                          const SizedBox(height: 50),
//                   Row(
//                     children: [
//                  SvgPicture.asset(
//                  'assets/svgs/coin-peak.svg',
//                   semanticsLabel: 'Dart Logo',
 
// ),
//                       const SizedBox(width: 8),
//                       const Text(
//                         "CoinPeek",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
                 
                 
                 SiteLogo(tap: (){}),
                  const SizedBox(height: 10),
             
              
                
                  const SizedBox(
                    height: 40,
                  )
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Contact information
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                  //   SiteLogo(tap: (){},),
                        // Row(
                        //   children: [
                        //     Container(
                        //       padding: const EdgeInsets.all(8.0),
                        //       decoration: BoxDecoration(
                        //      //   color: const Color(0xFFFEDA03),
                        //         borderRadius: BorderRadius.circular(8),
                        //       ),
                        //       child: const Text(
                        //         "CP",
                        //         style: TextStyle(
                        //           fontSize: 22,
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.white,
                        //         ),
                        //       ),
                        //     ),
                        //     const SizedBox(width: 8),
                        //     const Text(
                        //       "CoinPeek",
                        //       style: TextStyle(
                        //         fontSize: 23,
                        //         fontWeight: FontWeight.w600,
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(height: 10),
                        // const Text(
                        //   'Email: ttbumah@gmail.com',
                        //   style: TextStyle(
                        //       fontSize: 14,
                        //       fontWeight: FontWeight.w400,
                        //       color: Color(0xFF626262)),
                        // ),
                        // const Text(
                        //   'Phone: +44 7375 937236',
                        //   style: TextStyle(
                        //       fontSize: 14,
                        //       fontWeight: FontWeight.w400,
                        //       color: Color(0xFF626262)),
                        // ),
                        // const Text(
                        //   'Address: 123 Crypto St, Blockchain City',
                        //   style: TextStyle(
                        //       fontSize: 14,
                        //       fontWeight: FontWeight.w400,
                        //       color: Color(0xFF626262)),
                        // ),
                   
                   
                      ],
                    ),
                  ),
              
                ],
              ),
    
    
      ),
    );
  }

  Widget _buildContactForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.grey, width: 0.3)),
            labelText: 'Your Name',
            hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF626262)),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.grey, width: 0.03)),
            labelText: 'Your Email',
            hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF626262)),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.grey, width: 0.3)),
            labelText: 'Your Message',
            hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF626262)),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2752E7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(20),
          ),
          child: const Text(
            "Send Message",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
