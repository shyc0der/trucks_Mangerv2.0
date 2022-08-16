import 'package:flutter/material.dart';
import 'package:trucks_manager/src/models/model.dart';
import 'package:trucks_manager/src/ui/pages/home_page.dart';
import 'package:trucks_manager/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Model.initiateDbs(
    
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: themeData, home: const HomePage());
  }
}
