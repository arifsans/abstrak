import 'package:abstrak/navigation_page.dart';
import 'package:abstrak/notifier/auth_notifier.dart';
import 'package:abstrak/notifier/user_notifier.dart';
import 'package:abstrak/screen/about.dart';
import 'package:abstrak/screen/admin.dart';
import 'package:abstrak/screen/artwerk.dart';
import 'package:abstrak/screen/homepage.dart';
import 'package:abstrak/screen/manifesto.dart';
import 'package:abstrak/screen/my_artwerks.dart';
import 'package:abstrak/screen/privacy_policy.dart';
import 'package:abstrak/screen/profile.dart';
import 'package:abstrak/screen/sign_up.dart';
import 'package:abstrak/screen/sign_in.dart';
import 'package:abstrak/screen/terms_conditions.dart';
import 'package:abstrak/screen/tp_calculator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:dynamic_path_url_strategy/dynamic_path_url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _sectionNavigatorKey = GlobalKey<NavigatorState>();

final AuthNotifier authNotifier = AuthNotifier();
final UserNotifier userNotifier = UserNotifier();

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
              name: "artwerk",
              path: "/artwerk",
              builder: (context, state) => const ArtWerk(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: "about",
              path: "/about",
              builder: (context, state) => const About(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: "tp-calculator",
              path: "/tp-calculator",
              builder: (context, state) => const TpCalculator(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: "manifesto",
              path: "/manifesto",
              builder: (context, state) => const Manifesto(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: "profile",
              path: "/profile",
              builder: (context, state) => const Profile(),
              redirect: (context, state) async {
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                if (prefs.getString('token') == null || prefs.getString('token')!.isEmpty) {
                  return '/sign-in';
                }
                return null;
              },
            ),
          ],
        ),
      ],
    ),
    // Standalone route for sign-in (not part of the shell)
    GoRoute(
      name: "sign-in",
      path: "/sign-in",
      builder: (context, state) => Scaffold(
        backgroundColor: const Color(0xFF1a1a1a),
        body: const SignIn(),
      ),
    ),
    // Standalone route for register (not part of the shell)
    GoRoute(
      name: "sign-up",
      path: "/sign-up",
      builder: (context, state) => Scaffold(
        backgroundColor: const Color(0xFF1a1a1a),
        body: const SignUp(),
      ),
    ),
    GoRoute(
      name: "terms-of-service",
      path: "/terms-of-service",
      builder: (context, state) => TermsCondition(),
    ),
    GoRoute(
      name: "privacy-policy",
      path: "/privacy-policy",
      builder: (context, state) => PrivacyPolicy(),
    ),
    GoRoute(
      name: "admin",
      path: "/admin",
      builder: (context, state) => const Admin(),
      redirect: (context, state) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs.getString('token') == null || prefs.getString('token')!.isEmpty) {
          return '/sign-in';
        }
        if (prefs.getString('roles') != 'admin') {
          return '/profile';
        }
        return null;
      },
    ),
    GoRoute(
      name: "my-artwerks",
      path: "/my-artwerks",
      builder: (context, state) => MyArtwerks(),
      redirect: (context, state) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs.getString('token') == null || prefs.getString('token')!.isEmpty) {
          return '/sign-in';
        }
        if (prefs.getString('user_id') == null || prefs.getString('user_id')!.isEmpty) {
          return '/profile';
        }
        return null;
      },
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

TextTheme courierText = const TextTheme(
  displayLarge: TextStyle(
    fontFamily: 'Courier',
    fontSize: 96,
    color: Colors.white,
  ),
  displayMedium: TextStyle(
    fontFamily: 'Courier',
    fontSize: 60,
    color: Colors.white,
  ),
  displaySmall: TextStyle(
    fontFamily: 'Courier',
    fontSize: 48,
    color: Colors.white,
  ),
  headlineMedium: TextStyle(
    fontFamily: 'Courier',
    fontSize: 34,
    color: Colors.white,
  ),
  headlineSmall: TextStyle(
    fontFamily: 'Courier',
    fontSize: 24,
    color: Colors.white,
  ),
  titleLarge: TextStyle(
    fontFamily: 'Courier',
    fontSize: 20,
    color: Colors.white,
  ),
  bodyLarge: TextStyle(
    fontFamily: 'Courier',
    fontSize: 16,
    color: Colors.white,
  ),
  bodyMedium: TextStyle(
    fontFamily: 'Courier',
    fontSize: 14,
    color: Colors.white,
  ),
  titleMedium: TextStyle(
    fontFamily: 'Courier',
    fontSize: 16,
    color: Colors.white,
  ),
  titleSmall: TextStyle(
    fontFamily: 'Courier',
    fontSize: 14,
    color: Colors.white,
  ),
  labelLarge: TextStyle(
    fontFamily: 'Courier',
    fontSize: 14,
    color: Colors.white,
  ),
  bodySmall: TextStyle(
    fontFamily: 'Courier',
    fontSize: 12,
    color: Colors.white,
  ),
  labelSmall: TextStyle(
    fontFamily: 'Courier',
    fontSize: 10,
    color: Colors.white,
  ),
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    authNotifier.checkAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Captive',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF1a1a1a)),
        useMaterial3: true,
        textTheme: customTextTheme,
      ),
      routerConfig: _router,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 1024, name: TABLET),
          const Breakpoint(start: 1025, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }
}
