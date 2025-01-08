import 'dart:developer';

import 'package:chat_location/common/components/async_button.dart';
import 'package:chat_location/common/utils/bottom_snack_bar.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/features/user/presentation/provider/user_controller.dart';
import 'package:chat_location/features/user/domain/entities/member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfileButton extends ConsumerWidget {
  const EditProfileButton({super.key, required this.tempUser});
  final MemberInterface tempUser;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> _onClickSave(MemberInterface userInfo) async {
      try {
        log("clci");
        await ref.read(userProvider.notifier).updateUserInfo(userInfo);
      } catch (e) {
        showSnackBar(context: context, message: e.toString());
      }
    }

    return AsyncButton(
        onClick: () async {
          await _onClickSave(tempUser);
        },
        callback: () {
          Navigator.of(context).pop();
        },
        child: SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                  color: TTColors.ttPurple,
                  borderRadius: BorderRadius.circular(8)),
              child: const Center(
                child: Text(
                  '프로필 저장하기',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            )));
  }
}
