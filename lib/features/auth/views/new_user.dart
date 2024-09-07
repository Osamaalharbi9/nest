import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest/features/auth/providers/auth_provider.dart';

class NewUser extends ConsumerWidget {
  const NewUser({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String _username = '';
    String _email = '';
    String _password = '';
    final _authProvider = ref.watch(authNotifier);
    final _authNotifier = ref.read(authNotifier.notifier);
    final _formKey = GlobalKey<FormState>();
    void submit() async {
      final validiation = _formKey.currentState!.validate();
      if (validiation) {
        _formKey.currentState!.save();
        await _authNotifier.createNewUser(
            _username, _email, _password, context);
      }
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (newValue) {
                      _username = newValue!;
                    },
                    decoration: const InputDecoration(hintText: 'username'),
                  ),
                  TextFormField(
                    onSaved: (newValue) {
                      _email = newValue!;
                    },
                    autocorrect: false,
                    decoration: const InputDecoration(
                        hintText: 'useraccount@example.com',
                        helperText: 'Email'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      } else if (!value.contains('@')) {
                        return 'Email must enclude \'@\'';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    onSaved: (newValue) {
                      _password = newValue!;
                    },
                    obscureText: true,
                    autocorrect: false,
                    decoration: const InputDecoration(
                        hintText: '!pass123', helperText: 'Password'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Password is required';
                      } else if (value.trim().length <= 6) {
                        return 'Password must be 6 digits at least';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        submit();
                      },
                      child: null)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
