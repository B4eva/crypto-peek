import 'package:crypto_tracker/scr/api_service.dart';
import 'package:crypto_tracker/scr/models/coin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final coinsProvider = ChangeNotifierProvider<CoinsProvider>((ref) {
  return CoinsProvider();
});

class CoinsProvider extends ChangeNotifier {
  CoinsProvider() {
    fetchCoins(); // Call the API when the provider is created
  }

  // ApiService apiService = ApiService();
  ApiService apiService = ApiService();

  List<Coin> _coins = [];
  final List<Coin> _likedCoins = [];

  List<Coin> get likedCoins => _likedCoins;

  List<Coin> _filteredCoins = [];
  bool _isLoading = true;
  String? _error;

//  List<Coin> get coins => _coins;
  List<Coin> get coins => _filteredCoins.isNotEmpty ? _filteredCoins : _coins;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCoins() async {
    _isLoading = true;
    notifyListeners();

    final result = await ApiService().fetchCoins();

    if (result.error != null) {
      _error = result.error;
    } else {
      _coins = result.data ?? [];
      _error = null; // Clear any previous errors
    }

    _isLoading = false;
    notifyListeners();
  }

  void addCoinToLiked(Coin coin) {
    if (!_likedCoins.contains(coin)) {
      _likedCoins.add(coin);
    } else {
      _likedCoins.remove(coin);
    }
    notifyListeners();
  }

  bool isCoinLiked(String coinId) {
    return _likedCoins.any((coin) => coin.id == coinId);
  }

  TextEditingController _controller = TextEditingController();

  TextEditingController get controller => _controller;

  void searchCoins() {
    if (_controller.text.isEmpty) {
      _filteredCoins = _coins; // Reset filtered coins if the query is empty
    } else {
      _filteredCoins = _coins
          .where(
              (coin) => coin.name.toLowerCase().contains(controller.text.toLowerCase()))
          .toList();
    }
    notifyListeners(); // Notify listeners to update the UI
  }
}
