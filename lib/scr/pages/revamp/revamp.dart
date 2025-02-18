

import 'package:crypto_tracker/scr/models/coin.dart';
import 'package:crypto_tracker/scr/pages/home_page.dart';
import 'package:crypto_tracker/scr/providers/coins_provider.dart';
import 'package:crypto_tracker/scr/widgets/drawer_mobile.dart';
import 'package:crypto_tracker/scr/widgets/header_mobile.dart';
import 'package:crypto_tracker/scr/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CryptoRiskScanner extends ConsumerStatefulWidget {
  const CryptoRiskScanner({Key? key});
  @override
  _CryptoRiskScannerState createState() => _CryptoRiskScannerState();
}

class _CryptoRiskScannerState extends ConsumerState<CryptoRiskScanner> {
  bool isGridView = true;
  
final ScrollController _scrollController = ScrollController();  
    final double maxContentWidth = 1300.0;
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

 double kMinDesktopWidth = 600.0;

  
  

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final coinProvider = ref.watch(coinsProvider);
    return LayoutBuilder(
      builder:(context, constraints) => Scaffold(
        
          key: scaffoldKey,
            endDrawer: (constraints.maxWidth >= kMinDesktopWidth)
                ? null
                : const MobileDrawer(),
        backgroundColor: const Color(0xFF0C1C30),
        body:
        
         SafeArea(
           child: Center(
           
            child: ConstrainedBox(
                   constraints: BoxConstraints(
                maxWidth: maxContentWidth,
              ),
              child: Padding(
                 padding:  EdgeInsets.symmetric(horizontal: size.width >= kMinDesktopWidth ? 24 : 12),
                child: ListView(
      
                controller: _scrollController,
                 shrinkWrap: true,
                  children: [
                    
                     // Display responsive header based on screen width
                  if (size.width >= kMinDesktopWidth)
                    const ResponsiveHeader()
                  else
                    HeaderMobile(
                      onLogoTap: () {
                        // Handle logo tap
                      },
                      onMenuTap: () {
                        scaffoldKey.currentState?.openEndDrawer();
                      },
                    ),
                    _buildHeader(),
                     const SizedBox(height: 12,),
                  const  FixedSearchBar(),
                  const SizedBox(height: 12,),
                    LayoutBuilder(builder: (context, constraints) {
            return _buildViewToggle( constraints.maxWidth);
                    }
                    ),
                   const    SizedBox(height: 12,),
            coinProvider.isLoading ? Center(child: Container( height: 30, width: 30, child: CircularProgressIndicator())):        Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          if (isGridView) {
                            return _buildGridView(constraints.maxWidth);
                          }
                          return _buildTableView();
                        },
                      ),
                    ),
                     const    SizedBox(height: 40,),
                     const Footer(),
                  const SizedBox(
                    height: 30,
                  ),
      
                  const Divider(),
                  const SizedBox(
                    height: 30,
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      '© 2025. All rights reserved.',
                      style: TextStyle(fontSize: 12, color: Color(0xFFA0A3A9)),
                    ),
                  ),
      
                  const SizedBox(
                    height: 30,
                  ),
                
                  ],
                ),
              ),
            ),
               
                 ),
         ),
         
         
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child:const  Column(
        children: [
          Text(
            'Find Crypto Risks ',
            style: TextStyle(
              color: Color(0xFF2752E7),
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Text(
            '& Gems Early',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
  SizedBox(
    width: 423,
    child: Text('CoinPeek is a crypto scorecard that helps you uncover hidden risks and spot high-potential coins before it’s too late.', textAlign: TextAlign.center,  style: TextStyle(
             
              color: Color(0xFFFFFFFF),
              fontSize: 10,

              fontWeight: FontWeight.w400,
            ),),),  
          
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Enter Address',
          fillColor: Colors.white.withOpacity(0.1),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          suffixIcon: ElevatedButton(
            onPressed: () {},
            child: const Text('Scan'),
            style: ElevatedButton.styleFrom(
           //   primary: Colors.blue[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildViewToggle(double width) {
   // int crossAxisWidth = width < 400 ? 2 : width < 600 ? 2 : width < 900 ? 3 : 4;
   EdgeInsets padding;
  if (width < 400) {
    padding = const EdgeInsets.all(8); // Small screens
  } else if (width < 600) {
    padding = const EdgeInsets.all(16); // Medium screens
  } else if (width < 900) {
    padding = const EdgeInsets.all(24); // Large screens
  } else {
    padding = const EdgeInsets.symmetric(horizontal: 100, vertical: 16); // Very large screens
  }
    return 
    
    
    Padding(
            padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text( 'Assets', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),), 
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const BoxDecoration(  
              color: Color(0xFF132A46)
          
            ),
            child:   Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.grid_view,
                        color: isGridView ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () => setState(() => isGridView = true),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.table_rows,
                        color: !isGridView ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () => setState(() => isGridView = false),
                    ),
                  ],
                ),
             
           
          ),
        ],
      ),
    );
  }

 Widget _buildAssetCard(Coin coinData) {
    return LayoutBuilder(
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
                _buildMetricsSection(isVeryNarrow),
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
                   
                    Text(
                      coinData.name,
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

        IconButton(
        icon:Icon(  Icons.share, size: isVeryNarrow ? 14 : 16,),
        onPressed: () {},
          color: Colors.grey[400],
         
        ),
      ],
    );
  }

  Widget _buildPriceSection(Coin coinData, bool isVeryNarrow) {
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
        const SizedBox(height: 4),
         Row(
           children: [
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
                        Icons.arrow_upward_sharp,
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
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Color(0xFFACACAC),
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
            //color: color,
            border: Border.all(color: color, width: 2
          ),
          )
        ),
      ],
    );
  }

