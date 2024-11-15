import 'package:crypto/scr/coins_details.dart';
import 'package:crypto/scr/providers/coins_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LikedItemsScreen extends ConsumerWidget {
  const LikedItemsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedCoins = ref.watch(coinsProvider).likedCoins;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 36, 36),
      appBar: AppBar(
        title: const Text('Liked Coins', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black45,
      ),
      body: likedCoins.isEmpty
          ? const Center(
              child: Text(
                'No liked coins yet.',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          : ListView.builder(
              itemCount: likedCoins.length,
              itemBuilder: (context, index) {
                final coin = likedCoins[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CoinDetailScreen(
                          coinDetails: coin,
                          coinId: coin.id,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      coin.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      '\$${coin.currentPrice}',
                      style: TextStyle(color: Colors.grey.withOpacity(0.6)),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
