
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
      margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Row(
        children: [
          SiteLogo(tap: onLogoTap!),

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
