import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/controller/user_controller.dart';
import 'package:chat_location/core/database/secure_storage.dart';
import 'package:chat_location/features/map/presentation/screen/mapScreen.dart';
import 'package:chat_location/features/user/presentation/component/login/login_button.dart';

const LOGIN_LIST = [
  {
    'platform': LoginPlatform.KAKAO,
    "assetUrl": "assets/svgs/kakao.svg",
    "text": "카카오톡으로 로그인하기",
    "backgroundColor": TTColors.kakaoYellow
  },
  {
    'platform': LoginPlatform.GOOGLE,
    "assetUrl": "assets/svgs/google.svg",
    "text": "Google로 로그인하기",
    "backgroundColor": TTColors.googlGrey
  },
];

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  static const String routeName = '/login';
  static const String pageName = "login";
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isLoading = false;

  /// 로그인 버튼 클릭 처리
  Future<void> handleClickButton(WidgetRef ref, LoginPlatform platform) async {
    setState(() => _isLoading = true);
    try {
      await ref.read(userProvider.notifier).login(platform);
      context.go(MapScreen.routeName);
    } catch (e) {
      _showErrorDialog(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 오류 다이얼로그 표시
  void _showErrorDialog(Object e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그인 오류'),
        content: Text('로그인에 실패했습니다. 오류: $e'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const LogoSection(),
              Padding(
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  bottom: heightRatio(80),
                ),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        await ref.read(userProvider.notifier).logout();
                        await SecureStorageHelper.clearAll();
                      },
                      child: const Text("유저 초기화"),
                    ),
                    LoginButtonList(onButtonPressed: handleClickButton),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoading) const LoadingOverlay(),
        ],
      ),
    );
  }
}

/// 로고와 설명 텍스트를 표시하는 섹션
class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: heightRatio(267)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/svgs/logo.svg'),
          SizedBox(height: heightRatio(32)),
          Text(
            '트래블 톡, 티티',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: TTColors.ttPurple,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            "랜드마크 위치 기반 실시간 채팅 서비스",
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 11,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ],
      ),
    );
  }
}

class LoginButtonList extends ConsumerWidget {
  final Future<void> Function(WidgetRef, LoginPlatform) onButtonPressed;

  const LoginButtonList({required this.onButtonPressed, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: LOGIN_LIST.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final data = LOGIN_LIST[index];
        return LoginButton(
          assetUrl: data["assetUrl"] as String,
          text: data["text"] as String,
          onPressed: () =>
              onButtonPressed(ref, data['platform'] as LoginPlatform),
          backgroundColor: data['backgroundColor'] as Color,
        );
      },
    );
  }
}

/// 로딩 상태를 표시하는 오버레이
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
