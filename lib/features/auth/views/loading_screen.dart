import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest/features/auth/providers/auth_provider.dart';

class LoadingScreen extends ConsumerWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _authNotifier = ref.read(authNotifier.notifier);
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () async {
              final user=_authNotifier.auth.currentUser!;
              _authNotifier.auth.currentUser!.sendEmailVerification();
              if(user.emailVerified)
              
              print('email have been sent');

            },
            child: const Text('Verify Email'))
      ],
    ));
  }
}
