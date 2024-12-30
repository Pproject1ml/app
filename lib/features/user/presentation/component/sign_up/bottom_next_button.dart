import 'package:chat_location/common/ui/button/nextButton.dart';
import 'package:chat_location/controller/user_controller.dart';
import 'package:chat_location/features/map/presentation/screen/mapScreen.dart';
import 'package:chat_location/features/user/presentation/provider/bottom_button_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BottomNextButton extends ConsumerStatefulWidget {
  const BottomNextButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BottomNextButtonState();
}

class _BottomNextButtonState extends ConsumerState<BottomNextButton> {
  bool _isLoading = false;

  Future<void> handleClickButton(BottomButtonState state) async {
    setState(() {
      _isLoading = true;
    });
    await ref.read(bottomButtonProvider.notifier).handlePress();
    if (state.text == "회원가입") {
      context.go(MapScreen.routeName);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomButtonState = ref.watch(bottomButtonProvider);
    return Opacity(
      opacity: _isLoading ? 0.5 : 1,
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: Stack(
          children: [
            bottomNextButton(
                isDisabled: bottomButtonState.isDisabled,
                text: bottomButtonState.text,
                onPressed: () =>
                    _isLoading ? null : handleClickButton(bottomButtonState)),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
          ],
        ),
      ),
    );
  }
}
