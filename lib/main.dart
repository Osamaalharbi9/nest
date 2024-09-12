import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nest/bottom_navigator.dart';
import 'package:nest/config/themes/dark_theme.dart';
import 'package:nest/features/auth/auth_page.dart';
import 'package:nest/features/auth/views/new_user.dart';
import 'package:nest/features/auth/views/user_update_password.dart';
import 'package:nest/firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest/features/auth/providers/auth_provider.dart';
import 'config/themes/light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print(e.toString());
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _authNotifier = ref.watch(authNotifier.notifier);

    return ScreenUtilInit(
      designSize: const Size(430.0, 932.0),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: _authNotifier.auth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            }

            if (snapshot.hasData) {
              return BottomNavigator()
;              //final user = _authNotifier.auth.currentUser;

              // Check if the email is verified
              // if (user != null && user.emailVerified) {
              //   // If the email is verified, go to BottomNavigator.com
              //   return const UserUpdatePassword();
              // } else {
              //   // If the email is not verified, stay on the AuthView
              //   return const AuthView();
              // }
            }

            return const AuthView(); // Default to AuthView if no user is authenticated
          },
        ),
      ),
    );
  }
}

String getTMBDApiKey() {
  return dotenv.env['TMDB_API_KEY'] ?? '';
}

String getGPTApiKey() {
  return dotenv.env['GPT_API_KEY'] ?? '';
}
