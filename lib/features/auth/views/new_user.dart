import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest/features/auth/providers/auth_provider.dart';
import 'package:nest/features/auth/views/loading_screen.dart';

class NewUser extends ConsumerStatefulWidget {
  const NewUser({super.key});

  @override
  ConsumerState<NewUser> createState() => _NewUserState();
}

class _NewUserState extends ConsumerState<NewUser> {
  String _email = '';
  String _password='';
  final _formKey = GlobalKey<FormState>();

  
  void verifyEmail() async {
    final validation = _formKey.currentState!.validate();
    if (validation) {
      _formKey.currentState!.save();
      final _authNotifier = ref.read(authNotifier.notifier);
      await _authNotifier.createNewUser('', _email, '', context);
      
      
    }
  }

  @override
  Widget build(BuildContext context) {
    final _authProvider = ref.watch(authNotifier);

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
                      _email = newValue!;
                    },
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'useraccount@example.com',
                      helperText: 'Email',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      } else if (!value.contains('@')) {
                        return 'Email must include \'@\'';
                      }
                      return null;
                    },
                  ),TextFormField(obscureText: true,
                    onSaved: (newValue) {
                      _password = newValue!;
                    },
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'password',
                      helperText: 'pass',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      } 
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      verifyEmail();
                    },
                    child: const Text('Submit'),
                  ),
                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
