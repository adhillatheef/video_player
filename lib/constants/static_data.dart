import 'package:shared_preferences/shared_preferences.dart';

class StaticData{
  static String? uid;
  static String? mobileNumber;
  static String? name;
  static String? email;
  static String? profilePhoto;

  static Future<void> saveUserDataToSharedPreferences(
      String uid, String name, String phoneNumber, String buildingNumber, String area) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', uid);
    prefs.setString('name', name);
    prefs.setString('phone', phoneNumber);
    prefs.setString('email', buildingNumber);
    prefs.setString('profilePhoto', area);
  }

  static Future<void> clearUserDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
    await prefs.remove('name');
    await prefs.remove('phone');
    await prefs.remove('email');
    await prefs.remove('profilePhoto');
  }

  static Future<void> loadUserDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    name = prefs.getString('name');
    mobileNumber = prefs.getString('phone');
    email = prefs.getString('email');
    profilePhoto = prefs.getString('profilePhoto');
  }
}