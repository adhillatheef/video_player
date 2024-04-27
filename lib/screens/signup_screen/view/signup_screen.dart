import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/common_widgets/loading_widget.dart';
import 'package:video_player/common_widgets/submit_button.dart';

import '../controller/signup_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});


  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final controller = Get.put(SignUpController());
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  //File? _profileImage;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      builder: (obj) {
        bool isLoading = obj.isLoading;

        return Scaffold(
          body: LoadingWidget(
            isLoading: isLoading,
            child: GestureDetector(
              onTap: (){
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Center(
                          child:  Text(
                            'SignUp',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: controller.pickImage,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: controller.profileImage != null
                                    ? FileImage(controller.profileImage!)
                                    : const NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7ut5ImIGij7xxSShxWk-uyCJbjkIdLYpTWNJTJTFnPA&s') as ImageProvider,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    controller.pickImage();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          decoration: InputDecoration(
                            //labelText: 'Name',
                            hintText: 'Enter your name',
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(top: 15.0, bottom: 10, left: 15),
                              child: Icon(Icons.person_outline_outlined, size: 30, color: Colors.blue,),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            //labelText: 'Email',
                            hintText: 'Enter your email',
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(top: 15.0, bottom: 10, left: 15),
                              child: Icon(Icons.email_outlined, size: 30, color: Colors.blue,),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!controller.isValidEmail(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        const Spacer(),
                        CustomButton(function: (){
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()){
                            controller.submitUser(
                                name: _nameController.text.trim(),
                                email: _emailController.text.trim());
                          }
                        }),
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
