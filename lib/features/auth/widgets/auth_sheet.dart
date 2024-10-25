import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest/features/auth/pages/new_user.dart';
import 'package:nest/features/auth/providers/auth_provider.dart';

class AuthSheet extends ConsumerStatefulWidget {
  const AuthSheet({super.key});

  @override
  ConsumerState<AuthSheet> createState() => _AuthSheetState();
}

class _AuthSheetState extends ConsumerState<AuthSheet> {
  @override
  Widget build(BuildContext context) {
    final _authProvider = ref.watch(authNotifier);
    final _authNotifier = ref.read(authNotifier.notifier);

    String _email = '';
    String _password = '';
    final _formKey = GlobalKey<FormState>();
    void submit() async {
      final validate = _formKey.currentState!.validate();
      if (validate) {
        _formKey.currentState!.save();
        await _authNotifier.login(_email, _password, context);
      }
    }

    return SizedBox(
      height: 400,
      width: double.infinity + 100,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Column(
          children: [
            SizedBox(
              height: 30.h,
            ),
            SizedBox(
              height: 250.h,
              child: Form(
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
                    SizedBox(
                      height: 8.h,
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
                        } // else if (value.trim().length >= 6) {
                        //   return 'Password must be longer than 5 digits';
                        // }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Text(
                            'Forgot your password?',
                            style: TextStyle(color: Colors.purple.shade700),
                          ),
                        ],
                      ),
                    ),//TODO fix this shit
                    
                
                  ],
                ),
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                    fixedSize:
                        Size(MediaQuery.of(context).size.width / 1.1, 50.h),
                    backgroundColor: Theme.of(context).colorScheme.onSurface),
                onPressed: () async {
                  submit();
                  Navigator.pop(context);
                },
                child: Text('Login',
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: Theme.of(context).colorScheme.onSecondary))),
            Padding(
              padding: EdgeInsets.all(8.0.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a Member? ',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NewUser()));
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w700),
                    ),
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
