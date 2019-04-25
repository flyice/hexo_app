import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
          child: Center(
        child: Container(
          width: 100,
          height: 100,
          child: SvgPicture.asset(
            'assets/images/hexo_logo.svg',
            color: Theme.of(context).primaryColor,
          ),
        ),
      )),
    );
  }
}
