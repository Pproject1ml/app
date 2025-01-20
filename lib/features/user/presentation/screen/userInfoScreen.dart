import 'package:chat_location/common/dialog/bottom_up_dialog.dart';
import 'package:chat_location/common/ui/box/round_user_image_box.dart';
import 'package:chat_location/common/ui/box/rounded_with_sharp_box.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/constants/text_style.dart';
import 'package:chat_location/features/user/presentation/provider/user_controller.dart';
import 'package:chat_location/features/auth/presentaation/provider/auth_controller.dart';
import 'package:chat_location/features/user/domain/entities/member.dart';
import 'package:chat_location/features/user/presentation/component/profile/edit_user.dart';
import 'package:chat_location/features/user/presentation/ui/build_tag_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInfoScreen extends ConsumerWidget {
  const UserInfoScreen({super.key});
  static const String pageName = " userInfo";
  static const String routeName = '/userInfo';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider) as MemberInterface;

    return Scaffold(
        backgroundColor: TTColors.gray100,
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: Theme.of(context).cardTheme.color,
                    padding: const EdgeInsets.only(
                        top: 24, bottom: 32, left: 50.5, right: 50.5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        roundUserImageBox(size: 134, editable: false),
                        const SizedBox(height: 12),
                        // 이름과 나이
                        Column(
                          children: [
                            Text(
                              user.profile.nickname,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (user.profile.age != null)
                                  Text(
                                    '${user.profile.age}세',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(color: TTColors.gray500),
                                  ),
                                if (user.profile.gender != null)
                                  Text(
                                    user.profile.gender == "male" ? "남자" : "여자",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(color: TTColors.gray500),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // 소개글
                        if (user.profile.introduction != null)
                          roundedWithSharp(user.profile.introduction ?? ''),
                        const SizedBox(height: 16),
                        // 태그 리스트
                        // Wrap(
                        //   spacing: 4,
                        //   runSpacing: 4,
                        //   alignment: WrapAlignment.center,
                        //   children: [
                        //     buildTag('잠실 롯데타워'),
                        //     buildTag('경복궁'),
                        //     buildTag('홍대'),
                        //     buildTag('명동'),
                        //     buildTag('남산타워'),
                        //   ],
                        // ),
                        // const SizedBox(height: 8),
                        // const Text(
                        //   '내가 자주 갔던 상위 5개의 랜드마크 태그로 노출돼요.',
                        //   style: TextStyle(
                        //     fontSize: 10,
                        //     color: TTColors.gray,
                        //     letterSpacing: -0.3,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Positioned(
                      top: 24,
                      right: 24,
                      child: IconButton(
                          onPressed: () => {
                                // showDialog(
                                //   context: context,
                                //   barrierDismissible: true, // 외부 탭으로 닫기 가능
                                //   builder: (BuildContext context) {
                                //     return BottomUpDialog(
                                //       child: EditUser(currentUser: user),
                                //     );
                                //   },
                                // )
                                showModalBottomSheet(
                                    useSafeArea: false,
                                    isScrollControlled: true,
                                    useRootNavigator: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                          height: heightRatio(763),
                                          child: EditUser(currentUser: user));
                                    })
                              },
                          icon: const Icon(
                            Icons.edit,
                            size: 24,
                            color: TTColors.gray500,
                          ))),
                ],
              ),
              // 프로필 사진과 수정 아이콘
              const SizedBox(
                height: 4,
              ),
              // 메뉴 리스트
              Column(
                children: [
                  _buildMenuItem(
                      backgroundColor: Theme.of(context).cardTheme.color,
                      textColor: Theme.of(context).textTheme.bodyMedium?.color,
                      title: '내 채팅 기록',
                      icon: Icons.chat_bubble_outline),
                  const SizedBox(
                    height: 4,
                  ),
                  _buildMenuItem(
                      backgroundColor: Theme.of(context).cardTheme.color,
                      textColor: Theme.of(context).textTheme.bodyMedium?.color,
                      title: '로그아웃',
                      icon: Icons.settings_outlined,
                      onTap: () async {
                        await ref.read(authProvider.notifier).logout();
                      }),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    VoidCallback? onTap,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return ListTile(
      tileColor: backgroundColor,
      // leading: Icon(icon, color: Colors.grey),
      title: Text(
        title,
        style: TTTextStyle.bodyMedium16.copyWith(color: textColor),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
    );
  }
}
