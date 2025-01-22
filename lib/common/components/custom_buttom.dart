import 'package:flutter/material.dart';

class CustomAnimatedButton extends StatefulWidget {
  final VoidCallback onPressed; // 버튼 눌렀을 때 동작
  final double? width;
  final double? height;
  final Widget child;
  final double padding;

  const CustomAnimatedButton({
    Key? key,
    required this.onPressed,
    this.width,
    this.height,
    this.padding = 2,
    required this.child,
  }) : super(key: key);

  @override
  _CustomAnimatedButtonState createState() => _CustomAnimatedButtonState();
}

class _CustomAnimatedButtonState extends State<CustomAnimatedButton> {
  bool _isPressed = false; // 버튼 눌림 상태

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed, // 손을 뗄 때 실행
      onTapDown: (_) {
        // 버튼을 누름
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        // 버튼에서 손을 뗌
        setState(() {
          _isPressed = false;
        });
      },
      onTapCancel: () {
        // 누른 상태에서 손을 다른 곳으로 이동
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 100), // 크기 전환 속도
          curve: Curves.easeInOut, // 부드러운 애니메이션 효과
          width: widget.width, // 눌렀을 때 크기 감소
          height: widget.height,
          padding:
              EdgeInsets.all(_isPressed ? widget.padding : 0), // 눌렀을 때 패딩 증가
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: widget.child),
    );
  }
}
