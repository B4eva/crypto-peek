import 'package:crypto_tracker/scr/constants/colors.dart';
import 'package:crypto_tracker/scr/constants/nav_items.dart';
import 'package:crypto_tracker/scr/widgets/gradient_text.dart';
import 'package:flutter/material.dart';

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key});

  @override
  Widget build(context) {
    return Drawer(
      backgroundColor: const Color(0xFFF0C1C30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
              // leading: Icon(
              //   navIcons[i],
              // ),
              title: i == 2
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
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
                    )
                  : i == 1
                      ? TextButton(
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
                        )
                      : TextButton(onPressed: () {}, child: Text(navTitles[i])),
              onTap: () {},
            )
        ],
      ),
    );
  }
}
