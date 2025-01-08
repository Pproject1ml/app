import 'package:flutter/material.dart';

class BottomUpDialog extends StatefulWidget {
  const BottomUpDialog({super.key, required this.child});
  final Widget child;
  @override
  _BottomUpDialogState createState() => _BottomUpDialogState();
}

class _BottomUpDialogState extends State<BottomUpDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1), // 시작 위치: 화면 아래
      end: Offset(0, 0), // 끝 위치: 화면 중간
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // 애니메이션 시작
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.bottomCenter,
      insetPadding: EdgeInsets.zero, // 화면 전체를 사용할 수 있도록 설정
      backgroundColor: Colors.transparent, // 투명 배경
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
