import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../constants/static_data.dart';
import '../../otp_screen/view/otp_screen.dart';

class MobileNumberController extends GetxController {
  bool isLoading = false;
  String errorText = '';
  bool hasError = false;
  Future<void> verifyUserPhoneNumber(String countryCode, String number) async {
    isLoading = true;
    update();
    try {
      String phoneNumber = countryCode + number;
      int? forceResendingToken;
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          hasError = true;
          isLoading = false;
          errorText = _handleVerificationError(e);
          update();
        },
        codeSent: (String verificationId, int? resendToken) {
          forceResendingToken = resendToken;
          isLoading = false;
          update();
          StaticData.mobileNumber = phoneNumber;
          Get.off(
                () => OTPScreen(
                verificationId: verificationId,
                forceResendingToken: forceResendingToken,
                countryCode: countryCode,
                mobileNumber: number),
          );
          hasError = false;
          update();
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      isLoading = false;
      update();
    }
  }

  String _handleVerificationError(FirebaseAuthException e) {
    String errorMessage = 'An error occurred while verifying the phone number.';
    switch (e.code) {
      case 'invalid-phone-number':
        errorMessage =
        'Invalid phone number. Please enter a valid phone number.';
        break;
      case 'invalid-verification-code':
        errorMessage = 'Invalid verification code. Please enter a valid OTP.';
        break;
      case 'invalid-session-info':
        errorMessage = 'Invalid session information. Please try again later.';
        break;
      default:
        errorMessage = 'Verification failed. Please try again later.';
        break;
    }
    return errorMessage;
  }
}
