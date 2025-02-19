


import 'package:crypto_tracker/scr/providers/coins_provider.dart';
import 'package:crypto_tracker/scr/widgets/asset_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Assuming you're using Provider for state management

class GridViewWidget extends ConsumerWidget {
  final double width;
  final ScrollController scrollController;

  const GridViewWidget({
    Key? key,
    required this.width,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinProvider = ref.watch<CoinsProvider>(coinsProvider); // Replace with your actual provider type

    // Adjust columns based on width
    int crossAxisCount = width < 400 ? 2 : width < 600 ? 2 : width < 900 ? 3 : 4;
    double aspectRatio = width < 400 ? 0.83 : 0.85; // Taller cards on mobile

    // Define padding based on screen width
    EdgeInsets padding;
    if (width < 400) {
      padding = const EdgeInsets.all(8); // Small screens
    } else if (width < 600) {
      padding = const EdgeInsets.all(16); // Medium screens
    } else if (width < 900) {
      padding = const EdgeInsets.all(24); // Large screens
    } else {
      padding = const EdgeInsets.symmetric(horizontal: 100, vertical: 16); // Very large screens
    }

    return SizedBox(
      height: 700,
      child: Center( // Center the GridView
        child: Padding( // Apply padding
          padding: padding,
          child: GridView.builder(
            shrinkWrap: true,
            controller: scrollController,
            padding: const EdgeInsets.only(bottom: 16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: aspectRatio,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: coinProvider.coins.length,
            itemBuilder: (context, index) => AssetCard(coinData: coinProvider.coins[index]),
          ),
        ),
      ),
    );
  }
}






// Sliver Grid View Widget
class SliverGridViewWidget extends ConsumerWidget {
  final double width;

  const SliverGridViewWidget({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinProvider = ref.watch(coinsProvider);
    
    int crossAxisCount = width < 400 ? 2 : width < 600 ? 2 : width < 900 ? 3 : 4;
    double aspectRatio = width < 400 ? 0.83 : 0.85;

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

    return SliverPadding(
      padding: padding,
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: aspectRatio,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => AssetCard(coinData: coinProvider.coins[index]),
          childCount: coinProvider.coins.length,
        ),
      ),
    );
  }
}