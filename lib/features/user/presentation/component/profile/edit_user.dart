import 'dart:developer';
import 'dart:io';

import 'package:chat_location/common/ui/box/round_user_image_box.dart';
import 'package:chat_location/common/ui/box/text_field.dart';
import 'package:chat_location/common/ui/text_input/bottom_border_text_input.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/constants/text_style.dart';
import 'package:chat_location/features/user/domain/entities/member.dart';
import 'package:chat_location/features/user/presentation/component/profile/edit_profile_button.dart';
import 'package:chat_location/features/user/presentation/provider/edit_user_controller.dart';
import 'package:chat_location/features/user/presentation/ui/build_tag_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class EditUser extends ConsumerStatefulWidget {
  const EditUser({super.key, required this.currentUser});
  final MemberInterface currentUser;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditUserState();
}

class _EditUserState extends ConsumerState<EditUser> {
  XFile? file;

  Future<void> _pickImage() async {
    ImagePicker().pickImage(source: ImageSource.gallery).then((image) {
      if (image != null) {
        setState(() {
          file = image;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _tempMemberInfo = ref.watch(userProfileProvider(widget.currentUser));
    final _tempUserNotifier =
        ref.read(userProfileProvider(widget.currentUser).notifier);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
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
                    style: TTTextStyle.bodyBold18.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        height: 1.22),
                  ),
                ),
                Positioned(
                    top: heightRatio(11),
                    right: widthRatio(20),
                    child: TextButton(
                        onPressed: () => {Navigator.of(context).pop()},
                        child: Text(
                          '취소',
                          style: TTTextStyle.bodyMedium14.copyWith(
                              color: TTColors.gray500,
                              height: 1.22,
                              letterSpacing: -0.3),
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
                        style: TTTextStyle.bodySemibold16.copyWith(
                            letterSpacing: 0,
                            height: 1.4,
                            color:
                                Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                      const SizedBox(
                        height: 12,
                      ),

                      SizedBox(
                        height: widthRatio(110),
                        width: widthRatio(110),
                        child: Stack(
                          children: [
                            file != null
                                ? SizedBox(
                                    height: widthRatio(100),
                                    width: widthRatio(100),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.file(
                                        File(file!.path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Align(
                                    alignment: Alignment.topLeft,
                                    child: roundUserImageBox(
                                      imageUrl: widget
                                          .currentUser.profile.profileImage,
                                      size: 100,
                                    ),
                                  ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                  icon: const CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.camera_alt,
                                        size: 18, color: Colors.grey),
                                  ),
                                  onPressed: _pickImage),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // 닉네임
                      Text('닉네임',
                          style: TTTextStyle.bodySemibold16.copyWith(
                              letterSpacing: 0,
                              height: 1.4,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.color)),
                      const SizedBox(height: 8),
                      BottomBorderTextInput(
                        controller: _tempUserNotifier.nicknameController,
                        maxLength: 10,
                        enabled: true,
                        focusNode: _tempUserNotifier.nickNameFocusNode,
                        autofocus: false,
                      ),

                      const SizedBox(height: 40),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '나이 / 성별 공개',
                            style: TTTextStyle.bodySemibold16.copyWith(
                                letterSpacing: 0,
                                height: 1.4,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color),
                          ),
                          Switch(
                              overlayColor: MaterialStateProperty.resolveWith(
                                (final Set<MaterialState> states) {
                                  return Colors.transparent;
                                },
                              ),
                              thumbColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                return Colors.white;
                              }),
                              trackOutlineColor:
                                  MaterialStateProperty.resolveWith(
                                (final Set<MaterialState> states) {
                                  return Colors.transparent;
                                },
                              ),
                              activeColor: TTColors.ttPurple,
                              activeTrackColor:
                                  TTColors.ttPurple.withOpacity(1.0),
                              inactiveTrackColor:
                                  TTColors.gray300.withOpacity(1.0),
                              value: _tempMemberInfo.profile.isVisible,
                              onChanged: (value) {
                                _tempUserNotifier.toggleGenderVisibility(value);
                              }),
                        ],
                      ),
                      const SizedBox(height: 38),

                      // 한줄소개
                      Text('한줄소개',
                          style: TTTextStyle.bodySemibold16.copyWith(
                              letterSpacing: 0,
                              height: 1.4,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.color)),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _tempUserNotifier.descriptionController,
                        focusNode: _tempUserNotifier.descriptionFocusNode,
                        maxLength: 40,
                        maxLines: 4,
                        onTapOutsideAutoFocuseOut: false,
                        hintText:
                            'Ex) 홍대, 연남, 합정, 상수, 망원을 잘 압니다.\nMBTI는 ENFP예요~',
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
                child: EditProfileButton(
                  tempUser: _tempMemberInfo,
                  file: file,
                )),
          ],
        ),
      ),
    );
  }
}
