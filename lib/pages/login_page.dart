import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> login() => Future.delayed(Duration(seconds: 3));
    // ref.read(authControllerProvider.notifier).login(
    //       'myEmail',
    //       'myPassword',
    //     );
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login Page'),
            IconButton(
              onPressed: login,
              icon: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
