import 'package:chat_location/common/components/async_button.dart';
import 'package:chat_location/common/ui/button/nextButton.dart';
import 'package:chat_location/features/user/presentation/provider/bottom_button_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNextButton extends ConsumerWidget {
  const BottomNextButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomButtonState = ref.watch(bottomButtonProvider);
    return AsyncButton(
        child: SizedBox(
            height: 52,
            width: double.infinity,
            child: bottomNextButton(
                isDisabled: bottomButtonState.isDisabled,
                text: bottomButtonState.text,
                onPressed: () =>
                    ref.read(bottomButtonProvider.notifier).handlePress())),
        onClick: () async {
          await ref.read(bottomButtonProvider.notifier).handlePress();
        });
  }
}
