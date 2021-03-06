import 'package:flutter/material.dart';


class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const Responsive({
    Key? key,
    required this.mobile,
    this.tablet =  const SizedBox.shrink(),
    required this.desktop,
  }) : super(key: key);

  static deviceWidth(double p,BuildContext context)
  {
    return MediaQuery.of(context).size.width*(p/100);
  }
  static deviceHeight(double p,BuildContext context)
  {
    return MediaQuery.of(context).size.height*(p/100);
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 800;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 800 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static bool isMobileH(BuildContext context) =>
      MediaQuery.of(context).size.height < 800;

  static bool isTabletH(BuildContext context) =>
      MediaQuery.of(context).size.height >= 800 &&
          MediaQuery.of(context).size.height < 2200;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return desktop;
        } else if (constraints.maxWidth >= 800) {
          return tablet != SizedBox.shrink() ?  tablet :  mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}
