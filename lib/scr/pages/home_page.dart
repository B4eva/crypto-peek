import 'package:crypto/main.dart';
import 'package:crypto/scr/constants/colors.dart';
import 'package:crypto/scr/constants/size.dart';
import 'package:crypto/scr/widgets/crypto_risk_form.dart';
import 'package:crypto/scr/widgets/drawer_mobile.dart';
import 'package:crypto/scr/widgets/header_desktop.dart';
import 'package:crypto/scr/widgets/header_mobile.dart';
import 'package:crypto/scr/widgets/main_desktop.dart';
import 'package:crypto/scr/widgets/main_mobile.dart';
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
    final screenSize = MediaQuery.of(context).size;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          key: scaffoldKey,
          endDrawer: (constraints.maxWidth >= kMinDesktopWidth)
              ? null
              : const MobileDrawer(),
          backgroundColor: CustomColors.scaffoldBg,
          body: ListView(
            children: [
              // Header
              if (constraints.maxWidth >= kMinDesktopWidth)
                const HeaderDesktop()
              else
                HeaderMobile(
                  onLogoTap: () {},
                  onMenuTap: () {
                    scaffoldKey.currentState?.openEndDrawer();
                  },
                ),
              // Main desktop content
              if (constraints.maxWidth >= kMinDesktopWidth)
                const MainDesktop()
              else
                const MainMobile(),

              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 40.0,
                  horizontal: constraints.maxWidth < 600 ? 16.0 : 100.0,
                ),
                child: const CryptoRiskForm(),
              ),

              // Footer
              const Footer(),
            ],
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

    return Container(
      color: CustomColors
          .footerColor, // Assuming you have a footer background color
      padding: const EdgeInsets.all(20.0),
      child: screenSize.width < 600
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Contact Us',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text('Email: support@example.com'),
                const Text('Phone: +1 (234) 567-890'),
                const Text('Address: 123 Crypto St, Blockchain City'),
                const SizedBox(height: 20),
                const Text(
                  'Get in Touch',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildContactForm(),
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
                const Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Contact Us',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text('Email: support@example.com'),
                      Text('Phone: +1 (234) 567-890'),
                      Text('Address: 123 Crypto St, Blockchain City'),
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
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      _buildContactForm(),
                      const SizedBox(
                        height: 40,
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildContactForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Your Name',
          ),
        ),
        const SizedBox(height: 10),
        const TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Your Email',
          ),
        ),
        const SizedBox(height: 10),
        const TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Your Message',
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            // Handle form submission
          },
          child: const Text('Send Message'),
        ),
      ],
    );
  }
}
