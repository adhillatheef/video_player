import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../constants/static_data.dart';
import '../../home_screen/view/home_screen.dart';
import '../../signup_screen/view/signup_screen.dart';



class OtpController extends GetxController {
  bool isLoading = false;
  bool hasError = false;
  String errorText = '';
  StreamController<ErrorAnimationType>? errorController;
  int countdownDuration = 30; // Duration in seconds
  late Timer timer;
  bool isTimerLoading = false;

  @override
  void onInit() {
    super.onInit();
    startTimer();
    errorController = StreamController<ErrorAnimationType>();
  }

  @override
  void onClose() {
    super.onClose();
    timer.cancel();
    countdownDuration = 30;
    errorController!.close();
  }

  Future<void> verifyOTPCode(String otp, String verificationId) async {
    isLoading = true;
    update();

    if (otp.length != 6) {
      isLoading = false;
      hasError = true;
      errorText = 'OTP should contain 6 digits.';
      errorController!.add(ErrorAnimationType.shake);
      update();
      return;
    }

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        StaticData.uid = user.uid;
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        log("User documents exist: ${userDoc.exists.toString()}");

        if (userCredential.additionalUserInfo!.isNewUser) {
          Get.offAll(() => const SignUpScreen());        } else {
          if (userDoc.exists) {
            log("User already exists");
            StaticData.saveUserDataToSharedPreferences(
              user.uid,
              userDoc['name'],
              userDoc['phoneNumber'],
              userDoc['email'],
              userDoc['profilePhoto'],
            );
            StaticData.loadUserDataFromSharedPreferences();
            Get.offAll(() => const HomeScreen());
          } else {
            log("New user signing up");
            Get.offAll(() => const SignUpScreen());
          }
        }
      }
    } catch (e) {
      isLoading = false;
      hasError = true;
      update();

      log(e.toString());

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-verification-code':
            hasError = true;
            errorText = 'Invalid OTP. Please check the code and try again.';
            errorController!.add(ErrorAnimationType.shake);
            break;
          case 'too-many-requests':
            errorText =
            'Too many login attempts. Please try again later.';
            break;
          case 'session-expired':
            errorText = 'Session has expired. Please request a new OTP.';
            break;
          default:
            errorText = 'Authentication failed. Please try again.';
        }
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  void startTimer() {
    debugPrint("timer started");
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      isTimerLoading = true;
      update();
      if (countdownDuration > 0) {
        countdownDuration--;
        update();
      } else {
        timer.cancel();
        isTimerLoading = false;
        update();
        countdownDuration = 30;
      }
    });
  }

  Future<void> resendOtp(String phoneNumber, int? resendToken) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
      // Handle verification completed
    }
    verificationFailed(FirebaseAuthException authException) {}
    codeSent(String verificationId, [int? forceResendingToken]) async {}
    codeAutoRetrievalTimeout(String verificationId) {}

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        forceResendingToken: resendToken,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
