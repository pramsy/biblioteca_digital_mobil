import 'package:flutter/material.dart';
import '../../features/auth/login_page.dart';
import '../../features/dashboard/dashboard_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String dashboard = '/dashboard';

  static Map<String, WidgetBuilder> get routes => {
        login: (context) => const LoginPage(),
        dashboard: (context) => const DashboardPage(),
      };
}
