import 'dart:developer';

import 'package:chat_location/controller/user_controller.dart';
import 'package:chat_location/features/chat/screen/chat_list_screen.dart';
import 'package:chat_location/features/chat/screen/chat_page_screen.dart';
import 'package:chat_location/features/map/presentation/screen/mapScreen.dart';

import 'package:chat_location/features/user/presentation/screen/login.dart';
import 'package:chat_location/features/user/presentation/screen/signUp.dart';
import 'package:chat_location/features/user/presentation/screen/userInfoScreen.dart';
import 'package:chat_location/pages/index.dart';
import 'package:chat_location/features/initialize/screen/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _shellNavigatorKey = GlobalKey<NavigatorState>();
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(userProvider);

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
            name: LoginPage.pageName,
            path: LoginPage.routeName,
            pageBuilder: (context, state) => const NoTransitionPage(
                  child: LoginPage(),
                ),
            routes: [
              GoRoute(
                name: SingUpPage.pageName,
                path: SingUpPage.routeName,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SingUpPage(),
                ),
              )
            ]),
        GoRoute(
          path: '/chatRoom/:id',
          name: ChatPage.pageName,
          builder: (context, state) {
            final String id = state.pathParameters['id']!;
            log("ID: ${id}");
            return ChatPage(roomNumber: id);
          },
        ),
        StatefulShellRoute.indexedStack(
            builder: (BuildContext context, GoRouterState state,
                StatefulNavigationShell navigationShell) {
              return ShellRouteIndex(
                navigationShell: navigationShell,
              );
            },
            branches: <StatefulShellBranch>[
              // map
              StatefulShellBranch(routes: <RouteBase>[
                GoRoute(
                  name: MapScreen.pageName,
                  path: MapScreen.routeName,
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: MapScreen()),
                )
              ]),
              //chat
              StatefulShellBranch(routes: <RouteBase>[
                GoRoute(
                    name: ChatScreen.pageName,
                    path: ChatScreen.routeName,
                    pageBuilder: (context, state) => CustomTransitionPage(
                          key: state.pageKey,
                          child: const ChatScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            // Change the opacity of the screen using a Curve based on the the animation's
                            // value
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
                        )),
              ]),
//profile
              StatefulShellBranch(routes: <RouteBase>[
                GoRoute(
                    name: UserInfoScreen.pageName,
                    path: UserInfoScreen.routeName,
                    pageBuilder: (context, state) => CustomTransitionPage(
                          key: state.pageKey,
                          child: const UserInfoScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            // Change the opacity of the screen using a Curve based on the the animation's
                            // value
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
                        )),
              ])
            ]),
        // ShellRoute(
        //   navigatorKey: _shellNavigatorKey,
        //   builder: (context, state, child) =>
        //       BottomNavigationBarScaffold(child: child),
        //   routes: [
        //     GoRoute(
        //         name: MapScreen.pageName,
        //         path: MapScreen.routeName,
        //         pageBuilder: (context, state) =>
        //             const NoTransitionPage(child: MapScreen()),
        //         routes: [
        //           GoRoute(
        //               name: ChatScreen.pageName,
        //               path: ChatScreen.routeName,
        //               pageBuilder: (context, state) => CustomTransitionPage(
        //                     key: state.pageKey,
        //                     child: const ChatScreen(),
        //                     transitionsBuilder: (context, animation,
        //                         secondaryAnimation, child) {
        //                       // Change the opacity of the screen using a Curve based on the the animation's
        //                       // value
        //                       return SlideTransition(
        //                         position: animation.drive(
        //                           Tween<Offset>(
        //                             begin: const Offset(1.25, 0),
        //                             end: Offset.zero,
        //                           ).chain(CurveTween(curve: Curves.easeIn)),
        //                         ),
        //                         child: child,
        //                       );
        //                     },
        //                   )),
        //           GoRoute(
        //               name: UserInfoScreen.pageName,
        //               path: UserInfoScreen.routeName,
        //               pageBuilder: (context, state) => CustomTransitionPage(
        //                     key: state.pageKey,
        //                     child: const UserInfoScreen(),
        //                     transitionsBuilder: (context, animation,
        //                         secondaryAnimation, child) {
        //                       // Change the opacity of the screen using a Curve based on the the animation's
        //                       // value
        //                       return SlideTransition(
        //                         position: animation.drive(
        //                           Tween<Offset>(
        //                             begin: const Offset(1.25, 0),
        //                             end: Offset.zero,
        //                           ).chain(CurveTween(curve: Curves.easeIn)),
        //                         ),
        //                         child: child,
        //                       );
        //                     },
        //                   )),
        //         ]),
        //   ],
        // ),
      ],

      // refreshListenable: authState, desperated 라고 하는 issue 가 있음 -> 없어도 작동은 함
      redirect: (context, state) => authState.redirect(
          goRouterState: state, showErrorIfNonExistentRoute: true));
});
