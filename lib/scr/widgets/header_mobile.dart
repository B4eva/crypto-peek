import 'package:crypto/scr/styles/style.dart';
import 'package:crypto/scr/widgets/site_logo.dart';
import 'package:flutter/material.dart';

class HeaderMobile extends StatelessWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onLogoTap;
  const HeaderMobile({super.key, this.onMenuTap, this.onLogoTap});

  @override
  Widget build(context) {
    return Container(
      height: 50.0,
      decoration: kHeaderDecoration,
      margin: EdgeInsets.fromLTRB(40, 5, 20, 5),
      child: Row(
        children: [
          SiteLogo(tap: onLogoTap!),
          const Spacer(),
          IconButton(
            onPressed: onMenuTap,
            icon: const Icon(Icons.menu),
          ),
          SizedBox(
            width: 15,
          )
        ],
      ),
    );
  }
}
