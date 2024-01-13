import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class TranscationSuccessPage extends StatelessWidget {
  const TranscationSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            'Payment Successful!',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Image.asset(
                            'assets/images/shopping_bag.png',
                            width: 200,
                          )
                              .animate()
                              .shake(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn,
                              )
                              .then(delay: const Duration(milliseconds: 200))
                              .scale(
                                begin: const Offset(1, 1),
                                end: const Offset(0.8, 0.8),
                              )
                              .then(delay: const Duration(milliseconds: 200))
                              .shake(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton.tonal(
                        onPressed: () => context.go('/transactions'),
                        child: const Text('Order receipts'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
