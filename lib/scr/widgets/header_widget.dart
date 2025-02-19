


import 'package:crypto_tracker/scr/providers/coins_provider.dart';
import 'package:crypto_tracker/scr/widgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ConsumerState, ConsumerStatefulWidget;
class ResponsiveHeader extends ConsumerStatefulWidget {
  const ResponsiveHeader({super.key});

  @override
  ConsumerState<ResponsiveHeader> createState() => _ResponsiveHeaderState();
}

class _ResponsiveHeaderState extends ConsumerState<ResponsiveHeader> {
  TextEditingController controller = TextEditingController();
  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
final coinProvider = ref.watch<CoinsProvider>(coinsProvider); // Replace with your actual provider type
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo and Brand Name
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEDA03),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "CP",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "CoinPeek",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              if (!isMobile )
                Container(
                  width: 350,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF132A46),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: coinProvider.controller,
                                              style: TextStyle(fontSize: 12, color: Colors.white),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search Coin",
                            
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              isSearching = true;
                              coinProvider.searchCoins();
                            } else {
                              isSearching = false;
                            }
                            setState(() {});
                          },
                        ),
                      ),
                      Icon(Icons.search, color: Colors.grey),
                    ],
                  ),
                ),
            ],
          ),
          // Search Bar

          // Navigation Items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Home",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              TextButton(
                onPressed: () {},
                child: const GradientText(
                  text: "Calculator",
                  gradient: LinearGradient(
                    colors: [
                      Colors.pink,
                      Colors.purple,
                      Colors.orange,
                      Colors.yellow,
                    ],
                  ),
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF315177),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                onPressed: () {},
                child: const Text(
                  "Contact",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
