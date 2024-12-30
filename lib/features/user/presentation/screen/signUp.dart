import 'package:chat_location/features/user/presentation/component/sign_up/bottom_next_button.dart';
import 'package:chat_location/features/user/presentation/component/sign_up/sigun_up_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SingUpPage extends ConsumerStatefulWidget {
  const SingUpPage({super.key});
  static const String routeName = '/signUp';
  static const String pageName = " signUp";

  @override
  ConsumerState<SingUpPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<SingUpPage> {
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
        child: Column(
          children: [
            const Expanded(child: SingUpPageView()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Builder(builder: (context) {
                return const BottomNextButton();
              }),
            ),
          ],
        ),
      ),
    );
  }
}
