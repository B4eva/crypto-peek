

import 'package:crypto_tracker/scr/models/coin.dart';
import 'package:crypto_tracker/scr/providers/coins_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Assuming you're using Provider for state management

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
    final coinProvider = ref.watch(coinsProvider);  // Replace with your actual provider type

    return Padding(
      padding: _getPadding(width),
      child: Container(
        color: const Color(0xFF0C1C30),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowHeight: 40,
            horizontalMargin: 16,
            columnSpacing: 24,
            headingRowColor: MaterialStateProperty.all(Colors.transparent),
            dataRowColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return const Color(0xFF132A46);
              }
              return const Color(0xFF132A46);
            }),
            dividerThickness: 0.5,
            columns: _buildColumns(),
            rows: _buildRows(coinProvider),
          ),
        ),
      ),
    );
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

  List<DataColumn> _buildColumns() {
    return [
      DataColumn(
        label: _buildColumnHeader('Name'),
      ),
      DataColumn(
        label: _buildColumnHeader('Amount'),
      ),
      DataColumn(
        label: _buildColumnHeader('7d %'),
      ),
      const DataColumn(
        label: Text('Maturity', style: _headerTextStyle),
      ),
      const DataColumn(
        label: Text('Dominance', style: _headerTextStyle),
      ),
      const DataColumn(
        label: Text('Performance', style: _headerTextStyle),
      ),
      const DataColumn(
        label: Text('Loyalty', style: _headerTextStyle),
      ),
      const DataColumn(
        label: Text('Liquidity', style: _headerTextStyle),
      ),
      const DataColumn(
        label: Text('Whale Manipulation', style: _headerTextStyle),
      ),
    ];
  }

  Widget _buildColumnHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style:  TextStyle(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.w500),
        ),
         Icon(Icons.arrow_downward, size: 12, color: Colors.grey[400]),
      ],
    );
  }

  List<DataRow> _buildRows(CoinsProvider coinProvider) {
    return coinProvider.coins.asMap().entries.map((entry) {
      final index = entry.key + 1;
      final asset = entry.value;
      final priceChange = _calculateSevenDayPriceChange(asset.sparklineIn7d ?? []);
      final isPriceUp = priceChange >= 0;

      return DataRow(
        cells: [
          _buildNameCell(asset, index),
          _buildAmountCell(asset),
          _buildPriceChangeCell(asset, priceChange, isPriceUp),
          ...asset.calculateIndicators().map((isPositive) => _buildIndicatorCell(isPositive)),
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
            asset.symbol,
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
            '\$${asset.currentPrice.toStringAsFixed(2)}',
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
                  '$priceChange%',
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

  DataCell _buildIndicatorCell(bool isPositive) {
    return DataCell(
      Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isPositive ? Colors.green : Colors.red,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  static const TextStyle _headerTextStyle = TextStyle(
    color: Colors.grey,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );


}






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
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0C1C30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
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
                  showCheckboxColumn: false, // Hide checkbox column
                  rows: _buildRows(coinProvider),
                  columns: _buildColumns(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DataRow> _buildRows(CoinsProvider coinProvider) {
    return coinProvider.coins.asMap().entries.map((entry) {
      final index = entry.key + 1;
      final coin = entry.value;
      final indicators = _calculateIndicators(
          priceChange24h: coin.priceChangePercentage24h ?? 0,
    priceChange7d: coin.priceChangePercentage7dInCurrency ?? 0,
    priceChange30d: coin.priceChangePercentage24h ?? 0,
    marketCap: coin.marketCap.toDouble(),
    totalVolume: coin.totalVolume.toDouble(),
  
      );

      return DataRow(
        onSelectChanged: (_) {}, // Enable hover effect
        cells: [
          _buildIndexCell(index),
          _buildNameCell(coin),
          _buildPriceCell(coin),
          _buildChangeCell(coin.priceChangePercentage24h ?? 0),
          ...indicators.map(_buildIndicatorCell),
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
        '\$${coin.currentPrice.toStringAsFixed(2)}',
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
              '${change.abs().toStringAsFixed(2)}%',
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

  DataCell _buildIndicatorCell(bool isPositive) {
    return DataCell(
      Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isPositive ? Colors.green : Colors.red,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    final columns = [
      '#',
      'Name',
      'Price',
      '24h %',
      'Maturity',
      'Dominance',
      'Performance',
      'Loyalty',
      'Liquidity',
      'Whales Manipulation',
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

  List<bool> _calculateIndicators({
    required double priceChange24h,
    required double priceChange7d,
    required double priceChange30d,
    required double marketCap,
    required double totalVolume,
  }) {
    return [
      priceChange30d > 0,
      marketCap > 1000000000,
      priceChange7d > 0,
      priceChange24h > 0,
      totalVolume > 100000000,
      marketCap / totalVolume > 100,
    ];
  }
}