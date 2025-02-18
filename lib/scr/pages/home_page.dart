import 'package:crypto_tracker/scr/constants/size.dart';
import 'package:crypto_tracker/scr/widgets/crypto_risk_banner.dart';
import 'package:crypto_tracker/scr/widgets/crypto_risk_form.dart';
import 'package:crypto_tracker/scr/widgets/drawer_mobile.dart';
import 'package:crypto_tracker/scr/widgets/gradient_text.dart';
import 'package:crypto_tracker/scr/widgets/header_mobile.dart';

import 'package:crypto_tracker/scr/widgets/responsive_center.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    //  final screenSize = MediaQuery.of(context).size;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          key: scaffoldKey,
          endDrawer: (constraints.maxWidth >= kMinDesktopWidth)
              ? null
              : const MobileDrawer(),
          backgroundColor: const Color(0xFFFFFFFF),
          body: ResponsiveCenter(
            child: ListView(
              children: [
                // Header
                // ResponsiveHeader(),

                if (constraints.maxWidth >= kMinDesktopWidth)
                  const ResponsiveHeader()
                else
                  HeaderMobile(
                    onLogoTap: () {},
                    onMenuTap: () {
                      scaffoldKey.currentState?.openEndDrawer();
                    },
                  ),

                const SizedBox(
                  height: 30,
                ),
                const CryptoRiskScannerBanner(),

                const SizedBox(
                  height: 50,
                ),

                // Main desktop content

                const CryptoRiskForm(),
                const SizedBox(
                  height: 30,
                ),

                // Footer
                const Footer(),
                const SizedBox(
                  height: 30,
                ),

                const Divider(),
                const SizedBox(
                  height: 30,
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    '© 2024. All rights reserved.',
                    style: TextStyle(fontSize: 12, color: Color(0xFFA0A3A9)),
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

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
                  const Text(
                    'Get in Touch',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  _buildContactForm(),
                          const SizedBox(height: 50),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEDA03),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "CP",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "CoinPeek",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Email: ttbumah@gmail.com',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF626262)),
                  ),
                  const Text(
                    'Phone: +44 7375 937236',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF626262)),
                  ),
                  const Text(
                    'Address: 123 Crypto St, Blockchain City',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF626262)),
                  ),
                
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
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                             //   color: const Color(0xFFFEDA03),
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
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "CoinPeek",
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Email: ttbumah@gmail.com',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF626262)),
                        ),
                        const Text(
                          'Phone: +44 7375 937236',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF626262)),
                        ),
                        const Text(
                          'Address: 123 Crypto St, Blockchain City',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF626262)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20), // Space between two columns
                  // Contact form
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Get in Touch',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        _buildContactForm(),
                        const SizedBox(
                          height: 40,
                        ),
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

class ResponsiveHeader extends StatelessWidget {
  const ResponsiveHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo and Brand Name
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEDA03),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "CP",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "CoinPeek",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              if (!isMobile )
                Container(
                  width: 350,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF132A46),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: TextField(
                                              style: TextStyle(fontSize: 12, color: Colors.white),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search Coin",
                          ),
                        ),
                      ),
                      Icon(Icons.search, color: Colors.grey),
                    ],
                  ),
                ),
            ],
          ),
          // Search Bar

          // Navigation Items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Home",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              TextButton(
                onPressed: () {},
                child: const GradientText(
                  text: "Calculator",
                  gradient: LinearGradient(
                    colors: [
                      Colors.pink,
                      Colors.purple,
                      Colors.orange,
                      Colors.yellow,
                    ],
                  ),
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF315177),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                onPressed: () {},
                child: const Text(
                  "Contact",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
