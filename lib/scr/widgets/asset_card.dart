import 'package:crypto_tracker/scr/models/coin.dart';
import 'package:flutter/material.dart';


class AssetCard extends StatelessWidget {
  final Coin coinData;


  const AssetCard({Key? key, required this.coinData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
       LayoutBuilder(
      builder: (context, constraints) {
        final isVeryNarrow = constraints.maxWidth < 200;

        return Card(
          color: const Color(0xFF132A46),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(isVeryNarrow ? 8 : 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardHeader(coinData, isVeryNarrow),
                SizedBox(height: isVeryNarrow ? 8 : 12),
               
                _buildPriceSection(coinData, isVeryNarrow),
                 Divider( thickness: 0.2,),
                SizedBox(height: isVeryNarrow ? 8 : 12),
              buildMetricsDisplay(coinData, isVeryNarrow),
              ],
            ),
          ),
        );
      },
    );
 
  }


  Widget _buildCardHeader(Coin coinData, bool isVeryNarrow) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: isVeryNarrow ? 32 : 36,
                height: isVeryNarrow ? 32 : 36,
                decoration: BoxDecoration(
                  
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(9),
                  image: DecorationImage(
                    image: NetworkImage(coinData.image),
                    fit: BoxFit.cover,
                  ),
                ),
                // child: const Center(
                //   child: Text(
                //     'B',
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            coinData.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isVeryNarrow ? 12 : 14,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),


                        Text(
            '(${(coinData.symbol).toUpperCase()})',
            style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 12, fontWeight: FontWeight.w400),
          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        IconButton(
        icon:Icon(  Icons.share, size: isVeryNarrow ? 14 : 16,),
        onPressed: () {},
          color: Colors.grey[400],
         
        ),
      ],
    );
  }

  Widget _buildPriceSection(Coin coinData, bool isVeryNarrow) {
                     // Function to calculate price change percentage over 7 days



double calculateSevenDayPriceChange(List<double> prices) {
  if (prices.isEmpty) {
    return 0.0;
  }

  // Get the first and last price from the list
  double firstPrice = prices.first;
  double lastPrice = prices.last;

  // Calculate percentage change
  double priceChange = ((lastPrice - firstPrice) / firstPrice) * 100;

  // Return rounded to 2 decimal places
  return double.parse(priceChange.toStringAsFixed(2));
}

  bool? isPriceUp = calculateSevenDayPriceChange(coinData.sparklineIn7d ?? []) >= 0;
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
              '\$ ${coinData.currentPrice}',
              style: TextStyle(
                color: Colors.white,
                fontSize: isVeryNarrow ? 14 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            
           
          ],
        ),
        SizedBox(width: 4,),
         Row(
           children: [
             Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isVeryNarrow ? 2 : 4,
                    vertical: 2,
                  ),
                
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                isPriceUp ?      Container(
                   padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                       shape: BoxShape.circle,
                                         color: isPriceUp ?  Color(0xFF00DD23) : Color(0xFFDD0000),
                  //  borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                          Icons.arrow_upward_sharp   ,
                  color: Colors.white,
                          size: isVeryNarrow ? 8 : 10,
                        ),
                ) : Container(
                  padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                                         color: isPriceUp ?  Color(0xFF00DD23) : Color(0xFFDD0000),
                 //   borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                          Icons.arrow_downward_sharp,
                          color: Colors.white,
                          size: isVeryNarrow ? 8 : 10,
                        ),
                ), 

                   SizedBox(width: 4,),
                      Text(
                        '${calculateSevenDayPriceChange(coinData.sparklineIn7d ?? [])}',
                        style: TextStyle(
                                                                   color: isPriceUp ?  Color(0xFF00DD23) : Color(0xFFDD0000),
                          fontSize: isVeryNarrow ? 8 : 10,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4,),
                  Text(
                        '(Last 7days)',
                        style: TextStyle(
                          color: Color(0xFFACACAC),
                          fontSize: isVeryNarrow ? 8 : 10,
                          fontWeight: FontWeight.w400
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
          _buildMetricsRow('Dominance', Colors.orange, 'Liquidity', Colors.green, isVeryNarrow),
        
          _buildMetricsRow('Performance', Colors.red, 'Whales', Colors.orange, isVeryNarrow),
        ],
      ),
    );
  }

  Widget _buildMetricsRow(String label1, Color color1, String label2, Color color2, bool isVeryNarrow) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Expanded(
        child: Text(
          label,
          style: TextStyle(
            color: Color(0xFFACACAC),
            fontSize: isVeryNarrow ? 9 : 12,
            fontWeight: FontWeight.w400,
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
          border: Border.all(color: color, width: 2),
        ),
      ),
    ],
  );
}
}



class MetricsDisplay extends StatelessWidget {
  final double priceChange24h;
  final double priceChange7d;
  final double priceChange30d;
  final double marketCap;
  final double totalVolume;
  final bool isVeryNarrow;

  const MetricsDisplay({
    Key? key,
    required this.priceChange24h,
    required this.priceChange7d,
    required this.priceChange30d,
    required this.marketCap,
    required this.totalVolume,
    required this.isVeryNarrow,
  }) : super(key: key);

  List<bool> _calculateIndicators() {
    return [
      priceChange30d > 0,  // Maturity
      marketCap > 1000000000,  // Dominance
      priceChange7d > 0,  // Performance
      priceChange24h > 0,  // Loyalty
      totalVolume > 100000000,  // Liquidity
      marketCap / totalVolume > 100,  // Whale manipulation resistance
    ];
  }

  Widget _buildMetricsSection() {
    final indicators = _calculateIndicators();
    
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildMetricsRow(
            MetricPair(
              label1: 'Maturity',
              isPositive1: indicators[0],
              label2: 'Loyalty',
              isPositive2: indicators[3],
            ),
          ),
          _buildMetricsRow(
            MetricPair(
              label1: 'Dominance',
              isPositive1: indicators[1],
              label2: 'Liquidity',
              isPositive2: indicators[4],
            ),
          ),
          _buildMetricsRow(
            MetricPair(
              label1: 'Performance',
              isPositive1: indicators[2],
              label2: 'Whales',
              isPositive2: indicators[5],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsRow(MetricPair metrics) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: _buildMetric(
            metrics.label1,
            metrics.isPositive1 ? Colors.green : Colors.red,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMetric(
            metrics.label2,
            metrics.isPositive2 ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildMetric(String label, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: const Color(0xFFACACAC),
              fontSize: isVeryNarrow ? 9 : 12,
              fontWeight: FontWeight.w400
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
            border: Border.all(
              color: color,
              width: 2
            ),
          )
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMetricsSection();
  }
}

// Helper class to organize metric pairs
class MetricPair {
  final String label1;
  final bool isPositive1;
  final String label2;
  final bool isPositive2;

  MetricPair({
    required this.label1,
    required this.isPositive1,
    required this.label2,
    required this.isPositive2,
  });
}

// Usage example in your asset card or table row:
Widget buildMetricsDisplay(Coin coin, bool isVeryNarrow) {
  return MetricsDisplay(
    priceChange24h: coin.priceChangePercentage24h ?? 0,
    priceChange7d: coin.priceChangePercentage7dInCurrency ?? 0,
    priceChange30d: coin.priceChangePercentage24h ?? 0,
    marketCap: coin.marketCap.toDouble(),
    totalVolume: coin.totalVolume.toDouble(),
    isVeryNarrow: isVeryNarrow,
  );
}