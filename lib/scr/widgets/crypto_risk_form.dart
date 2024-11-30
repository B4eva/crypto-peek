import 'package:crypto/scr/pages/risk_details.dart';
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Coin Name
              _buildInputField(
                controller: coinNameController,
                label: "Coin Name",
                hint: "Enter cryptocurrency name (e.g., Bitcoin)",
                isRequired: true,
              ),

              const SizedBox(height: 20),

              // Year Founded
              _buildDropdownField(
                label: "Year Founded",
                value: yearFounded,
                onChanged: (value) => setState(() => yearFounded = value),
                items: const [
                  DropdownMenuItem(value: "< 1 year", child: Text("< 1 year")),
                  DropdownMenuItem(
                      value: "1 - 5 years", child: Text("1 - 5 years")),
                  DropdownMenuItem(
                      value: "> 5 years", child: Text("> 5 years")),
                ],
              ),

              const SizedBox(height: 20),

              // Exchanges Listed
              _buildDropdownField(
                label: "Exchanges Listed",
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
                keyboardType: TextInputType.number,
                isRequired: true,
              ),

              const SizedBox(height: 20),

              // Market Capitalization
              _buildInputField(
                controller: marketCapController,
                label: "Market Capitalization (USD)",
                hint: "Enter market cap in USD (e.g., 10,000,000,000)",
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),

              _buildInputField(
                controller: tradingVolumeController,
                label: "Trading volume",
                hint: "Enter trading volume",
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),

              // Price Changes
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      controller: priceChange7DController,
                      label: "7D (%)",
                      hint: "e.g., 5.2",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildInputField(
                      controller: priceChange14DController,
                      label: "14D (%)",
                      hint: "e.g., -3.4",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildInputField(
                      controller: priceChange30DController,
                      label: "30D (%)",
                      hint: "e.g., 12.0",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              _buildInputField(
                controller: priceChange1YController,
                label: "1-Year price Change %",
                hint: "Enter % 1 year change",
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),

              const Text('All time price(\$)'),
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      controller: allTimeHighController,
                      label: "All Time High",
                      hint: "e.g., 5.2",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildInputField(
                      controller: allTimeLowController,
                      label: "All time Low",
                      hint: "e.g., -3.4",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              // Whale Holdings
              _buildInputField(
                controller: whaleHoldingsController,
                label: "Whale Holdings (%)",
                hint:
                    "Enter % of total supply held by large holders (e.g., 15.0)",
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),

              const Text('Addresse by holding(%)'),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      controller: holdings0To1kController,
                      label: "0-\$1k",
                      hint: "",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildInputField(
                      controller: holdings1kTo100kController,
                      label: "\$1k-\$100k",
                      hint: "e.g., -3.4",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildInputField(
                      controller: holdings100kPlusController,
                      label: "\$100k+",
                      hint: "",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text('Addresse by time held'),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      controller: cruisersController,
                      label: "cruisers",
                      hint: "",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildInputField(
                      controller: tradersController,
                      label: "Traders",
                      hint: "e.g., -3.4",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildInputField(
                      controller: hodlersController,
                      label: "holders",
                      hint: "",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text('Community Sentiment (%)'),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      controller: bullishSentimentController,
                      label: "Bullish",
                      hint: "",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildInputField(
                      controller: bearishSentimentController,
                      label: "Bearish",
                      hint: "",
                      keyboardType: TextInputType.number,
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
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(
                        250, 70), // Set minimum size for width and height
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15), // Set border radius
                    ),
                  ),
                  child: const Text("Get Risk Report"),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    String hint = "",
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          validator: isRequired
              ? (value) => value == null || value.trim().isEmpty
                  ? "$label is required"
                  : null
              : null,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required void Function(String?) onChanged,
    required List<DropdownMenuItem<String>> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
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
