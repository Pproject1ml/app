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

String BASE_URL = "http://3.37.171.121:8080/";
// user info 와 관련된 데이터 정의

// 어디에서 input_user_screen으로 진입하는지 분기점 설정
// first - 첫 진입
// add - 추가
// modify - 수정
enum InputStatus { first, add, modify }

// 어디에서 tutorial_screen으로 진입하는지 분기점 설정
// first - 첫 진입
// second - setting 창에서 진입
enum TutorialStatus { first, second }

// 어디에서 show_select_user_dialog로 진입하는지 분기점 설정
// goonghap - 궁합에서 진입
// infobar - user_info_bar에서 진입
enum SelectUserStatus { goonghap, infobar }
