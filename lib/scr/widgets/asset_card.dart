import 'package:crypto_tracker/scr/models/coin.dart';
import 'package:crypto_tracker/scr/widgets/score_tooltip.dart';
import 'package:flutter/material.dart';


// Weights configuration for the scoring system
class MetricWeights {
  static const Map<String, double> weights = {
    'Age': 0.10,          // 10%
    'Dominance': 0.10,    // 10%
    'Adoption': 0.15,     // 15%
    'Loyalty': 0.15,      // 15%
    'Momentum': 0.15,     // 15%
    'Crash': 0.10,        // 10%
    'Liquidity': 0.15,    // 15%
    'Manipulation': 0.10, // 10%
  };
}

class AssetCard extends StatefulWidget {
  final Coin coinData;

  const AssetCard({Key? key, required this.coinData}) : super(key: key);

  @override
  State<AssetCard> createState() => _AssetCardState();
}

class _AssetCardState extends State<AssetCard> {
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
                _buildCardHeader(widget.coinData, isVeryNarrow, context),
                SizedBox(height: isVeryNarrow ? 8 : 12),
                _buildPriceSection(widget.coinData, isVeryNarrow),
                const Divider(thickness: 0.2,),
                SizedBox(height: isVeryNarrow ? 8 : 12),
                buildMetricsDisplay(widget.coinData, isVeryNarrow),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardHeader(Coin coinData, bool isVeryNarrow, BuildContext context) {
    // Calculate the score using the metrics display logic
    final metricsDisplay = MetricsDisplay(coin: coinData, isVeryNarrow: isVeryNarrow);
    final metrics = metricsDisplay._calculateMetricScores();
    final score = _calculateFinalScore(metrics);
    
    // Create tooltip content
    final tooltipContent = _buildScoreTooltipContent(metrics);
    
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
                          style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 10, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: isVeryNarrow ? 8 : 12),
        ScoreTooltip(
          message: tooltipContent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getScoreColor(score).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _getScoreColor(score).withOpacity(0.4), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Score: ${score.toStringAsFixed(1)}',
                  style: TextStyle(
                    color: _getScoreColor(score),
                    fontSize: isVeryNarrow ? 10 : 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.info_outline,
                  color: _getScoreColor(score),
                  size: isVeryNarrow ? 10 : 12,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

String _buildScoreTooltipContent(Map<String, MetricScore> metrics) {
  final StringBuffer buffer = StringBuffer();
  buffer.writeln('Score Breakdown:');
  buffer.writeln('');
  
  // Map of metric descriptions based on rating
  final Map<String, Map<String, String>> metricDescriptions = {
    'Age': {
      'high': 'Long-term project with proven stability',
      'medium': 'Some maturity, but still growing',
      'low': 'Very new or untested project',
    },
    'Dominance': {
      'high': 'Strong market presence and recognition',
      'medium': 'Gaining traction, but not widely adopted yet',
      'low': 'Low visibility and influence in the market',
    },
    'Adoption': {
      'high': 'Broad and healthy user base',
      'medium': 'Some user activity, but room to grow',
      'low': 'Weak adoption and limited real-world use',
    },
    'Loyalty': {
      'high': 'Most holders are long-term believers',
      'medium': 'Mixed sentiment among holders',
      'low': 'Mostly short-term or speculative holders',
    },
    'Momentum': {
      'high': 'Clear upward trend across timeframes',
      'medium': 'Mixed or inconsistent trend signals',
      'low': 'Downward trend in recent months',
    },
    'Crash': {
      'high': 'Holding strong near past highs',
      'medium': 'Significant drop, possible recovery zone',
      'low': 'Heavy crash, confidence likely broken',
    },
    'Liquidity': {
      'high': 'Easy to buy and sell with minimal slippage',
      'medium': 'Tradable but may experience some price impact',
      'low': 'Low activity, harder to exit positions safely',
    },
    'Manipulation': {
      'high': 'Well-distributed supply, low whale influence',
      'medium': 'Some concentration among large holders',
      'low': 'High whale control, risk of manipulation',
    },
  };
  
  // Calculate weighted scores for each metric
  metrics.forEach((metric, score) {
    final weight = MetricWeights.weights[metric]! * 100;
    final weightedScore = score.score * MetricWeights.weights[metric]!;
    
    // Determine rating level based on score
    String ratingLevel = 'medium';
    if (score.score == 100) {
      ratingLevel = 'high';
    } else if (score.score == 0) {
      ratingLevel = 'low';
    }
    
    // Get description text for this metric and rating
    final description = metricDescriptions[metric]?[ratingLevel] ?? '';
    
    buffer.writeln('$metric:');
    buffer.writeln('• $description');
    buffer.writeln('');
  });
  
  // Add total score
  double totalScore = 0;
  metrics.forEach((metric, score) {
    totalScore += score.score * MetricWeights.weights[metric]!;
  });
  
  buffer.writeln('Final Score: ${totalScore.toStringAsFixed(1)}/100');
  
  return buffer.toString();
}


  // Calculate the final score based on metrics and weights
  double _calculateFinalScore(Map<String, MetricScore> metrics) {
    double finalScore = 0.0;
    metrics.forEach((metric, metricScore) {
      finalScore += metricScore.score * MetricWeights.weights[metric]!;
    });
    return finalScore;
  }

  // Get color based on the score
  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.lightGreen;
    if (score >= 40) return Colors.amber;
    if (score >= 20) return Colors.orange;
    return Colors.red;
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
        const SizedBox(width: 4,),
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
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPriceUp ? const Color(0xFF00DD23) : const Color(0xFFDD0000),
                    ),
                    child: Icon(
                      Icons.arrow_upward_sharp,
                      color: Colors.white,
                      size: isVeryNarrow ? 8 : 10,
                    ),
                  ) : Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPriceUp ? const Color(0xFF00DD23) : const Color(0xFFDD0000),
                    ),
                    child: Icon(
                      Icons.arrow_downward_sharp,
                      color: Colors.white,
                      size: isVeryNarrow ? 8 : 10,
                    ),
                  ),
                  const SizedBox(width: 4,),
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
            const SizedBox(width: 4,),
            Text(
              '(Last 24hrs)',
              style: TextStyle(
                color: const Color(0xFFACACAC),
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


class MetricsDisplay extends StatelessWidget {
  final Coin coin;
  final bool isVeryNarrow;

  const MetricsDisplay({
    Key? key,
    required this.coin,
    required this.isVeryNarrow,
  }) : super(key: key);

  // Updated liquidity calculation function based on the provided formula
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
      'Liquidity': _rateMetric(_calculateLiquidity(marketCap, volumeToMarketCapRatio.toDouble())), 
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
        const SizedBox(height: 8),
        _buildMetricsRow('Adoption', metrics['Adoption']!, 'Loyalty', metrics['Loyalty']!, isVeryNarrow),
        const SizedBox(height: 8),
        _buildMetricsRow('Momentum', metrics['Momentum']!, 'Crash', metrics['Crash']!, isVeryNarrow),
        const SizedBox(height: 8),
        _buildMetricsRow('Liquidity', metrics['Liquidity']!, 'Manipulation', metrics['Manipulation']!, isVeryNarrow),
      ],
    );
  }

  Widget _buildMetricsRow(String label1, MetricScore score1, String label2, MetricScore score2, bool isVeryNarrow) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildMetric(label1, score1.color, isVeryNarrow)),
        const SizedBox(width: 8),
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
              color: const Color(0xFFACACAC),
              fontSize: isVeryNarrow ? 9 : 12,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
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





