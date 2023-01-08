import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucks_manager/src/models/model.dart';
import 'package:trucks_manager/src/modules/firebase_user_module.dart';
import 'package:trucks_manager/src/modules/job_module.dart';
import 'package:trucks_manager/src/modules/order_modules.dart';
import 'package:trucks_manager/src/modules/trucks_modules.dart';
import 'package:trucks_manager/src/modules/user_modules.dart';
import 'package:trucks_manager/src/ui/login_page.dart';
import 'package:trucks_manager/src/ui/pages/home_page.dart';

import 'package:trucks_manager/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Model.initiateDbs();
  Get.put(OrderModules());
  Get.put(UserModule());
  Get.put(JobModule());
  Get.put(TruckModules());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final UserModule userModule = Get.put(UserModule());
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseUserModule.userLoginState(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const MaterialApp(
                  home: Material(
                      child: Center(child: LinearProgressIndicator())));
            case ConnectionState.none:
              return const MaterialApp(
                  home: Material(child: Text('no connection')));
            default:
              if (snapshot.data != null) {
                userModule.setCurrentUser(snapshot.data!.uid.toString());
                
                return GetMaterialApp(theme: themeData, home: const HomePage());
              } else {
                return GetMaterialApp(
                    theme: themeData, home: const LoginPage());
              }
          }
        });
  }
}
