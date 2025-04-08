// import 'package:flutter/material.dart';

// class RiskAssessmentTable extends StatelessWidget {
//   final Map<String, dynamic> riskData;

//   const RiskAssessmentTable({super.key, required this.riskData});

//   @override
//   Widget build(BuildContext context) {
//     final headers = ["Criteria", "Ratings", "Coin Value", "Explanation"];

//     // Create a list to hold the data rows
//     List<List<String>> data = [];

//     // Populate the data based on riskData
//     data.add([
//       "Year Founded",
//       _assessYearFounded(riskData["Year Founded"]),
//       riskData["Year Founded"] ?? "No Data Provided",
//       _getYearFoundedExplanation(riskData["Year Founded"]),
//     ]);
//     data.add([
//       "Exchanges Listed",
//       _assessExchangesListed(riskData["Exchanges Listed"]),
//       riskData["Exchanges Listed"] ?? "No Data Provided",
//       _getExchangesListedExplanation(riskData["Exchanges Listed"]),
//     ]);
//     data.add([
//       "Market Capitalization (USD)",
//       _assessMarketCap(riskData["Market Capitalization"]),
//       riskData["Market Capitalization"]?.toString() ?? "No Data Provided",
//       _getMarketCapExplanation(riskData["Market Capitalization"]),
//     ]);
//     data.add([
//       "Trading Volume (USD)",
//       _assessTradingVolume(riskData["Trading Volume"]),
//       riskData["Trading Volume"]?.toString() ?? "No Data Provided",
//       _getTradingVolumeExplanation(riskData["Trading Volume"]),
//     ]);
//     data.add([
//       "Price Changes (%)",
//       _assessPriceChanges(riskData["Price Change (14D)"],
//           riskData["Price Change (7D)"], riskData["Price Change (30D)"]),
//       riskData["Price Change (7D)"]?.toString() ?? "No Data Provided",
//       _getPriceChangesExplanation(riskData["Price Change (14D)"],
//           riskData["Price Change (7D)"], riskData["Price Change (30D)"]),
//     ]);
//     data.add([
//       "1-Year Price Change (%)",
//       _assessOneYearPriceChange(riskData["Price Change (1Y)"]),
//       riskData["Price Change (1Y)"]?.toString() ?? "No Data Provided",
//       _getOneYearPriceChangeExplanation(riskData["Price Change (1Y)"]),
//     ]);
//     data.add([
//       "All-Time High (USD)",
//       _assessAllTimeHigh(riskData["All-Time High"], riskData["Current Price"]),
//       riskData["All-Time High"]?.toString() ?? "No Data Provided",
//       _getAllTimeHighExplanation(
//           riskData["All-Time High"], riskData["Current Price"]),
//     ]);
//     data.add([
//       "All-Time Low (USD)",
//       _assessAllTimeLow(riskData["All-Time Low"], riskData["Current Price"]),
//       riskData["All-Time Low"]?.toString() ?? "No Data Provided",
//       _getAllTimeLowExplanation(
//           riskData["All-Time Low"], riskData["Current Price"]),
//     ]);
//     data.add([
//       "Whale Holdings (%)",
//       _assessWhaleHoldings(riskData["Whale Holdings"]),
//       riskData["Whale Holdings"]?.toString() ?? "No Data Provided",
//       _getWhaleHoldingsExplanation(riskData["Whale Holdings"]),
//     ]);
//     data.add([
//       "Addresses by Holdings (%)",
//       _assessAddressesByHoldings(riskData["0-\$1k Holdings"]),
//       riskData["0-\$1k Holdings"]?.toString() ?? "No Data Provided",
//       _getAddressesByHoldingsExplanation(riskData["0-\$1k Holdings"]),
//     ]);
//     data.add([
//       "Addresses by Time Held (%)",
//       _assessAddressesByTimeHeld(
//           riskData["Hodlers (> 1 year)"], riskData["Traders (< 1 month)"]),
//       riskData["Hodlers (> 1 year)"]?.toString() ?? "No Data Provided",
//       _getAddressesByTimeHeldExplanation(
//           riskData["Hodlers (> 1 year)"], riskData["Traders (< 1 month)"]),
//     ]);
//     data.add([
//       "Community Sentiment (%)",
//       _assessCommunitySentiment(
//           riskData["Bullish Sentiment"], riskData["Bearish Sentiment"]),
//       riskData["Bullish Sentiment"]?.toString() ?? "No Data Provided",
//       _getCommunitySentimentExplanation(
//           riskData["Bullish Sentiment"], riskData["Bearish Sentiment"]),
//     ]);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         title: const Text('Risk Assessment Table'),
//       ),
//       body: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: DataTable(
//           columns:
//               headers.map((header) => DataColumn(label: Text(header))).toList(),
//           rows: data.map((row) {
//             return DataRow(
//               cells: [
//                 DataCell(Text(row[0])),
//                 DataCell(
//                   Container(
//                     color: _getRiskColor(
//                         row[1]), // Set color based on risk assessment
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(row[1]),
//                     ),
//                   ),
//                 ),
//                 DataCell(Text(row[2])),
//                 DataCell(Text(row[3])),
//               ],
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }

