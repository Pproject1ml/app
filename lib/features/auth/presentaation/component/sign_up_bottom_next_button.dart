import 'dart:developer';

import 'package:chat_location/common/components/async_button.dart';
import 'package:chat_location/common/ui/button/nextButton.dart';
import 'package:chat_location/common/utils/bottom_snack_bar.dart';
import 'package:chat_location/features/auth/presentaation/provider/sign_up_bottom_button_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpBottomNextButton extends ConsumerWidget {
  const SignUpBottomNextButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomButtonState = ref.watch(signUpBottomButtonProvider);
    final bottomButtonNotifier = ref.read(signUpBottomButtonProvider.notifier);
    Future<void> handleClick() async {
      try {
        await bottomButtonNotifier.handlePress();
      } catch (e) {
        showSnackBar(context: context, message: e.toString());
      }
    }

    return AsyncButton(
        child: SizedBox(
            height: 52,
            width: double.infinity,
            child: bottomNextButtonT(
              isDisabled: bottomButtonState.isDisabled,
              text: bottomButtonState.text,
            )),
        onClick: () async {
          await handleClick();
        });
  }
}
