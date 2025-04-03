import 'package:crypto_tracker/scr/models/coin.dart';
import 'package:crypto_tracker/scr/providers/coins_provider.dart';
import 'package:crypto_tracker/scr/providers/pagination_provider.dart';
import 'package:crypto_tracker/scr/widgets/asset_card.dart';
import 'package:crypto_tracker/scr/widgets/hoverable_cell.dart';
import 'package:crypto_tracker/scr/widgets/score_tooltip.dart';
import 'package:crypto_tracker/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Custom InfoTooltip widget for showing metric descriptions
class InfoTooltip extends StatelessWidget {
  final String title;
  final String description;

  const InfoTooltip({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      constraints: const BoxConstraints(maxWidth: 250),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A5C),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// Map of metric descriptions
final Map<String, String> metricDescriptions = {
  'Age': 'How long the coin has been around—older coins are usually more stable.',
  'Dominance': 'Shows how big the coin is in the overall crypto market.',
  'Adoption': 'Measures how widely held and used the coin is by different investors.',
  'Loyalty': 'Shows how many people are holding the coin long term.',
  'Momentum': 'Reveals whether the coin\'s price is trending up or down.',
  'Crash': 'Shows how far the coin has dropped from its all-time high.',
  'Liquidity': 'Tells you how easy it is to trade the coin without big price swings.',
  'Manipulation': 'Estimates how much control big holders (whales) have over the coin.',
};



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
                        ? const SizedBox(
                            width: 300,
                            height: 200,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : HoverableDataTable(
                            rows: _buildRows(paginatedCoins, startIndex),
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
List<DataRow> _buildRows(List<Coin> coins, int startIndex) {
  return coins.asMap().entries.map((entry) {
    final index = entry.key + startIndex + 1;
    final coin = entry.value;
    final metrics = _calculateAllMetrics(coin);

    return DataRow(
      cells: [
          _buildIndexCell(index),
    _buildNameCell(coin),
    _buildPriceCell(coin),
    _buildChangeCell(coin.priceChangePercentage24h),
    
    _buildMetricCell('Age', metrics['Age']!),
        _buildMetricCell('Dominance', metrics['Dominance']!),
        _buildMetricCell('Adoption', metrics['Adoption']!),
        _buildMetricCell('Loyalty', metrics['Loyalty']!),
        _buildMetricCell('Momentum', metrics['Momentum']!),
        _buildMetricCell('Crash', metrics['Crash']!),
        _buildMetricCell('Liquidity', metrics['Liquidity']!),
        _buildMetricCell('Manipulation', metrics['Manipulation']!),
        _buildOverallScoreCell(coin), 
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

DataCell _buildMetricCell(String metricName, MetricScore metricScore) {
  // Determine rating level based on score
  String ratingLevel = 'medium';
  if (metricScore.score == 100) {
    ratingLevel = 'high';
  } else if (metricScore.score == 0) {
    ratingLevel = 'low';
  }
  
  // Get detailed description for this metric and rating
  final description = metricDescriptionsDetailed[metricName]?[ratingLevel] ?? '';
  
  // Create tooltip content
  final tooltipContent = _buildScoreTooltipContent(metricName, metricScore, description);
  
  return DataCell(
    ScoreTooltip(
      message: tooltipContent,
      child: Center(
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: metricScore.color,
          ),
        ),
      ),
    ),
  );
}

String _buildScoreTooltipContent(String metricName, MetricScore metricScore, String description) {
  final StringBuffer buffer = StringBuffer();
  buffer.writeln('$metricName:');
  buffer.writeln('');
  buffer.writeln('• $description');
  
  return buffer.toString();
}


DataCell _buildOverallScoreCell(Coin coin) {
  final metrics = _calculateAllMetrics(coin);
  
  // Calculate overall score
  double totalScore = 0.0;
  final Map<String, double> weights = MetricWeights.weights;
  
  metrics.forEach((metric, metricScore) {
    totalScore += metricScore.score * (weights[metric] ?? 0.125); // Default to equal weight if not specified
  });
  
  // Round to one decimal place
  final score = double.parse(totalScore.toStringAsFixed(1));
  
  // Get color based on score
  Color scoreColor = _getScoreColor(score);
  
  // Build full tooltip content
  final tooltipContent = _buildFullScoreTooltipContent(metrics);
  
  return DataCell(
    ScoreTooltip(
      message: tooltipContent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: scoreColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: scoreColor.withOpacity(0.4), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$score',
              style: TextStyle(
                color: scoreColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.info_outline,
              color: scoreColor,
              size: 12,
            ),
          ],
        ),
      ),
    ),
  );
}


String _buildFullScoreTooltipContent(Map<String, MetricScore> metrics) {
  final StringBuffer buffer = StringBuffer();
  buffer.writeln('Score Breakdown:');
  buffer.writeln('');
  
  // Get metric descriptions for each metric
  metrics.forEach((metric, score) {
    String ratingLevel = 'medium';
    if (score.score == 100) {
      ratingLevel = 'high';
    } else if (score.score == 0) {
      ratingLevel = 'low';
    }
    
    // Get detailed description
    final description = metricDescriptionsDetailed[metric]?[ratingLevel] ?? '';
    
    buffer.writeln('$metric:');
    buffer.writeln('• $description');
    buffer.writeln('');
  });
  
  // Add total score
  double totalScore = 0;
  final weights = MetricWeights.weights;
  metrics.forEach((metric, score) {
    totalScore += score.score * (weights[metric] ?? 0.125);
  });
  
  buffer.writeln('Final Score: ${totalScore.toStringAsFixed(1)}/100');
  
  return buffer.toString();
}

// Helper function to get color based on score
Color _getScoreColor(double score) {
  if (score >= 80) return Colors.green;
  if (score >= 60) return Colors.lightGreen;
  if (score >= 40) return Colors.amber;
  if (score >= 20) return Colors.orange;
  return Colors.red;
}



  List<DataColumn> _buildColumns() {
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
       'Score', // New overall score column
  ];

    return columns.map((title) {
      if (title == 'Name') {
        return DataColumn(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                size: 12,
                color: Colors.grey[400],
              ),
            ],
          ),
        );
      } else if (title != '#' && metricDescriptions.containsKey(title)) {
        // For metrics columns, add tooltips with explanations
        return DataColumn(
          label: InfoColumnHeader(
            title: title,
            description: metricDescriptions[title] ?? '',
          ),
        );
      } else {
        return DataColumn(label: Text(title));
      }
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


  

String _calculateLiquidity(double marketCap, double volumeToMarketCapRatio) {
  // Convert marketCap to billions for easier comparison
  final marketCapInBillions = marketCap / 1000000000;
  final marketCapInMillions = marketCap / 1000000;
  
  // GREEN (High Liquidity):
  // - Market Cap > $5B OR
  // - Market Cap > $1B AND Volume/Cap > 10%
  if (marketCapInBillions > 5 || (marketCapInBillions > 1 && volumeToMarketCapRatio > 10)) {
    return 'high';
  }
  
  // AMBER (Moderate Liquidity):
  // - Market Cap > $1B AND Volume/Cap > 5% OR
  // - Market Cap > $500M AND Volume/Cap > 10%
  if ((marketCapInBillions > 1 && volumeToMarketCapRatio > 5) || 
      (marketCapInMillions > 500 && volumeToMarketCapRatio > 10)) {
    return 'medium';
  }
  
  // The rest is RED (Low Liquidity)
  return 'low';
}

// Update this in your _calculateAllMetrics function:
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
    'Liquidity': _rateMetric(_calculateLiquidity(marketCap, volumeToMarketCapRatio.toDouble())), // Updated to use new formula
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

// Custom Column Header Widget with Hover Tooltip
class InfoColumnHeader extends StatefulWidget {
  final String title;
  final String description;

  const InfoColumnHeader({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  State<InfoColumnHeader> createState() => _InfoColumnHeaderState();
}

class _InfoColumnHeaderState extends State<InfoColumnHeader> {
  bool _showTooltip = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    // Add a global click listener to hide tooltip when clicking elsewhere
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GestureBinding.instance.pointerRouter.addGlobalRoute(_handleGlobalPointerEvent);
    });
  }

  @override
  void dispose() {
    _hideTooltip();
    // Remove the global click listener
    GestureBinding.instance.pointerRouter.removeGlobalRoute(_handleGlobalPointerEvent);
    super.dispose();
  }

  // Handle clicks outside the tooltip
  void _handleGlobalPointerEvent(PointerEvent event) {
    if (event is PointerDownEvent && _showTooltip) {
      // Check if the click is outside our widget
      final RenderBox box = context.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);
      final size = box.size;
      final Rect widgetRect = Rect.fromLTWH(
        position.dx, 
        position.dy, 
        size.width, 
        size.height
      );
      
      if (!widgetRect.contains(event.position)) {
        _hideTooltip();
      }
    }
  }

  void _showTooltipOverlay() {
    if (_overlayEntry != null) return;
    
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _showTooltip = true;
    });
  }

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _showTooltip = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: 250,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 30),
          child: Material(
            color: Colors.transparent,
            child: InfoTooltip(
              title: widget.title,
              description: widget.description,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          MouseRegion(
            onEnter: (_) {
              setState(() {
                _isHovering = true;
              });
              // Show tooltip on hover
              if (!_showTooltip) {
                _showTooltipOverlay();
              }
            },
            onExit: (_) {
              setState(() {
                _isHovering = false;
              });
              // If tooltip isn't locked (by click), hide on hover exit
              if (!_showTooltip || !_isLocked) {
                _hideTooltip();
              }
            },
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                // Toggle locked state
                if (_showTooltip) {
                  _isLocked = !_isLocked;
                  if (!_isLocked) {
                    // If unlocking and not hovering, hide
                    if (!_isHovering) {
                      _hideTooltip();
                    }
                  }
                } else {
                  _isLocked = true;
                  _showTooltipOverlay();
                }
              },
              child: Icon(
                Icons.info_outline,
                size: 14,
                color: (_showTooltip || _isHovering) ? Colors.white : Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Track if tooltip is locked in place by click
  bool _isLocked = false;
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

