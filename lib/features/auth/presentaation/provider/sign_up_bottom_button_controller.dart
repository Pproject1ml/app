import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomButtonState {
  final bool isDisabled;
  final String text;
  final Future<void> Function()? onPress;

  BottomButtonState({
    required this.isDisabled,
    required this.text,
    this.onPress,
  });

  BottomButtonState copyWith({
    bool? isDisabled,
    String? text,
    Future<void> Function()? onPress,
  }) {
    return BottomButtonState(
      isDisabled: isDisabled ?? this.isDisabled,
      text: text ?? this.text,
      onPress: onPress ?? this.onPress,
    );
  }
}

class BottomButtonControllerT extends StateNotifier<BottomButtonState> {
  BottomButtonControllerT()
      : super(BottomButtonState(isDisabled: true, text: "확인", onPress: null));

  // 상태 업데이트: 버튼 활성/비활성 설정
  void setDisabled(bool isDisabled) {
    state = state.copyWith(isDisabled: isDisabled);
  }

  // 버튼 동작 설정
  void setOnPress(Future<void> Function()? onPress) {
    state = state.copyWith(onPress: onPress);
  }

  void setText(String text) {
    state = state.copyWith(text: text);
  }

  void update(
      {bool? isDisabled, Future<void> Function()? onPress, String? text}) {
    state =
        state.copyWith(isDisabled: isDisabled, onPress: onPress, text: text);
  }

  // 버튼 클릭 처리
  Future<void> handlePress() async {
    try {
      if (!state.isDisabled && state.onPress != null) {
        await state.onPress!();
      }
    } catch (e) {
      rethrow;
    }
  }
}

final signUpBottomButtonProvider = StateNotifierProvider.autoDispose<
    BottomButtonControllerT, BottomButtonState>(
  (ref) {
    return BottomButtonControllerT();
  },
);
