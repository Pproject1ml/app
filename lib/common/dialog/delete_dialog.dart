import 'package:flutter/material.dart';

void showDeleteDialog(BuildContext context, void Function() onPressed) {
  showDialog(
    context: context,
    barrierDismissible: false, // 배경 클릭 시 닫히지 않도록 설정
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text("회원 탈퇴"),
        content: const Text("회원 탈퇴를 하면 모든 정보가 삭제됩니다."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Dialog 닫기
            },
            child: const Text("아니요"),
          ),
          ElevatedButton(
            onPressed: () async {
              onPressed();
            },
            child: const Text("확인"),
          ),
        ],
      );
    },
  );
}
