import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:music_app/consts/colors.dart';

const bold = "bold";
const regular = "regular";

TextStyle? ourStyle({family = regular, double size = 14.0, color = whiteColor}){
  return TextStyle(fontSize: size, color: color, fontFamily: family);
}