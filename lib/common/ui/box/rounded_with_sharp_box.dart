import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/text_style.dart';
import 'package:flutter/material.dart';

Widget roundedWithSharp(
  String message,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      CustomPaint(
        size: const Size(20, 16),
        painter: TrianglePainter(),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: TTColors.purple100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TTTextStyle.bodyRegular14.copyWith(
              height: 1.22, letterSpacing: -0.3, color: TTColors.black),
        ),
      ),
    ],
  );
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = TTColors.purple100 // 삼각형 색상
      ..style = PaintingStyle.fill;

    final Path path = Path();
    // 삼각형의 꼭짓점 좌표 설정
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
