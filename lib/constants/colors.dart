import 'package:flutter/material.dart';

class TTColors {
  static const black01 = Color(0xff333333);
  static const gray = Color.fromRGBO(174, 174, 178, 1);
  static const gray2 = Color.fromRGBO(174, 174, 178, 1);
  static const gray3 = Color.fromRGBO(199, 199, 204, 1);
  static const gray4 = Color.fromRGBO(209, 209, 214, 1);
  static const gray5 = Color.fromRGBO(229, 229, 234, 1);
  static const gray6 = Color.fromRGBO(242, 242, 247, 1);
  static const gray200 = Color.fromRGBO(224, 229, 235, 1);
  static const gray900 = Color.fromRGBO(11, 11, 11, 1);
  static const purple100 = Color.fromRGBO(226, 229, 255, 1);
  static const purple200 = Color.fromRGBO(141, 155, 255, 1);
  static const purple300 = Color.fromRGBO(111, 67, 255, 1);
  static const purple400 = Color.fromRGBO(78, 24, 186, 1);
  static const red = Color.fromRGBO(255, 45, 85, 1);
  static const white = Color.fromRGBO(255, 255, 255, 1);

  static const violet = Color.fromRGBO(233, 227, 255, 1);
  static const kakaoYellow = Color.fromRGBO(254, 229, 0, 1);
  static const googlGrey = Color.fromRGBO(233, 235, 243, 1);
  static const ttPurple = purple300;
  static const chatEventBgColor = Color.fromRGBO(142, 142, 147, 0.8);
  static const backgroundPrimary = white;
  static const backgroundSecondary = white;
}

extension ColorExtension on String {
  toColor() {
    var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
