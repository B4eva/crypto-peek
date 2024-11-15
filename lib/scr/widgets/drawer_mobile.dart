import 'package:crypto/scr/constants/colors.dart';
import 'package:crypto/scr/constants/nav_items.dart';
import 'package:flutter/material.dart';

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key});

  @override
  Widget build(context) {
    return Drawer(
      backgroundColor: CustomColors.scaffoldBg,
      child: ListView(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20, bottom: 20),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close)),
            ),
          ),
          for (int i = 0; i < navTitles.length; i++)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              titleTextStyle: const TextStyle(
                  color: CustomColors.whitePrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
              leading: Icon(
                navIcons[i],
              ),
              title: Text(navTitles[i]),
              onTap: () {},
            )
        ],
      ),
    );
  }
}
