import 'package:crypto_tracker/scr/pages/risk_details.dart';
import 'package:flutter/material.dart';

class CryptoRiskForm extends StatefulWidget {
  const CryptoRiskForm({super.key});

  @override
  State<CryptoRiskForm> createState() => _CryptoRiskFormState();
}

class _CryptoRiskFormState extends State<CryptoRiskForm> {
  // Controllers for text fields
  final TextEditingController coinNameController = TextEditingController();
  final TextEditingController currentPriceController = TextEditingController();
  final TextEditingController marketCapController = TextEditingController();
  final TextEditingController tradingVolumeController = TextEditingController();
  final TextEditingController priceChange7DController = TextEditingController();
  final TextEditingController priceChange14DController =
      TextEditingController();
  final TextEditingController priceChange30DController =
      TextEditingController();
  final TextEditingController priceChange1YController = TextEditingController();
  final TextEditingController allTimeHighController = TextEditingController();
  final TextEditingController allTimeLowController = TextEditingController();
  final TextEditingController whaleHoldingsController = TextEditingController();
  final TextEditingController holdings0To1kController = TextEditingController();
  final TextEditingController holdings1kTo100kController =
      TextEditingController();
  final TextEditingController holdings100kPlusController =
      TextEditingController();
  final TextEditingController cruisersController = TextEditingController();
  final TextEditingController tradersController = TextEditingController();
  final TextEditingController hodlersController = TextEditingController();
  final TextEditingController bullishSentimentController =
      TextEditingController();
  final TextEditingController bearishSentimentController =
      TextEditingController();

