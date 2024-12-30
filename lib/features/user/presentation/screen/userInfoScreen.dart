import 'package:chat_location/common/ui/box/round_user_image_box.dart';
import 'package:chat_location/common/ui/box/rounded_with_sharp_box.dart';
import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/controller/user_controller.dart';
import 'package:chat_location/core/database/secure_storage.dart';
import 'package:chat_location/features/user/presentation/component/profile/edit_user.dart';
import 'package:chat_location/features/user/domain/entities/auth.dart';

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
    final auth = ref.watch(userProvider).authState as AuthStateAuthenticated;

    return Scaffold(
        backgroundColor: TTColors.backgroundSecondary,
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
                    color: Colors.white,
                    padding: EdgeInsets.only(
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
                              auth.user.nickname,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '27세 남자',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(color: TTColors.gray),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // 소개글
                        roundedWithSharp('일이삼사오육칠팔구십일이삼사오육칠팔구\n'
                            '일이삼사오육칠팔구십일이삼사오육칠팔구'),
                        const SizedBox(height: 16),
                        // 태그 리스트
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          alignment: WrapAlignment.center,
                          children: [
                            buildTag('잠실 롯데타워'),
                            buildTag('경복궁'),
                            buildTag('홍대'),
                            buildTag('명동'),
                            buildTag('남산타워'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '내가 자주 갔던 상위 5개의 랜드마크 태그로 노출돼요.',
                          style: TextStyle(
                            fontSize: 10,
                            color: TTColors.gray,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      top: 24,
                      right: 24,
                      child: IconButton(
                          onPressed: () => {
                                // showDialog(
                                //       context: context,
                                //       barrierDismissible: true, // 외부 탭으로 닫기 가능
                                //       builder: (BuildContext context) {
                                //         return BottomUpDialog(child: EditUser(currentUser: auth.user),);
                                //       },
                                //     )
                                showModalBottomSheet(
                                    useSafeArea: false,
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                          height: heightRatio(763),
                                          child:
                                              EditUser(currentUser: auth.user));
                                    })
                              },
                          icon: const Icon(
                            Icons.edit,
                            size: 24,
                            color: TTColors.gray,
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
                      title: '내 채팅 기록', icon: Icons.chat_bubble_outline),
                  const SizedBox(
                    height: 4,
                  ),
                  _buildMenuItem(
                      title: '로그아웃',
                      icon: Icons.settings_outlined,
                      onTap: () async {
                        SecureStorageHelper.clearAll();
                        await ref.read(userProvider.notifier).logout();
                      }),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildMenuItem(
      {required String title, required IconData icon, VoidCallback? onTap}) {
    return ListTile(
      tileColor: Colors.white,
      // leading: Icon(icon, color: Colors.grey),
      title: Text(title),
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
