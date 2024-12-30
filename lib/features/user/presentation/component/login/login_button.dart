import 'package:chat_location/common/ui/button/loginButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginButton extends StatelessWidget {
  final String assetUrl; // 이미지 경로
  final String text; // 버튼에 표시될 텍스트
  final VoidCallback onPressed; // 버튼 클릭 이벤트 콜백
  final Color? backgroundColor;
  const LoginButton(
      {super.key,
      required this.assetUrl,
      required this.text,
      required this.onPressed,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: squareLoginButton(
          backgroundColor: backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // 필요한 만큼만 차지
            children: [
              // 이미지 표시
              SvgPicture.asset(
                assetUrl,
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 15), // 간격 추가
              Text(
                text,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ));
  }
}