//   // Method to get the color based on risk assessment
//   Color _getRiskColor(String riskAssessment) {
//     switch (riskAssessment) {
//       case "OK":
//         return Colors.green; // Green for Positive
//       case "Caution":
//         return const Color.fromARGB(255, 124, 119, 74); // Yellow for Caution
//       case "Warning":
//         return Colors.red; // Red for Warning
//       default:
//         return Colors.transparent; // Default color
//     }
//   }

//   // Refined assessment methods based on the criteria
//   String _assessYearFounded(String? yearFounded) {
//     if (yearFounded == null) return "No Data Provided";
//     if (yearFounded.contains("> 5 years")) return "OK";
//     if (yearFounded.contains("1 - 5 years")) return "Caution";
//     return "Warning";
//   }

//   String _assessExchangesListed(String? exchangesListed) {
//     if (exchangesListed == null) return "No Data Provided";
//     if (exchangesListed.contains("Binance") &&
//         exchangesListed.contains("Coinbase")) return "OK";
//     if (exchangesListed.contains("Kraken") ||
//         exchangesListed.contains("OKX") ||
//         exchangesListed.contains("Gemini") ||
//         exchangesListed.contains("KuCoin") ||
//         exchangesListed.contains("ByBit")) return "Caution";
//     return "Warning";
//   }

//   String _assessMarketCap(double? marketCap) {
//     if (marketCap == null) return "No Data Provided";
//     if (marketCap > 10e9) return "OK";
//     if (marketCap >= 1e9) return "Caution";
//     return "Warning";
//   }

//   String _assessTradingVolume(double? tradingVolume) {
//     if (tradingVolume == null) return "No Data Provided";
//     if (tradingVolume > 500e6) return "OK";
//     if (tradingVolume >= 100e6) return "Caution";
//     return "Warning";
//   }

//   String _assessPriceChanges(
//       double? priceChange14D, double? priceChange7D, double? priceChange30D) {
//     if (priceChange14D == null ||
//         priceChange7D == null ||
//         priceChange30D == null) return "No Data Provided";
//     if (priceChange14D > 0 && priceChange7D > 0 && priceChange30D > 0) {
//       return "OK";
//     }
//     int positiveCount = [priceChange14D, priceChange7D, priceChange30D]
//         .where((change) => change > 0)
//         .length;
//     if (positiveCount >= 2) return "Caution";
//     return "Warning";
//   }

//   String _assessOneYearPriceChange(double? oneYearPriceChange) {
//     if (oneYearPriceChange == null) return "No Data Provided";
//     if (oneYearPriceChange > 20) return "OK";
//     if (oneYearPriceChange >= -20) return "Caution";
//     return "Warning";
//   }

//   String _assessAllTimeHigh(double? allTimeHigh, double? currentPrice) {
//     if (allTimeHigh == null || currentPrice == null) return "No Data Provided";
//     if (currentPrice >= allTimeHigh * 0.8) return "OK";
//     if (currentPrice >= allTimeHigh * 0.5) return "Caution";
//     return "Warning";
//   }

//   String _assessAllTimeLow(double? allTimeLow, double? currentPrice) {
//     if (allTimeLow == null || currentPrice == null) return "No Data Provided";
//     if (currentPrice >= allTimeLow * 2) return "OK";
//     if (currentPrice >= allTimeLow * 1.5) return "Caution";
//     return "Warning";
//   }

