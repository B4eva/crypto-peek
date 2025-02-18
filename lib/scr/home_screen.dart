import 'package:crypto_tracker/scr/coins_details.dart';
import 'package:crypto_tracker/scr/liked_screen.dart';
import 'package:crypto_tracker/scr/providers/coins_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final String _searchQuery = '';
  int _currentIndex = 0; // For tracking the selected tab

  // Define the screens for each tab
  final List<Widget> _screens = [
    const HomeScreenContent(),
    const LikedItemsScreen(), // Implement a simple LikedItemsScreen
  ];

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(coinsProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 36, 36),
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: const Text(
          'Crypto Market',
          style: TextStyle(
            color: Color.fromARGB(255, 211, 208, 208),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  style: const TextStyle(
                    color: Color.fromARGB(255, 211, 208, 208),
                  ),
                  controller: _searchController,
                  onChanged: (value) {
                    ref.read(coinsProvider).searchCoins(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 211, 208, 208),
                    ),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      body: _screens[
          _currentIndex], // Display the current screen based on the index
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black45,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the index on tap
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Liked',
          ),
        ],
      ),
    );
  }
}

// HomeScreen content separated for clarity
class HomeScreenContent extends ConsumerWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(coinsProvider);

    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.error != null
                      ? Center(child: Text(provider.error!))
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: provider.coins.length > 40
                              ? 40
                              : provider.coins.length,
                          itemBuilder: (context, index) {
                            final coin = provider.coins[index];
                            final isLiked = provider.isCoinLiked(coin.id);

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
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 60,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Hero(
                                            tag: coin.id,
                                            child: Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[700],
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey[700]!,
                                                    offset: const Offset(4, 4),
                                                    blurRadius: 3,
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child:
                                                    Image.network(coin.image),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                coin.name,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                coin.priceChangePercentage24h
                                                    .toStringAsFixed(2),
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey
                                                      .withOpacity(0.6),
                                                ),
                                              ),
                                              if (isLiked)
                                                const Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                  size: 13,
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '\$ ${coin.currentPrice.round()}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            coin.symbol,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                              color:
                                                  Colors.grey.withOpacity(0.6),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
