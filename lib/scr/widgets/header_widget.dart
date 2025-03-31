import 'package:crypto_tracker/scr/providers/coins_provider.dart';
import 'package:crypto_tracker/scr/widgets/gradient_text.dart';
import 'package:crypto_tracker/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ConsumerState, ConsumerStatefulWidget, ConsumerWidget, Provider, StateProvider;

// Create a scroll controller provider that can be accessed throughout the app
final scrollControllerProvider = Provider<ScrollController>((ref) {
  return ScrollController();
});



// Provider to track the current active section
final currentSectionProvider = StateProvider<AppSection>((ref) {
  return AppSection.home;
});

class ResponsiveHeader extends ConsumerStatefulWidget {
  const ResponsiveHeader({super.key});

  @override
  ConsumerState<ResponsiveHeader> createState() => _ResponsiveHeaderState();
}

class _ResponsiveHeaderState extends ConsumerState<ResponsiveHeader> {
  TextEditingController controller = TextEditingController();
  bool isSearching = false;
  
  // Function to scroll to a specific section
  void scrollToSection(AppSection section) {
    final scrollController = ref.read(scrollControllerProvider);
    
    // Update the current section
    ref.read(currentSectionProvider.notifier).state = section;
    
    // Determine the scroll position based on the section
    double scrollPosition = 0;
    switch (section) {
      case AppSection.home:
        scrollPosition = 0; // Scroll to top
        break;
      case AppSection.calculator:
        scrollPosition = 1000; // Adjust this value based on your layout
        break;
      case AppSection.contact:
        scrollPosition = 2000; // Adjust this value based on your layout
        break;
    }
    
    // Animate to the position
    scrollController.animateTo(
      scrollPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // Get the current active section
    final currentSection = ref.watch(currentSectionProvider);
    
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
            ],
          ),

          // Navigation Items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => scrollToSection(AppSection.home),
                child: Text(
                  "Home",
                  style: TextStyle(
                    color: currentSection == AppSection.home ? Colors.white : Colors.grey,
                    fontSize: 15,
                    fontWeight: currentSection == AppSection.home ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              TextButton(
                onPressed: () => scrollToSection(AppSection.calculator),
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
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: currentSection == AppSection.contact 
                    ? Color(0xFF4183D7) // Brighter blue when active
                    : Color(0xFF315177),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                onPressed: () => scrollToSection(AppSection.contact),
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
