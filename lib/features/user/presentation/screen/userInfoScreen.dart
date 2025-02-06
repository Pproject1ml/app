import 'package:chat_location/common/dialog/delete_dialog.dart';
import 'package:chat_location/common/utils/bottom_snack_bar.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/constants/text_style.dart';
import 'package:chat_location/features/chat/presentation/screen/personal_chat_tab.dart';
import 'package:chat_location/features/user/presentation/component/info/notification_permission.dart';
import 'package:chat_location/features/user/presentation/provider/user_controller.dart';
import 'package:chat_location/features/auth/presentaation/provider/auth_controller.dart';
import 'package:chat_location/features/user/domain/entities/member.dart';
import 'package:chat_location/features/user/presentation/component/profile/edit_user.dart';
import 'package:chat_location/features/user/presentation/ui/menu_item.dart';
import 'package:chat_location/features/user/presentation/ui/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  const UserInfoScreen({super.key});
  static const String pageName = " userInfo";
  static const String routeName = '/userInfo';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  Future<void> handleClickDeleteUser(BuildContext context) async {
    try {
      // 탈퇴 요청
      await ref.read(authProvider.notifier).deleteUser();
    } catch (e, s) {
      context.pop();
      showSnackBar(context: context, message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider) as MemberInterface;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "마이페이지",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold, letterSpacing: -0.4),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2.0), // 하단 영역 높이
            child: Container(
              color: TTColors.gray200, // 하단 테두리 색상
              height: 1.0, // 테두리 두께
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: Stack(
                        children: [
                          userProfile(
                              profile: user.profile,
                              backgroundColor:
                                  Theme.of(context).cardTheme.color ??
                                      TTColors.white,
                              textColor: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color ??
                                  TTColors.black),
                          Positioned(
                              top: 24,
                              right: 24,
                              child: IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        useSafeArea: false,
                                        isScrollControlled: true,
                                        useRootNavigator: true,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SizedBox(
                                              height: heightRatio(763),
                                              child:
                                                  EditUser(currentUser: user));
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 24,
                                    color: TTColors.gray500,
                                  ))),
                        ],
                      ),
                    ),
                    // 프로필 사진과 수정 아이콘
                    const SizedBox(
                      height: 4,
                    ),

                    // 메뉴 리스트
                    Column(
                      children: [
                        mypageMenuItem(
                          backgroundColor: Theme.of(context).cardTheme.color,
                          onTap: () async {
                            context.pushNamed(PersonalChatScreen.pageName);
                          },
                          textColor:
                              Theme.of(context).textTheme.bodyMedium?.color,
                          title: '내 채팅 기록',
                          trailing: const Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        NotificationPermissionTile(),
                        const SizedBox(
                          height: 4,
                        ),
                        mypageMenuItem(
                            backgroundColor: Theme.of(context).cardTheme.color,
                            textColor:
                                Theme.of(context).textTheme.bodyMedium?.color,
                            title: '로그아웃',
                            trailing: const Icon(Icons.arrow_forward_ios,
                                size: 16, color: Colors.grey),
                            onTap: () async {
                              await ref.read(authProvider.notifier).logout();
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: TTColors.gray600, // 텍스트 색상
                  backgroundColor: Colors.transparent, // 배경색
                  padding: EdgeInsets.symmetric(
                      horizontal: widthRatio(23), vertical: heightRatio(16)),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // 모서리를 0으로 설정
                  ),
                ),
                onPressed: () {
                  showDeleteDialog(context, () async {
                    await handleClickDeleteUser(context);
                  });
                },
                child: Text(
                  "탈퇴하기",
                  style: TTTextStyle.bodyMedium14
                      .copyWith(color: TTColors.gray600),
                ),
              ),
            )
          ],
        ));
  }
}
