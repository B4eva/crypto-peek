


import 'package:crypto_tracker/scr/constants/nav_items.dart';
import 'package:crypto_tracker/scr/providers/navigation_provider.dart';
import 'package:crypto_tracker/scr/widgets/gradient_text.dart';
import 'package:crypto_tracker/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class MobileDrawer extends ConsumerWidget {
  const MobileDrawer({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navController = ref.watch(navigationControllerProvider);
    final currentSection = navController.currentSection;
    
    return Drawer(
      backgroundColor: const Color(0xFF0C1C30),
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
                icon: const Icon(Icons.close)
              ),
            ),
          ),
          for (int i = 0; i < navTitles.length; i++)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              titleTextStyle: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 16
              ),
              title: i == 2
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentSection == AppSection.contact 
                        ? Color(0xFF4183D7) // Active color
                        : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Close drawer
                      // navController.scrollToSection(AppSection.contact);
                      sendEmail();
                    },
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
                      onPressed: () {
                        Navigator.pop(context); // Close drawer
                        navController.scrollToSection(AppSection.calculator);
                      },
                      child: currentSection == AppSection.calculator
                        ? const GradientText(
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
                          )
                        : Text(
                            "Calculator",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                    )
                  : TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close drawer
                        navController.scrollToSection(AppSection.home);
                      }, 
                      child: Text(
                        navTitles[i],
                        style: TextStyle(
                          color: currentSection == AppSection.home ? Colors.white : Colors.grey,
                          fontWeight: currentSection == AppSection.home ? FontWeight.bold : FontWeight.normal,
                        ),
                      )
                    ),
              onTap: () {},
            )
        ],
      ),
    );
  }
}