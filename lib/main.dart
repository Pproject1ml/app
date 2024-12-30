import 'package:chat_location/constants/colors.dart';
import 'package:chat_location/constants/data.dart';
import 'package:chat_location/constants/theme.dart';
import 'package:chat_location/pages/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: 'Pretendard',
        brightness: Brightness.light,
        cardTheme: const CardTheme(
          color: Colors.white,
        ),
        textTheme: TTTextTheme.lightTextTheme,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          centerTitle: true,
        ),
        navigationBarTheme:
            const NavigationBarThemeData(backgroundColor: Colors.white),
        dialogBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: TTColors.ttPurple,
              foregroundColor: Colors.white,
              disabledBackgroundColor: TTColors.gray5),
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Pretendard',
        // 다크 모드 테마 설정
        brightness: Brightness.dark,
        cardTheme: const CardTheme(
          color: Colors.black,
        ),
        textTheme: TTTextTheme.darkTextTheme,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(color: Colors.black, centerTitle: true),
        navigationBarTheme:
            const NavigationBarThemeData(backgroundColor: Colors.black),
        dialogBackgroundColor: Colors.black,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