// Update the GridView configuration in _buildGridView
 Widget _buildGridView(double width) {
  // Adjust columns based on width
  int crossAxisCount = width < 400 ? 2 : width < 600 ? 2 : width < 900 ? 3 : 4;
  
  double aspectRatio = width < 400 ? 0.83 : 0.85; // Taller cards on mobile
  
  // Define padding based on screen width
  EdgeInsets padding;
  if (width < 400) {
    padding = const EdgeInsets.all(8); // Small screens
  } else if (width < 600) {
    padding = const EdgeInsets.all(16); // Medium screens
  } else if (width < 900) {
    padding = const EdgeInsets.all(24); // Large screens
  } else {
    padding = const EdgeInsets.symmetric(horizontal: 100, vertical: 16); // Very large screens
  }
    final coinProvider = ref.watch(coinsProvider);
  return SizedBox(
    height: 700,
    child: Center( // Center the GridView
      child: Padding( // Apply padding
        padding: padding,
        child: GridView.builder(
          shrinkWrap: true,
          controller: _scrollController,
          padding: const EdgeInsets.only(bottom: 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: aspectRatio,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: coinProvider.coins.length ,
          itemBuilder: (context, index) => _buildAssetCard(coinProvider.coins[index]),
        ),
      ),
    ),
  );
}


 Widget _buildTableView() {
  final coinProvider = ref.watch(coinsProvider);
  
  return Container(
    color: const Color(0xFF0C1C30),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowHeight: 40,
       // dataRowMinHeight: 60,
        horizontalMargin: 16,
        columnSpacing: 24,
        headingRowColor: WidgetStateProperty.all(Colors.transparent),
        dataRowColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF132A46);
          }
          return const Color(0xFF132A46);
        }),
        dividerThickness: 0.5,
        columns: [
          DataColumn(
            label: Row(
              children: [
                Text('Name ', 
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    fontWeight: FontWeight.w500
                  )
                ),
                Icon(Icons.arrow_downward, size: 12, color: Colors.grey[400])
              ]
            )
          ),
          DataColumn(
            label: Row(
              children: [
                Text('Amount ', 
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    fontWeight: FontWeight.w500
                  )
                ),
                Icon(Icons.arrow_downward, size: 12, color: Colors.grey[400])
              ]
            )
          ),

          DataColumn(
            label: Row(
              children: [
                Text('7d % ', 
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    fontWeight: FontWeight.w500
                  )
                ),
                Icon(Icons.circle_outlined, size: 12, color: Colors.grey[400])
              ]
            )
          ),
          const DataColumn(
            label: Text('Maturity', 
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500
              )
            )
          ),
          const DataColumn(
            label: Text('Dominance', 
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500
              )
            )
          ),
          const DataColumn(
            label: Text('Performance', 
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500
              )
            )
          ),
          const DataColumn(
            label: Text('Loyalty', 
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500
              )
            )
          ),
          const DataColumn(
            label: Text('Liquidity', 
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500
              )
            )
          ),
          const DataColumn(
            label: Text('Whale Manipulation', 
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500
              )
            )
          ),
        ],
        rows: coinProvider.coins.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final asset = entry.value;
          final priceChange = asset.priceChangePercentage24h;
          final isPriceUp = priceChange >= 0;

          return DataRow(
            cells: [
              DataCell(
                Row(
                  children: [
                    Text(
                      '$index',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(asset.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      asset.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '\$${asset.currentPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                 
                  ],
                ),
              ),
              DataCell(      Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 2,),
                 decoration: BoxDecoration(
                        color: isPriceUp ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                child: Text(
                              '${priceChange.abs().toStringAsFixed(2)}%',
                              style: TextStyle(
                                color: isPriceUp ? Colors.green : Colors.red,
                                fontSize: 12,
                              ),
                            ),
              ),
                      ),
            
             ...asset.calculateIndicators().map((isPositive) => 
              
              DataCell(
              
               
                Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:isPositive ? Colors.green:   Colors.red,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              )
              
              ),
        
            ],
          );
        }).toList(),
      ),
    ),
  );
}

}