import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

const bgColor = Color(0xff1f212c);
const whiteColor = Color(0xffffffff);
const sliderColor = Color(0xff7e70ff);
const buttonColor = Color(0xff60e95d);
const bgDarkColor = Color(0xff070b11);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xff1f212c),
  primaryColorDark: const Color(0xff070b11),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0
    )
);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  primaryColorDark: Colors.blueGrey,
  primaryColorLight: Colors.lightBlue,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0
    )
);