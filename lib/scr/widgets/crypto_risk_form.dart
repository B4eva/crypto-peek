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
              hint: "Enter cryptocurrency name (e.g., Bitcoin)",
              isRequired: true,
              isNumeric: false, // Coin name is not numeric
            ),
            const SizedBox(height: 20),
            // Year Founded
            _buildDropdownField(
              label: "Coin Age",
              hint: 'e.g 2010',
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
              hint: 'e.g Binance or Coinbase',
              value: exchangesListed,
              onChanged: (value) => setState(() => exchangesListed = value),
              items: const [
                DropdownMenuItem(
                    value: "Binance or Coinbase",
                    child: Text("Listed on Binance or Coinbase")),
                DropdownMenuItem(
                    value: "Crypto.com, Kraken, etc.",
                    child: Text("Listed on Crypto.com, Kraken, etc.")),
                DropdownMenuItem(
                    value: "Other Exchanges",
                    child: Text("Listed only on other exchanges")),
              ],
            ),
            const SizedBox(height: 20),
            // Current Price
            _buildInputField(
                controller: currentPriceController,
                label: "Current Price (USD)",
                hint: "Enter current price in USD (e.g., 24.50)",
                isRequired: true),
            const SizedBox(height: 20),
            // Market Capitalization
            _buildInputField(
              controller: marketCapController,
              label: "Market Capitalization (USD)",
              hint: "Enter market cap in USD (e.g., 10,000,000,000)",
            ),
            const SizedBox(height: 20),
            // Trading Volume
            _buildInputField(
              controller: tradingVolumeController,
              label: "Trading Volume (USD)",
              hint:
                  "Enter the 24-hour trading volume in USD (e.g., 500,000,000)",
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
                    hint: "e.g. 5.2",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    controller: priceChange14DController,
                    label: "14D",
                    hint: "e.g. -3.4",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    controller: priceChange30DController,
                    label: "30D",
                    hint: "e.g. 12.0",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInputField(
              controller: priceChange1YController,
              label: "1-Year Price Change %",
              hint: "Enter % 1 year change e.g -25.0",
            ),
            const SizedBox(height: 20),
            const Text('All Time Price (\$)',
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
                    label: "All Time High",
                    hint: "e.g 150.0",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    controller: allTimeLowController,
                    label: "All Time Low",
                    hint: "e.g 0.50",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Whale Holdings
            _buildInputField(
              controller: whaleHoldingsController,
              label: "Whale Holdings (%)",
              hint: "Enter % of total supply held by large holders (e.g. 15.0)",
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
                    hint: "34.0",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    controller: holdings1kTo100kController,
                    label: "\$1k-\$100k",
                    hint: "e.g. 25.0",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    controller: holdings100kPlusController,
                    label: "\$100k+",
                    hint: "e.g 40.0",
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
                    hint: "e.g 35.0",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    controller: tradersController,
                    label: "Traders (%)",
                    hint: "e.g. 40.0",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    controller: hodlersController,
                    label: "Holders (%)",
                    hint: "30.0",
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
                    hint: "65.0",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInputField(
                    controller: bearishSentimentController,
                    label: "Bearish (%)",
                    hint: "35.0",
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
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
                fontWeight: FontWeight.w400, fontSize: 14, color: Colors.grey),
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
                fontWeight: FontWeight.w400, fontSize: 14, color: Colors.grey),
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
        "Current Price": double.tryParse(currentPriceController.text) ?? 0.0,
        "Market Capitalization":
            double.tryParse(marketCapController.text) ?? 0.0,
        "Trading Volume": double.tryParse(tradingVolumeController.text) ?? 0.0,
        "Price Change (7D)":
            double.tryParse(priceChange7DController.text) ?? 0.0,
        "Price Change (14D)":
            double.tryParse(priceChange14DController.text) ?? 0.0,
        "Price Change (30D)":
            double.tryParse(priceChange30DController.text) ?? 0.0,
        "Price Change (1Y)":
            double.tryParse(priceChange1YController.text) ?? 0.0,
        "All-Time High": double.tryParse(allTimeHighController.text) ?? 0.0,
        "All-Time Low": double.tryParse(allTimeLowController.text) ?? 0.0,
        "Whale Holdings": double.tryParse(whaleHoldingsController.text) ?? 0.0,
        "0-\$1k Holdings": double.tryParse(holdings0To1kController.text) ?? 0.0,
        "\$1k-\$100k Holdings":
            double.tryParse(holdings1kTo100kController.text) ?? 0.0,
        "\$100k+ Holdings":
            double.tryParse(holdings100kPlusController.text) ?? 0.0,
        "Cruisers (1-12 months)":
            double.tryParse(cruisersController.text) ?? 0.0,
        "Traders (< 1 month)": double.tryParse(tradersController.text) ?? 0.0,
        "Hodlers (> 1 year)": double.tryParse(hodlersController.text) ?? 0.0,
        "Bullish Sentiment":
            double.tryParse(bullishSentimentController.text) ?? 0.0,
        "Bearish Sentiment":
            double.tryParse(bearishSentimentController.text) ?? 0.0,
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
}
