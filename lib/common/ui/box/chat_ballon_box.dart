import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:flutter/material.dart';

class ChatBallon extends StatelessWidget {
  const ChatBallon({super.key, this.chat});
  final String? chat;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightRatio(55),
      width: widthRatio(70),
      child: Stack(
        // clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomPaint(
              size: Size(15, 19), // 삼각형 크기
              painter: InvertedTrianglePainter(),
            ),
          ),
          Container(
            height: heightRatio(45),
            width: widthRatio(70),
            decoration: BoxDecoration(
              color: TTColors.ttPurple,
              borderRadius: BorderRadius.circular(999),
            ),
            alignment: Alignment.center,
            child: Text(
              chat ?? '',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class InvertedTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = TTColors.ttPurple
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0); // 왼쪽 위 꼭짓점
    path.lineTo(size.width, 0); // 오른쪽 위 꼭짓점
    path.lineTo(size.width / 2, size.height); // 아래 중앙 꼭짓점
    path.close(); // 삼각형 닫기

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
