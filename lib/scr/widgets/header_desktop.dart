import 'package:crypto_tracker/scr/constants/colors.dart';
import 'package:crypto_tracker/scr/constants/nav_items.dart';
import 'package:crypto_tracker/scr/styles/style.dart';
import 'package:crypto_tracker/scr/widgets/site_logo.dart';
import 'package:flutter/material.dart';

class HeaderDesktop extends StatelessWidget {
  const HeaderDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      decoration: kHeaderDecoration,
      child: Row(children: [
        // Logo
        SiteLogo(tap: () {}),

        const Spacer(),
        for (int i = 0; i < navTitles.length; i++)
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: TextButton(
              onPressed: () {},
              child: Text(
                navTitles[i],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: CustomColors.whitePrimary,
                ),
              ),
            ),
          ),
      ]),
    );
  }
}
