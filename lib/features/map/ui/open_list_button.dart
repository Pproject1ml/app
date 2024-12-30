import 'package:chat_location/common/ui/box/rounded_box.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/constants/theme.dart';
import 'package:flutter/material.dart';

class OpenListButton extends StatelessWidget {
  const OpenListButton({super.key, this.isOpened = false});
  final bool isOpened;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isOpened ? 0.6 : 1,
      child: SizedBox(
        width: widthRatio(93),
        child: RoundedContainer(
            backgroundColor: TTColors.ttPurple,
            child: Padding(
              padding: EdgeInsets.only(
                  top: heightRatio(3),
                  bottom: heightRatio(3),
                  left: widthRatio(14),
                  right: widthRatio(8)),
              child: SizedBox(
                child: Row(
                  children: [
                    (Text(isOpened ? '목록닫기' : '목록열기',
                        style: TTTextTheme.darkTextTheme.labelMedium)),
                    AnimatedRotation(
                      turns: isOpened ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                        size: 15,
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
