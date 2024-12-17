import 'package:crypto_tracker/scr/api_service.dart';
import 'package:crypto_tracker/scr/models/coin.dart';
import 'package:crypto_tracker/scr/providers/coins_provider.dart';
import 'package:crypto_tracker/scr/widgets/price_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:crypto/scr/coin.dart';

class CoinDetailScreen extends ConsumerStatefulWidget {
  final String coinId;
  final Coin? coinDetails;

  const CoinDetailScreen({super.key, required this.coinId, this.coinDetails});

  @override
  ConsumerState<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends ConsumerState<CoinDetailScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  CoinDetail? _coinDetail;
  late Future<List<double>> _historicalData;

  @override
  void initState() {
    super.initState();
    _fetchCoinDetails();
    _historicalData = ApiService().fetchHistoricalData(widget.coinId);
  }

  Future<void> _fetchCoinDetails() async {
    final result = await ApiService().fetchCoinDetails(widget.coinId);

    if (result.error != null) {
      setState(() {
        _isLoading = false;
        _errorMessage = result.error; // Set the error message
      });
    } else {
      setState(() {
        _isLoading = false;
        _coinDetail = result.data; // Set the fetched coin detail
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.read(coinsProvider);
    final isLiked = provider.isCoinLiked(widget.coinId);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 36, 36),
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                if (widget.coinDetails != null) {
                  provider.addCoinToLiked(widget.coinDetails!);
                }
              },
              icon: provider.isCoinLiked(widget.coinId)
                  ? const Icon(Icons.favorite, color: Colors.red)
                  : const Icon(Icons.favorite_border, color: Colors.white),
            ),
          ],
          backgroundColor: Colors.black45,
          centerTitle: true,
          title: Text(_coinDetail?.name ?? 'Coin Details',
              style: const TextStyle(color: Colors.white))),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!)) // Show error message
              : _coinDetail != null
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: widget
                                  .coinId, // Use the same tag for hero animation
                              child: Center(
                                  child: Image.network(_coinDetail!.image)),
                            ),
                            const SizedBox(height: 16),
                            const Text('Description:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white)),
                            const SizedBox(height: 16),
                            CoinDescription(
                                description: _coinDetail!.description),
                            const SizedBox(height: 16),
                            Text('Market Cap: \$${_coinDetail!.marketCap}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                    color: Colors.white)),
                            const SizedBox(height: 16),
                            Text('Total Supply: ${_coinDetail!.totalSupply}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                    color: Colors.white)),
                            const SizedBox(
                              height: 30,
                            ),
                            FutureBuilder<List<double>>(
                              future: _historicalData,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}, ',
                                          style: const TextStyle(
                                              color: Colors.white)));
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Historical Data',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                            height: 370,
                                            child: PriceChart(
                                                prices: snapshot.data!)),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
    );
  }
}

class CoinDescription extends StatefulWidget {
  final String description;

  const CoinDescription({super.key, required this.description});

  @override
  _CoinDescriptionState createState() => _CoinDescriptionState();
}

class _CoinDescriptionState extends State<CoinDescription> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isExpanded ? widget.description : _truncateText(widget.description),
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12,
            color: Colors.white,
          ),
        ),
        if (widget.description.length > 200)
          TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? 'Read less' : 'Read more',
              style: const TextStyle(color: Colors.blue),
            ),
          ),
      ],
    );
  }

  String _truncateText(String text) {
    return text.length > 200 ? '${text.substring(0, 200)}...' : text;
  }
}
