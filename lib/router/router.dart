import 'package:chat_location/features/auth/presentaation/provider/auth_controller.dart';
import 'package:chat_location/features/auth/presentaation/screen/login_screen.dart';
import 'package:chat_location/features/auth/presentaation/screen/sign_up_screen.dart';
import 'package:chat_location/features/chat/presentation/screen/chat_tab_screen.dart';
import 'package:chat_location/features/chat/presentation/screen/chat_page_screen.dart';
import 'package:chat_location/features/chat/presentation/screen/personal_chat_page_screen.dart';
import 'package:chat_location/features/chat/presentation/screen/personal_chat_tab.dart';
import 'package:chat_location/features/map/presentation/screen/mapScreen.dart';
import 'package:chat_location/features/user/domain/entities/profile.dart';

import 'package:chat_location/features/user/presentation/screen/userInfoScreen.dart';
import 'package:chat_location/features/user/presentation/screen/user_profile_screen.dart';
import 'package:chat_location/pages/index.dart';
import 'package:chat_location/features/initialize/screen/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProviderV2 = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: SplashScreen.routeName,
    routes: [
      GoRoute(
          name: SplashScreen.pageName,
          path: SplashScreen.routeName,
          pageBuilder: (context, state) => const NoTransitionPage(
                child: SplashScreen(),
              )),
      GoRoute(
          name: UserProfileScreen.pageName,
          path: UserProfileScreen.routeName,
          pageBuilder: (context, state) {
            final ProfileInterface profile = state.extra! as ProfileInterface;

            return NoTransitionPage(
                child: UserProfileScreen(
              userProfile: profile,
            ));
          }),
      GoRoute(
          name: LoginPageT.pageName,
          path: LoginPageT.routeName,
          pageBuilder: (context, state) => const NoTransitionPage(
                child: LoginPageT(),
              ),
          routes: [
            GoRoute(
              name: SingUpScreenT.pageName,
              path: SingUpScreenT.routeName,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SingUpScreenT(),
              ),
            )
          ]),
      GoRoute(
        path: '/chatRoom/:id',
        name: ChatPage.pageName,
        builder: (context, state) {
          final String id = state.pathParameters['id']!;

          return ChatPage(roomNumber: id);
        },
      ),
      GoRoute(
          path: PersonalChatScreen.routeName,
          name: PersonalChatScreen.pageName,
          pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const PersonalChatScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: animation.drive(
                      Tween<Offset>(
                        begin: const Offset(1.25, 0),
                        end: Offset.zero,
                      ).chain(CurveTween(curve: Curves.easeIn)),
                    ),
                    child: child,
                  );
                },
              ),
          routes: [
            GoRoute(
              path: '${PersonalChatPage.routeName}/:id',
              name: PersonalChatPage.pageName,
              builder: (context, state) {
                final String id = state.pathParameters['id']!;

                return PersonalChatPage(roomNumber: id);
              },
            ),
          ]),
    ],
    // redirect: (context, state) => authState.redirect(
    //     goRouterState: state, showErrorIfNonExistentRoute: true)
  );
});
