import 'package:abstrak/cookie_policy.dart';
import 'package:abstrak/do_not_sell.dart';
import 'package:abstrak/homepage.dart';
import 'package:abstrak/navigation_page.dart';
import 'package:abstrak/privacy.dart';
import 'package:abstrak/support.dart';
import 'package:abstrak/terms.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _sectionNavigatorKey = GlobalKey<NavigatorState>();

// GoRouter configuration
final _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: "/",
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return NavigationPage(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _sectionNavigatorKey,
          routes: [
            GoRoute(
              name: "home",
              path: "/",
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: "support",
              path: "/support",
              builder: (context, state) => const Support(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: "terms",
              path: "/terms",
              builder: (context, state) => const Terms(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: "privacy",
              path: "/privacy",
              builder: (context, state) => const Privacy(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: "cookie-policy",
              path: "/cookie-policy",
              builder: (context, state) => const CookiePolicy(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: "do-not-sell-my-personal-information",
              path: "/do-not-sell-my-personal-information",
              builder: (context, state) => const DoNotSell(),
            ),
          ],
        )
      ],
    ),
  ],
);

TextTheme customTextTheme = const TextTheme(
  displayLarge: TextStyle(
    fontFamily: 'Kenzo',
    fontSize: 96,
    color: Colors.white,
  ),
  displayMedium: TextStyle(
    fontFamily: 'Kenzo',
    fontSize: 60,
    color: Colors.white,
  ),
  displaySmall: TextStyle(
    fontFamily: 'Kenzo',
    fontSize: 48,
    color: Colors.white,
  ),
  headlineMedium: TextStyle(
    fontFamily: 'Kenzo',
    fontSize: 34,
    color: Colors.white,
  ),
  headlineSmall: TextStyle(
    fontFamily: 'Kenzo',
    fontSize: 24,
    color: Colors.white,
  ),
  titleLarge: TextStyle(
    fontFamily: 'Kenzo',
    fontSize: 20,
    color: Colors.white,
  ),
  bodyLarge: TextStyle(
    fontFamily: 'Kenzo',
    fontSize: 16,
    color: Colors.white,
  ),
  bodyMedium: TextStyle(
    fontFamily: 'Kenzo',
    fontSize: 14,
    color: Colors.white,
  ),
  titleMedium: TextStyle(
    fontFamily: 'Kenzo',
    fontSize: 16,
    color: Colors.white,
  ),
  titleSmall: TextStyle(
    fontFamily: 'Kenzo',
    fontSize: 14,
    color: Colors.white,
  ),
  labelLarge: TextStyle(
    fontFamily: 'Kenzo',
    fontSize: 14,
    color: Colors.white,
  ),
  bodySmall: TextStyle(
    fontFamily: 'Kenzo',
    fontSize: 12,
    color: Colors.white,
  ),
  labelSmall: TextStyle(
    fontFamily: 'Kenzo',
    fontSize: 10,
    color: Colors.white,
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Abstract',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
        textTheme: customTextTheme,
      ),
      routerConfig: _router,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }
}
