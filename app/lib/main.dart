import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/api/api_client.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/ads_provider.dart';
import 'core/providers/categories_provider.dart';
import 'core/providers/chat_provider.dart';
import 'core/providers/country_provider.dart';
import 'core/localization/app_localizations.dart';
import 'core/localization/localization_provider.dart';
import 'shared/theme/app_theme.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization exception: $e');
  }

  final initialToken = await ApiClient.getToken();
  final initialUser = await ApiClient.getUser();
  runApp(KuwaitSouqApp(
    initialToken: initialToken,
    initialUser: initialUser,
  ));
}

class KuwaitSouqApp extends StatelessWidget {
  final String? initialToken;
  final Map<String, dynamic>? initialUser;

  const KuwaitSouqApp({super.key, this.initialToken, this.initialUser});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            initialToken: initialToken,
            initialUser: initialUser,
          ),
        ),
        ChangeNotifierProvider(create: (_) => LocalizationProvider()),
        ChangeNotifierProvider(create: (_) => CountryProvider()),
        ChangeNotifierProvider(create: (_) => AdsProvider()),
        ChangeNotifierProvider(create: (_) => CategoriesProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: Consumer<LocalizationProvider>(
        builder: (context, l10n, child) {
          final router = createRouter(context);
          return MaterialApp.router(
            title: 'KuwaitSouq',
            theme: AppTheme.light,
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            locale: l10n.locale,
            supportedLocales: const [
              Locale('ar'),
              Locale('en'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}
