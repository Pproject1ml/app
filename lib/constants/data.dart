import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

double deviceWidth = 0;
double deviceHeight = 0;

// iPhone12 mini 기준
// 상수(변경 X)
double standardDeviceWidth =
    MediaQueryData.fromView(WidgetsBinding.instance.window).size.width;
double standardDeviceHeight =
    MediaQueryData.fromView(WidgetsBinding.instance.window).size.height;

double widthRatio(double width) {
  final deviceWidthRatio = deviceWidth / standardDeviceWidth;
  return width * deviceWidthRatio;
}

double heightRatio(double height) {
  final deviceHeightRatio = deviceHeight / standardDeviceHeight;
  return height * deviceHeightRatio;
}

double AVAILABLE_RADIUS_M = 10000;
double SEARCH_RADIUS = 100000;

final String BASE_URL = dotenv.env['SERVER_URL'] ?? '';
final String HTTPS_BASE_URL = dotenv.env['SERVER_SERVICE_URL'] ?? '';

const String HIVE_CHATROOM = 'room';
const String HIVE_CHAT_MESSAGE = 'message';
const String HIVE_PROFILE = 'profile';

const String HIVE_PERSONAL_CHATROOM = 'personalroom';
const String HIVE_PERSONAL_CHAT_MESSAGE = 'personalmessage';

const String SUBSCRIBE_BASE_URL = '/sub';
const String PUBLISH_BASE_URL = '/pub';
