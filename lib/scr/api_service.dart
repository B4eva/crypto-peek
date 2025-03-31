import 'dart:async';
import 'dart:convert';

import 'package:crypto_tracker/scr/models/coin.dart';
import 'package:http/http.dart' as http;

// Updated ApiService with improved error handling
class ApiService {
  final String baseUrl = 'https://api.coingecko.com/api/v3/coins/';

  Future<ApiResult<List<Coin>>> fetchCoins() async {
    print('======================> Fetching coins...');
    // Check if the internet connection is available
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}markets?vs_currency=usd&order=market_cap_desc&per_page=00&page=1&sparkline=true&price_change_percentage=24h,7d,30d'),
        headers: {
          'Accept': 'application/json',
          // Add an API key if you have one
          // 'x-cg-pro-api-key': 'YOUR_API_KEY',
        },
      ).timeout(const Duration(seconds: 15)); // Add timeout for reliability

      if (response.statusCode == 200) {
        List<Coin> coins = coinFromJson(response.body);
        return ApiResult(data: coins);
      } else if (response.statusCode == 429) {
        return ApiResult(error: 'Rate limit exceeded. Please try again later.');
      } else {
        return ApiResult(
            error: 'Failed to fetch coins: ${response.statusCode}. ${response.body}');
      }
    } on TimeoutException {
      return ApiResult(error: 'Connection timed out. Please check your internet and try again.');
    } catch (e) {
      return ApiResult(error: 'Error: $e');
    }
  }

  Future<ApiResult<CoinDetail>> fetchCoinDetails(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$id'),
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ApiResult(data: CoinDetail.fromJson(data));
      } else if (response.statusCode == 429) {
        return ApiResult(error: 'Rate limit exceeded. Please try again later.');
      } else {
        return ApiResult(
            error: 'Failed to fetch coin details: ${response.statusCode}');
      }
    } on TimeoutException {
      return ApiResult(error: 'Connection timed out. Please check your internet and try again.');
    } catch (e) {
      return ApiResult(error: 'Error: $e');
    }
  }

  Future<ApiResult<List<double>>> fetchHistoricalData(String coinId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$coinId/market_chart?vs_currency=usd&days=30'),
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<double> prices =
            (data['prices'] as List).map((item) => item[1] as double).toList();
        return ApiResult(data: prices);
      } else {
        return ApiResult(error: 'Failed to load historical data: ${response.statusCode}');
      }
    } catch (e) {
      return ApiResult(error: 'Error: $e');
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
      description: json['description']['en'],
      marketCap: json['market_data']['market_cap']['usd'] ?? 0,
      totalSupply: json['market_data']['total_supply'] ?? 0.0,
      image: json['image']['large'],
    );
  }
}