  // Dropdown variables
  String? yearFounded;
  String? exchangesListed;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter Coin Details",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF000000)),
            ),
            const SizedBox(height: 20),
            // Coin Name
            _buildInputField(
              controller: coinNameController,
              label: "Coin Name",
              hint: "Enter the name of the cryptocurrency.",
              isRequired: true,
              isNumeric: false, // Coin name is not numeric
            ),
            const SizedBox(height: 20),
            // Year Founded
            _buildDropdownField(
              label: "Coin Age",
              hint: ' < 1 year',
              value: yearFounded,
              onChanged: (value) => setState(() => yearFounded = value),
              items: const [
                DropdownMenuItem(value: "< 1 year", child: Text("< 1 year")),
                DropdownMenuItem(
                    value: "1 - 5 years", child: Text("1 - 5 years")),
                DropdownMenuItem(value: "> 5 years", child: Text("> 5 years")),
              ],
            ),
            const SizedBox(height: 20),
            // Exchanges Listed
            _buildDropdownField(
              label: "Exchanges Listed",
              hint: ' Binance or Coinbase',
              value: exchangesListed,
              onChanged: (value) => setState(() => exchangesListed = value),
              items: const [
                DropdownMenuItem(
                    value: "Binance or Coinbase",
                    child: Text(
                        "Listed on major exchanges (e.g. Binance, Coinbase, ByBit, OKX)")),
                DropdownMenuItem(
                    value: "Crypto.com, Kraken, etc.",
                    child: Text(
                        "Listed on a other reputable exchanges (e.g. Gemini, KuCoin, Kraken)")),
                DropdownMenuItem(
                    value: "Other Exchanges",
                    child:
                        Text("Listed only on smaller or less-known exchanges")),
              ],
            ),
            const SizedBox(height: 20),
            // Current Price
            _buildInputField(
                controller: currentPriceController,
                label: "Current Price (USD)",
                hint: "Enter current price in USD",
                isRequired: true),
            const SizedBox(height: 20),
            // Market Capitalization
            _buildInputField(
              controller: marketCapController,
              label: "Market Capitalization (USD)",
              hint: "Enter the market cap in USD.",
            ),
            const SizedBox(height: 20),
            // Trading Volume
            _buildInputField(
              controller: tradingVolumeController,
              label: "Trading Volume ",
              hint: "Enter the % change for each time period.",
            ),
            const SizedBox(height: 20),
            const Text('Price Changes (%)',
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            // Price Changes
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    controller: priceChange7DController,
                    label: "7D",
                    hint: "Enter 7-day price change in %.",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    controller: priceChange14DController,
                    label: "30D",
                    hint: "Enter 30-day price change in %.",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    controller: priceChange30DController,
                    label: "90D",
                    hint: " Enter 90-day price change in %.",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInputField(
              controller: priceChange1YController,
              label: "1-Year Price Change %",
              hint: "Enter the 1-year price change in %.",
            ),
            const SizedBox(height: 20),
            const Text('All-Time High Price (\$)',
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    controller: allTimeHighController,
                    label: "All-Time High Price (\$)",
                    hint: "Enter the all-time high price in USD.",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    controller: allTimeLowController,
                    label: "All-Time Low Price (\$)",
                    hint: "Enter the all-time low price in USD.",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Whale Holdings
            _buildInputField(
              controller: whaleHoldingsController,
              label: "Whale Holdings (%)",
              hint: "Enter the % of total supply held by large holders.",
            ),
            const SizedBox(height: 20),
            const Text('Addresses by Holding (%)',
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    controller: holdings0To1kController,
                    label: "0-\$1k",
                    hint: "Enter % of addresses holding \$0-\$1k.",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    controller: holdings1kTo100kController,
                    label: "\$1k-\$100k",
                    hint: " Enter % of addresses holding \$1k-\$100k.",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    controller: holdings100kPlusController,
                    label: "\$100k+",
                    hint: " Enter % of addresses holding over \$100k.",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Addresses by Time Held (%)',
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    controller: cruisersController,
                    label: "Cruisers (%)",
                    hint: "Enter % of addresses holding 1-12 months.",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    controller: tradersController,
                    label: "Traders (%)",
                    hint: "Enter % of addresses holding less than 1 month.",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    controller: hodlersController,
                    label: "Holders (%)",
                    hint: " Enter % of addresses holding over 1 year.",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Community Sentiment (%)',
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    controller: bullishSentimentController,
                    label: "Bullish (%)",
                    hint: "Enter % of community sentiment that is bullish.",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    controller: bearishSentimentController,
                    label: "Bearish (%)",
                    hint: "Enter % of community sentiment that is bearish.",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Risk Report Button
            SizedBox(
              height: 60,
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2752E7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Text(
                  "Get Risk Report",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    ValueChanged<String>? onChanged,
    required String label,
    String hint = "",
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = false,
    bool isNumeric = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF000000),
                fontWeight: FontWeight.w400)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
                fontWeight: FontWeight.w400, fontSize: 12, color: Colors.grey),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.grey, width: 0.03)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.grey, width: 0.03)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.grey, width: 0.03)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.red, width: 0.03)),
          ),
          validator: (value) {
            if (isRequired && (value == null || value.trim().isEmpty)) {
              return "$label is required";
            }
            if (isNumeric) {
              if (value!.isNotEmpty) {
                final numValue = double.tryParse(value);
                if (numValue == null) {
                  return "$label must be a valid number (positive or negative)";
                }
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required void Function(String?) onChanged,
    required List<DropdownMenuItem<String>> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF000000),
                fontWeight: FontWeight.w400)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
                fontWeight: FontWeight.w400, fontSize: 12, color: Colors.grey),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      Map<String, dynamic> formData = {
        "Coin Name": coinNameController.text,
        "Year Founded": yearFounded,
        "Current Price": double.tryParse(currentPriceController.text),
        "Market Capitalization": double.tryParse(marketCapController.text),
        "Trading Volume": double.tryParse(tradingVolumeController.text),
        "Price Change (7D)": double.tryParse(priceChange7DController.text),
        "Price Change (14D)": double.tryParse(priceChange14DController.text),
        "Price Change (30D)": double.tryParse(priceChange30DController.text),
        "Price Change (1Y)": double.tryParse(priceChange1YController.text),
        "All-Time High": double.tryParse(allTimeHighController.text),
        "All-Time Low": double.tryParse(allTimeLowController.text),
        "Whale Holdings": double.tryParse(whaleHoldingsController.text),
        "0-\$1k Holdings": double.tryParse(holdings0To1kController.text),
        "\$1k-\$100k Holdings":
            double.tryParse(holdings1kTo100kController.text),
        "\$100k+ Holdings": double.tryParse(holdings100kPlusController.text),
        "Cruisers (1-12 months)": double.tryParse(cruisersController.text),
        "Traders (< 1 month)": double.tryParse(tradersController.text),
        "Hodlers (> 1 year)": double.tryParse(hodlersController.text),
        "Bullish Sentiment": double.tryParse(bullishSentimentController.text),
        "Bearish Sentiment": double.tryParse(bearishSentimentController.text),
        "Exchanges Listed": exchangesListed,
      };
      // Navigate to the RiskDetails page with the collected data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RiskAssessmentTable(riskData: formData),
        ),
      );
    }
  }

  void _validateSum(BuildContext context) {
    final bullishValue = double.tryParse(bullishSentimentController.text) ?? 0;
    final bearishValue = double.tryParse(bearishSentimentController.text) ?? 0;
    final total = bullishValue + bearishValue;

    if (total > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The total percentage cannot exceed 100%.'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (total < 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The total percentage is less than 100%.'),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      // Optionally, you can show a success message when it equals 100
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Total percentage is exactly 100%.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
