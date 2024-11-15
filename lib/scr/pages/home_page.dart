import 'package:crypto/main.dart';
import 'package:crypto/scr/constants/colors.dart';
import 'package:crypto/scr/constants/size.dart';

import 'package:crypto/scr/widgets/drawer_mobile.dart';
import 'package:crypto/scr/widgets/header_desktop.dart';

import 'package:crypto/scr/widgets/header_mobile.dart';
import 'package:crypto/scr/widgets/main_desktop.dart';
import 'package:crypto/scr/widgets/main_mobile.dart';
import 'package:flutter/material.dart';
// Import the form

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
              // mobile main
              else
                const MainMobile(),
              // Footer with CryptoRiskForm
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 40.0,
                  horizontal: constraints.maxWidth < 600 ? 16.0 : 100.0,
                ),
                child: const CryptoRiskForm(),
              ),
            ],
          ),
        );
      },
    );
  }
}
