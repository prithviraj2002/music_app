import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:music_app/appwrite/appwrite_auth.dart';
import 'package:music_app/consts/colors.dart';
import 'package:music_app/views/home.dart';
import 'package:music_app/views/login.dart';

import 'views/splash_screen.dart';

var user;
var userId;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final box = GetStorage();
  userId = box.read('userId');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  bool isDarkMode = false;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Beats',
      theme: isDarkMode ? darkTheme : lightTheme,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      //   appBarTheme: const AppBarTheme(
      //     backgroundColor: Colors.transparent,
      //     elevation: 0
      //   )
      // ),
      home: Splash(),
    );
  }
}

