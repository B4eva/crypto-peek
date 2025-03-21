

import 'package:crypto_tracker/scr/models/coin.dart';
import 'package:crypto_tracker/scr/pages/home_page.dart';
import 'package:crypto_tracker/scr/providers/coins_provider.dart';
import 'package:crypto_tracker/scr/widgets/asset_card.dart';
import 'package:crypto_tracker/scr/widgets/assets_grid_view.dart';
import 'package:crypto_tracker/scr/widgets/assets_table_view.dart';
import 'package:crypto_tracker/scr/widgets/drawer_mobile.dart';
import 'package:crypto_tracker/scr/widgets/header_mobile.dart';
import 'package:crypto_tracker/scr/widgets/header_widget.dart';
import 'package:crypto_tracker/scr/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Main CryptoRiskScanner Widget
class CryptoRiskScanner extends ConsumerStatefulWidget {
  const CryptoRiskScanner({Key? key}) : super(key: key);
  
  @override
  _CryptoRiskScannerState createState() => _CryptoRiskScannerState();
}

class _CryptoRiskScannerState extends ConsumerState<CryptoRiskScanner> {
  bool isGridView = true;
  final double maxContentWidth = 1300.0;
  final double kMinDesktopWidth = 600.0;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final coinProvider = ref.watch(coinsProvider);
    
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
                  slivers: [
                    // Header Section
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          if (size.width >= kMinDesktopWidth)
                            const ResponsiveHeader()
                          else
                            HeaderMobile(
                              onLogoTap: () {
                                // Handle logo tap
                              },
                              onMenuTap: () {
                                scaffoldKey.currentState?.openEndDrawer();
                              },
                            ),
                          _buildHeader(context),
                          const SizedBox(height: 12),
                          const FixedSearchBar(),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),

                    // View Toggle Section
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: ViewToggleHeaderDelegate(
                        scrollController: _scrollController,
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
                      isGridView
                          ? SliverGridViewWidget(width: constraints.maxWidth)
                          : SliverTableViewWidget(
                              isVeryNarrow: constraints.maxWidth < 200,
                              width: constraints.maxWidth,
                            ),

                    // Footer Section
                   const  SliverToBoxAdapter(
                      child: Column(
                        children: [
                           SizedBox(height: 40),
                           Footer(),
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
                  ],
                ),
              ),
            ),
          ),
        ),
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
  if (screenWidth < 400) {
    // Mobile
    titleFontSize = 24;
    subtitleFontSize = 10;
    containerWidth = screenWidth * 0.9;
    padding = const EdgeInsets.all(16);
  } else if (screenWidth < 600) {
    // Small tablet
    titleFontSize = 28;
    subtitleFontSize = 10;
    containerWidth = screenWidth * 0.8;
    padding = const EdgeInsets.all(20);
  } else if (screenWidth < 900) {
    // Large tablet
    titleFontSize = 30;
    subtitleFontSize = 11;
    containerWidth = 400;
    padding = const EdgeInsets.all(24);
  } else {
    // Desktop
    titleFontSize = 32;
    subtitleFontSize = 12;
    containerWidth = 450;
    padding = const EdgeInsets.all(24);
  }

  return Container(
    padding: padding,
    child: Column(
      children: [
        Text(
          'Analyze Crypto Without Being an Expert',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF2752E7),
            fontSize: titleFontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: containerWidth,
          child: Text(
            'Uncover market trends, spot risks, and discover hidden gems easily with simple, smart insights — no technical knowledge needed',
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
                            if (value.isNotEmpty) {
                           
                              coinProvider.searchCoins();
                            } 
                           
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
                        Icons.grid_view,
                        color: isGridView ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () => onViewToggle(true),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.table_rows,
                        color: !isGridView ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () => onViewToggle(false),
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