// TEMPORARY: Manual localization implementation
// This is a workaround until flutter gen-l10n generates properly

import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // English translations
  String get appTitle => 'EcomService';
  String get home => 'Home';
  String get cart => 'My Cart';
  String get favorites => 'Favorites';
  String get profile => 'Profile';
  String get categories => 'Categories';
  String get searchHint => 'Search products...';
  String get login => 'Login';
  String get signup => 'Sign Up';
  String get email => 'Email';
  String get password => 'Password';
  String get forgotPassword => 'Forgot Password?';
  String get startShopping => 'Start Shopping';
  String get addToCart => 'Add to Cart';
  String get buyNow => 'Buy Now';
  String get settings => 'Settings';
  String get language => 'Language';
  String get theme => 'Theme';
  String get lightTheme => 'Light Theme';
  String get darkTheme => 'Dark Theme';
  String get logout => 'Logout';
  String get viewAll => 'View All';
  String get newArrivals => 'New Arrivals';
  String get trending => 'Trending';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
