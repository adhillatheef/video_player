import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:video_player/common_widgets/loading_widget.dart';

import '../../../common_widgets/submit_button.dart';
import '../../../constants/static_data.dart';
import '../../mobile_number_screen/view/mobile_number_screen.dart';
import '../controller/otp_controller.dart';

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
  final controller = Get.put(OtpController());
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String currentText = "";

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OtpController>(
      builder: (obj) {
        return Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: LoadingWidget(
              isLoading: controller.isLoading,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Enter the code sent to your phone',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        const Text(
                          'The code was sent to the number',
                          style:  TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "${widget.countryCode}${widget.mobileNumber}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MobileNumberScreen(
                                          mobileNumber: widget.mobileNumber,
                                        ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.black,
                                size: 16,
                              ),
                            )
                          ],
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
                                activeFillColor: Colors.blue[200],
                                activeBorderWidth: 1,
                                activeColor: Colors.blue,
                                selectedBorderWidth: 1,
                                selectedColor: Colors.blue,
                                selectedFillColor: Colors.blue[200],
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
                              errorAnimationController: controller.errorController,
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
                                controller.verifyOTPCode(
                                  currentText,
                                  widget.verificationId,
                                );
                                debugPrint("Completed");
                              },
                              onChanged: (value) {
                                controller.errorText = '';
                                controller.hasError = false;
                                debugPrint(value);
                                setState(() {
                                  currentText = value;
                                });
                              },
                              beforeTextPaste: (text) {
                                debugPrint("Allowing to paste $text");
                                return true;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        controller.errorText != ''
                            ? Center(
                            child: Text(
                              controller.errorText,
                              style: const TextStyle(color: Colors.red),
                            ))
                            : const SizedBox(),
                        controller.isTimerLoading
                            ? Center(
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  const TextSpan(
                                    text: 'Get a new code in ',
                                    style: TextStyle(
                                      fontFamily: "Urbanist",
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                    '00.${controller.countdownDuration}',
                                    style: const TextStyle(
                                      fontFamily: "Urbanist",
                                      fontSize: 16,
                                      color: Colors
                                          .black, // Set the color to black
                                    ),
                                  ),
                                ],
                              ),
                            ))
                            : Center(
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Didn't receive OTP yet? ",
                                style: TextStyle(
                                  fontFamily: "Urbanist",
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  controller.startTimer();
                                  controller.resendOtp(
                                      StaticData.mobileNumber!,
                                      widget.forceResendingToken);
                                },
                                child: const Text(
                                  'Resend',
                                  style: TextStyle(
                                    fontFamily: "Urbanist",
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        CustomButton(
                          function: () {
                            _formKey.currentState!.validate();
                            controller.verifyOTPCode(
                                currentText, widget.verificationId);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
