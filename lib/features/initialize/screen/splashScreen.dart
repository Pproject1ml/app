import 'dart:developer';

import 'package:chat_location/common/utils/pre_load_svg.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/constants/time_ago_setting.dart';
import 'package:chat_location/controller/notification_controller.dart';
import 'package:chat_location/core/database/no_sql/chat_message.dart';
import 'package:chat_location/core/database/no_sql/chat_room.dart';
import 'package:chat_location/core/database/no_sql/profile.dart';
import 'package:chat_location/core/database/shared_preference.dart';
import 'package:chat_location/features/auth/presentaation/provider/auth_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:lottie/lottie.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Splash 화면으로 초기화 작업 및 사용자 인증 확인을 처리합니다.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/splash';
  static const String pageName = '/splash';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    log("splash Screen initState");
    // 앱 초기화 작업을 실행하고 사용자 인증 상태를 확인합니다.
    _initializeApp().then((_) {
      log("initialized finish");
      Future.delayed(Duration.zero, () async {
        await ref.read(authProvider.notifier).checkIfAuthenticated();
        ref.read(notificationControllerProvider.notifier).build();
      });
    });
  }

  /// 비동기로 초기화 작업을 수행합니다.
  Future<void> _initializeApp() async {
    log("initialize start");
    // 환경 변수 파일 로드
    await dotenv.load(fileName: 'assets/config/.env');

    // Kakao SDK 초기화
    KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']!);

    // Shared Preferences 초기화
    await SharedPreferencesHelper.init();

    // 한국어 로케일 초기화
    await initializeDateFormatting('ko_KR', null);

    timeago.setLocaleMessages('ko', CustomKoMessages());
    final RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    // 채팅 local db init
    await Hive.initFlutter();
    Hive.registerAdapter(ChatRoomHiveModelAdapter()); // 채팅방 어댑터
    Hive.registerAdapter(ChatMessageHiveModelAdapter()); // 채팅 어댑터
    Hive.registerAdapter(ProfileHiveModelAdapter());
    await Hive.openLazyBox<ChatRoomHiveModel>(HIVE_CHATROOM); // LazyBox 열기

    // SVG 리소스 미리 로드
    await preloadSvg([
      'assets/svgs/logo.svg',
      'assets/svgs/kakao.svg',
      'assets/svgs/google.svg',
    ]);
    await Future.delayed(const Duration(seconds: 2));
    log("splash screen init end");
  }

  @override
  Widget build(BuildContext context) {
    log("splash Screen build");

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Lottie.asset('assets/animation/logo.json', repeat: true),
        ),
      ),
    );
  }
}
