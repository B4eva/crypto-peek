import 'dart:convert';
import 'package:flutter/material.dart';

List<Coin> coinFromJson(String str) =>
    List<Coin>.from(json.decode(str).map((x) => Coin.fromJson(x)));

String coinToJson(List<Coin> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Coin {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double marketCap;  // Changed from int to double
  final int marketCapRank;
  final double fullyDilutedValuation;  // Changed from int to double
  final double totalVolume;  // Changed from int to double
  final double high24h;
  final double low24h;
  final double priceChange24h;
  final double priceChangePercentage24h;
  final double marketCapChange24h;
  final double marketCapChangePercentage24h;
  final double circulatingSupply;
  final double totalSupply;
  final double? maxSupply;
  final double ath;
  final double athChangePercentage;
  final DateTime athDate;
  final double atl;
  final double atlChangePercentage;
  final DateTime atlDate;
  final dynamic roi;
  final DateTime lastUpdated;
  final List<double>? sparklineIn7d;
  final double? priceChangePercentage24hInCurrency;
  final double? priceChangePercentage7dInCurrency;
  final bool isLiked;

  Coin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    required this.fullyDilutedValuation,
    required this.totalVolume,
    required this.high24h,
    required this.low24h,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.marketCapChange24h,
    required this.marketCapChangePercentage24h,
    required this.circulatingSupply,
    required this.totalSupply,
    this.maxSupply,
    required this.ath,
    required this.athChangePercentage,
    required this.athDate,
    required this.atl,
    required this.atlChangePercentage,
    required this.atlDate,
    this.roi,
    required this.lastUpdated,
    this.sparklineIn7d,
    this.priceChangePercentage24hInCurrency,
    this.priceChangePercentage7dInCurrency,
    this.isLiked = false,
  });

  factory Coin.fromJson(Map<String, dynamic> json) => Coin(
        id: json["id"],
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        currentPrice: _safeToDouble(json["current_price"]),
        marketCap: _safeToDouble(json["market_cap"]),
        marketCapRank: json["market_cap_rank"] ?? 0,
        fullyDilutedValuation: _safeToDouble(json["fully_diluted_valuation"]),
        totalVolume: _safeToDouble(json["total_volume"]),
        high24h: _safeToDouble(json["high_24h"]),
        low24h: _safeToDouble(json["low_24h"]),
        priceChange24h: _safeToDouble(json["price_change_24h"]),
        priceChangePercentage24h: _safeToDouble(json["price_change_percentage_24h"]),
        marketCapChange24h: _safeToDouble(json["market_cap_change_24h"]),
        marketCapChangePercentage24h: _safeToDouble(json["market_cap_change_percentage_24h"]),
        circulatingSupply: _safeToDouble(json["circulating_supply"]),
        totalSupply: _safeToDouble(json["total_supply"]),
        maxSupply: json["max_supply"] != null ? _safeToDouble(json["max_supply"]) : null,
        ath: _safeToDouble(json["ath"]),
        athChangePercentage: _safeToDouble(json["ath_change_percentage"]),
        athDate: DateTime.parse(json["ath_date"]),
        atl: _safeToDouble(json["atl"]),
        atlChangePercentage: _safeToDouble(json["atl_change_percentage"]),
        atlDate: DateTime.parse(json["atl_date"]),
        roi: json["roi"],
        lastUpdated: DateTime.parse(json["last_updated"]),
        sparklineIn7d: json["sparkline_in_7d"] != null 
            ? List<double>.from(json["sparkline_in_7d"]["price"].map((x) => _safeToDouble(x)))
            : null,
        priceChangePercentage24hInCurrency: json["price_change_percentage_24h_in_currency"] != null
            ? _safeToDouble(json["price_change_percentage_24h_in_currency"])
            : null,
        priceChangePercentage7dInCurrency: json["price_change_percentage_7d_in_currency"] != null
            ? _safeToDouble(json["price_change_percentage_7d_in_currency"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "symbol": symbol,
        "name": name,
        "image": image,
        "current_price": currentPrice,
        "market_cap": marketCap,
        "market_cap_rank": marketCapRank,
        "fully_diluted_valuation": fullyDilutedValuation,
        "total_volume": totalVolume,
        "high_24h": high24h,
        "low_24h": low24h,
        "price_change_24h": priceChange24h,
        "price_change_percentage_24h": priceChangePercentage24h,
        "market_cap_change_24h": marketCapChange24h,
        "market_cap_change_percentage_24h": marketCapChangePercentage24h,
        "circulating_supply": circulatingSupply,
        "total_supply": totalSupply,
        "max_supply": maxSupply,
        "ath": ath,
        "ath_change_percentage": athChangePercentage,
        "ath_date": athDate.toIso8601String(),
        "atl": atl,
        "atl_change_percentage": atlChangePercentage,
        "atl_date": atlDate.toIso8601String(),
        "roi": roi,
        "last_updated": lastUpdated.toIso8601String(),
        "sparkline_in_7d": sparklineIn7d != null ? {"price": sparklineIn7d} : null,
        "price_change_percentage_24h_in_currency": priceChangePercentage24hInCurrency,
        "price_change_percentage_7d_in_currency": priceChangePercentage7dInCurrency,
      };

  List<bool> calculateIndicators() {
    return _calculateIndicators(
      priceChange24h: priceChange24h,
      priceChange7d: priceChangePercentage7dInCurrency ?? 0.0,
      priceChange30d: priceChangePercentage24h ?? 0.0, // Assuming you have a way to get this
      marketCap: marketCap,
      totalVolume: totalVolume,
    );
  }

  List<bool> _calculateIndicators({
    required double priceChange24h,
    required double priceChange7d,
    required double priceChange30d,
    required double marketCap,
    required double totalVolume,
  }) {
    return [
      priceChange30d > 0,  // Maturity
      marketCap > 1000000000,  // Dominance
      priceChange7d > 0,  // Performance
      priceChange24h > 0,  // Loyalty
      totalVolume > 100000000,  // Liquidity
      marketCap / totalVolume > 100,  // Whale manipulation resistance
    ];
  }
}

// Helper function to safely convert any value to double
double _safeToDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is int) return value.toDouble();
  if (value is double) return value;
  if (value is String) {
    try {
      return double.parse(value);
    } catch (_) {
      return 0.0;
    }
  }
  return 0.0;
}

class Roi {
  double times;
  Currency currency;
  double percentage;

  Roi({
    required this.times,
    required this.currency,
    required this.percentage,
  });

  factory Roi.fromJson(Map<String, dynamic> json) => Roi(
        times: _safeToDouble(json["times"]),
        currency: currencyValues.map[json["currency"]]!,
        percentage: _safeToDouble(json["percentage"]),
      );

  Map<String, dynamic> toJson() => {
        "times": times,
        "currency": currencyValues.reverse[currency],
        "percentage": percentage,
      };
}

enum Currency { BTC, ETH, USD }

final currencyValues =
    EnumValues({"btc": Currency.BTC, "eth": Currency.ETH, "usd": Currency.USD});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

class MetricScore {
  final int score;
  final Color color;

  MetricScore({
    required this.score,
    required this.color,
  });
}