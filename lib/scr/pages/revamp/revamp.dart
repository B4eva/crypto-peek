

import 'package:crypto_tracker/scr/models/coin.dart';

import 'package:crypto_tracker/scr/providers/coins_provider.dart';
import 'package:crypto_tracker/scr/providers/navigation_provider.dart';
import 'package:crypto_tracker/scr/widgets/asset_card.dart';
import 'package:crypto_tracker/scr/widgets/assets_grid_view.dart';

import 'package:crypto_tracker/scr/widgets/drawer_mobile.dart';
import 'package:crypto_tracker/scr/widgets/footer.dart';
import 'package:crypto_tracker/scr/widgets/gradient_text.dart';
import 'package:crypto_tracker/scr/widgets/header_mobile.dart';

import 'package:crypto_tracker/scr/widgets/sliver_table_view.dart';
import 'package:crypto_tracker/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
class CryptoRiskScanner extends ConsumerStatefulWidget {
  const CryptoRiskScanner({Key? key}) : super(key: key);
  
  @override
  ConsumerState<CryptoRiskScanner> createState() => _CryptoRiskScannerState();
}

class _CryptoRiskScannerState extends ConsumerState<CryptoRiskScanner> {
  bool isGridView = false;
  final double maxContentWidth = 1300.0;
  final double kMinDesktopWidth = 600.0;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController controller = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    // Calculate section positions after layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navController = ref.read(navigationControllerProvider);
      navController.updateSectionPositions(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final coinProvider = ref.watch(coinsProvider);
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    // Get the navigation controller
    final navController = ref.watch(navigationControllerProvider);
    final currentSection = navController.currentSection;
    
    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        key: scaffoldKey,
        endDrawer: (constraints.maxWidth >= kMinDesktopWidth)
            ? null
            : const MobileDrawer(),
        backgroundColor: const Color(0xFF0C1C30),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width >= kMinDesktopWidth ? 24 : 12
                ),
                child: CustomScrollView(
                  controller: navController.scrollController, // Use the controller from navigationController
                  slivers: [
                    // Header Section
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          if (size.width >= kMinDesktopWidth)
                            _buildDesktopHeader(currentSection, navController)
                          else
                            HeaderMobile(
                              onLogoTap: () {
                                navController.scrollToSection(AppSection.home);
                              },
                              onMenuTap: () {
                                scaffoldKey.currentState?.openEndDrawer();
                              },
                            ),
                          
                          // Home section with key
                          SizedBox(key: navController.homeKey, height: 1), // Invisible marker for home section
                          _buildHeader(context),
                          const SizedBox(height: 12),
                      
                          Container(
                            width: 350,
                            margin: const EdgeInsets.symmetric(horizontal: 16.0),
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFF132A46),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: coinProvider.controller,
                                    style: TextStyle(fontSize: 12, color: Colors.white),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Search Coin",
                                    ),
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        isSearching = true;
                                        coinProvider.searchCoins();
                                      } else {
                                        isSearching = false;
                                        coinProvider.clearSearch();
                                      }
                                      setState(() {});
                                    },
                                  ),
                                ),
                                Icon(Icons.search, color: Colors.grey),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),

                    // View Toggle Section
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: ViewToggleHeaderDelegate(
                        scrollController: navController.scrollController,
                        isGridView: isGridView,
                        onViewToggle: (bool isGrid) {
                          setState(() => isGridView = isGrid);
                        },
                        width: constraints.maxWidth,
                      ),
                    ),

                    // Content Section
                    if (coinProvider.isLoading)
                      const SliverFillRemaining(
                        child: Center(
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    else
                      !isGridView
                          ? 
                                       // Calculator Section
                   SliverTableViewWidget(
                              isVeryNarrow: constraints.maxWidth < 200,
                              width: constraints.maxWidth,
                            ): SliverGridViewWidget(width: constraints.maxWidth),

               // Footer Section (Contact)
                    SliverToBoxAdapter(
                      child: Container(
                        key: navController.contactKey, // Important: Key for contact section
                        child: const Column(
                          children: [
                            SizedBox(height: 40),
                          
                            SizedBox(height: 20),
                            // Add contact form or content here
                        //    const Footer(),
                            SizedBox(height: 30),
                            Divider(),
                            SizedBox(height: 30),
                            Text(
                              '© 2025. All rights reserved.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFA0A3A9),
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Desktop header with navigation
  Widget _buildDesktopHeader(AppSection currentSection, NavigationController navController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo and Brand Name
          Row(
            children: [
 Image.asset(
                 'assets/images/coinpeek-white.png',
             
         height: 60,
         width: 60,
         fit: BoxFit.cover,
 
),
           SizedBox(width: 5,), 
              const Text(
                "CoinPeek",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              
              
              // const SizedBox(width: 20),
            ],
          ),
          
          // Navigation Items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => navController.scrollToSection(AppSection.home),
                child: Text(
                  "Home",
                  style: TextStyle(
                    color: currentSection == AppSection.home ? Colors.white : Colors.grey,
                    fontSize: 15,
                    fontWeight: currentSection == AppSection.home ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () => navController.scrollToSection(AppSection.calculator),
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
              const SizedBox(width: 10),
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
                onPressed: () => navController.scrollToSection(AppSection.contact),
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

  Widget _buildHeader(BuildContext context) {
    // Get the screen width to make responsive adjustments
    double screenWidth = MediaQuery.of(context).size.width;
    
    // Define responsive font sizes
    double titleFontSize;
    double subtitleFontSize;
    double containerWidth;
    EdgeInsets padding;
    
    // Adjust sizes based on screen width
    if (screenWidth < 450) {
      // Mobile
      titleFontSize = 24;
      subtitleFontSize = 13;
      containerWidth = screenWidth * 0.9;
      padding = const EdgeInsets.all(16);
    } else if (screenWidth < 600) {
      // Small tablet
      titleFontSize = 28;
      subtitleFontSize = 14;
      containerWidth = screenWidth * 0.8;
      padding = const EdgeInsets.all(20);
    } else if (screenWidth < 900) {
      // Large tablet
      titleFontSize = 30;
      subtitleFontSize = 16;
      containerWidth = 400;
      padding = const EdgeInsets.all(24);
    } else {
      // Desktop
      titleFontSize = 32;
      subtitleFontSize = 16;
      containerWidth = 450;
      padding = const EdgeInsets.all(24);
    }

    return Container(
      padding: padding,
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 24.0,
              ),
              children: [
                TextSpan(
                  text: "See Crypto ",
                  style: TextStyle(
                    color: const Color(0xFF2752E7),
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: "Differently",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: titleFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: containerWidth,
            child: Text(
              'Never miss a beat. CoinPeek is your early warning system for crypto — transforming noisy, complex data into clear, explainable signals that help you avoid bad bets and uncover hidden opportunities',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFFFFFFFF),
                fontSize: subtitleFontSize,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }


}



// Persistent Header Delegate for View Toggle with Animated Search
class ViewToggleHeaderDelegate extends SliverPersistentHeaderDelegate {
  final bool isGridView;
  final Function(bool) onViewToggle;
  final double width;
  final ScrollController scrollController;

  ViewToggleHeaderDelegate({
    required this.isGridView,
    required this.onViewToggle,
    required this.width,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {

    TextEditingController controller = TextEditingController();

    // Calculate the opacity of the search bar based on scroll offset
    final double searchOpacity = shrinkOffset > 0 ? 1.0 : 0.0;
    
    EdgeInsets padding;
    if (width < 400) {
      padding = const EdgeInsets.all(8);
    } else if (width < 600) {
      padding = const EdgeInsets.all(16);
    } else if (width < 900) {
      padding = const EdgeInsets.all(24);
    } else {
      padding = const EdgeInsets.symmetric(horizontal: 100, vertical: 16);
    }

    return Consumer(
      builder: (context, ref, child) { 
final coinProvider = ref.watch<CoinsProvider>(coinsProvider);
      return 
      Container(
        height: 100,
        color: const Color(0xFF0C1C30),
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Assets',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: AnimatedOpacity(
                  duration:  Duration(milliseconds: 200),
                  opacity: searchOpacity,
                  child: Container(
                    width: 350,
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF132A46),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: coinProvider.controller,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search Coin",
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                         onChanged: (value) {
  print("Searching for revam main search=============>: $value");
  if (value.isNotEmpty) {
    // isSearching = true;
    coinProvider.searchCoins();
  } else {
    // isSearching = false;
    coinProvider.clearSearch();
  }
 // setState(() {});
},
                          ),
                        ),
                        const Icon(Icons.search, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
            
            
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: const BoxDecoration(
                  color: Color(0xFF132A46),
                ),
                child: Row(
                  children: [
                     IconButton(
                      icon: Icon(
                        Icons.table_rows,
                        color: !isGridView ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () => onViewToggle(false),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.grid_view,
                        color: isGridView ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () => onViewToggle(true),
                    ),
                   
                  ],
                ),
              ),
            ],
          ),
        ),
        );}
    );
  }

  @override
  double get maxExtent => 90;

  @override
  double get minExtent => 90;

  @override
  bool shouldRebuild(covariant ViewToggleHeaderDelegate oldDelegate) {
    return oldDelegate.isGridView != isGridView ||
        oldDelegate.width != width;
  }
}