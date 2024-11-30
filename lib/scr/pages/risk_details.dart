import 'package:flutter/material.dart';

class RiskAssessmentTable extends StatelessWidget {
  final Map<String, dynamic> riskData;

  const RiskAssessmentTable({super.key, required this.riskData});

  @override
  Widget build(BuildContext context) {
    final headers = ["Criteria", "Ratings", "Coin Value", "Explanation"];

    // Create a list to hold the data rows
    List<List<String>> data = [];

    // Populate the data based on riskData
    data.add([
      "Year Founded",
      _assessYearFounded(riskData["Year Founded"]),
      riskData["Year Founded"] ?? "N/A",
      _getYearFoundedExplanation(riskData["Year Founded"]),
    ]);
    data.add([
      "Exchanges Listed",
      _assessExchangesListed(riskData["Exchanges Listed"]),
      riskData["Exchanges Listed"] ?? "N/A",
      _getExchangesListedExplanation(riskData["Exchanges Listed"]),
    ]);
    data.add([
      "Market Capitalization (USD)",
      _assessMarketCap(riskData["Market Capitalization"]),
      riskData["Market Capitalization"]?.toString() ?? "N/A",
      _getMarketCapExplanation(riskData["Market Capitalization"]),
    ]);
    data.add([
      "Trading Volume (USD)",
      _assessTradingVolume(riskData["Trading Volume"]),
      riskData["Trading Volume"]?.toString() ?? "N/A",
      _getTradingVolumeExplanation(riskData["Trading Volume"]),
    ]);
    data.add([
      "Price Changes (%)",
      _assessPriceChanges(riskData["Price Change (1D)"],
          riskData["Price Change (7D)"], riskData["Price Change (30D)"]),
      riskData["Price Change (7D)"]?.toString() ?? "N/A",
      _getPriceChangesExplanation(riskData["Price Change (1D)"],
          riskData["Price Change (7D)"], riskData["Price Change (30D)"]),
    ]);
    data.add([
      "1-Year Price Change (%)",
      _assessOneYearPriceChange(riskData["Price Change (1Y)"]),
      riskData["Price Change (1Y)"]?.toString() ?? "N/A",
      _getOneYearPriceChangeExplanation(riskData["Price Change (1Y)"]),
    ]);
    data.add([
      "All-Time High (USD)",
      _assessAllTimeHigh(riskData["All-Time High"], riskData["Current Price"]),
      riskData["All-Time High"]?.toString() ?? "N/A",
      _getAllTimeHighExplanation(
          riskData["All-Time High"], riskData["Current Price"]),
    ]);
    data.add([
      "All-Time Low (USD)",
      _assessAllTimeLow(riskData["All-Time Low"], riskData["Current Price"]),
      riskData["All-Time Low"]?.toString() ?? "N/A",
      _getAllTimeLowExplanation(
          riskData["All-Time Low"], riskData["Current Price"]),
    ]);
    data.add([
      "Whale Holdings (%)",
      _assessWhaleHoldings(riskData["Whale Holdings"]),
      riskData["Whale Holdings"]?.toString() ?? "N/A",
      _getWhaleHoldingsExplanation(riskData["Whale Holdings"]),
    ]);
    data.add([
      "Addresses by Holdings (%)",
      _assessAddressesByHoldings(riskData["0-\$1k Holdings"]),
      riskData["0-\$1k Holdings"]?.toString() ?? "N/A",
      _getAddressesByHoldingsExplanation(riskData["0-\$1k Holdings"]),
    ]);
    data.add([
      "Addresses by Time Held (%)",
      _assessAddressesByTimeHeld(
          riskData["Hodlers (> 1 year)"], riskData["Traders (< 1 month)"]),
      riskData["Hodlers (> 1 year)"]?.toString() ?? "N/A",
      _getAddressesByTimeHeldExplanation(
          riskData["Hodlers (> 1 year)"], riskData["Traders (< 1 month)"]),
    ]);
    data.add([
      "Community Sentiment (%)",
      _assessCommunitySentiment(
          riskData["Bullish Sentiment"], riskData["Bearish Sentiment"]),
      riskData["Bullish Sentiment"]?.toString() ?? "N/A",
      _getCommunitySentimentExplanation(
          riskData["Bullish Sentiment"], riskData["Bearish Sentiment"]),
    ]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Risk Assessment Table'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns:
              headers.map((header) => DataColumn(label: Text(header))).toList(),
          rows: data.map((row) {
            return DataRow(
              cells: [
                DataCell(Text(row[0])),
                DataCell(
                  Container(
                    color: _getRiskColor(
                        row[1]), // Set color based on risk assessment
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(row[1]),
                    ),
                  ),
                ),
                DataCell(Text(row[2])),
                DataCell(Text(row[3])),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // Method to get the color based on risk assessment
  Color _getRiskColor(String riskAssessment) {
    switch (riskAssessment) {
      case "OK":
        return Colors.green; // Green for Positive
      case "Caution":
        return const Color.fromARGB(255, 124, 119, 74); // Yellow for Caution
      case "Warning":
        return Colors.red; // Red for Warning
      default:
        return Colors.transparent; // Default color
    }
  }

  // Refined assessment methods based on the criteria
  String _assessYearFounded(String? yearFounded) {
    if (yearFounded == null) return "N/A";
    if (yearFounded.contains("> 5 years")) return "OK";
    if (yearFounded.contains("1 - 5 years")) return "Caution";
    return "Warning";
  }

  String _assessExchangesListed(String? exchangesListed) {
    if (exchangesListed == null) return "N/A";
    if (exchangesListed.contains("Binance") &&
        exchangesListed.contains("Coinbase")) return "OK";
    if (exchangesListed.contains("Kraken") ||
        exchangesListed.contains("OKX") ||
        exchangesListed.contains("Gemini") ||
        exchangesListed.contains("KuCoin") ||
        exchangesListed.contains("ByBit")) return "Caution";
    return "Warning";
  }

  String _assessMarketCap(double? marketCap) {
    if (marketCap == null) return "N/A";
    if (marketCap > 10e9) return "OK";
    if (marketCap >= 1e9) return "Caution";
    return "Warning";
  }

  String _assessTradingVolume(double? tradingVolume) {
    if (tradingVolume == null) return "N/A";
    if (tradingVolume > 500e6) return "OK";
    if (tradingVolume >= 100e6) return "Caution";
    return "Warning";
  }

  String _assessPriceChanges(
      double? priceChange1D, double? priceChange7D, double? priceChange30D) {
    if (priceChange1D == null ||
        priceChange7D == null ||
        priceChange30D == null) return "N/A";
    if (priceChange1D > 0 && priceChange7D > 0 && priceChange30D > 0) {
      return "OK";
    }
    int positiveCount = [priceChange1D, priceChange7D, priceChange30D]
        .where((change) => change > 0)
        .length;
    if (positiveCount >= 2) return "Caution";
    return "Warning";
  }

  String _assessOneYearPriceChange(double? oneYearPriceChange) {
    if (oneYearPriceChange == null) return "N/A";
    if (oneYearPriceChange > 20) return "OK";
    if (oneYearPriceChange >= -20) return "Caution";
    return "Warning";
  }

  String _assessAllTimeHigh(double? allTimeHigh, double? currentPrice) {
    if (allTimeHigh == null || currentPrice == null) return "N/A";
    if (currentPrice >= allTimeHigh * 0.8) return "OK";
    if (currentPrice >= allTimeHigh * 0.5) return "Caution";
    return "Warning";
  }

  String _assessAllTimeLow(double? allTimeLow, double? currentPrice) {
    if (allTimeLow == null || currentPrice == null) return "N/A";
    if (currentPrice >= allTimeLow * 2) return "OK";
    if (currentPrice >= allTimeLow * 1.5) return "Caution";
    return "Warning";
  }

  String _assessWhaleHoldings(double? whaleHoldings) {
    if (whaleHoldings == null) return "N/A";
    if (whaleHoldings < 10) return "OK";
    if (whaleHoldings <= 20) return "Caution";
    return "Warning";
  }

  String _assessAddressesByHoldings(double? holdings) {
    if (holdings == null) return "N/A";
    if (holdings > 50) return "OK";
    if (holdings >= 20) return "Caution";
    return "Warning";
  }

  String _assessAddressesByTimeHeld(double? hodlers, double? traders) {
    if (hodlers == null || traders == null) return "N/A";
    if (hodlers > 50) return "OK";
    if (traders < 50) return "Caution";
    return "Warning";
  }

  String _assessCommunitySentiment(double? bullish, double? bearish) {
    if (bullish == null || bearish == null) return "N/A";
    double sentiment = bullish / (bullish + bearish) * 100;
    if (sentiment > 70) return "OK";
    if (sentiment >= 50) return "Caution";
    return "Warning";
  }

  // Explanation methods for each criterion
  String _getYearFoundedExplanation(String? yearFounded) {
    if (yearFounded == null) return "N/A";
    if (yearFounded.contains("> 5 years")) {
      return "Established history, showing resilience and proven stability over time.";
    }
    if (yearFounded.contains("1 - 5 years")) {
      return "Moderate age, indicating some experience but still maturing in the market.";
    }
    return "Very new, with limited history; may face uncertainties and volatility as it establishes itself.";
  }

  String _getExchangesListedExplanation(String? exchangesListed) {
    if (exchangesListed == null) return "N/A";
    if (exchangesListed.contains("Binance") &&
        exchangesListed.contains("Coinbase")) {
      return "High credibility and accessibility through trusted exchanges.";
    }
    if (exchangesListed.contains("Kraken") ||
        exchangesListed.contains("OKX") ||
        exchangesListed.contains("Gemini") ||
        exchangesListed.contains("KuCoin") ||
        exchangesListed.contains("ByBit")) {
      return "Reasonably credible with moderate accessibility.";
    }
    return "Limited accessibility, potentially indicating lower credibility.";
  }

  String _getMarketCapExplanation(double? marketCap) {
    if (marketCap == null) return "N/A";
    if (marketCap > 10e9) {
      return "Large cap, indicating stability and lower risk of major price swings.";
    }
    if (marketCap >= 1e9) {
      return "Mid-cap, reasonably stable but with potential for moderate volatility.";
    }
    return "Small cap, more susceptible to large price swings and market manipulation.";
  }

  String _getTradingVolumeExplanation(double? tradingVolume) {
    if (tradingVolume == null) return "N/A";
    if (tradingVolume > 500e6) {
      return "High liquidity, easy to buy/sell without affecting the price significantly.";
    }
    if (tradingVolume >= 100e6) {
      return "Moderate liquidity, with some risk of slippage during trades.";
    }
    return "Low liquidity, making it vulnerable to high slippage and price manipulation.";
  }

  String _getPriceChangesExplanation(
      double? priceChange1D, double? priceChange7D, double? priceChange30D) {
    if (priceChange1D == null ||
        priceChange7D == null ||
        priceChange30D == null) return "N/A";
    if (priceChange1D > 0 && priceChange7D > 0 && priceChange30D > 0) {
      return "Consistent growth, showing strong market support.";
    }
    int positiveCount = [priceChange1D, priceChange7D, priceChange30D]
        .where((change) => change > 0)
        .length;
    if (positiveCount >= 2) {
      return "Mixed performance, indicating potential for moderate fluctuations.";
    }
    return "Unstable, indicating recent or ongoing declines.";
  }

  String _getOneYearPriceChangeExplanation(double? oneYearPriceChange) {
    if (oneYearPriceChange == null) return "N/A";
    if (oneYearPriceChange > 20) {
      return "Strong long-term growth, indicating resilience and positive market sentiment.";
    }
    if (oneYearPriceChange >= -20) {
      return "Small gains/losses, indicating some fluctuations but relative stability.";
    }
    return "Significant decline, indicating high volatility and potential loss of market confidence.";
  }

  String _getAllTimeHighExplanation(double? allTimeHigh, double? currentPrice) {
    if (allTimeHigh == null || currentPrice == null) return "N/A";
    if (currentPrice >= allTimeHigh * 0.8) {
      return "The current price is close to the all-time high, within 20% of its peak. This stability suggests strong market support, with low volatility risk.";
    }
    if (currentPrice >= allTimeHigh * 0.5) {
      return "The current price is moderately below the all-time high, falling between 20% and 50% of its peak. While there’s been some decline, the asset shows potential to recover.";
    }
    return "The current price is significantly below its all-time high, over 50% off its peak. This suggests high volatility and a potential struggle to regain previous highs.";
  }

  String _getAllTimeLowExplanation(double? allTimeLow, double? currentPrice) {
    if (allTimeLow == null || currentPrice == null) return "N/A";
    if (currentPrice >= allTimeLow * 2) {
      return "The current price is comfortably above the all-time low, more than double its lowest value. This distance from the ATL suggests a stable support level.";
    }
    if (currentPrice >= allTimeLow * 1.5) {
      return "The current price is moderately above the all-time low, sitting 50% to 100% higher. Although it’s moved up, the asset shows some sensitivity to downside pressure.";
    }
    return "The current price is close to its all-time low, within 50% of the lowest recorded value. This proximity to the ATL indicates potential instability and low market support.";
  }

  String _getWhaleHoldingsExplanation(double? whaleHoldings) {
    if (whaleHoldings == null) return "N/A";
    if (whaleHoldings < 10) {
      return "Decentralized, low risk of price manipulation by large holders.";
    }
    if (whaleHoldings <= 20) {
      return "Moderate concentration, some influence from large holders but not dominant.";
    }
    return "High concentration, significant risk of price manipulation by large holders.";
  }

  String _getAddressesByHoldingsExplanation(double? holdings) {
    if (holdings == null) return "N/A";
    if (holdings > 50) {
      return "High retail interest, indicating wide adoption and community support.";
    }
    if (holdings >= 20) {
      return "Moderate retail interest, with balanced retail and large holder presence.";
    }
    return "Low retail interest, potentially high concentration among few large holders.";
  }

  String _getAddressesByTimeHeldExplanation(double? hodlers, double? traders) {
    if (hodlers == null || traders == null) return "N/A";
    if (hodlers > 50) {
      return "Dominance of long-term holders, indicating strong confidence and low volatility.";
    }
    if (traders < 50) {
      return "Balanced, with both long-term and mid-term confidence.";
    }
    return "Predominantly short-term holders, suggesting speculative trading and high volatility.";
  }

  String _getCommunitySentimentExplanation(double? bullish, double? bearish) {
    if (bullish == null || bearish == null) return "N/A";
    double sentiment = bullish / (bullish + bearish) * 100;
    if (sentiment > 70) {
      return "High confidence and positive perception among the community.";
    }
    if (sentiment >= 50) {
      return "Moderate sentiment, with mixed opinions in the community.";
    }
    return "Low confidence, indicating skepticism or negative perception.";
  }
}
