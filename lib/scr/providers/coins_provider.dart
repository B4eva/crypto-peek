import 'package:crypto_tracker/scr/api_service.dart';
import 'package:crypto_tracker/scr/models/coin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:crypto_tracker/scr/models/coin.dart';
import 'package:flutter/material.dart';


final coinsProvider = ChangeNotifierProvider<CoinsProvider>((ref) {
  return CoinsProvider();
});

class CoinsProvider extends ChangeNotifier {
  CoinsProvider() {
    fetchCoins(); // Initial fetch when provider is created
    
    // Set up a timer to fetch coins every minute
    _autoRefreshTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      fetchCoins();
    });
  }

  ApiService apiService = ApiService();
  Timer? _autoRefreshTimer;

  List<Coin> _allCoins = []; // Store all coins from the API
  List<Coin> _coins = []; // Filtered coins (excluding stablecoins)
  final List<Coin> _likedCoins = [];
  List<Coin> _filteredCoins = []; // Search results
  
  bool _isLoading = true;
  String? _error;
  bool _excludeStablecoins = true; // Flag to control stablecoin filtering

  // Getters
  List<Coin> get likedCoins => _likedCoins;
  List<Coin> get coins => _filteredCoins.isNotEmpty ? _filteredCoins : _coins;
  List<Coin> get allCoins => _allCoins; // Access to all coins including stablecoins
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get excludeStablecoins => _excludeStablecoins;

  // List of known stablecoins for filtering
  final List<String> stablecoinIds = [
    'tether', 'usd-coin', 'binance-usd', 'dai', 'frax', 'true-usd', 
    'pax-dollar', 'usdd', 'gemini-dollar', 'liquity-usd', 'neutrino',
    'fei-usd', 'usdk', 'reserve', 'husd', 'nusd', 'susd', 'usdx', 'vai'
  ];

  final List<String> stablecoinSymbols = [
    'usdt', 'usdc', 'busd', 'dai', 'frax', 'tusd', 'usdp', 'usdd', 'gusd',
    'lusd', 'usdn', 'fei', 'usdk', 'rsr', 'husd', 'nusd', 'susd', 'usdx', 'vai'
  ];

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchCoins() async {
    // Don't show loading indicator for auto-refresh
    final bool showLoading = _allCoins.isEmpty;
    
    if (showLoading) {
      _isLoading = true;
      notifyListeners();
    }

    final result = await apiService.fetchCoins();

    if (result.error != null) {
      _error = result.error;
    } else {
      _allCoins = result.data ?? [];
      // Apply stablecoin filtering if enabled
      _filterStablecoins();
      _error = null; // Clear any previous errors
    }

    _isLoading = false;
    notifyListeners();
  }

  // Filter out stablecoins if the exclude flag is set
  void _filterStablecoins() {
    if (_excludeStablecoins) {
      _coins = _allCoins.where((coin) => !isStablecoin(coin)).toList();
    } else {
      _coins = List.from(_allCoins);
    }
  }

  // Toggle stablecoin filtering
  void toggleStablecoinFilter() {
    _excludeStablecoins = !_excludeStablecoins;
    _filterStablecoins();
    // Clear any search results when changing filters
    if (_filteredCoins.isNotEmpty) {
      searchCoins();
    }
    notifyListeners();
  }

  // Check if a coin is a stablecoin using multiple criteria
  bool isStablecoin(Coin coin) {
    // Check known stablecoin lists
    if (stablecoinIds.contains(coin.id) || 
        stablecoinSymbols.contains(coin.symbol.toLowerCase())) {
      return true;
    }
    
    // Check name/symbol for USD terms
    final nameOrSymbol = '${coin.name.toLowerCase()} ${coin.symbol.toLowerCase()}';
    bool containsStablecoinTerms = nameOrSymbol.contains('usd') || 
                                  nameOrSymbol.contains('dollar') ||
                                  nameOrSymbol.contains('stable');
    
    // Check if price is stable around $1 (for USD-pegged coins)
    bool isPricePeggedToUSD = coin.currentPrice >= 0.95 && coin.currentPrice <= 1.05;
    
    // Additional check for specific stable terms in full words
    if (nameOrSymbol.contains('usd')) {
      // Ensure it's not just part of another word (like "wisdom")
      bool isStandalone = nameOrSymbol.contains(' usd') || 
                          nameOrSymbol.contains('usd ') ||
                          nameOrSymbol.contains('usdt') ||
                          nameOrSymbol.contains('usdc');
      
      if (!isStandalone) {
        return false;
      }
    }
    
    // A coin is considered a stablecoin if it has stablecoin terms and is price-pegged
    return containsStablecoinTerms && isPricePeggedToUSD;
  }

  // Get a filtered list of only stablecoins
  List<Coin> getStablecoins() {
    return _allCoins.where((coin) => isStablecoin(coin)).toList();
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

  final TextEditingController _controller = TextEditingController();
  TextEditingController get controller => _controller;

  void searchCoins() {
    String value = _controller.text;
    print("Searching for in Provider=============>: $value");

    if (_controller.text.isEmpty) {
      _filteredCoins = []; // Clear filtered results
    } else {
      // Search within the already filtered list (with or without stablecoins)
      _filteredCoins = _coins
          .where((coin) => 
            coin.name.toLowerCase().contains(value.toLowerCase()) ||
            coin.symbol.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void clearSearch() {
    _filteredCoins = [];
    _controller.clear();
    notifyListeners();
  }

  // Force a manual refresh outside the automatic timer
  Future<void> refreshCoins() async {
    return fetchCoins();
  }
}
