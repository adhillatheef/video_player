import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/submit_button.dart';
import '../controller/mobile_number_controller.dart';

class MobileNumberScreen extends StatefulWidget {
  final String? mobileNumber;
  const MobileNumberScreen({super.key, this.mobileNumber});

  @override
  _MobileNumberScreenState createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> {

  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controller = Get.put(MobileNumberController());
  bool _isFormInvalid = false;

  @override
  void initState() {
    super.initState();
    if(widget.mobileNumber!=null && widget.mobileNumber!.isNotEmpty){
      _controller.text=widget.mobileNumber!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<MobileNumberController>(
      builder: (obj) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50),
            child: Form(
              key: _formKey,
              autovalidateMode: _isFormInvalid
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
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
                  Expanded(
                    child: TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.phone,
                      decoration:  InputDecoration(
                        contentPadding:  const EdgeInsets.symmetric(vertical: 3),
                        prefixIcon: const Padding(
                          padding:  EdgeInsets.only(top: 15.0, bottom: 10, left: 15),
                          child: Text('+91  ', style: TextStyle(fontSize:24, fontWeight: FontWeight.w600),),
                        ),
                        hintText: '9876543210',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                      maxLength: 10,
                      onChanged: (value) {
                        if (_formKey.currentState != null) {
                          _formKey.currentState!.validate();
                          setState(() {
                            _isFormInvalid = false;
                          });
                        }
                        obj.hasError = false;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  obj.hasError?Text(
                    obj.errorText,
                    style: const TextStyle(color: Colors.red),
                  ) : const SizedBox(),
                  CustomButton(function: () {
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      setState(() {
                        _isFormInvalid = false;
                      });
                      controller.verifyUserPhoneNumber('+91', _controller.text.trim());
                      debugPrint("form validated");
                    }
                  },)
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
