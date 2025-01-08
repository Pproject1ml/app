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

int selectedUserId = 0;
int userListLength = 0;
const String server = "3.37.171.121:8080";
const String local1 = "192.168.0.11:8080";
const String local3 = "192.168.0.190:8080";
const String localAnyang = "172.30.1.6:8080";
const String BASE_URL = localAnyang;
const String LOCAL_URL = localAnyang;

// user info 와 관련된 데이터 정의

const String HIVE_CHATROOM = 'chatrooms';
const String HIVE_CHAT_MESSAGE = 'chatMessage';

const String SUBSCRIBE_BASE_URL = 'sub';
const String PUBLISH_BASE_URL = 'pub';
