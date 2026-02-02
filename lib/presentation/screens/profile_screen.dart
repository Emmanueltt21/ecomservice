import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecomservics/presentation/blocs/theme_bloc.dart';
import 'package:ecomservics/presentation/blocs/language_bloc.dart';
import 'package:ecomservics/presentation/blocs/auth_bloc.dart';
import 'package:ecomservics/presentation/routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Profile Header
            _buildProfileHeader(theme),
            const SizedBox(height: 32),
            
            // Content & Preferences
            _buildSectionLabel(theme, 'CONTENT & PREFERENCES'),
            _buildMenuItem(theme, icon: Icons.newspaper, title: 'Blog'),
            _buildMenuItem(theme, icon: Icons.shopping_bag, title: 'Order History', onTap: () => context.push(AppRoutes.orderHistory)),
            _buildLanguageSelector(theme),
            _buildMenuItem(theme, icon: Icons.payments, title: 'Currency', trailing: 'USD (\$)'),
            
            const SizedBox(height: 24),
            
            // Support & Legal
            _buildSectionLabel(theme, 'SUPPORT & LEGAL'),
            _buildMenuItem(theme, icon: Icons.assignment_return, title: 'Refund Policy', onTap: () => context.push(AppRoutes.refund)),
            _buildMenuItem(theme, icon: Icons.gavel, title: 'Terms & Services', onTap: () => context.push(AppRoutes.terms)),
            
            const SizedBox(height: 24),
            
            // App Settings
            _buildSectionLabel(theme, 'APP SETTINGS'),
            _buildThemeToggle(theme),
            _buildMenuItem(theme, icon: Icons.tune, title: 'General Settings', onTap: () => context.push(AppRoutes.settings)),
            
            const SizedBox(height: 32),
            
            // Logout
            
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutEvent());
                    context.go(AppRoutes.login);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red.withOpacity(0.2)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            Text('Version 2.4.1 (Build 120)', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                image: const DecorationImage(
                  image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuD79uN2csw-SqxIRzNpuAy-9duVHb3eKCbH8eqLjnL4ojOFS-ciBxQb7cO4jVAy_sALcHfz45AALC7cpmW0L74w3W9izvHeR5bM-lPhImaLzhWeng8Gnq5q3PFTsKG0Fx-RXd-8DR56GTiqBwr1ojSfMNJj_qtK_dj9TaJlTUaCaHFiZnjQKKVUvNVK2Ud50gm1j3h7vvHzkjIvviamuFm5BzokZTMuAM2Zdq2kOVw8H_Mmdvym0Ckv3Qa3SxtOUaUbDLHWakk19A"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.verified, color: Colors.white, size: 14),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('Alex Johnson', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('alex.johnson@ecomservice.com', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'VERIFIED MEMBER', 
            style: TextStyle(color: theme.colorScheme.primary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(ThemeData theme, String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
      child: Text(
        label, 
        style: theme.textTheme.labelSmall?.copyWith(
          color: Colors.grey, 
          fontWeight: FontWeight.bold, 
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildMenuItem(ThemeData theme, {required IconData icon, required String title, String? trailing, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap ?? () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: theme.colorScheme.primary, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(trailing, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildThemeToggle(ThemeData theme) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.dark_mode, color: theme.colorScheme.primary, size: 20),
          ),
          title: const Text('Dark Theme', style: TextStyle(fontWeight: FontWeight.w600)),
          trailing: Switch(
            value: state.themeMode == ThemeMode.dark,
            onChanged: (value) {
              context.read<ThemeBloc>().add(ChangeTheme(value ? ThemeMode.dark : ThemeMode.light));
            },
            activeColor: theme.colorScheme.primary,
          ),
        );
      },
    );
  }

  Widget _buildLanguageSelector(ThemeData theme) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        String languageName = 'English';
        if (state.locale.languageCode == 'fr') languageName = 'Français';
        if (state.locale.languageCode == 'ar') languageName = 'العربية';

        return ListTile(
          onTap: () {
            // Show a simple dialog for language selection
            showModalBottomSheet(
              context: context,
              builder: (dialogContext) => Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: const Text('English'),
                      onTap: () {
                        context.read<LanguageBloc>().add(const ChangeLanguage(Locale('en')));
                        Navigator.pop(dialogContext);
                      },
                    ),
                    ListTile(
                      title: const Text('Français'),
                      onTap: () {
                        context.read<LanguageBloc>().add(const ChangeLanguage(Locale('fr')));
                        Navigator.pop(dialogContext);
                      },
                    ),
                    ListTile(
                      title: const Text('العربية'),
                      onTap: () {
                        context.read<LanguageBloc>().add(const ChangeLanguage(Locale('ar')));
                        Navigator.pop(dialogContext);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.language, color: theme.colorScheme.primary, size: 20),
          ),
          title: const Text('Language', style: TextStyle(fontWeight: FontWeight.w600)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(languageName, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        );
      },
    );
  }
}
