import 'package:chat_location/features/auth/presentaation/component/sign_up_bottom_next_button.dart';
import 'package:chat_location/features/auth/presentaation/component/sigun_up_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SingUpScreenT extends ConsumerStatefulWidget {
  const SingUpScreenT({super.key});
  static const String routeName = '/signUpT';
  static const String pageName = " signUpT";

  @override
  ConsumerState<SingUpScreenT> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SingUpScreenT> {
  @override
  void initState() {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const Expanded(child: SingUpPageViewT()),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Builder(builder: (context) {
                    return const SignUpBottomNextButton();
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
