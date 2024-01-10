import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool isLoggedIn;
  late VoidCallback profileHandler;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    isLoggedIn = supabase.auth.currentSession != null;
    profileHandler =
        isLoggedIn ? () => context.go('/settings') : () => context.go('/login');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InkWell(
              onTap: profileHandler,
              child: FittedBox(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: isLoggedIn
                      ? Row(
                          children: [
                            Text(supabase.auth.currentUser!.email ??
                                "You successfully logged in"),
                            const Icon(
                              Icons.arrow_right,
                            ),
                          ],
                        )
                      : const Row(
                          children: [
                            Text("You have not logged in"),
                            Icon(
                              Icons.arrow_right,
                            ),
                          ],
                        ),
                        
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
