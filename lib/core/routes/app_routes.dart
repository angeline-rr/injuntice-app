import 'package:injustice_app/core/routes/auth_routes.dart';
import 'package:injustice_app/core/routes/injustice_routes.dart';
import 'package:injustice_app/under_construction_view.dart';
import 'package:go_router/go_router.dart';

/// Route names for easier referencing
class GlobalRouteNames {
  static const underConstruction = 'under_construction';

  // static const home = 'home';
  // static const about = 'about';
  // static const accountCreate = 'account_create';
  // static const characters = 'characters';

  // // Authentication route names
  // static const authSplash = 'splash';
  // static const authLogin = 'login';
  // static const authRegister = 'register';
  // static const authForgot = 'forgot';
  // static const authHome = 'home';
}

/// Paths to keep URL structure consistent
class GlobalPaths {
  static const underConstruction = '/under-construction';

  // static const home = '/home';
  // static const about = '/about';
  // static const accountCreate = '/account-create';
  // static const characters = '/characters';

  // // Authentication paths
  // static const authSplash = '/';
  // static const authLogin = '/login';
  // static const authRegister = '/register';
  // static const authForgot = '/forgot';
  // static const authHome = '/home';
}

/// app routers using go_router
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AuthPaths.splash,
    routes: <RouteBase>[
      ...authRoutes,
      ...appRoutes,
      GoRoute(
        path: GlobalPaths.underConstruction,
        name: GlobalRouteNames.underConstruction,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: UnderConstructionView()),
      ),

      // GoRoute(
      //   path: AppPaths.underConstruction,
      //   name: AppRouteNames.underConstruction,
      //   pageBuilder:
      //       (context, state) => const NoTransitionPage(child: UnderConstructionView()),
      // ),
      // GoRoute(
      //   path: AppPaths.authSplash,
      //   name: AppRouteNames.authSplash,
      //   pageBuilder:
      //       (context, state) => const NoTransitionPage(child: SplashPage()),
      // ),
      // GoRoute(
      //   path: AppPaths.authLogin,
      //   name: AppRouteNames.authLogin,
      //   builder: (context, state) => const LoginPage(),
      // ),
      // GoRoute(
      //   path: AppPaths.authRegister,
      //   name: AppRouteNames.authRegister,
      //   builder: (context, state) => const SignupPage(),
      // ),

      // GoRoute(
      //   path: AppPaths.authHome,
      //   name: AppRouteNames.authHome,
      //   builder: (context, state) {
      //     // Pega o argumento passado via extra
      //     final session = state.extra as AuthSession;
      //     return MyHomePage(title: 'Flutter Demo Home Page', session: session);
      //   },
      // ),
    ],
  );
}