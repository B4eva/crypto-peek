


import 'package:flutter/material.dart';

class CryptoRiskScanner extends StatefulWidget {
  @override
  _CryptoRiskScannerState createState() => _CryptoRiskScannerState();
}

class _CryptoRiskScannerState extends State<CryptoRiskScanner> {
  bool isGridView = true;
  final double maxContentWidth = 1200.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1929),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildSearchBar(),
                  _buildViewToggle(),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return _buildGridView(constraints.maxWidth);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Crypto Risk',
            style: TextStyle(
              color: Colors.blue[400],
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Scanner',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'CoinPeek helps you uncover hidden\nand potential risks in any cryptocurrency',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Enter Address',
          hintStyle: TextStyle(color: Colors.grey[600]),
          fillColor: Colors.white.withOpacity(0.1),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
              //  primary: Colors.purple[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text('Scan'),
            ),
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildViewToggle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Assets',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.grid_view,
                  color: isGridView ? Colors.blue : Colors.grey,
                  size: 20,
                ),
                onPressed: () => setState(() => isGridView = true),
              ),
              IconButton(
                icon: Icon(
                  Icons.view_list,
                  color: !isGridView ? Colors.blue : Colors.grey,
                  size: 20,
                ),
                onPressed: () => setState(() => isGridView = false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(double width) {
    // Adjust columns based on width
    int crossAxisCount = width < 400 ? 1 : width < 700 ? 2 : width < 1000 ? 3 : 4;
    double aspectRatio = width < 400 ? 1.8 : 1.6; // Taller cards on mobile

    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 10,
      itemBuilder: (context, index) => _buildAssetCard(),
    );
  }

  Widget _buildAssetCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isVeryNarrow = constraints.maxWidth < 200;
        
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(isVeryNarrow ? 8 : 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardHeader(isVeryNarrow),
                SizedBox(height: isVeryNarrow ? 8 : 12),
                _buildPriceSection(isVeryNarrow),
                SizedBox(height: isVeryNarrow ? 8 : 12),
                _buildMetricsSection(isVeryNarrow),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardHeader(bool isVeryNarrow) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: isVeryNarrow ? 24 : 32,
                height: isVeryNarrow ? 24 : 32,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Text(
                    'B',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Asset Name',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: isVeryNarrow ? 10 : 12,
                      ),
                    ),
                    Text(
                      'Bitcoin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isVeryNarrow ? 12 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.share,
          color: Colors.grey[400],
          size: isVeryNarrow ? 14 : 16,
        ),
      ],
    );
  }

  Widget _buildPriceSection(bool isVeryNarrow) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: isVeryNarrow ? 10 : 12,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              '\$84,995',
              style: TextStyle(
                color: Colors.white,
                fontSize: isVeryNarrow ? 14 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isVeryNarrow ? 2 : 4,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_upward,
                    color: Colors.green[400],
                    size: isVeryNarrow ? 8 : 10,
                  ),
                  Text(
                    '1.25%',
                    style: TextStyle(
                      color: Colors.green[400],
                      fontSize: isVeryNarrow ? 8 : 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricsSection(bool isVeryNarrow) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildMetricsRow('Maturity', Colors.green, 'Loyalty', Colors.red, isVeryNarrow),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: Colors.yellow.withOpacity(0.2),
            ),
            child: Center(
              child: Text(
                'CRYPTO OVERSOLD',
                style: TextStyle(
                  color: Colors.yellow[700],
                  fontSize: isVeryNarrow ? 7 : 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _buildMetricsRow('Performance', Colors.red, 'Whales', Colors.orange, isVeryNarrow),
        ],
      ),
    );
  }

  Widget _buildMetricsRow(String label1, Color color1, String label2, Color color2, bool isVeryNarrow) {
    return Row(
      children: [
        Expanded(
          child: _buildMetric(label1, color1, isVeryNarrow),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMetric(label2, color2, isVeryNarrow),
        ),
      ],
    );
  }

  Widget _buildMetric(String label, Color color, bool isVeryNarrow) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: isVeryNarrow ? 10 : 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        Container(
          width: isVeryNarrow ? 6 : 8,
          height: isVeryNarrow ? 6 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ],
    );
  }


}