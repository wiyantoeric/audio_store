import 'package:audio_store/pages/add_to_cart_page.dart';
import 'package:audio_store/pages/cart_page.dart';
import 'package:audio_store/pages/checkout_page.dart';
import 'package:audio_store/pages/home_page.dart';
import 'package:audio_store/pages/item_page.dart';
import 'package:audio_store/pages/login_page.dart';
import 'package:audio_store/pages/register_page.dart';
import 'package:audio_store/pages/setting_page.dart';
import 'package:audio_store/pages/transactions_page.dart';
import 'package:audio_store/pages/transaction_success_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutPage(),
    ),
    GoRoute(
      path: '/transactions',
      builder: (context, state) => const TransactionsPage(),
    ),
    GoRoute(
      path: '/transaction/success',
      builder: (context, state) => const TranscationSuccessPage(),
    ),
    GoRoute(
      path: '/item/:id',
      name: 'item',
      builder: (context, state) {
        String? id = state.pathParameters['id'];

        if (id == null) return const HomePage();

        return ItemPage(id: int.parse(id));
      },
    ),
    GoRoute(
      path: '/add_to_cart/:id',
      name: 'add_to_cart',
      builder: (context, state) {
        String? id = state.pathParameters['id'];

        if (id == null) return const HomePage();

        return AddToCart(id: int.parse(id));
      },
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) {
        return const CartPage();
      },
    ),
  ],
);
