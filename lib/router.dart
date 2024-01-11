import 'package:audio_store/pages/home_page.dart';
import 'package:audio_store/pages/login_page.dart';
import 'package:audio_store/pages/register_page.dart';
import 'package:audio_store/pages/transaction_history_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => RegisterPage(),
    ),
    GoRoute(
      path: '/transactions',
      builder: (context, state) => TransactionHistoryPage(),
    ),
  ],
);
