import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest/features/auth/providers/auth_provider.dart';

class UserUpdatePassword extends ConsumerWidget {
  const UserUpdatePassword({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

     String _username = '';
    String _password = '';
    final _authNotifier=ref.read(authNotifier.notifier);
    final _formKey = GlobalKey<FormState>();
    
    void submit()async{
      final validate=_formKey.currentState!.validate();
      if(validate){
      _formKey.currentState!.save();
      await _authNotifier.addUsernameAndPassword(_username, _password);
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Your Password'),
      ),
      body: Form(key: _formKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
                    onSaved: (newValue) {
                      _username = newValue!;
                    },
                    decoration: const InputDecoration(hintText: 'username'),
                  ), TextFormField(
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
        ],
      )),
    );
  }
}
