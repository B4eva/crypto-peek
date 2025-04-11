import 'dart:async';
import 'dart:convert';

import 'package:crypto_tracker/scr/models/coin.dart';
import 'package:http/http.dart' as http;

// Enhanced ApiService with multi-page fetching capabilities
class ApiService {
  final String baseUrl = 'https://api.coingecko.com/api/v3/coins/';

  // Main method to fetch coins with combined results from multiple pages
  Future<ApiResult<List<Coin>>> fetchCoins({int totalCoins = 500}) async {
    print('======================> Fetching up to $totalCoins coins with pagination...');
    
    // Calculate how many pages we need (CoinGecko often limits to ~100 per page)
    final int perPage = 100; // More reliable limit for CoinGecko
    final int pages = (totalCoins / perPage).ceil();
    
    List<Coin> allCoins = [];
    String? errorMessage;

    try {
      for (int page = 1; page <= pages; page++) {
        print('======================> Fetching page $page of $pages...');
        
        final response = await http.get(
          Uri.parse('${baseUrl}markets?vs_currency=usd&order=market_cap_desc&per_page=$perPage&page=$page&sparkline=true&price_change_percentage=24h,7d,30d'),
          headers: {
            'Accept': 'application/json',
          },
        ).timeout(const Duration(seconds: 15));

        if (response.statusCode == 200) {
          // Log response size for debugging
          print('======================> Received data for page $page: ${response.body.length} bytes');
          
          // Parse the coins from this page
          List<Coin> pageCoins = coinFromJson(response.body);
          print('======================> Successfully parsed ${pageCoins.length} coins from page $page');
          
          // Add to our accumulated list
          allCoins.addAll(pageCoins);
          
          // If we've reached our target or received fewer than expected (end of list),
          // we can stop fetching more pages
          if (allCoins.length >= totalCoins || pageCoins.length < perPage) {
            break;
          }
          
          // Add delay between requests to avoid rate limiting
          if (page < pages) {
            await Future.delayed(const Duration(milliseconds: 500));
          }
        } else if (response.statusCode == 429) {
          print('======================> Rate limit exceeded on page $page');
          errorMessage = 'Rate limit exceeded. Please try again later.';
          break;
        } else {
          print('======================> Error on page $page: ${response.statusCode}');
          errorMessage = 'Failed to fetch coins: ${response.statusCode}. ${response.body}';
          break;
        }
      }

      if (errorMessage != null) {
        return ApiResult(error: errorMessage);
      }
      
      print('======================> Total coins fetched across all pages: ${allCoins.length}');
      return ApiResult(data: allCoins);
    } on TimeoutException {
      return ApiResult(error: 'Connection timed out. Please check your internet and try again.');
    } catch (e) {
      print('======================> Exception during fetch: $e');
      return ApiResult(error: 'Error: $e');
    }
  }

  // The rest of your methods remain the same
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