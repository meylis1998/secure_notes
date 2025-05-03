// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/config/config.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 3),
      () => context.go(AppRoutes.home),
    );
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Color.fromRGBO(180, 155, 135, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash.png',
              width: Constants.deviceWidth(context) / 2.5,
              height: Constants.deviceHeight(context) / 2.5,
            ),

            Text(
              'Secure Notes App',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
