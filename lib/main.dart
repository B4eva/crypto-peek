import 'package:crypto/scr/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const Scaffold(
        body: HomePage(),
      ),
    );
  }
}

class CryptoRiskForm extends StatelessWidget {
  const CryptoRiskForm({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double horizontalPadding = constraints.maxWidth < 600 ? 16.0 : 100.0;

        return Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Input Coin Details from CoinMarketCap",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Coin Name
                const Text("Coin Name"),
                TextFormField(
                  decoration: _inputDecoration(
                      "Enter the name of the cryptocurrency (e.g., Bitcoin, Ethereum)"),
                ),

                const SizedBox(height: 20),

                // Year Founded
                const Text("Year Founded"),
                DropdownButtonFormField<String>(
                  dropdownColor: Colors.black,
                  decoration: _inputDecoration(),
                  items: const [
                    DropdownMenuItem(
                        value: "Less than 1 year",
                        child: Text("Less than 1 year")),
                    DropdownMenuItem(
                        value: "1 to 5 years", child: Text("1 to 5 years")),
                    DropdownMenuItem(
                        value: "More than 5 years",
                        child: Text("More than 5 years")),
                  ],
                  onChanged: (value) {},
                ),

                const SizedBox(height: 20),

                // Exchanges Listed
                const Text("Exchanges Listed"),
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration(),
                  items: const [
                    DropdownMenuItem(
                        value: "Listed on Binance or Coinbase",
                        child: Text("Listed on Binance or Coinbase")),
                    DropdownMenuItem(
                        value:
                            "Listed on Crypto.com, Kraken, OKX, Gemini, KuCoin, or ByBit",
                        child: Text(
                            "Listed on Crypto.com, Kraken, OKX, Gemini, KuCoin, or ByBit")),
                    DropdownMenuItem(
                        value: "Listed only on other exchanges",
                        child: Text("Listed only on other exchanges")),
                  ],
                  onChanged: (value) {},
                ),

                const SizedBox(height: 20),

                // Current Price
                const Text("Current Price (USD)"),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration("(e.g., 24.50)"),
                ),

                const SizedBox(height: 20),

                // Market Capitalization
                const Text("Market Capitalization (USD)"),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(" (e.g., 10,000,000,000)"),
                ),

                const SizedBox(height: 20),

                // Trading Volume
                const Text("Trading Volume"),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(" in USD (e.g., 500,000,000)"),
                ),

                const SizedBox(height: 20),

                // Price Changes (7D, 14D, 30D)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Price Changes (%) - 7D"),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(
                                "price change in % (e.g., 5.2)"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Price Changes (%) - 14D"),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(
                                "Enter the 14-day price change in % (e.g., -3.4)"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Price Changes (%) - 30D"),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(
                                "Enter the 30-day price change in % (e.g., 12.0)"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 1-Year Price Change
                const Text("1-Year Price Change (%)"),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(
                      "Enter the 1-year price change in % (e.g., -25.0)"),
                ),

                const SizedBox(height: 20),

                // All-Time High Price
                const Text("All-Time High Price (USD)"),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(
                      "Enter the all-time high price in USD (e.g., 150.00)"),
                ),

                const SizedBox(height: 20),

                // All-Time Low Price
                const Text("All-Time Low Price (USD)"),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(
                      "Enter the all-time low price in USD (e.g., 0.50)"),
                ),

                const SizedBox(height: 20),

                // Whale Holdings
                const Text("Whale Holdings (%)"),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(
                      "Enter the % of total supply held by large holders (e.g., 15.0)"),
                ),

                const SizedBox(height: 20),

                // Addresses by Holdings
                const Text("Addresses by Holdings (%)"),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("0 - \$1k"),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(
                                "Enter % of addresses holding \$0-\$1k (e.g., 60.0)"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("\$1k - \$100k"),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(
                                "Enter % of addresses holding \$1k-\$100k (e.g., 30.0)"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("\$100k+"),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(
                                "Enter % of addresses holding over \$100k (e.g., 10.0)"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Addresses by Time Held
                const Text("Addresses by Time Held (%)"),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Cruisers (1-12 months)"),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(" (e.g., 35.0)"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Traders (< 1 month)"),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration("(e.g., 25.0)"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Hodlers (> 1 year)"),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(
                                "Enter % of addresses holding over 1 year (e.g., 40.0)"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Community Sentiment
                const Text("Community Sentiment (%)"),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Bullish: "),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(" (e.g., 65.0)"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Bearish"),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(" (e.g., 35.0)"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                //
                // TextFormField(
                //   keyboardType: TextInputType.number,
                //   decoration:
                //       _inputDecoration("Enter the community sentiment in %"),
                // ),

                const SizedBox(height: 20),

                // Get Risk Report Button
                ElevatedButton(
                  onPressed: () {
                    // Implement button functionality
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 60),
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Get Risk Report",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration([String hintText = ""]) {
    return InputDecoration(
      filled: true,
      fillColor: const Color.fromARGB(255, 96, 89, 89),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
    );
  }
}
