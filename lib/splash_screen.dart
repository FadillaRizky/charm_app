import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../constants.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isEnable = true;

  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 1),
          () {
        isEnable = false;
        Navigator.of(context).pushReplacement(PageTransition(
            duration: Duration(seconds: 3),
            type: PageTransitionType.fade,
            child: Login()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              HeroMode(
                enabled: isEnable,
                child: Hero(
                  tag: "logo",
                  child: Image.asset(
                    'assets/logo_charm.png',
                    width: width / 3,
                  ),
                ),
              ),
              SizedBox(
                height: height / 2.5,
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
