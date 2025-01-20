import 'package:flutter/material.dart';

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

double AVAILABLE_RADIUS_M = 2000;

const String server = "3.37.171.121:8080";
const String local1 = "192.168.0.219:8080";
const String local2 = "192.168.0.168:8080";
const String local3 = "192.168.0.190:8080";
const String localAnyang = "172.30.1.24:8080";

const String BASE_URL = server;
const String LOCAL_URL = server;

const String HIVE_CHATROOM = 'room';
const String HIVE_CHAT_MESSAGE = 'message';
const String HIVE_PROFILE = 'profile';

const String SUBSCRIBE_BASE_URL = '/sub';
const String PUBLISH_BASE_URL = '/pub';
