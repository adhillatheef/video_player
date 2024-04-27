import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants/constatns.dart';
import '../../../constants/static_data.dart';
import '../../home_screen/view/home_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';


class SignUpController extends GetxController {
  bool isLoading = false;
  late Uri downloadURL;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  File? profileImage;


  submitUser({required String name, required String email}) async {
    isLoading = true;
    update();
    try {
      if(profileImage !=null){
        downloadURL = await uploadPic(profileImage!);
      }else{
        downloadURL = Uri.parse('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7ut5ImIGij7xxSShxWk-uyCJbjkIdLYpTWNJTJTFnPA&s');
      }
      StaticData.name = name;
      StaticData.email = email;
      StaticData.profilePhoto = downloadURL.toString();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(StaticData.uid)
          .set({
        'uid': StaticData.uid,
        'phoneNumber': StaticData.mobileNumber,
        'name': StaticData.name,
        'email': StaticData.email,
        'profilePhoto': StaticData.profilePhoto,
      });
      StaticData.saveUserDataToSharedPreferences(
          StaticData.uid!,
          StaticData.name!,
          StaticData.mobileNumber!,
          StaticData.email!,
          StaticData.profilePhoto!);
      StaticData.loadUserDataFromSharedPreferences();
      isLoading = false;
      update();
      Get.offAll(const HomeScreen());
      debugPrint("Validated");
    } catch (e) {
      isLoading = false;
      update();
      showToast(
          message: "Sorry, unable to process, please try again after sometime");
      debugPrint(e.toString());
    }
  }


  Future<Uri> uploadPic(File imageFile) async {
    try {
      isLoading = true;
      update();
      Reference reference = _storage.ref().child("images/${DateTime.now().millisecondsSinceEpoch}.jpg");
      UploadTask uploadTask = reference.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      var url = await snapshot.ref.getDownloadURL();
      downloadURL = Uri.parse(url);
      print(downloadURL);
      isLoading = false;
      update();
      return downloadURL;
    } catch (error) {
      isLoading = false;
      update();
      showToast(
          message: "Sorry, unable to process, please try again after sometime");
      print('Error uploading image: $error');
      rethrow;
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
        profileImage = File(pickedImage.path);
        update();
    }
  }


  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

}
