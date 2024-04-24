import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../common_widgets/submit_button.dart';

class OTPScreen extends StatefulWidget {
  final String countryCode;
  final String mobileNumber;
  final String verificationId;
  final int? forceResendingToken;
  const OTPScreen({super.key,
    required this.countryCode,
    required this.mobileNumber,
    required this.verificationId,
    this.forceResendingToken});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType>? errorController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Enter your mobile Number',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: PinCodeTextField(
                    autoFocus: true,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                    appContext: context,
                    length: 6,
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 50,
                      activeFillColor: Colors.blue,
                      activeBorderWidth: 1,
                      activeColor: Colors.blue,
                      selectedBorderWidth: 1,
                      selectedColor: Colors.blue,
                      selectedFillColor: Colors.blue,
                      inactiveBorderWidth: 1,
                      inactiveColor: Colors.grey,
                      inactiveFillColor: CupertinoColors.systemGrey4,
                      errorBorderColor: Colors.red,
                      errorBorderWidth: 1,
                    ),
                    cursorColor: Colors.black,
                    animationDuration: const Duration(
                      milliseconds: 300,
                    ),
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black12,
                        blurRadius: 10,
                      )
                    ],
                    onCompleted: (v) {
                      // controller.verifyOTPCode(
                      //   currentText,
                      //   widget.verificationId,
                      // );
                      debugPrint("Completed");
                    },
                    onChanged: (value) {
                      // controller.errorText = '';
                      // controller.hasError = false;
                      // debugPrint(value);
                      // setState(() {
                      //   currentText = value;
                      // });
                    },
                    beforeTextPaste: (text) {
                      debugPrint("Allowing to paste $text");
                      return true;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(function: () {
                if (_formKey.currentState!.validate()) {
                  // Handle form submission
                  debugPrint('Mobile number: ${_controller.text}');
                }
              },)
            ],
          ),
        ),
      ),
    );
  }
}
