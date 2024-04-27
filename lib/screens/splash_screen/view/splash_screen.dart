import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/screens/mobile_number_screen/view/mobile_number_screen.dart';

import '../../../constants/static_data.dart';
import '../../home_screen/view/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    asyncMethod();
  }

  asyncMethod() async {
    final navigator = Navigator.of(context);
    Timer(
      const Duration(seconds: 4),
          () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? uid = prefs.getString('uid');

        if (uid != null && uid.isNotEmpty) {
          StaticData.loadUserDataFromSharedPreferences();
          Get.offAll(
                () => const HomeScreen(),
            transition: Transition.fade,
          );
        } else {
          navigator.pushReplacement(
            MaterialPageRoute(builder: (context) => const MobileNumberScreen()),
          );
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Lottie.asset('assets/lottie/video_player.json',
            renderCache: RenderCache.raster,
          ),
        ),
      ),
    );
  }
}
