import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RefreshButton extends StatefulWidget {
  final Future<void> Function() onRefresh;

  const RefreshButton({super.key, required this.onRefresh});

  @override
  _RefreshButtonState createState() => _RefreshButtonState();
}

class _RefreshButtonState extends State<RefreshButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.3)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (isLoading) {
      return;
    }
    _controller.repeat();
    setState(() {
      isLoading = true;
    });
    await widget.onRefresh();
    setState(() {
      isLoading = false;
    });
    _controller.stop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: _handleRefresh,
      child: Container(
        height: heightRatio(52),
        decoration: BoxDecoration(
            color: isLoading ? TTColors.gray600 : TTColors.ttPurple,
            borderRadius: BorderRadius.circular(100)),
        padding:
            const EdgeInsets.only(left: 14, top: 12, bottom: 12, right: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RotationTransition(
              turns: _animation,
              child: SvgPicture.asset(
                'assets/svgs/auto_renew.svg',
                height: 28,
                width: 28,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "위치 새로고침",
              style: TTTextStyle.bodySemibold16.copyWith(color: TTColors.white),
            )
          ],
        ),
      ),
    );
  }
}