//   String _assessWhaleHoldings(double? whaleHoldings) {
//     if (whaleHoldings == null) return "No Data Provided";
//     if (whaleHoldings < 10) return "OK";
//     if (whaleHoldings <= 20) return "Caution";
//     return "Warning";
//   }

//   String _assessAddressesByHoldings(double? holdings) {
//     if (holdings == null) return "No Data Provided";
//     if (holdings > 50) return "OK";
//     if (holdings >= 20) return "Caution";
//     return "Warning";
//   }

//   String _assessAddressesByTimeHeld(double? hodlers, double? traders) {
//     if (hodlers == null || traders == null) return "No Data Provided";
//     if (hodlers > 50) return "OK";
//     if (traders < 50) return "Caution";
//     return "Warning";
//   }

//   String _assessCommunitySentiment(double? bullish, double? bearish) {
//     if (bullish == null || bearish == null) return "No Data Provided";
//     double sentiment = bullish / (bullish + bearish) * 100;
//     if (sentiment > 70) return "OK";
//     if (sentiment >= 50) return "Caution";
//     return "Warning";
//   }

//   // Explanation methods for each criterion
//   String _getYearFoundedExplanation(String? yearFounded) {
//     if (yearFounded == null) return "No Data Provided";
//     if (yearFounded.contains("> 5 years")) {
//       return "The coin has an established history, showing resilience and proven stability over time.";
//     }
//     if (yearFounded.contains("1 - 5 years")) {
//       return "The coin is of moderate age, indicating some experience but still maturing in the market.";
//     }
//     return "The coin is very new with limited history, which may result in uncertainties and volatility as it establishes itself.";
//   }

//   String _getExchangesListedExplanation(String? exchangesListed) {
//     if (exchangesListed == null) return "No Data Provided";
//     if (exchangesListed.contains("Binance") ||
//         exchangesListed.contains("OKX") ||
//         exchangesListed.contains("Coinbase") ||
//         exchangesListed.contains("ByBit")) {
//       return "The coin is listed on both Binance and Coinbase, which are highly credible and offer broad accessibility.";
//     }
//     if (exchangesListed.contains("Kraken") ||
//         exchangesListed.contains("Gemini") ||
//         exchangesListed.contains("KuCoin")) {
//       return "The coin is listed on at least two of Kraken, OKX, Gemini, KuCoin, or ByBit, which are reasonably credible and provide moderate access.";
//     }
//     return "The coin is listed only on smaller exchanges, which limits accessibility and may suggest lower credibility.";
//   }

//   String _getMarketCapExplanation(double? marketCap) {
//     if (marketCap == null) return "No Data Provided";
//     if (marketCap > 10e9) {
//       return "The coin has a large market cap, indicating stability and a low risk of major price swings.";
//     }
//     if (marketCap >= 1e9) {
//       return "The coin has a mid-market cap, which is reasonably stable but may experience moderate volatility.";
//     }
//     return "The coin has a small market cap, making it more susceptible to large price swings and potential market manipulation.";
//   }

//   String _getTradingVolumeExplanation(double? tradingVolume) {
//     if (tradingVolume == null) return "No Data Provided";
//     if (tradingVolume > 500e6) {
//       return "The coin has high liquidity, making it easy to buy or sell without significantly affecting its price.";
//     }
//     if (tradingVolume >= 100e6) {
//       return "The coin has moderate liquidity, so there may be some risk of price fluctuations or slippage during trades.";
//     }
//     return "The coin has low liquidity, making it vulnerable to high slippage and price manipulation.";
//   }

//   String _getPriceChangesExplanation(
//       double? priceChange14D, double? priceChange7D, double? priceChange30D) {
//     if (priceChange14D == null ||
//         priceChange7D == null ||
//         priceChange30D == null) return "No Data Provided";
//     if (priceChange14D > 0 && priceChange7D > 0 && priceChange30D > 0) {
//       return "The coin has experienced consistent growth, showing strong support from the market.";
//     }
//     int positiveCount = [priceChange14D, priceChange7D, priceChange30D]
//         .where((change) => change > 0)
//         .length;
//     if (positiveCount >= 2) {
//       return "The coin shows mixed performance, indicating some moderate fluctuations and potential for risk.";
//     }
//     return "The coin's price changes have been unstable, indicating declines or high volatility.";
//   }

