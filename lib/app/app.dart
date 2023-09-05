import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:wow_shopping/app/config.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/features/login/bloc/auth_bloc.dart';
import 'package:wow_shopping/features/login/login_screen.dart';
import 'package:wow_shopping/features/main/main_screen.dart';
import 'package:wow_shopping/features/splash/splash_screen.dart';

export 'package:wow_shopping/app/config.dart';

const _appTitle = 'Shop Wow';

class ShopWowApp extends StatefulWidget {
  const ShopWowApp({
    super.key,
    required this.config,
  });

  final AppConfig config;

  @override
  State<ShopWowApp> createState() => _ShopWowAppState();
}

class _ShopWowAppState extends State<ShopWowApp> {
  late Future<Backend> _appLoader;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Intl.defaultLocale = PlatformDispatcher.instance.locale.toLanguageTag();
    _appLoader = _loadApp();
  }

  Future<Backend> _loadApp() async {
    await initializeDateFormatting();
    final backend = await Backend.init();
    return backend;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: appOverlayDarkIcons,
      child: FutureBuilder<Backend>(
        future: _appLoader,
        builder: (BuildContext context, AsyncSnapshot<Backend> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Theme(
              data: generateLightTheme(),
              child: const Directionality(
                textDirection: TextDirection.ltr,
                child: SplashScreen(),
              ),
            );
          } else {
            return BackendInheritedWidget(
              backend: snapshot.requireData,
              child: BlocProvider(
                create: (context) => AuthBloc(
                  authRepo: snapshot.data!.authRepo,
                )..add(AuthStatusSubscriptionRequested()),
                child: const AppView(),
              ),
            );
          }
        },
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        bool isLoggedIn = state is AuthAuthenticated;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: _appTitle,
          theme: generateLightTheme(),
          onGenerateRoute: (RouteSettings settings) {
            if (settings.name == Navigator.defaultRouteName) {
              if (!isLoggedIn) {
                return LoginScreen.route();
              }
              return MainScreen.route();
            } else {
              return null; // Page not found
            }
          },
        );
      },
    );
  }
}
