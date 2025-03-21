import 'package:crypto_tracker/scr/models/coin.dart';
import 'package:flutter/material.dart';

class AssetCard extends StatelessWidget {
  final Coin coinData;

  const AssetCard({Key? key, required this.coinData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isVeryNarrow = constraints.maxWidth < 200;

        return Card(
          color: const Color(0xFF132A46),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(isVeryNarrow ? 8 : 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardHeader(coinData, isVeryNarrow),
                SizedBox(height: isVeryNarrow ? 8 : 12),
                _buildPriceSection(coinData, isVeryNarrow),
                Divider(thickness: 0.2,),
                SizedBox(height: isVeryNarrow ? 8 : 12),
                buildMetricsDisplay(coinData, isVeryNarrow),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardHeader(Coin coinData, bool isVeryNarrow) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: isVeryNarrow ? 32 : 36,
                height: isVeryNarrow ? 32 : 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  image: DecorationImage(
                    image: NetworkImage(coinData.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            coinData.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isVeryNarrow ? 12 : 14,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '(${(coinData.symbol).toUpperCase()})',
                          style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.share, size: isVeryNarrow ? 14 : 16,),
          onPressed: () {},
          color: Colors.grey[400],
        ),
      ],
    );
  }

  Widget _buildPriceSection(Coin coinData, bool isVeryNarrow) {
    // Function to calculate price change percentage over 24 hours
    double calculate24HourPriceChange(List<double>? prices) {
      if (prices == null || prices.isEmpty) {
        // If sparkline data isn't available, use the API-provided 24h change
        return coinData.priceChangePercentage24h;
      }
      
      // Determine number of data points - CoinGecko typically provides
      // hourly data points for the last 7 days (168 hours)
      // So we'll use the last 24 points to represent 24 hours
      final dataPointsPer24Hours = 24;
      
      int startIndex = prices.length - dataPointsPer24Hours;
      startIndex = startIndex < 0 ? 0 : startIndex;
      
      double priceFrom24HoursAgo = prices[startIndex];
      double currentPrice = prices.last;

      double priceChange = ((currentPrice - priceFrom24HoursAgo) / priceFrom24HoursAgo) * 100;

      return double.parse(priceChange.toStringAsFixed(2));
    }

    // Use API-provided 24h change if available, otherwise calculate it
    double priceChange = coinData.priceChangePercentage24h;
    if (coinData.sparklineIn7d != null && coinData.sparklineIn7d!.isNotEmpty) {
      // Optionally use the calculated value if you prefer
      // priceChange = calculate24HourPriceChange(coinData.sparklineIn7d);
    }
    
    bool isPriceUp = priceChange >= 0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: isVeryNarrow ? 10 : 12,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              '\$ ${coinData.currentPrice.toStringAsFixed(coinData.currentPrice < 1 ? 4 : 2)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: isVeryNarrow ? 14 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(width: 4,),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isVeryNarrow ? 2 : 4,
                vertical: 2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isPriceUp ? Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPriceUp ? Color(0xFF00DD23) : Color(0xFFDD0000),
                    ),
                    child: Icon(
                      Icons.arrow_upward_sharp,
                      color: Colors.white,
                      size: isVeryNarrow ? 8 : 10,
                    ),
                  ) : Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPriceUp ? Color(0xFF00DD23) : Color(0xFFDD0000),
                    ),
                    child: Icon(
                      Icons.arrow_downward_sharp,
                      color: Colors.white,
                      size: isVeryNarrow ? 8 : 10,
                    ),
                  ),
                  SizedBox(width: 4,),
                  Text(
                    '${priceChange.toStringAsFixed(2)}%',
                 
                    style: TextStyle(
                      color: isPriceUp ? Color(0xFF00DD23) : Color(0xFFDD0000),
                      fontSize: isVeryNarrow ? 8 : 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4,),
            Text(
              '(Last 24hrs)',
              style: TextStyle(
                color: Color(0xFFACACAC),
                fontSize: isVeryNarrow ? 8 : 10,
                fontWeight: FontWeight.w400
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Updated MetricsDisplay class with new metrics
class MetricsDisplay extends StatelessWidget {
  final Coin coin;
  final bool isVeryNarrow;

  const MetricsDisplay({
    Key? key,
    required this.coin,
    required this.isVeryNarrow,
  }) : super(key: key);

  // Calculate metric scores based on the provided criteria
  Map<String, MetricScore> _calculateMetricScores() {
    // Calculate age based on ATH and ATL dates
    final ageInYears = _estimateCoinAge();
    
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
      'Loyalty': _rateMetric(_estimateLoyalty(double.parse(athDropPercentage.toStringAsFixed(2)), priceChange7d)),
      'Momentum': _rateMetric(positiveTimeframes >= 2 ? 'high' : (positiveTimeframes >= 1 ? 'medium' : 'low')),
      'Crash': _rateMetric(athDropPercentage < 30 ? 'high' : (athDropPercentage < 70 ? 'medium' : 'low')),
      'Liquidity': _rateMetric(volumeToMarketCapRatio >= 10 ? 'high' : (volumeToMarketCapRatio >= 3 ? 'medium' : 'low')),
      'Manipulation': _rateMetric(_estimateManipulation(marketCap, totalVolume, double.parse(volumeToMarketCapRatio.toStringAsFixed(2)))),
    };
  }

  // Helper methods for metric calculations
  double _estimateCoinAge() {
    // If we have ATL date, we can use that as an approximation of age
    // (ATL often occurs near a coin's launch)
    final now = DateTime.now();
    final timeSinceAtl = now.difference(coin.atlDate).inDays / 365;
    
    // Reasonable minimum age
    return timeSinceAtl > 0.5 ? timeSinceAtl : 0.5;
  }

  String _estimateAdoption(double marketCap, double totalVolume) {
    // Using criteria from the screenshots
    if (marketCap > 10000000000) return 'high'; // $10B+ market cap = high adoption
    if (marketCap > 1000000000) return 'medium'; // $1B+ market cap = medium adoption
    return 'low'; // Low market cap = low adoption
  }

  String _estimateLoyalty(double athDropPercentage, double priceChange7d) {
    // Lower ATH drop and positive recent movement suggest higher loyalty
    if (athDropPercentage < 50 && priceChange7d >= 0) return 'high';
    if (athDropPercentage < 70) return 'medium';
    return 'low';
  }

  String _estimateManipulation(double marketCap, double totalVolume, double volumeToMarketCapRatio) {
    // Based on the screenshots:
    // - Low whale % is good (green)
    // - High whale % is bad (red)
    
    // For lower market cap coins, manipulation risk is higher
    if (marketCap < 1000000000) {
      // Small cap coins with low volume are at high risk
      if (volumeToMarketCapRatio < 3) return 'high';
      return 'medium';
    }
    
    // For large market cap coins
    if (volumeToMarketCapRatio < 1) return 'high'; // Very low volume compared to market cap
    if (volumeToMarketCapRatio < 5) return 'medium';
    return 'low'; // Good volume to market cap ratio
  }

  MetricScore _rateMetric(String rating) {
    // Convert rating string to MetricScore object with appropriate colors
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

  @override
  Widget build(BuildContext context) {
    final metrics = _calculateMetricScores();
    
    // Group metrics into rows of 2
    return Column(
      children: [
        _buildMetricsRow('Age', metrics['Age']!, 'Dominance', metrics['Dominance']!, isVeryNarrow),
        SizedBox(height: 8),
        _buildMetricsRow('Adoption', metrics['Adoption']!, 'Loyalty', metrics['Loyalty']!, isVeryNarrow),
        SizedBox(height: 8),
        _buildMetricsRow('Momentum', metrics['Momentum']!, 'Crash', metrics['Crash']!, isVeryNarrow),
        SizedBox(height: 8),
        _buildMetricsRow('Liquidity', metrics['Liquidity']!, 'Manipulation', metrics['Manipulation']!, isVeryNarrow),
      ],
    );
  }

  Widget _buildMetricsRow(String label1, MetricScore score1, String label2, MetricScore score2, bool isVeryNarrow) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildMetric(label1, score1.color, isVeryNarrow)),
        SizedBox(width: 8),
        Expanded(child: _buildMetric(label2, score2.color, isVeryNarrow)),
      ],
    );
  }

  Widget _buildMetric(String label, Color color, bool isVeryNarrow) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Color(0xFFACACAC),
              fontSize: isVeryNarrow ? 9 : 12,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 4),
        Container(
          width: isVeryNarrow ? 6 : 8,
          height: isVeryNarrow ? 6 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ],
    );
  }
}

// Helper class to organize metric scores
class MetricScore {
  final int score;
  final Color color;

  MetricScore({
    required this.score,
    required this.color,
  });
}

// Usage example
Widget buildMetricsDisplay(Coin coin, bool isVeryNarrow) {
  return MetricsDisplay(
    coin: coin,
    isVeryNarrow: isVeryNarrow,
  );
}