//   String _getOneYearPriceChangeExplanation(double? oneYearPriceChange) {
//     if (oneYearPriceChange == null) return "No Data Provided";
//     if (oneYearPriceChange > 20) {
//       return "The coin has shown strong growth over the past year, reflecting resilience and positive market sentiment.";
//     }
//     if (oneYearPriceChange >= -20) {
//       return "The coin has experienced small gains or losses, indicating relative stability with some fluctuations.";
//     }
//     return "The coin has seen a significant decline, showing high volatility and a potential loss of market confidence.";
//   }

//   String _getAllTimeHighExplanation(double? allTimeHigh, double? currentPrice) {
//     if (allTimeHigh == null || currentPrice == null) return "No Data Provided";
//     if (currentPrice >= allTimeHigh * 0.8) {
//       return "The current price is close to its all-time high (within 20%), suggesting stability and low volatility risk.";
//     }
//     if (currentPrice >= allTimeHigh * 0.5) {
//       return "The current price is moderately below its all-time high (between 20%-50% lower), indicating potential for recovery.";
//     }
//     return "The current price is significantly below its all-time high (more than 50% lower), which suggests high volatility and difficulty regaining previous highs.";
//   }

//   String _getAllTimeLowExplanation(double? allTimeLow, double? currentPrice) {
//     if (allTimeLow == null || currentPrice == null) return "No Data Provided";
//     if (currentPrice >= allTimeLow * 2) {
//       return "The current price is comfortably above its all-time low (more than double the lowest value), which suggests a strong support level.";
//     }
//     if (currentPrice >= allTimeLow * 1.5) {
//       return "The current price is moderately above its all-time low (50%-100% higher), suggesting some downside risk but a potential for further recovery.";
//     }
//     return "The current price is close to its all-time low (within 50%), indicating potential instability and weak market support..";
//   }

//   String _getWhaleHoldingsExplanation(double? whaleHoldings) {
//     if (whaleHoldings == null) return "No Data Provided";
//     if (whaleHoldings < 10) {
//       return "The coin is decentralized, with a low risk of price manipulation by large holders.";
//     }
//     if (whaleHoldings <= 20) {
//       return "The coin has a moderate concentration of whale holdings, meaning there is some influence from large holders but not a dominant position.";
//     }
//     return "The coin has a high concentration of whale holdings, which presents a significant risk of price manipulation by large holders.";
//   }

//   String _getAddressesByHoldingsExplanation(double? holdings) {
//     if (holdings == null) return "No Data Provided";
//     if (holdings > 50) {
//       return "The coin has high retail interest, indicating broad adoption and strong community support.";
//     }
//     if (holdings >= 20) {
//       return "The coin shows a balance of retail and large holder interest, which suggests moderate retail interest and adoption.";
//     }
//     return "The coin has low retail interest, with a high concentration of holdings among a few large holders.";
//   }

//   String _getAddressesByTimeHeldExplanation(double? hodlers, double? traders) {
//     if (hodlers == null || traders == null) return "No Data Provided";
//     if (hodlers > 50) {
//       return "The coin is dominated by long-term holders, suggesting strong confidence and low volatility.";
//     }
//     if (traders < 50) {
//       return "The coin shows a balance of long-term and mid-term holders, indicating stability with moderate fluctuations.";
//     }
//     return "The coin is predominantly held by short-term traders, suggesting speculative trading and high volatility.";
//   }

//   String _getCommunitySentimentExplanation(double? bullish, double? bearish) {
//     if (bullish == null || bearish == null) return "No Data Provided";
//     double sentiment = bullish / (bullish + bearish) * 100;
//     if (sentiment > 70) {
//       return "The community has high confidence and a positive perception of the coin.";
//     }
//     if (sentiment >= 50) {
//       return "The community sentiment is mixed, with both positive and negative opinions.";
//     }
//     return "The community sentiment is low, with skepticism or negative perceptions about the coin.";
//   }
// }
