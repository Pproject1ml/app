import 'dart:async';

import 'package:chat_location/pages/login_page.dart';
import 'package:chat_location/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// part 'routes.g.dart';

// @TypedGoRoute<HomeRoute>(
//   path: '/',
//   routes: [
//     TypedGoRoute<AdminRoute>(path: 'admin'),
//     TypedGoRoute<UserRoute>(path: 'user'),
//     TypedGoRoute<GuestRoute>(path: 'guest'),
//   ],
// )
// class HomeRoute extends GoRouteData {
//   const HomeRoute();

//   /// Important note on this redirect function: this isn't reactive.
//   /// No redirect will be triggered on a user role change.
//   ///
//   /// This is currently unsupported.
//   @override
//   FutureOr<String?> redirect(BuildContext context, GoRouterState state) async {
//     final userRole = await ProviderScope.containerOf(context).read(
//       permissionsProvider.future,
//     );

//     return userRole.map(
//       admin: (_) => const AdminRoute().location,
//       user: (_) => const UserRoute().location,
//       guest: (_) => const GuestRoute().location,
//       none: (_) => null,
//     );
//   }

//   @override
//   Widget build(BuildContext context, GoRouterState state) {
//     return const HomePage();
//   }
// }

@TypedGoRoute<SplashRoute>(path: '/splash')
class SplashRoute extends GoRouteData {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SplashPage();
  }
}

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
  }
}


/// This route shows how to parametrize a simple page and how to pass a simple query parameter.
// @TypedGoRoute<DetailsRoute>(path: '/details/:id')
// class DetailsRoute extends GoRouteData {
//   const DetailsRoute(this.id, {this.isNuke = false});
//   final int id;
//   final bool isNuke;

//   @override
//   Widget build(BuildContext context, GoRouterState state) {
//     return DetailsPage(
//       id,
//       isNuclearCode: isNuke,
//     );
//   }
// }