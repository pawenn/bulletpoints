import 'package:bulletpoints/constants/deviceDimensions.dart';
import 'package:bulletpoints/views/login/desktop_login_body.dart';
import 'package:bulletpoints/views/login/mobile_login_body.dart';
import 'package:bulletpoints/views/login/tablet_login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ResponsiveLoginView extends StatefulWidget {
  final Widget mobileBody;
  final Widget desktopBody;
  //final Widget tabletBody;

  const ResponsiveLoginView({
    super.key,
    required this.mobileBody,
    required this.desktopBody,
    //required this.tabletBody,
  });

  @override
  State<ResponsiveLoginView> createState() => _ResponsiveLoginViewState();
}

class _ResponsiveLoginViewState extends State<ResponsiveLoginView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Responsive(
      mobile: MobileLoginBody(),
      tab: TabletLoginBody(),
      web: DesktopLoginBody(),
    ));
  }
}

class Responsive extends StatefulWidget {
  const Responsive(
      {required this.mobile, required this.tab, required this.web, Key? key})
      : super(key: key);

  final Widget mobile;
  final Widget tab;
  final Widget web;

  @override
  State<Responsive> createState() => _ResponsiveState();
}

class _ResponsiveState extends State<Responsive> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        print(constraints..maxWidth);

        if (constraints.maxWidth < 480) {
          return widget.mobile;
        } else if (constraints.maxWidth > 480 && constraints.maxWidth <= 850) {
          return widget.tab;
        } else {
          return widget.web;
        }
      },
    );
  }
}
