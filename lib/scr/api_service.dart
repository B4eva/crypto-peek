import 'dart:convert';

import 'package:crypto_tracker/scr/models/coin.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://api.coingecko.com/api/v3/coins/';

  Future<ApiResult<List<Coin>>> fetchCoins() async {
    try {
      final response = await http.get(Uri.parse(
          '${baseUrl}/markets?vs_currency=usd&order=market_cap_desc&per_page=500&page=1&sparkline=true&price_change_percentage=24h,7d,30d'));

      if (response.statusCode == 200) {
        List<Coin> coins = coinFromJson(response.body);
        return ApiResult(data: coins);
      } else {
        return ApiResult(
            error: 'Failed to fetch coins: ${response.statusCode}');
      }
    } catch (e) {
      return ApiResult(error: 'Error: $e');
    }
  }

  Future<ApiResult<CoinDetail>> fetchCoinDetails(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ApiResult(data: CoinDetail.fromJson(data));
      } else {
        return ApiResult(
            error: 'Failed to fetch coin details: ${response.statusCode}');
      }
    } catch (e) {
      return ApiResult(error: 'Error: $e');
    }
  }

  Future<List<double>> fetchHistoricalData(String coinId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/$coinId/market_chart?vs_currency=usd&days=30'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<double> prices =
          (data['prices'] as List).map((item) => item[1] as double).toList();
      return prices;
    } else {
      throw Exception('Failed to load historical data');
    }
  }
}

class ApiResult<T> {
  final T? data;
  final String? error;

  ApiResult({this.data, this.error});
}

class CoinDetail {
  final String id;
  final String name;
  final String description;
  final int marketCap;
  final double totalSupply;
  final String image;

  CoinDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.marketCap,
    required this.totalSupply,
    required this.image,
  });

  factory CoinDetail.fromJson(Map<String, dynamic> json) {
    return CoinDetail(
      id: json['id'],
      name: json['name'],
      description: json['description']
          ['en'], // Assuming you want the English description
      marketCap: json['market_data']['market_cap']['eur'],
      totalSupply: json['market_data']['total_supply'],
      image: json['image']['large'],
    );
  }
}
