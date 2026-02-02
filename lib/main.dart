import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ecomservics/core/theme/app_theme.dart';
import 'package:ecomservics/core/di/injection_container.dart' as di;
import 'package:ecomservics/presentation/routes/app_router.dart';
import 'package:ecomservics/generated/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecomservics/presentation/blocs/theme_bloc.dart';
import 'package:ecomservics/presentation/blocs/language_bloc.dart';
import 'package:ecomservics/presentation/blocs/auth_bloc.dart';
import 'package:ecomservics/presentation/blocs/cart_bloc.dart';
import 'package:ecomservics/presentation/blocs/favorite_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<ThemeBloc>()),
        BlocProvider(create: (_) => di.sl<LanguageBloc>()),
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(create: (_) => di.sl<CartBloc>()), // Global Cart
        BlocProvider(create: (_) => di.sl<FavoriteBloc>()), // Global Favorites
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, languageState) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp.router(
                title: 'EcomService',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.themeMode,
                locale: languageState.locale,
                routerConfig: router,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en'),
                  Locale('fr'),
                  Locale('ar'),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
