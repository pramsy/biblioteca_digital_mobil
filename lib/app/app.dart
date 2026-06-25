import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';
import 'config/injection.dart';
import '../core/services/NavigationService.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService = getIt<NavigationService>();

    return MaterialApp(
      title: 'Biblioteca Digital',
      theme: AppTheme.lightTheme,
      navigatorKey: navigationService.navigatorKey,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
