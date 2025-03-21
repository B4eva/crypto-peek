

import 'package:crypto_tracker/scr/models/coin.dart';
import 'package:crypto_tracker/scr/providers/coins_provider.dart';
import 'package:crypto_tracker/scr/providers/pagination_provider.dart';
import 'package:crypto_tracker/scr/widgets/asset_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




// Paginated grid view
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
    final coinProvider = ref.watch(coinsProvider);
    final paginationState = ref.watch(paginationControllerProvider);
    final paginationController = ref.read(paginationControllerProvider.notifier);

    // Update total pages when coins change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      paginationController.setTotalItems(coinProvider.coins.length);
    });

    // Calculate start and end indices for current page
    final startIndex = (paginationState.currentPage - 1) * paginationState.itemsPerPage;
    final endIndex = startIndex + paginationState.itemsPerPage;
    final paginatedCoins = coinProvider.coins.length > startIndex
        ? coinProvider.coins.sublist(
            startIndex,
            endIndex < coinProvider.coins.length ? endIndex : coinProvider.coins.length,
          )
        : <Coin>[];

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

    return Column(
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: padding,
              child: paginatedCoins.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      shrinkWrap: true,
                      controller: scrollController,
                      padding: const EdgeInsets.only(bottom: 16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: aspectRatio,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: paginatedCoins.length,
                      itemBuilder: (context, index) => AssetCard(coinData: paginatedCoins[index]),
                    ),
            ),
          ),
        ),
        // Pagination controls
        _buildPaginationControls(context, ref, paginationState, paginationController),
      ],
    );
  }

  Widget _buildPaginationControls(
    BuildContext context,
    WidgetRef ref,
    PaginationState paginationState,
    PaginationController paginationController,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: const Color(0xFF0C1C30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Items per page selector
          if (width > 600) // Only show on larger screens
            Row(
              children: [
                Text(
                  'Items per page:',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
                const SizedBox(width: 8),
                _buildItemsPerPageDropdown(paginationState, paginationController),
                const SizedBox(width: 24),
              ],
            ),
          
          // Previous page button
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 16),
            onPressed: paginationState.currentPage > 1
                ? () => paginationController.previousPage()
                : null,
            color: paginationState.currentPage > 1 ? Colors.white : Colors.grey[600],
          ),
          
          // Page indicator with direct page selection
          _buildPageSelector(paginationState, paginationController),
          
          // Next page button
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: paginationState.currentPage < paginationState.totalPages
                ? () => paginationController.nextPage()
                : null,
            color: paginationState.currentPage < paginationState.totalPages
                ? Colors.white
                : Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Widget _buildItemsPerPageDropdown(
    PaginationState paginationState,
    PaginationController paginationController,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF132A46),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<int>(
        value: paginationState.itemsPerPage,
        dropdownColor: const Color(0xFF132A46),
        underline: const SizedBox(),
        style: const TextStyle(color: Colors.white),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        items: [10, 20, 50, 100].map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text('$value'),
          );
        }).toList(),
        onChanged: (int? value) {
          if (value != null) {
            paginationController.setItemsPerPage(value);
          }
        },
      ),
    );
  }

  Widget _buildPageSelector(
    PaginationState paginationState,
    PaginationController paginationController,
  ) {
    // For many pages, show a dropdown instead of buttons
    if (paginationState.totalPages > 10) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF132A46),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButton<int>(
              value: paginationState.currentPage,
              dropdownColor: const Color(0xFF132A46),
              underline: const SizedBox(),
              style: const TextStyle(color: Colors.white),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items: List.generate(paginationState.totalPages, (index) {
                return DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text('${index + 1}'),
                );
              }),
              onChanged: (int? value) {
                if (value != null) {
                  paginationController.goToPage(value);
                }
              },
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'of ${paginationState.totalPages}',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
        ],
      );
    } else {
      // For fewer pages, show page buttons
      return Row(
        children: [
          for (int i = 1; i <= paginationState.totalPages; i++)
            InkWell(
              onTap: () => paginationController.goToPage(i),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: paginationState.currentPage == i
                      ? const Color(0xFF264A78)
                      : const Color(0xFF132A46),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$i',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      );
    }
  }
}

// Sliver grid view with pagination
class SliverGridViewWidget extends ConsumerWidget {
  final double width;

  const SliverGridViewWidget({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinProvider = ref.watch(coinsProvider);
    final paginationState = ref.watch(paginationControllerProvider);
    final paginationController = ref.read(paginationControllerProvider.notifier);

    // Update total pages when coins change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      paginationController.setTotalItems(coinProvider.coins.length);
    });

    // Calculate paginated coins
    final startIndex = (paginationState.currentPage - 1) * paginationState.itemsPerPage;
    final endIndex = startIndex + paginationState.itemsPerPage;
    final paginatedCoins = coinProvider.coins.length > startIndex
        ? coinProvider.coins.sublist(
            startIndex,
            endIndex < coinProvider.coins.length ? endIndex : coinProvider.coins.length,
          )
        : <Coin>[];

    // Adjust cross axis count based on width
    int crossAxisCount = width < 400 ? 2 : width < 600 ? 2 : width < 900 ? 3 : 4;
    
    // More adaptive aspect ratio based on screen size and content
    // Lower aspect ratio means taller cards
    double aspectRatio;
    if (width < 400) {
      aspectRatio = 0.65; // Even taller cards on mobile
    } else if (width < 600) {
      aspectRatio = 0.70;
    } else if (width < 900) {
      aspectRatio = 0.70;
    } else {
      aspectRatio = 0.75;
    }

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

    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: padding,
          sliver: paginatedCoins.isEmpty
              ? const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              : SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: aspectRatio,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 20, // Increased spacing between rows
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => AssetCard(coinData: paginatedCoins[index]),
                    childCount: paginatedCoins.length,
                  ),
                ),
        ),
        SliverToBoxAdapter(
          child: _buildPaginationControls(context, ref, paginationState, paginationController),
        ),
      ],
    );
  }
  Widget _buildPaginationControls(
    BuildContext context,
    WidgetRef ref,
    PaginationState paginationState,
    PaginationController paginationController,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: const Color(0xFF0C1C30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Items per page selector
          if (width > 600) // Only show on larger screens
            Row(
              children: [
                Text(
                  'Items per page:',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
                const SizedBox(width: 8),
                _buildItemsPerPageDropdown(paginationState, paginationController),
                const SizedBox(width: 24),
              ],
            ),
          
          // Previous page button
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 16),
            onPressed: paginationState.currentPage > 1
                ? () => paginationController.previousPage()
                : null,
            color: paginationState.currentPage > 1 ? Colors.white : Colors.grey[600],
          ),
          
          // Page indicator with direct page selection
          _buildPageSelector(paginationState, paginationController),
          
          // Next page button
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: paginationState.currentPage < paginationState.totalPages
                ? () => paginationController.nextPage()
                : null,
            color: paginationState.currentPage < paginationState.totalPages
                ? Colors.white
                : Colors.grey[600],
          ),
        ],
      ),
    );
  }
  
  Widget _buildItemsPerPageDropdown(
    PaginationState paginationState,
    PaginationController paginationController,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF132A46),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<int>(
        value: paginationState.itemsPerPage,
        dropdownColor: const Color(0xFF132A46),
        underline: const SizedBox(),
        style: const TextStyle(color: Colors.white),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        items: [10, 20, 50, 100].map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text('$value'),
          );
        }).toList(),
        onChanged: (int? value) {
          if (value != null) {
            paginationController.setItemsPerPage(value);
          }
        },
      ),
    );
  }

  Widget _buildPageSelector(
    PaginationState paginationState,
    PaginationController paginationController,
  ) {
    // For many pages, show a dropdown instead of buttons
    if (paginationState.totalPages > 10) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF132A46),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButton<int>(
              value: paginationState.currentPage,
              dropdownColor: const Color(0xFF132A46),
              underline: const SizedBox(),
              style: const TextStyle(color: Colors.white),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items: List.generate(paginationState.totalPages, (index) {
                return DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text('${index + 1}'),
                );
              }),
              onChanged: (int? value) {
                if (value != null) {
                  paginationController.goToPage(value);
                }
              },
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'of ${paginationState.totalPages}',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
        ],
      );
    } else {
      // For fewer pages, show page buttons
      return Row(
        children: [
          for (int i = 1; i <= paginationState.totalPages; i++)
            InkWell(
              onTap: () => paginationController.goToPage(i),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: paginationState.currentPage == i
                      ? const Color(0xFF264A78)
                      : const Color(0xFF132A46),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$i',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      );
    }
  }
}