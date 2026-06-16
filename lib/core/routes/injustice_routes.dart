import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injustice_app/authentication/domain/models/auth_entities.dart';
import 'package:injustice_app/account/domain/models/account_entity.dart';

import '../../account/presentation/views/home_view.dart';
import '../../account/presentation/views/about_view.dart';
import '../../account/presentation/views/account_create_view.dart';
import '../../account/presentation/views/characters/list_of/characters_view.dart';

class AppRouteNames {
  static const home = 'home';
  static const about = 'about';
  static const accountCreate = 'account_create';
  static const characters = 'characters';
}

class AppPaths {
  static const home = '/home';
  static const about = '/about';
  static const accountCreate = '/account_create';
  static const characters = '/characters';
}
final List<RouteBase> appRoutes = [
  GoRoute(
    path: AppPaths.home,
    name: AppRouteNames.home,
    builder: (context, state) {
    // Aqui você extrai o objeto que veio no 'extra' do context.goNamed
    final auth = state.extra as AuthSession; 
    
    // E passa ele para o construtor da sua HomeView
    return HomeView(auth: auth); 
  },
  ),
  GoRoute(
    path: AppPaths.accountCreate,
    name: AppRouteNames.accountCreate,
    builder: (context, state) => const AccountCreateView(),
  ),
  GoRoute(
    path: AppPaths.characters,
    name: AppRouteNames.characters,
    builder: (context, state) {
      final account = state.extra as Account?;

      if (account == null) {
      return const Scaffold(
        body: Center(child: Text("Erro: Conta não carregada. Tente novamente.")),
      );
    }

      return CharactersView(account: account);
    },
  ),
  GoRoute(
    path: AppPaths.about,
    name: AppRouteNames.about,
    builder: (context, state) => const AboutView(),
  ),
];