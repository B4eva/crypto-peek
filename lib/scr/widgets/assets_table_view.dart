import 'package:crypto_tracker/scr/models/coin.dart';
import 'package:crypto_tracker/scr/providers/coins_provider.dart';
import 'package:crypto_tracker/scr/providers/pagination_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';





class TableViewWidget extends ConsumerWidget {
  final bool isVeryNarrow;
  final double width;

  const TableViewWidget({
    Key? key,
    required this.isVeryNarrow,
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

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: _getPadding(width),
            child: Container(
              color: const Color(0xFF0C1C30),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: paginatedCoins.isEmpty
                    ? const SizedBox(
                        width: 300,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : DataTable(
                        headingRowHeight: 40,
                        horizontalMargin: 16,
                        columnSpacing: 24,
                        headingRowColor: WidgetStateProperty.all(Colors.transparent),
                        dataRowColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return const Color(0xFF132A46);
                          }
                          return const Color(0xFF132A46);
                        }),
                        dividerThickness: 0.5,
                        columns: _buildColumns(),
                        rows: _buildRows(paginatedCoins),
                      ),
              ),
            ),
          ),
        ),
        // Pagination controls
        _buildPaginationControls(context, ref, paginationState, paginationController),
      ],
    );
  }

  // Rest of the TableViewWidget methods...
  // (Keep your existing table methods here)

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
          
          // Page indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${paginationState.currentPage} of ${paginationState.totalPages}',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          
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

  // Include your existing methods for building table columns and rows here...
  List<DataColumn> _buildColumns() {
    return [
      DataColumn(label: _buildColumnHeader('Name')),
      DataColumn(label: _buildColumnHeader('Amount')),
      DataColumn(label: _buildColumnHeader('7d %')),
      const DataColumn(label: Text('Age', style: _headerTextStyle)),
      const DataColumn(label: Text('Dominance', style: _headerTextStyle)),
      const DataColumn(label: Text('Adoption', style: _headerTextStyle)),
      const DataColumn(label: Text('Loyalty', style: _headerTextStyle)),
      const DataColumn(label: Text('Momentum', style: _headerTextStyle)),
      const DataColumn(label: Text('Crash', style: _headerTextStyle)),
      const DataColumn(label: Text('Liquidity', style: _headerTextStyle)),
      const DataColumn(label: Text('Manipulation', style: _headerTextStyle)),
    ];
  }

  Widget _buildColumnHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.w500),
        ),
        Icon(Icons.arrow_downward, size: 12, color: Colors.grey[400]),
      ],
    );
  }

  List<DataRow> _buildRows(List<Coin> coins) {
    return coins.asMap().entries.map((entry) {
      final index = entry.key + 1;
      final coin = entry.value;
      final priceChange = _calculateSevenDayPriceChange(coin.sparklineIn7d ?? []);
      final isPriceUp = priceChange >= 0;

      // Calculate all metrics for this coin
      final metrics = _calculateAllMetrics(coin);

      return DataRow(
        cells: [
          _buildNameCell(coin, index),
          _buildAmountCell(coin),
          _buildPriceChangeCell(coin, priceChange, isPriceUp),
          // Add all the metric cells
          _buildIndicatorCell(metrics['Age']!),
          _buildIndicatorCell(metrics['Dominance']!),
          _buildIndicatorCell(metrics['Adoption']!),
          _buildIndicatorCell(metrics['Loyalty']!),
          _buildIndicatorCell(metrics['Momentum']!),
          _buildIndicatorCell(metrics['Crash']!),
          _buildIndicatorCell(metrics['Liquidity']!),
          _buildIndicatorCell(metrics['Manipulation']!),
        ],
      );
    }).toList();
  }

  double _calculateSevenDayPriceChange(List<double> prices) {
    if (prices.isEmpty) return 0.0;
    double firstPrice = prices.first;
    double lastPrice = prices.last;
    double priceChange = ((lastPrice - firstPrice) / firstPrice) * 100;
    return double.parse(priceChange.toStringAsFixed(2));
  }

  DataCell _buildNameCell(Coin asset, int index) {
    return DataCell(
      Row(
        children: [
          Text(
            '$index',
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
          const SizedBox(width: 8),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(asset.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            asset.symbol.toUpperCase(),
            style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 12, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  DataCell _buildAmountCell(Coin asset) {
    return DataCell(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '\$${asset.currentPrice.toStringAsFixed(asset.currentPrice < 1 ? 4 : 2)}',
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  DataCell _buildPriceChangeCell(Coin asset, double priceChange, bool isPriceUp) {
    return DataCell(
      Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: isVeryNarrow ? 2 : 4, vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isPriceUp ? const Color(0xFF00DD23) : const Color(0xFFDD0000),
                  ),
                  child: Icon(
                    isPriceUp ? Icons.arrow_upward_sharp : Icons.arrow_downward_sharp,
                    color: Colors.white,
                    size: isVeryNarrow ? 8 : 10,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${priceChange.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: isPriceUp ? const Color(0xFF00DD23) : const Color(0xFFDD0000),
                    fontSize: isVeryNarrow ? 8 : 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataCell _buildIndicatorCell(MetricScore metricScore) {
    return DataCell(
      Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: metricScore.color,
          ),
        ),
      ),
    );
  }

  // Calculate all metrics for a coin
  Map<String, MetricScore> _calculateAllMetrics(Coin coin) {
    // Calculate age based on ATH and ATL dates
    final ageInYears = _estimateCoinAge(coin);
    
    // Get market cap ranking
    final marketCapRank = coin.marketCapRank;
    
    // Calculate volume to market cap ratio for liquidity assessment
    final marketCap = coin.marketCap.toDouble();
    final totalVolume = coin.totalVolume.toDouble();
    final volumeToMarketCapRatio = marketCap > 0 ? (totalVolume / marketCap) * 100 : 0;
    
    // Calculate ATH drop (crash)
    final athPrice = coin.ath;
    final currentPrice = coin.currentPrice;
    final athDropPercentage = athPrice > 0 ? ((athPrice - currentPrice) / athPrice) * 100 : 0;
    
    // Price changes for different time periods
    final priceChange24h = coin.priceChangePercentage24h;
    final priceChange7d = coin.priceChangePercentage7dInCurrency ?? 0;
    
    // Count positive timeframes for momentum
    int positiveTimeframes = 0;
    if (priceChange24h > 0) positiveTimeframes++;
    if (priceChange7d > 0) positiveTimeframes++;
    
    return {
      'Age': _rateMetric(ageInYears >= 5 ? 'high' : (ageInYears >= 2 ? 'medium' : 'low')),
      'Dominance': _rateMetric(marketCapRank <= 50 ? 'high' : (marketCapRank <= 200 ? 'medium' : 'low')),
      'Adoption': _rateMetric(_estimateAdoption(marketCap, totalVolume)),
      'Loyalty': _rateMetric(_estimateLoyalty(double.parse(athDropPercentage.toString()), priceChange7d)),
      'Momentum': _rateMetric(positiveTimeframes >= 2 ? 'high' : (positiveTimeframes >= 1 ? 'medium' : 'low')),
      'Crash': _rateMetric(athDropPercentage < 30 ? 'high' : (athDropPercentage < 70 ? 'medium' : 'low')),
      'Liquidity': _rateMetric(volumeToMarketCapRatio >= 10 ? 'high' : (volumeToMarketCapRatio >= 3 ? 'medium' : 'low')),
      'Manipulation': _rateMetric(_estimateManipulation(marketCap, totalVolume, double.parse(volumeToMarketCapRatio.toString()))),
    };
  }

  double _estimateCoinAge(Coin coin) {
    final now = DateTime.now();
    final timeSinceAtl = now.difference(coin.atlDate).inDays / 365;
    return timeSinceAtl > 0.5 ? timeSinceAtl : 0.5;
  }

  String _estimateAdoption(double marketCap, double totalVolume) {
    if (marketCap > 10000000000) return 'high';
    if (marketCap > 1000000000) return 'medium';
    return 'low';
  }

  String _estimateLoyalty(double athDropPercentage, double priceChange7d) {
    if (athDropPercentage < 50 && priceChange7d >= 0) return 'high';
    if (athDropPercentage < 70) return 'medium';
    return 'low';
  }

  String _estimateManipulation(double marketCap, double totalVolume, double volumeToMarketCapRatio) {
    if (marketCap < 1000000000) {
      if (volumeToMarketCapRatio < 3) return 'high';
      return 'medium';
    }
    
    if (volumeToMarketCapRatio < 1) return 'high';
    if (volumeToMarketCapRatio < 5) return 'medium';
    return 'low';
  }

  MetricScore _rateMetric(String rating) {
    switch (rating.toLowerCase()) {
      case 'high':
        return MetricScore(score: 100, color: Colors.green);
      case 'medium':
        return MetricScore(score: 50, color: Colors.amber);
      case 'low':
        return MetricScore(score: 0, color: Colors.red);
      default:
        return MetricScore(score: 50, color: Colors.amber);
    }
  }

  EdgeInsets _getPadding(double width) {
    if (width < 400) {
      return const EdgeInsets.all(8); // Small screens
    } else if (width < 600) {
      return const EdgeInsets.all(16); // Medium screens
    } else if (width < 900) {
      return const EdgeInsets.all(24); // Large screens
    } else {
      return const EdgeInsets.symmetric(horizontal: 100, vertical: 16); // Very large screens
    }
  }

  static const TextStyle _headerTextStyle = TextStyle(
    color: Colors.grey,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
}

// Also update the SliverTableViewWidget for pagination
class SliverTableViewWidget extends ConsumerWidget {
  final bool isVeryNarrow;
  final double width;

  const SliverTableViewWidget({
    Key? key,
    required this.isVeryNarrow,
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

    return SliverPadding(
      padding: _getPadding(width),
      sliver: SliverToBoxAdapter(
        child: Theme(
          // Override default DataTable theme
          data: Theme.of(context).copyWith(
            dataTableTheme: DataTableThemeData(
              headingTextStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              dataTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0C1C30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: paginatedCoins.isEmpty
                        ? SizedBox(
                            width: 300,
                            height: 200,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : HoverableDataTable(
                            rows: _buildRows(paginatedCoins),
                            columns: _buildColumns(),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildPaginationControls(context, ref, paginationState, paginationController),
            ],
          ),
        ),
      ),
    );
  }

  // Updated row building function
  List<DataRow> _buildRows(List<Coin> coins) {
    return coins.asMap().entries.map((entry) {
      final index = entry.key + 1;
      final coin = entry.value;
      final metrics = _calculateAllMetrics(coin);

      return DataRow(
        cells: [
          _buildIndexCell(index),
          _buildNameCell(coin),
          _buildPriceCell(coin),
          _buildChangeCell(coin.priceChangePercentage24h ?? 0),
          // Use our metrics
          _buildMetricCell(metrics['Age']!),
          _buildMetricCell(metrics['Dominance']!),
          _buildMetricCell(metrics['Adoption']!),
          _buildMetricCell(metrics['Loyalty']!),
          _buildMetricCell(metrics['Momentum']!),
          _buildMetricCell(metrics['Crash']!),
          _buildMetricCell(metrics['Liquidity']!),
          _buildMetricCell(metrics['Manipulation']!),
        ],
      );
    }).toList();
  }

  DataCell _buildIndexCell(int index) {
    return DataCell(
      Row(
        children: [
          Icon(Icons.star_border_outlined, color: Colors.grey[400], size: 12),
          SizedBox(width: 4,),
          Text(
            index.toString(),
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  DataCell _buildNameCell(Coin coin) {
    return DataCell(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(coin.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            coin.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  DataCell _buildPriceCell(Coin coin) {
    return DataCell(
      Text(
        '\$${coin.currentPrice.toStringAsFixed(coin.currentPrice < 1 ? 4 : 2)}',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  DataCell _buildChangeCell(double change) {
    final isPositive = change >= 0;
    return DataCell(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isPositive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPositive ? Icons.arrow_upward : Icons.arrow_downward,
              color: isPositive ? Colors.green : Colors.red,
              size: 12,
            ),
            const SizedBox(width: 4),
            Text(
              '${change.toStringAsFixed(2)}%',
              style: TextStyle(
                color: isPositive ? Colors.green : Colors.red,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Updated to use MetricScore object instead of boolean
  DataCell _buildMetricCell(MetricScore metricScore) {
    return DataCell(
      Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: metricScore.color,
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    // Updated column names to match new metrics
    final columns = [
      '#',
      'Name',
      'Price',
      '24h %',
      'Age',
      'Dominance',
      'Adoption',
      'Loyalty',
      'Momentum',
      'Crash',
      'Liquidity',
      'Manipulation',
    ];

    return columns.map((title) {
      return DataColumn(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title),
            if (title == 'Name' ) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                size: 12,
                color: Colors.grey[400],
              ),
            ] else if(title != '#')...[
              const SizedBox(width: 4),
              Icon(
                Icons.info,
                size: 8,
                color: Colors.grey[400],
              ),
            ],
          ],
        ),
      );
    }).toList();
  }

  EdgeInsets _getPadding(double width) {
    if (width < 400) {
      return const EdgeInsets.all(8);
    } else if (width < 600) {
      return const EdgeInsets.all(16);
    } else if (width < 900) {
      return const EdgeInsets.all(24);
    } else {
      return const EdgeInsets.symmetric(horizontal: 100, vertical: 16);
    }
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

  // Calculate all metrics for a coin
  Map<String, MetricScore> _calculateAllMetrics(Coin coin) {
    // Calculate age based on ATH and ATL dates
    final ageInYears = _estimateCoinAge(coin);
    
    // Get market cap ranking
    final marketCapRank = coin.marketCapRank;
    
    // Calculate volume to market cap ratio for liquidity assessment
    final marketCap = coin.marketCap.toDouble();
    final totalVolume = coin.totalVolume.toDouble();
    final volumeToMarketCapRatio = marketCap > 0 ? (totalVolume / marketCap) * 100 : 0;
    
    // Calculate ATH drop (crash)
    final athPrice = coin.ath;
    final currentPrice = coin.currentPrice;
    final athDropPercentage = athPrice > 0 ? ((athPrice - currentPrice) / athPrice) * 100 : 0;
    
    // Price changes for different time periods
    final priceChange24h = coin.priceChangePercentage24h;
    final priceChange7d = coin.priceChangePercentage7dInCurrency ?? 0;
    
    // Count positive timeframes for momentum
    int positiveTimeframes = 0;
    if (priceChange24h > 0) positiveTimeframes++;
    if (priceChange7d > 0) positiveTimeframes++;
    
    return {
      'Age': _rateMetric(ageInYears >= 5 ? 'high' : (ageInYears >= 2 ? 'medium' : 'low')),
      'Dominance': _rateMetric(marketCapRank <= 50 ? 'high' : (marketCapRank <= 200 ? 'medium' : 'low')),
      'Adoption': _rateMetric(_estimateAdoption(marketCap, totalVolume)),
      'Loyalty': _rateMetric(_estimateLoyalty(double.parse(athDropPercentage.toString()), priceChange7d)),
      'Momentum': _rateMetric(positiveTimeframes >= 2 ? 'high' : (positiveTimeframes >= 1 ? 'medium' : 'low')),
      'Crash': _rateMetric(athDropPercentage < 30 ? 'high' : (athDropPercentage < 70 ? 'medium' : 'low')),
      'Liquidity': _rateMetric(volumeToMarketCapRatio >= 10 ? 'high' : (volumeToMarketCapRatio >= 3 ? 'medium' : 'low')),
      'Manipulation': _rateMetric(_estimateManipulation(marketCap, totalVolume, double.parse(volumeToMarketCapRatio.toString()))),
    };
  }

  double _estimateCoinAge(Coin coin) {
    final now = DateTime.now();
    final timeSinceAtl = now.difference(coin.atlDate).inDays / 365;
    return timeSinceAtl > 0.5 ? timeSinceAtl : 0.5;
  }

  String _estimateAdoption(double marketCap, double totalVolume) {
    if (marketCap > 10000000000) return 'high';
    if (marketCap > 1000000000) return 'medium';
    return 'low';
  }

  String _estimateLoyalty(double athDropPercentage, double priceChange7d) {
    if (athDropPercentage < 50 && priceChange7d >= 0) return 'high';
    if (athDropPercentage < 70) return 'medium';
    return 'low';
  }

  String _estimateManipulation(double marketCap, double totalVolume, double volumeToMarketCapRatio) {
    if (marketCap < 1000000000) {
      if (volumeToMarketCapRatio < 3) return 'high';
      return 'medium';
    }
    
    if (volumeToMarketCapRatio < 1) return 'high';
    if (volumeToMarketCapRatio < 5) return 'medium';
    return 'low';
  }

  MetricScore _rateMetric(String rating) {
    switch (rating.toLowerCase()) {
      case 'high':
        return MetricScore(score: 100, color: Colors.green);
      case 'medium':
        return MetricScore(score: 50, color: Colors.amber);
      case 'low':
        return MetricScore(score: 0, color: Colors.red);
      default:
        return MetricScore(score: 50, color: Colors.amber);
    }
  }
}

// Helper class for metric scoring
class MetricScore {
  final int score;
  final Color color;

  MetricScore({
    required this.score,
    required this.color,
  });
}

class HoverableDataTable extends StatefulWidget {
  final List<DataRow> rows;
  final List<DataColumn> columns;

  const HoverableDataTable({
    Key? key,
    required this.rows,
    required this.columns,
  }) : super(key: key);

  @override
  State<HoverableDataTable> createState() => _HoverableDataTableState();
}

class _HoverableDataTableState extends State<HoverableDataTable> {
  int? hoveredIndex;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowHeight: 40,
      horizontalMargin: 16,
      columnSpacing: 24,
      headingRowColor: WidgetStateProperty.all(Colors.transparent),
      dataRowColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF1B3454); // Darker blue when selected
          }
          if (states.contains(WidgetState.hovered)) {
            return const Color(0xFF162C47); // Slightly lighter when hovered
          }
          return const Color(0xFF132A46); // Default background
        },
      ),
      border: const TableBorder(
        horizontalInside: BorderSide(
          color: Color(0xFF1E3A5C),
          width: 1,
        ),
      ),
      showCheckboxColumn: false,
      columns: widget.columns,
      rows: widget.rows.asMap().entries.map((entry) {
        final index = entry.key;
        final row = entry.value;
        
        return DataRow(
          color: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (index == selectedIndex) {
                return const Color(0xFF132A46); // Selected color
              }
              if (index == hoveredIndex) {
                return const Color(0xFF1B3B64); // Hover color
              }
              return null; // Default/transparent
            },
          ),
          onSelectChanged: (_) {
            setState(() {
              selectedIndex = index == selectedIndex ? null : index;
            });
          },
          cells: row.cells.map((cell) {
            return DataCell(
              MouseRegion(
                onEnter: (_) => setState(() => hoveredIndex = index),
                onExit: (_) => setState(() => hoveredIndex = null),
                child: cell.child,
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}