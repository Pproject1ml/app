import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomButtonState {
  final bool isDisabled;
  final VoidCallback? onPress;

  BottomButtonState({
    required this.isDisabled,
    this.onPress,
  });

  BottomButtonState copyWith({
    bool? isDisabled,
    VoidCallback? onPress,
  }) {
    return BottomButtonState(
      isDisabled: isDisabled ?? this.isDisabled,
      onPress: onPress ?? this.onPress,
    );
  }
}

class BottomButtonController extends StateNotifier<BottomButtonState> {
  BottomButtonController()
      : super(BottomButtonState(isDisabled: true, onPress: null));

  // 상태 업데이트: 버튼 활성/비활성 설정
  void setDisabled(bool isDisabled) {
    state = state.copyWith(isDisabled: isDisabled);
  }

  // 버튼 동작 설정
  void setOnPress(VoidCallback? onPress) {
    state = state.copyWith(onPress: onPress);
  }

  // 버튼 클릭 처리
  void handlePress() {
    if (!state.isDisabled && state.onPress != null) {
      state.onPress!();
    }
  }
}

final bottomButtonProvider = StateNotifierProvider.autoDispose<
    BottomButtonController, BottomButtonState>(
  (ref) {
    return BottomButtonController();
  },
);
