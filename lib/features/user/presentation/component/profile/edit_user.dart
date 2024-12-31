import 'dart:developer';

import 'package:chat_location/common/ui/box/round_user_image_box.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/controller/user_controller.dart';
import 'package:chat_location/features/user/domain/entities/auth.dart';
import 'package:chat_location/features/user/domain/entities/user.dart';
import 'package:chat_location/features/user/presentation/provider/edit_user_controller.dart';
import 'package:chat_location/features/user/presentation/screen/userInfoScreen.dart';
import 'package:chat_location/features/user/presentation/ui/build_tag_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditUser extends ConsumerStatefulWidget {
  const EditUser({super.key, required this.currentUser});
  final AppUser currentUser;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditUserState();
}

class _EditUserState extends ConsumerState<EditUser> {
  late TextEditingController _nickNamecontroller;
  late TextEditingController _introductionController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nickNamecontroller =
        TextEditingController(text: widget.currentUser.nickname);
    _introductionController =
        TextEditingController(text: widget.currentUser.introduction);
  }

  @override
  void dispose() {
    // TODO: implement dispose

    log("dispose");
    _nickNamecontroller.dispose();
    _introductionController.dispose();
    super.dispose();
  }

  Future<void> _onClickSave(AppUser userInfo) async {
    await ref.read(userProvider.notifier).updateUserInfo(userInfo);
  }

  @override
  Widget build(BuildContext context) {
    log("UserName: ${widget.currentUser.nickname}");
    final _tempUserInfo = ref.watch(userProfileProvider(widget.currentUser));
    final _tempUserNotifier =
        ref.read(userProfileProvider(widget.currentUser).notifier);
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      height: heightRatio(763),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: heightRatio(64),
                alignment: Alignment.center,
                child: Text(
                  "프로필 수정",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Positioned(
                  top: heightRatio(11),
                  right: widthRatio(20),
                  child: TextButton(
                      onPressed: () => {},
                      child: Text(
                        '취소',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: TTColors.gray, height: 0.22),
                      )))
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 프로필 사진

                    Text(
                      '프로필 사진',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          letterSpacing: 0,
                          height: 1.4,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    roundUserImageBox(size: 100, editable: true),
                    const SizedBox(height: 30),

                    // 닉네임
                    Text(
                      '닉네임',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          letterSpacing: 0,
                          height: 1.4,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      onTapOutside: (event) {
                        // FocusScope.of(context).unfocus();
                      },
                      controller: _nickNamecontroller, // 텍스트,
                      decoration: InputDecoration(
                        hintText: '닉네임을 입력하세요',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                                height: 1.4, fontWeight: FontWeight.w400),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                                height: 1.4, fontWeight: FontWeight.w400),
                        border: const UnderlineInputBorder(),
                        suffixText:
                            '${_tempUserInfo.nickname.length}/10', // 글자수 표시
                      ),
                      onChanged: (value) {
                        // 상태 업데이트
                        _tempUserNotifier.updateName(value);
                        log("nickname${value}");
                      },
                    ),
                    const SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '나이 / 성별 공개',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  letterSpacing: 0,
                                  height: 1.4,
                                  fontWeight: FontWeight.bold),
                        ),
                        Switch(value: false, onChanged: (value) {}),
                      ],
                    ),
                    const SizedBox(height: 38),

                    // 나의 랜드마크 공개
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '나의 랜드마크 공개',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  letterSpacing: 0,
                                  height: 1.4,
                                  fontWeight: FontWeight.bold),
                        ),
                        Switch(value: true, onChanged: (value) {}),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        buildTag('잠실 롯데타워'),
                        buildTag('경복궁'),
                        buildTag('홍대'),
                        buildTag('명동'),
                        buildTag('남산타워'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '내가 자주 갔던 상위 5개의 랜드마크 태그로 노출돼요.',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: 10,
                          letterSpacing: -0.3,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 26),

                    // 한줄소개
                    Text(
                      '한줄소개',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          letterSpacing: 0,
                          height: 1.4,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      onTapOutside: (event) {
                        // FocusScope.of(context).unfocus();
                      },
                      controller: _introductionController, // 텍스트,
                      maxLines: 4,
                      maxLength: 40,
                      decoration: InputDecoration(
                        hintText:
                            'Ex) 홍대, 연남, 합정, 상수, 망원을 잘 압니다.\nMBTI는 ENFP예요~',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                color: TTColors.gray,
                                letterSpacing: -0.3,
                                height: 1.5,
                                fontWeight: FontWeight.w500),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                letterSpacing: -0.3,
                                height: 1.5,
                                fontWeight: FontWeight.w500),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(12),
                      ),
                      onChanged: (value) {
                        _tempUserNotifier.updateIntroduction(value);
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    )

                    // 저장 버튼
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await _onClickSave(_tempUserInfo);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TTColors.ttPurple,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '프로필 저장하기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
