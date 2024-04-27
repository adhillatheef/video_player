import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/static_data.dart';
import '../../splash_screen/view/splash_screen.dart';
import '../controller/homeScreen_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.put(HomeScreenController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
      builder: (obj) {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: const Text(
              'Video Player',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                scaffoldKey.currentState?.openDrawer();
              },
              icon: const Icon(Icons.menu,size: 30,),
            ),
          ),
          drawer: Drawer(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 40,
                        backgroundImage: StaticData.profilePhoto != null
                            ? NetworkImage(StaticData.profilePhoto!)
                            : const NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7ut5ImIGij7xxSShxWk-uyCJbjkIdLYpTWNJTJTFnPA&s') as ImageProvider,
                      ),
                      title: Text(
                        StaticData.name ?? "",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 24),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.person_outline, color: Colors.blue,),
                      title: Text('User Information', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.blue),),
                    ),
                     ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.logout, color: Colors.red,),
                      title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.red),),onTap: () async {
                       final navigator = Navigator.of(context);
                       StaticData.clearUserDataFromSharedPreferences();
                       navigator.pushAndRemoveUntil(
                         MaterialPageRoute(
                             builder: (context) => const SplashScreen()),
                             (route) => false,
                       );
                     }),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
