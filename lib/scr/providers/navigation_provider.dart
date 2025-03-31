
import 'package:crypto_tracker/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



// Create a provider for the controller
final navigationControllerProvider = ChangeNotifierProvider<NavigationController>((ref) {
  return NavigationController();
});

// Create a navigation controller class
class NavigationController extends ChangeNotifier {
  AppSection _currentSection = AppSection.home;
  final ScrollController scrollController = ScrollController();
  
  // Section position thresholds - adjust based on your layout
  double calculatorThreshold = 600;
  double contactThreshold = 1200;
  
  // Section keys for position calculation
  final homeKey = GlobalKey();
  final calculatorKey = GlobalKey();
  final contactKey = GlobalKey();
  
  AppSection get currentSection => _currentSection;
  
  NavigationController() {
    // Add scroll listener
    scrollController.addListener(_updateCurrentSection);
  }
  
  @override
  void dispose() {
    scrollController.removeListener(_updateCurrentSection);
    scrollController.dispose();
    super.dispose();
  }
  
  // Update section based on scroll position
  void _updateCurrentSection() {
    if (!scrollController.hasClients) return;
    
    final double offset = scrollController.offset;
    AppSection newSection;
    
    if (offset < calculatorThreshold) {
      newSection = AppSection.home;
    } else if (offset < contactThreshold) {
      newSection = AppSection.calculator;
    } else {
      newSection = AppSection.contact;
    }
    
    if (_currentSection != newSection) {
      _currentSection = newSection;
      notifyListeners();
    }
  }
  
  // Method to calculate actual section positions once layout is complete
  void updateSectionPositions(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Update thresholds based on actual positions
      final calculatorContext = calculatorKey.currentContext;
      final contactContext = contactKey.currentContext;
      
      if (calculatorContext != null) {
        final RenderBox box = calculatorContext.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero);
        calculatorThreshold = position.dy - 100; // Subtract header height
      }
      
      if (contactContext != null) {
        final RenderBox box = contactContext.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero);
        contactThreshold = position.dy - 100; // Subtract header height
      }
    });
  }
  
  // Public method to scroll to section
  void scrollToSection(AppSection section) {
    double scrollPosition;
    
    switch (section) {
      case AppSection.home:
        scrollPosition = 0;
        break;
      case AppSection.calculator:
        scrollPosition = calculatorThreshold;
        break;
      case AppSection.contact:
        scrollPosition = contactThreshold;
        break;
    }
    
    // Animate to position
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
    
    // Update current section
    _currentSection = section;
    notifyListeners();
  }
}
