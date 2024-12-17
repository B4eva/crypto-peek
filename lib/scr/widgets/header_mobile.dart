import 'package:crypto_tracker/scr/styles/style.dart';
import 'package:crypto_tracker/scr/widgets/site_logo.dart';
import 'package:flutter/material.dart';

class HeaderMobile extends StatelessWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onLogoTap;
  const HeaderMobile({super.key, this.onMenuTap, this.onLogoTap});

  @override
  Widget build(context) {
    return Container(
      height: 50.0,
      //    decoration: kHeaderDecoration,
      margin: const EdgeInsets.fromLTRB(40, 5, 20, 5),
      child: Row(
        children: [
          SiteLogo(tap: onLogoTap!),
          // Container(
          //   width: 200,
          //   margin: const EdgeInsets.symmetric(horizontal: 16.0),
          //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
          //   decoration: BoxDecoration(
          //     color: const Color(0xFFF6F6F6),
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: const Row(
          //     children: [
          //       Expanded(
          //         child: TextField(
          //           decoration: InputDecoration(
          //             border: InputBorder.none,
          //             hintText: "Search Coin",
          //           ),
          //         ),
          //       ),
          //       Icon(Icons.search, color: Colors.grey),
          //     ],
          //   ),
          // ),
          const Spacer(),
          IconButton(
            onPressed: onMenuTap,
            icon: const Icon(Icons.menu),
          ),
          const SizedBox(
            width: 15,
          )
        ],
      ),
    );
  }
}
