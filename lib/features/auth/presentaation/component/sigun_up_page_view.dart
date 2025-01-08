import 'package:chat_location/constants/data.dart';
import 'package:chat_location/features/auth/presentaation/UI/index_indicator.dart';
import 'package:chat_location/features/auth/presentaation/component/sign_up_pages.dart';
import 'package:chat_location/features/auth/presentaation/provider/sign_up_form_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SingUpPageViewT extends ConsumerStatefulWidget {
  const SingUpPageViewT({super.key});

  @override
  ConsumerState<SingUpPageViewT> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<SingUpPageViewT> {
  @override
  void initState() {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signUpNotifier = ref.read(signUpFormProvider.notifier);
    final signUpState = ref.watch(signUpFormProvider);

    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(top: heightRatio(21)),
            child: indexIndicator(signUpNotifier.currentPage)),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              top: heightRatio(44),
            ),
            child: PageView(
              controller: signUpNotifier.pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                signUpNotifier.setCurrentPage(index);
                signUpNotifier.setFocus(index);
              },
              children: [
                SignUpPage1(notifier: signUpNotifier, state: signUpState),
                SignUpPage2(notifier: signUpNotifier, state: signUpState),
                SignUpPage3(notifier: signUpNotifier, state: signUpState)
              ],
            ),
          ),
        )
      ],
    );
  }
}
