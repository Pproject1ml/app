import 'package:flutter/material.dart';

// void showBottomUpDialog(BuildContext context, Widget child) {
//   Navigator.of(context).push(PageRouteBuilder(
//     opaque: false, // 배경을 투명하게 설정
//     barrierDismissible: true, // 바깥 클릭으로 닫기
//     pageBuilder: (_, __, ___) => _BottomUpDialog(child: child,), // 팝업 화면 위젯
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const begin = Offset(0.0, 1.0); // 시작 위치: 화면 아래
//       const end = Offset.zero; // 종료 위치: 원래 위치
//       const curve = Curves.easeInOut; // 애니메이션 커브

//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//       var offsetAnimation = animation.drive(tween);

//       return SlideTransition(
//         position: offsetAnimation,
//         child: child,
//       );
//     },
//   ));
// }

// showDialog(
//               context: context,
//               barrierDismissible: true, // 외부 탭으로 닫기 가능
//               builder: (BuildContext context) {
//                 return _BottomUpDialog();
//               },
            // )

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
      child: 
      SlideTransition(
        position: _slideAnimation,
        child: widget.child
      ),
    );
  }
}