import 'package:go_router/go_router.dart';

class AppRouteNames {
  static const home = 'home';
  static const about = 'about';
}

class AppPaths {
  static const home = '/home';
  static const about = '/about';
}

final List<RouteBase> appRoutes = [
  // GoRoute(
  //   path: AppPaths.home,
  //   name: AppRouteNames.home,
  //   builder: (context, state) {
  //     final session = state.extra as AuthSession;
  //     return MyHomePage(title: 'Home Page', session: session);
  //   },
  // ),
  // Outras rotas...
];