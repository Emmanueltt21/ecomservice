import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomservics/presentation/blocs/theme_bloc.dart';
import 'package:ecomservics/presentation/blocs/language_bloc.dart';
import 'package:ecomservics/presentation/routes/app_routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Appearance state is now managed by ThemeBloc

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appearance
            _buildSectionHeader(theme, 'Appearance'),
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                int index = 0;
                if (state.themeMode == ThemeMode.dark) index = 1;
                if (state.themeMode == ThemeMode.system) index = 2;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    children: [
                      _buildToggleOption(context, 'Light', 0, index == 0),
                      const SizedBox(width: 12),
                      _buildToggleOption(context, 'Dark', 1, index == 1),
                      const SizedBox(width: 12),
                      _buildToggleOption(context, 'System', 2, index == 2),
                    ],
                  ),
                );
              },
            ),
            
            // Preferences
            _buildSectionHeader(theme, 'Preferences'),
            BlocBuilder<LanguageBloc, LanguageState>(
              builder: (context, state) {
                String languageName = 'English (US)';
                if (state.locale.languageCode == 'fr') languageName = 'Français';
                if (state.locale.languageCode == 'ar') languageName = 'العربية';
                
                return _buildSettingsItem(theme, 
                  icon: Icons.translate, 
                  title: 'Language', 
                  subtitle: languageName,
                  onTap: () => _showLanguageDialog(context),
                );
              },
            ),
            _buildSettingsItem(theme, 
              icon: Icons.payments, 
              title: 'Currency', 
              subtitle: 'USD (\$)',
              onTap: () {},
            ),
            
            // Maintenance
            _buildSectionHeader(theme, 'Maintenance'),
            _buildMaintenanceItem(theme, 
              icon: Icons.delete_sweep, 
              title: 'Clear Cache', 
              subtitle: '32.4 MB currently used',
              actionLabel: 'CLEAR',
              onTap: () {},
            ),
            
            // Information
            _buildSectionHeader(theme, 'Information'),
            _buildSettingsItem(theme, 
              icon: Icons.info_outline, 
              title: 'About App', 
              subtitle: 'ecomservice v1.0.4',
              onTap: () => context.push(AppRoutes.about),
            ),
            _buildSettingsItem(theme, 
              icon: Icons.verified_user_outlined, 
              title: 'Legal & Privacy', 
              subtitle: 'Terms of service',
              onTap: () => context.push(AppRoutes.legal),
            ),
            
            const SizedBox(height: 64),
            // Footer Branding
            Center(
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.shopping_bag, color: Colors.white, size: 20),
                  ),
                  const SizedBox(height: 8),
                  Text('ECOMSERVICE', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 2)),
                  Text('Made with precision', style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Text(
        title, 
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildToggleOption(BuildContext context, String label, int index, bool isSelected) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          final themeMode = index == 0 ? ThemeMode.light : (index == 1 ? ThemeMode.dark : ThemeMode.system);
          context.read<ThemeBloc>().add(ChangeTheme(themeMode));
        },
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: isSelected ? Colors.transparent : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withOpacity(0.1),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label, 
              style: TextStyle(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.6),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
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
  }

  Widget _buildSettingsItem(ThemeData theme, {required IconData icon, required String title, required String subtitle, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.05)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }

  Widget _buildMaintenanceItem(ThemeData theme, {required IconData icon, required String title, required String subtitle, required String actionLabel, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.05)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.delete_sweep, color: Colors.red),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            actionLabel, 
            style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
